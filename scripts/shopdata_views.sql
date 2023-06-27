-- Complete information about customer
DROP VIEW IF EXISTS customer_info;

CREATE OR REPLACE VIEW customer_info AS
    SELECT first_name,
           last_name,
           birthday,
           rpad('*', 12, '*') || substr(phone_number, 12) as phone_number,
           ca.card_id,
           balance
    FROM sd.customer cu
    JOIN (SELECT * FROM sd.card_hist WHERE to_td IS NULL) ca ON cu.card_id = ca.card_id;

-- Most profitable products in descending order
DROP VIEW IF EXISTS product_profit;

CREATE OR REPLACE VIEW product_profit AS
    SELECT al.author_name,
    	   al.album_name,
           la.label_name,
           pr.release_date,
           prof.profit
    FROM sd.product pr
    JOIN sd.album al ON pr.album_id = al.album_id
    JOIN sd.label la ON pr.label_id = la.label_id
    JOIN (SELECT product_id,
          	     sum(purchase_amount) as profit
          FROM sd.purchase
          GROUP BY product_id) prof ON pr.product_id = prof.product_id
    ORDER BY profit DESC;

-- Information about currently available products in shop
DROP VIEW IF EXISTS available_products;

CREATE OR REPLACE VIEW available_products AS
	SELECT al.author_name,
    	   al.album_name,
           la.label_name,
           pr.release_date,
           pr.price,
           st.product_count
 	FROM sd.product pr
    JOIN sd.album al ON pr.album_id = al.album_id
   	JOIN sd.label la ON pr.label_id = la.label_id
    JOIN (SELECT * FROM sd.stock WHERE to_td IS NULL) st ON pr.product_id = st.product_id
    WHERE st.product_count > 0
    order by pr.price DESC;

-- View with info about most recent purchases - what vinyl was bought, who bought it
DROP VIEW IF EXISTS recent_purchases;

CREATE OR REPLACE VIEW recent_purchases AS
	SELECT pu.purchase_date,
           substr(cu.first_name, 0, 3) || rpad('*', 8, '*') as first_name,
           substr(cu.last_name, 0, 3) || rpad('*', 8, '*') as second_name,
           al.author_name,
    	   al.album_name,
           la.label_name,
           pr.release_date,
           pu.product_count,
           pu.purchase_amount
    FROM sd.purchase pu
    JOIN sd.product pr ON pu.product_id = pr.product_id
    JOIN sd.customer cu ON pu.customer_id = cu.customer_id
    JOIN sd.album al ON pr.album_id = al.album_id
    JOIN sd.label la ON pr.label_id = la.label_id
    ORDER BY purchase_date desc;

-- Information about how many albums the store has, its average price and vinyls decade-wise
DROP VIEW IF EXISTS products_by_decade;

CREATE OR REPLACE VIEW products_by_decade AS
WITH year_ranges AS(
	SELECT i as left_yr,
  		   i + 10 AS right_yr
	FROM generate_series(1900, 2020, 10) AS i)
SELECT substr(CAST(pr.left_yr AS TEXT), 3) || '''s' as decade,
	   count(*),
	   avg(price),
       sum(st.product_count)
FROM (SELECT *
	  FROM sd.product pr
	  JOIN year_ranges ra ON
      	ra.left_yr <= pr.release_date and pr.release_date < ra.right_yr) pr
JOIN sd.stock st ON pr.product_id = st.product_id
GROUP BY left_yr
ORDER BY decade desc;

-- Labels that have most publishes and average price for vinyl
DROP VIEW IF EXISTS label_view;

CREATE OR REPLACE VIEW label_view AS
SELECT count(*) AS product_count,
	   AVG(pr.price) AS average_price,
       la.label_name
FROM sd.label la
JOIN sd.product pr ON la.label_id = pr.label_id
GROUP BY la.label_name
ORDER BY product_count DESC, average_price DESC;

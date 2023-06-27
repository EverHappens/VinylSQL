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
          	     SUM(purchase_amount) AS profit
          FROM sd.purchase
          GROUP BY product_id) prof ON pr.product_id = prof.product_id
    ORDER BY profit DESC;

SELECT * FROM product_profit;

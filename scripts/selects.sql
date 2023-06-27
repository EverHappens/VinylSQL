--Top 5 most profitable clients
WITH clients_profit AS(
    SELECT
        tr.customer_id as customer_id,
        sum(purchase_amount) as profit
    FROM sd.purchase tr
    JOIN sd.customer cu ON tr.customer_id = cu.customer_id
    GROUP BY tr.customer_id)
SELECT
    'first' as table_name,
	cu.first_name,
    cu.last_name,
	clients_profit.profit
FROM sd.customer cu, clients_profit
WHERE clients_profit.customer_id = cu.customer_id
ORDER BY profit desc
LIMIT 5;

--Top 5 most expensive products
SELECT
    'second' as table_name,
    rank() OVER (ORDER BY pr.price DESC),
    al.author_name,
    al.album_name,
    la.label_name,
    pr.price,
    la.country,
    pr.release_date,
    al.genre
FROM sd.product pr
JOIN sd.album al ON pr.album_id = al.album_id
JOIN sd.label la ON pr.label_id = la.label_id
LIMIT 5;

--Value of all products in the shop
WITH actual_value AS (
  	SELECT
  		price,
 		product_count
  	FROM sd.stock st
  	JOIN sd.product pr ON st.product_id = pr.product_id
  	WHERE st.to_td IS NULL)
SELECT
    'third' as table_name,
	sum(actual_value.price * actual_value.product_count)
FROM actual_value;

--Average amount of bonuses on loyalty cards
WITH current_cards AS (
    SELECT
        balance,
        to_td
    FROM sd.card_hist
    WHERE to_td IS NULL)
SELECT
    'fourth' as table_name,
    avg(balance)
FROM current_cards;

--Show phone numbers that have been binded more than once
SELECT
    'fifth' as table_name,
    phone_number,
    count(phone_number) as bind_count
FROM sd.customer
GROUP BY phone_number
HAVING COUNT(phone_number) > 1;

--Show customers that have binded their phone number more than once
WITH bad_numbers AS (
    SELECT
        phone_number,
        count(phone_number) as bind_count
    FROM sd.customer
    GROUP BY phone_number
    HAVING count(phone_number) > 1)
SELECT
    'sixth' as table_name,
    customer_id,
    first_name,
    last_name,
    cu.phone_number
FROM sd.customer cu, bad_numbers
WHERE cu.phone_number IN(bad_numbers.phone_number)
ORDER BY cu.phone_number;

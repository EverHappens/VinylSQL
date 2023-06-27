--Value of all products in the shop
WITH actual_value AS (
  	SELECT
  		price,
 		product_count
  	FROM sd.stock st
  	JOIN sd.product pr ON st.product_id = pr.product_id
  	WHERE st.to_td IS NULL)
SELECT
	sum(actual_value.price * actual_value.product_count)
FROM actual_value;
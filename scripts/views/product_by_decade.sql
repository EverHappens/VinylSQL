-- Information about how many albums the store has, its average price and vynils decade-wise
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

SELECT * FROM products_by_decade;

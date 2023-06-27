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

SELECT * FROM label_view;

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

SELECT * FROM available_products;
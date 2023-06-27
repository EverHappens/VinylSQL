-- View with info about most recent purchases - what vynil was bought, who bought it
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

SELECT * FROM recent_purchases;

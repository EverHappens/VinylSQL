-- Complete information about customer
DROP VIEW IF EXISTS customer_info;

CREATE OR REPLACE VIEW customer_info AS
    SELECT first_name,
           last_name,
           birthday,
           rpad('*', 12, '*') || substr(phone_number, 12) AS phone_number,
           ca.card_id,
           balance
    FROM sd.customer cu
    JOIN (SELECT * FROM sd.card_hist WHERE to_td IS NULL) ca ON cu.card_id = ca.card_id;

SELECT * FROM customer_info;

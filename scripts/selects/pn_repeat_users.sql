--Show customers that have binded their phone number more than once
WITH bad_numbers AS (
    SELECT
        phone_number,
        count(phone_number) as bind_count
    FROM sd.customer
    GROUP BY phone_number
    HAVING count(phone_number) > 1)
SELECT
    customer_id,
    first_name,
    last_name,
    cu.phone_number
FROM sd.customer cu, bad_numbers
WHERE cu.phone_number IN(bad_numbers.phone_number)
ORDER BY cu.phone_number
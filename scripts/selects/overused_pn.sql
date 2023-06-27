--Show phone numbers that have been binded more than once
SELECT
    phone_number,
    count(phone_number) as bind_count
FROM sd.customer
GROUP BY phone_number
HAVING COUNT(phone_number) > 1
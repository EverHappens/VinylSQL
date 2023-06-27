--Top 5 most profitable clients
WITH clients_profit AS(
    SELECT
        tr.customer_id as customer_id,
        sum(purchase_amount) as profit
    FROM sd.purchase tr
    JOIN sd.customer cu ON tr.customer_id = cu.customer_id
    GROUP BY tr.customer_id)
SELECT
	cu.first_name,
    cu.last_name,
	clients_profit.profit
FROM sd.customer cu, clients_profit
WHERE clients_profit.customer_id = cu.customer_id
ORDER BY profit desc
LIMIT 5;

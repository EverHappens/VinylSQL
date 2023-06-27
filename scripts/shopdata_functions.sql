---create product by existing

CREATE OR REPLACE FUNCTION current_count(prod_id integer)
RETURNS INTEGER AS
$$
BEGIN
    SELECT product_count
    FROM sd.stock
    WHERE to_td IS NULL and prod_id = product_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION current_balance(cust_id integer)
RETURNS INTEGER AS
$$
BEGIN
    WITH loyalty_id AS(
        SELECT card_id
        FROM sd.customer
        WHERE customer_id = cust_id)
    SELECT balance
    FROM sd.card_hist
    WHERE to_td IS NULL and loyalty_id = card_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION loyalty_bonus(cust_id integer, purchase_amount numeric)
RETURNS NUMERIC AS
$$
BEGIN
    IF now()::date = (SELECT birthday FROM sd.customer WHERE cust_id = customer_id) THEN
        SELECT purchase_amount * 0.1;
    ELSE
        SELECT purchase_amount * 0.05;
    END IF;
END;
$$ LANGUAGE plpgsql;
---function for easy transaction processing
---insert new transaction entry
---update loyalty card balance
---update stock info
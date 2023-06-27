--trigger to update to_td(null values) and check product availability before purchase
--outputs error if stock has less than needed
CREATE OR REPLACE FUNCTION new_purchase()
RETURNS TRIGGER AS
$$
DECLARE
	current_cnt integer = current_count(product_id);
    current_tm timestamp without time zone = now()::timestamp;
    loyalty_id integer = (SELECT cu.card_id
                              FROM sd.customer cu
                              WHERE cu.customer_id = new.customer_id);
BEGIN
    IF new.product_count < current_count(product_id) THEN
        RAISE EXCEPTION 'There is not enough product';
    END IF;

    INSERT INTO sd.stock VALUES
    (new.product_id, current_cnt - new.purchase_amount, current_tm, NULL);

    UPDATE sd.stock st
    SET st.to_td = @current_tm
    WHERE st.to_td IS NULL and st.product_id = new.product_id;

    UPDATE sd.card_hist ca
    SET ca.to_td = @current_tm
    WHERE ca.to_td IS NULL and ca.card_id = loyalty_id;

    INSERT INTO sd.card_hist VALUES
    (loyalty_id, current_balance(new.customer_id) + loyalty_bonus(new.customer_id, new.purchase_amount), current_tm, NULL);
END;
$$ language plpgsql;

CREATE OR REPLACE TRIGGER purchase_trigger BEFORE INSERT
    ON sd.purchase
    FOR EACH ROW
    EXECUTE FUNCTION new_purchase();


CREATE OR REPLACE FUNCTION clean_customer_deletion()
RETURNS TRIGGER AS
$$
DECLARE
BEGIN
    DELETE FROM sd.card_hist ca
    WHERE old.card_id = ca.card_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER customer_delete_trigger AFTER DELETE
    ON sd.customer
    FOR EACH ROW
    EXECUTE FUNCTION clean_customer_deletion();

--delete trigger(for customer)? to delete all corresponding rows in other tables
--trigger for removing previous purchase(with to_td cleanup)?
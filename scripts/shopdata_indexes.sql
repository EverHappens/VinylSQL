-- Indexes are not used on sd.album and sd.label as they are the smallest tables
-- During purchase multiple tables are queried (sd.card_hist, sd.stock, sd.product, sd.purchase)
-- and some of those are likely to grow fast.

CREATE INDEX "product.albid_labid"
    ON sd.product
    USING btree
    (album_id, label_id);

CREATE INDEX "customer.customer_id"
    ON sd.customer
    USING btree
    (customer_id);

-- Fast navigation through purchase timeline
CREATE INDEX "card_hist.from_td"
    ON sd.card_hist
    USING btree
    (from_td);

CREATE INDEX "card_hist.card_id_from_td"
    ON sd.card_hist
    USING btree
    (card_id, from_td);

-- Fast navigation through stock supply changes
CREATE INDEX "stock.from_td"
    ON sd.stock
    USING btree
    (from_td);

CREATE INDEX "stock.product_id_from_td"
    ON sd.stock
    USING btree
    (product_id, from_td);

-- Fast navigation through purchases
CREATE INDEX "purchase.purchase_date"
    ON sd.purchase
    USING btree
    (purchase_date);

CREATE INDEX "purchase.customer_id_purchase_date"
    ON sd.purchase
    USING btree
    (customer_id, purchase_date)
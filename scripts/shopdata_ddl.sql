CREATE SCHEMA IF NOT EXISTS sd;

CREATE TABLE IF NOT EXISTS sd.album (
    album_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    author_name varchar(200) NOT NULL,
    album_name varchar(200) NOT NULL,
    genre varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS sd.label (
    label_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    label_name varchar(200) NOT NULL,
    country varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS sd.product (
    product_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    album_id integer NOT NULL,
    label_id integer NOT NULL,
    release_date smallint NOT NULL,
    price numeric NOT NULL,
        FOREIGN KEY (album_id) REFERENCES sd.album(album_id),
        FOREIGN KEY (label_id) REFERENCES sd.label(label_id)
);

CREATE TABLE IF NOT EXISTS sd.customer (
    customer_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name varchar(200) NOT NULL,
    last_name varchar(200) NOT NULL,
    birthday date NOT NULL,
    phone_number varchar(20) NOT NULL,
    card_id integer UNIQUE
);

CREATE TABLE IF NOT EXISTS sd.card_hist (
    card_id integer NOT NULL,
    balance numeric NOT NULL DEFAULT 0,
    from_td timestamp without time zone NOT NULL,
    to_td timestamp without time zone,
        PRIMARY KEY (card_id, from_td),
        FOREIGN KEY (card_id) REFERENCES sd.customer(card_id)
);

CREATE TABLE IF NOT EXISTS sd.stock (
    product_id integer NOT NULL,
    product_count integer NOT NULL,
    from_td timestamp without time zone NOT NULL,
    to_td timestamp without time zone,
        PRIMARY KEY (product_id, from_td),
        FOREIGN KEY (product_id) REFERENCES sd.product(product_id)
);

CREATE TABLE IF NOT EXISTS sd.purchase (
    purchase_id integer GENERATED ALWAYS AS IDENTITY,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    product_count integer NOT NULL,
    purchase_amount numeric NOT NULL,
    purchase_date timestamp without time zone NOT NULL,
        PRIMARY KEY (purchase_id, product_id),
        FOREIGN KEY (customer_id) REFERENCES sd.customer(customer_id),
        FOREIGN KEY (product_id) REFERENCES sd.product(product_id)
);

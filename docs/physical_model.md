Таблица `sd.album`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `album_id` | Идентификатор альбома | `INTEGER` | `PRIMARY KEY GENERATED ALWAYS AS IDENTITY` |
| `author_name` | Имя автора | `VARCHAR(200)` | `NOT NULL` |
| `album_name` | Название альбома | `VARCHAR(200)` | `NOT NULL` |
| `genre` | Жанр | `VARCHAR(100)` | `NOT NULL` |

Таблица `sd.label`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `label_id` | Идентификатор лейбла | `INTEGER` | `PRIMARY KEY GENERATED ALWAYS AS IDENTITY` |
| `label_name` | Название лейбла | `VARCHAR(200)` | `NOT NULL` |
| `country` | Страна выпуска | `VARCHAR(100)` | `NOT NULL` |

Таблица `sd.product`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `product_id` | Идентификатор товара | `INTEGER` | `PRIMARY KEY GENERATED ALWAYS AS IDENTITY` |
| `album_id` | Идентификатор альбома | `INTEGER` | `NOT NULL` |
| `label_id` | Идентификатор лейбла | `INTEGER` | `NOT NULL` |
| `release_date` | Дата выпуска | `SMALLINT` | `NOT NULL` |
| `price` | Цена | `NUMERIC` | `NOT NULL` |

Таблица `sd.customer`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `customer_id` | Идентификатор покупателя  | `INTEGER` | `PRIMARY KEY GENERATED ALWAYS AS IDENTITY` |
| `first_name` | Имя покупателя | `VARCHAR(200)` | `NOT NULL` |
| `last_name` | Фамилия покупателя | `VARCHAR(200)` | `NOT NULL` |
| `birthday` | Дата рождения | `DATE` | `NOT NULL` |
| `phone_number` | Номер телефона | `VARCHAR(20)` | `NOT NULL` |
| `card_id` | Идентификатор карты лояльности | `INTEGER` | `UNIQUE` |

Таблица `sd.card_hist`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `card_id` | Идентификатор карты | `INTEGER` | `PRIMARY KEY` |
| `balance` | Баланс на карте | `NUMERIC` | `NOT NULL DEFAULT 0` |
| `from_td` | Дата начала | `TIMESTAMP WITHOUT TIME ZONE` | `PRIMARY KEY` |
| `to_td` | Дата окончания | `TIMESTAMP WITHOUT TIME ZONE` | `-` |

Таблица `sd.stock`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `product_id` | Идентификатор товара | `INTEGER` | `PRIMARY KEY` |
| `product_count` | Количество товара | `INTEGER` | `NOT NULL` |
| `from_td` | Дата начала | `TIMESTAMP WITHOUT TIME ZONE` | `PRIMARY KEY` |
| `to_td` | Дата окончания | `TIMESTAMP WITHOUT TIME ZONE` | `-` |

Таблица `sd.purchase`:

| Название | Описание | Тип данных | Ограничение |
| --- | --- | --- | --- |
| `purchase_id` | Идентификатор покупки | `INTEGER` | `PRIMARY KEY GENERATED ALWAYS AS IDENTITY` |
| `customer_id` | Идентификатор покупателя | `INTEGER` | `NOT NULL` |
| `product_id` | Идентификатор альбома | `INTEGER` | `PRIMARY KEY` |
| `product_count` | Количество купленного товара | `INTEGER` | `NOT NULL` |
| `purchase_amount` | Стоимость покупки | `NUMERIC` | `NOT NULL` |
| `purchase_date` | Дата покупки | `TIMESTAMP WITHOUT TIME ZONE` | `NOT NULL` |

Taблица `sd.album`:

```
CREATE TABLE IF NOT EXISTS sd.album(
    album_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    author_name varchar(200) NOT NULL,
    album_name varchar(200) NOT NULL,
    genre varchar(100) NOT NULL
);
```

Taблица `sd.label`:

```
CREATE TABLE IF NOT EXISTS sd.label (
    label_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    label_name varchar(200) NOT NULL,
    country varchar(100) NOT NULL
);
```

Taблица `sd.product`:

```
CREATE TABLE IF NOT EXISTS sd.product (
    product_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    album_id integer NOT NULL,
    label_id integer NOT NULL,
    release_date smallint NOT NULL,
    price numeric NOT NULL,
        FOREIGN KEY (album_id) REFERENCES sd.album(album_id),
        FOREIGN KEY (label_id) REFERENCES sd.label(label_id)
);
```

Taблица `sd.customer`:

```
CREATE TABLE IF NOT EXISTS sd.customer (
    customer_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name varchar(200) NOT NULL,
    last_name varchar(200) NOT NULL,
    birthday date NOT NULL,
    phone_number varchar(20) NOT NULL,
    card_id integer UNIQUE
);
```

Taблица `sd.card_hist`:

```
CREATE TABLE IF NOT EXISTS sd.card_hist (
    card_id integer NOT NULL,
    balance numeric NOT NULL DEFAULT 0,
    from_td timestamp without time zone NOT NULL,
    to_td timestamp without time zone,
        PRIMARY KEY (card_id, from_td),
        FOREIGN KEY (card_id) REFERENCES sd.customer(card_id)
);
```

Taблица `sd.stock`:

```
CREATE TABLE IF NOT EXISTS sd.stock (
    product_id integer NOT NULL,
    product_count integer NOT NULL,
    from_td timestamp without time zone NOT NULL,
    to_td timestamp without time zone,
        PRIMARY KEY (product_id, from_td),
        FOREIGN KEY (product_id) REFERENCES sd.product(product_id)
);
```

Taблица `sd.purchase`:

```
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
```

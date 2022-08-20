# 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders
# в интернет магазине.
USE shop;

truncate orders;
SELECT * FROM users;
SELECT * FROM orders;
SELECT * FROM orders_products;

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name LIKE 'гра%';

INSERT INTO orders_products (order_id, product_id, total, created_at)
SELECT last_insert_id(), id, 5, now()
FROM products WHERE name like 'int%';

INSERT INTO orders (user_id)
SELECT id FROM users WHERE name LIKE 'про%';

INSERT INTO orders_products (order_id, product_id, total, created_at)
	SELECT last_insert_id(), id, 2, now()
FROM products WHERE id IN (1, 6);

SELECT * FROM users
WHERE id IN (SELECT user_id FROM orders);

# Решение через JOIN
SELECT users.id, users.name, users.birthday_at, orders.created_at FROM users
JOIN orders ON users.id = orders.user_id;

# 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

INSERT INTO products (name,	desсription,	price,	catalog_id,	created_at,	updated_at) VALUES
			('Nvidia 3060ti', 'графический ускоритель Nvidia', '110000', 6, now(), now() ),
			('Nvidia 3080ti', 'графический ускоритель Nvidia', '140000', 4, now(), now() ),
			('AMD Ryzen 3600x', 'процессор', '14000', 10, now(), now() ),
			('AMD Ryzen 3600', 'процессор', '11000', 5, now(), now() ),
;

SELECT
	catalogs.name AS catalog_name,
	products.name AS product_name,
	products.price,
	products.desсription AS product_description
FROM products
LEFT JOIN catalogs ON catalogs.id = products.catalog_id;

# 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
# Поля from, to и label содержат английские названия городов, поле name — русское.
# Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    `from` VARCHAR(50),
    `to` VARCHAR(50)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    label VARCHAR(50),
    name VARCHAR(50)
);

INSERT INTO flights (`from`, `to`) VALUES
			('moscow', 'omsk'),
			('novgorod', 'kazan'),
			('irkutsk', 'moscow'),
			('omsk', 'irkutsk'),
			('moscow', 'kazan');
			
INSERT INTO cities (label, name) VALUES
			('moscow', 'Москва'),
			('irkutsk', 'Иркутск'),
			('novgorod', 'Новгород'),
			('kazan', 'Казань'),
			('omsk', 'Омск');
			
SELECT
	id,
	(SELECT name FROM cities WHERE label = flights.`from`) AS 	`from`,
	(SELECT name FROM cities c WHERE label = flights.`to`) AS `to`
FROM flights;

# Решение через JOIN
SELECT flights.id, `from`.name AS `from`, `to`.name AS `to`
FROM flights
JOIN cities AS `from` ON flights.`from` = `from`.label
JOIN cities AS `to` ON flights.`to` = `to`.label
ORDER BY id
;
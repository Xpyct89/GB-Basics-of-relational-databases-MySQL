# Практическое задание по теме “Транзакции, переменные, представления”

# 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;

INSERT INTO sample.users 
SELECT id, name 
FROM shop.users 
WHERE id = 1;

DELETE FROM shop.users
WHERE id=1; 

COMMIT;

# 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

CREATE VIEW name_and_type AS
SELECT p.name, c.name AS `type`
FROM products p
JOIN
catalogs c 
WHERE p.catalog_id = c.id 

SELECT * 
FROM name_and_type

# 3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

# создаём и заполняем таблицу:
CREATE TABLE IF NOT EXISTS tasktable (
	id SERIAL PRIMARY KEY,
	created_at DATE NOT NULL
);

INSERT INTO tasktable (id,created_at) VALUES 
	(1,'2018-08-01'),
	(2,'2016-08-04'),
	(3,'2018-08-16'),
	(4,'2018-08-17');

CREATE TABLE IF NOT EXISTS august (
	id SERIAL PRIMARY KEY,
	created_at DATE NOT NULL
);

INSERT INTO august (id, created_at) VALUES 
	(1,'2018-08-01'),
	(2,'2018-08-02'),
	(3,'2018-08-03'),
	(4,'2018-08-04'),
	(5,'2018-08-05'),
	(6,'2018-08-06'),
	(7,'2018-08-07'),
	(8,'2018-08-08'),
	(9,'2018-08-09'),
	(10,'2018-08-10'),
	(11,'2018-08-11'),
	(12,'2018-08-12'),
	(13,'2018-08-13'),
	(14,'2018-08-14'),
	(15,'2018-08-15'),
	(16,'2018-08-16'),
	(17,'2018-08-17'),
	(18,'2018-08-18'),
	(19,'2018-08-19'),
	(20,'2018-08-20'),
	(21,'2018-08-21'),
	(22,'2018-08-22'),
	(23,'2018-08-23'),
	(24,'2018-08-24'),
	(25,'2018-08-25'),
	(26,'2018-08-26'),
	(27,'2018-08-27'),
	(28,'2018-08-28'),
	(29,'2018-08-29'),
	(30,'2018-08-30'),
	(31,'2018-08-31');
	
SELECT a.created_at, (
	CASE 
		WHEN a.created_at = t.created_at THEN 1 ELSE 0 END) AS `Boolean`
FROM august a 
JOIN
tasktable t
GROUP BY a.created_at, `Boolean`

# 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DELETE FROM august 
WHERE created_at NOT IN (
SELECT *
FROM (
	SELECT created_at 
	FROM august 
	ORDER BY created_at DESC
	LIMIT 5
) x
)


# Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)

# 1. Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'user1'@'localhost';
GRANT SELECT, SHOW VIEW ON shop.* TO 'user1'@'localhost';
 
CREATE USER 'user2'@'localhost';
GRANT ALL ON shop.* TO 'user2'@'localhost';

# 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

CREATE USER 'user3'@'localhost';
GRANT SELECT(id, name) ON shop.users TO 'user3'@'localhost';


# Практическое задание по теме “Хранимые процедуры и функции, триггеры"
# 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER $$
$$
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	DECLARE time INT;
	SET time = HOUR(now());
	CASE
		WHEN time BETWEEN 0 AND 5 THEN 
			RETURN 'Доброй ночи!';
		WHEN time BETWEEN 6 AND 11 THEN 
			RETURN 'Доброе утро!';
		WHEN time BETWEEN 12 AND 17 THEN 
			RETURN 'Добрый день!';
		WHEN time BETWEEN 18 AND 23 THEN 
			RETURN 'Добрый вечер!';
	END CASE;
END$$
DELIMITER ;
SELECT hello()

# 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.

DELIMITER $$
DROP TRIGGER IF EXISTS not_null $$
CREATE TRIGGER not_null BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF NEW.name IS NULL AND NEW.description IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Оба значения не могут быть NULL';
	END IF;
END $$
DELIMITER ;

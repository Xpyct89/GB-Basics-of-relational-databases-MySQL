Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

-- создаю колонки created_at и updated_at
ALTER TABLE vk.users ADD created_at DATETIME;
ALTER TABLE vk.users ADD updated_at DATETIME;

-- заполняю текущей датой и временем
UPDATE users SET created_at = NOW(), updated_at = NOW();

2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

-- неудачно проектируем таблицу
ALTER TABLE vk.users MODIFY COLUMN created_at VARCHAR(26) NULL;
ALTER TABLE vk.users MODIFY COLUMN updated_at VARCHAR(26) NULL;

UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '20.10.2017 8:10';

-- преобразование полей к формату DATETIME с сохранением значений
UPDATE users 
SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

-- преобразлвание в тип DATETIME
ALTER TABLE vk.users MODIFY COLUMN created_at DATETIME NULL;
ALTER TABLE vk.users MODIFY COLUMN updated_at DATETIME NULL;

3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

-- заполняем таблицу storehouses_products
INSERT INTO shop.storehouses_products
(id, storehouse_id, product_id, value, created_at, updated_at)
VALUES 
(1, 1, 1, 5, NOW(), NOW()),
(2, 2, 2, 6, NOW(), NOW()),
(3, 3, 3, 0, NOW(), NOW()),
(4, 4, 4, 14, NOW(), NOW()),
(5, 5, 5, 5, NOW(), NOW()),
(6, 6, 6, 0, NOW(), NOW()),
(7, 7, 7, 10, NOW(), NOW()),
(8, 8, 8, 1, NOW(), NOW()),
(9, 9, 9, 13, NOW(), NOW()),
(10, 10, 10, 0, NOW(), NOW()),
(11, 11, 11, 14, NOW(), NOW()),
(12, 12, 12, 12, NOW(), NOW()),
(13, 13, 13, 0, NOW(), NOW()),
(14, 14, 14, 1, NOW(), NOW()),
(15, 15, 15, 17, NOW(), NOW())
;

-- сортируем
SELECT * 
FROM storehouses_products 
ORDER BY CASE WHEN  value = 0 THEN 999999 ELSE value END;

4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

SELECT *
FROM users
WHERE DATE_FORMAT(birthday_at, '%M') IN ('may', 'august'); 

5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

-- 1 вариант
SELECT * 
FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY id=2, id=1, id=5
;

-- 2 вариант
SELECT * 
FROM catalogs 
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2) 
;

Практическое задание теме “Агрегация данных”

1. Подсчитайте средний возраст пользователей в таблице users

SELECT 
SUM(DATE_FORMAT(NOW() , '%Y') - DATE_FORMAT(birthday_at, '%Y'))/COUNT(birthday_at) 
FROM users
; 

2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.


SELECT
DATE_FORMAT( 					
STR_TO_DATE(				-- перевод из строчного в DATETIME формат
CONCAT_WS('.', 			-- получаю строчную дату
DATE_FORMAT(birthday_at, '%d'), 	-- день рождения
DATE_FORMAT(birthday_at, '%M'), 	-- месяц рождения
DATE_FORMAT(NOW(), '%Y')),		-- 2021 год
'%d.%M.%Y'), '%W') as WeekDay, COUNT(*)	
FROM users
GROUP BY WeekDay			-- группировка дней недели
;

3. (по желанию) Подсчитайте произведение чисел в столбце таблицы

SELECT 
EXP(SUM(LN(id))) 
FROM products
;

INSERT IGNORE INTO users (id, firstname, lastname, email, phone) # Если добавить после INSERT IGNORE, то возможная ошибка будет игнорироваться
VALUES (1, 'Ivan', 'Ivanov', 'testmail@mail.ru', '9374071116');

# Можно и так, но должны быть перечислены все колонки таблицы
INSERT IGNORE INTO users
VALUES (6, 'Nik', 'Shushin', 'testmail6@mail.ru', '9374071166', NULL);

# Более быстрый вариант (Пакетная вставка данных)
INSERT IGNORE INTO users (id, firstname, lastname, email, phone)
VALUES
(2, 'Sasha', 'Putin', 'testmail2@mail.ru', '9374071112'),
(3, 'Petr', 'Ivanov', 'testmail3@mail.ru', '9374071113'),
(4, 'Dima', 'Petrov', 'testmail4@mail.ru', '9374071114');

# Еще один способ вставки
INSERT IGNORE INTO users
SET
	id = 5,
	firstname = 'Anya',
	lastname = 'Sidorova',
	email = 'testmail5@mail.ru',
	phone = '9374071115'
;

# Вставка из другого источника (копирование)
INSERT IGNORE INTO users (firstname, lastname, email)
SELECT first_name, last_name, email
FROM sakila.staff

# Вывод информации
SELECT 'Hellow World'

# Вывод всей информации колонки 
SELECT * 
FROM users;

# Более лучший и быстрый вариант
SELECT id, firstname, lastname, email, password_hash, phone
FROM users;
# where id = 1; (фильтр отображения)
# where phone is not null; (Отобразить не пустые)
# where phone is null; (Отобразить пустые)

# Пример добавления в друзья в базе vk
INSERT INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES (1, 2, requested);

# Обновление подтвержденного статуса
UPDATE friend_requests 
SET
	status = approved
WHERE initiator_user_id  = 1 AND target_user_id  = 2
;

# Удаление сообщений
DELETE FROM messages
WHERE from_user_id = 1 AND to_user_id = 2
;
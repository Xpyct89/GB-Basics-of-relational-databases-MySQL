DROP DATABASE IF EXISTS vk; # Страхуемся если такая база уже есть
CREATE DATABASE vk; # Создаем базу
USE vk; # Переключаемся на эту базу

DROP TABLE IF EXISTS users; # Страховка на случай существования таблицы
CREATE TABLE users ( #Создаем таблицу
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, # Колонка id целочисленная(большое значение), положительное зн, не пустое зн, автозаполнение зн, с главным ключом
	# id SERIAL == BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE (Уникальный ключ)
	firstname VARCHAR(50), # Колонка имени на 50 символов
	lastname VARCHAR(50), # Колонка 2 имени на 50 символов
	email VARCHAR(100) UNIQUE, # Колонка с уникальными значениями эл почты
	phone BIGINT UNSIGNED UNIQUE, # Колонка с номерами телефонов
	password_hash VARCHAR(256),
	
	INDEX idx_users_username (firstname, lastname) # Создание индекса с уникальным именем
) COMMENT 'Пользователи'; # Создание комита

# Таблица 1 к 1
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1),
	hometown VARCHAR(100),
	created_at DATETIME DEFAULT NOW() # По умолчанию ставит время создания
);

ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id # Создание внешнего ключа
FOREIGN KEY (user_id) REFERENCES users (id); # Определение внешнего ключа

ALTER  TABLE profiles ADD COLUMN birthday DATETIME; # Добавляем в таблицу profiles колонку birthday
ALTER TABLE profiles MODIFY COLUMN birthday DATE; # Внесение изменений в колонку таблицы
ALTER TABLE profiles RENAME COLUMN birthday TO date_of_birth; # Переименовываем колонку
ALTER TABLE profiles DROP COLUMN date_of_birth; # Удалили колонку из таблицы

# Таблица 1 ко многим
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested', 'approved', 'declined', 'unfriend'), # ENUM == перечисление
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, # Проставляет время обновления
	
	PRIMARY KEY (initiator_user_id, target_user_id), # Уникальный составной ключ
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id)
	# CHECK (initiator_user_id != target_user_id) # Проверка не добавляется ли пользователь сам к себе в друзья
);

# ALTER TABLE friends_requests
# ADD CHECK (initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id SERIAL,
	name VARCHAR(255),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX (name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
	);

# Таблица многие ко многим
DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,

	PRIMARY KEY (user_id, community_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL,
	name VARCHAR(255) # 'text', 'video', 'music', 'image'
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	# media_type ENUM('text', 'video', 'music', 'image'),
	media_type_id BIGINT UNSIGNED NOT NULL,
	body VARCHAR(255),
	filename VARCHAR(255),
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP tables IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW()
);
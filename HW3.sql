/* Написать скрипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
*/
# Удаляем ранее созданную базу, если такая есть
DROP DATABASE IF EXISTS vk;
# Создаем БД заново
CREATE DATABASE vk;
# Переключаемся на нее
USE vk;
# Удаляем таблицу с процедурой проверки
DROP TABLE IF EXISTS goods_categories;
# Создаю таблицу
CREATE TABLE goods_categories (
	category_id SERIAL PRIMARY KEY, # Уникальный ID категории
	category_name VARCHAR(255) UNIQUE, # Название категории товаров
	created_at DATETIME DEFAULT NOW(), # Дата создания
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, # Дата обновления
    
    INDEX category_name_idx(category_name)
    
) COMMENT = 'Таблица категорий товаров';
# Удаляем таблицу с процедурой проверки
DROP TABLE IF EXISTS goods_description;
# Создаю таблицу
CREATE TABLE goods_description (
	goods_id SERIAL PRIMARY KEY, # Уникальный ID товара
	goods_name VARCHAR(255), # Название товара
	goods_photo VARCHAR(255) DEFAULT NULL, # Изображение товара
	goods_description TEXT, # Описание товара
	goods_price DECIMAL(10,2), # Стоимость товара
	goods_category BIGINT UNSIGNED NOT NULL, # Категория товара
	user_posted_id BIGINT UNSIGNED NOT NULL, # Пользователь предлагающий товар/услугу
	created_at DATETIME DEFAULT NOW(), # Дата создания
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, # Дата обновления
    
    INDEX goods_category_idx(goods_category),
    INDEX goods_updated_at_idx(updated_at),
    
    FOREIGN KEY fk_goods_category(goods_category) REFERENCES goods_categories(category_id),
    FOREIGN KEY (user_posted_id) REFERENCES users(id)
        
) COMMENT = 'Таблица с описанием товара';
# Удаляем таблицу с процедурой проверки
DROP TABLE IF EXISTS activity_status;
# Создаю таблицу
CREATE TABLE activity status (
	active_user_id SERIAL PRIMARY KEY NOT NULL,
	activity status ENUM('Online', 'Offline'),
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX active_user_id_idx(active_user_id),
    
    INDEX updated_at_idx(updated_at),
    
    FOREIGN KEY fk_active_user_id(active_user_id) REFERENCES users(id)

) COMMENT = 'Статус активности пользователей';

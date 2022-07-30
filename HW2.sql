# Практическое задание по теме “Управление БД”
#
/* Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
*/
/* Система Windows 11. Созданный файл my.cnf расположил на диске C:\ Его содержимое:
[mysql]
user=root
password=***********
*/
/* Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
*/
# Создаю БД с проверкой на наличие такой

create database if not exists exemple;
# Переключаюсь на созданную базу
USE example;
# Размещаю таблицу
CREATE TABLE users (id INT, name TEXT);
# Проверяю таблицу
DESCRIBE users
/* Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
*/
# Создаю БД с проверкой на наличие такой

create database if not exists sample;
# Выхожу
exit
# В командной строке (с правами администратора) перехожу в расположение mysqldump
cd "c:\Program Files\MySQL\MySQL Server 8.0\bin"
# Смотрю сожержимое
dir
# Делаю dump
mysqldump -u root -p example > sample.sql
# Разворачиваю dump
mysql -u root -p sample < sample.sql
# Перехожу в Mysql
mysql
# Проверяю БДшки
SHOW DATABASES;
DESCRIBE sample.users;

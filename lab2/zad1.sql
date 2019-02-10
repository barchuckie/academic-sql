CREATE DATABASE  `Laboratorium-Filmoteka`;

CREATE USER '244968'@'localhost' IDENTIFIED BY 'password';
SET PASSWORD FOR '244968'@'localhost' = 'patryk968';

GRANT SELECT, INSERT, UPDATE ON `Laboratorium-Filmoteka`.* TO '244968'@'localhost';
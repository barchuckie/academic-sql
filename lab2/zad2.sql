CREATE TABLE `Laboratorium-Filmoteka`.`aktorzy` (
  `aktor_id` INT NOT NULL AUTO_INCREMENT,
  `imię` VARCHAR(45) NULL,
  `nazwisko` VARCHAR(45) NULL,
  PRIMARY KEY (`aktor_id`));
  
  CREATE TABLE `Laboratorium-Filmoteka`.`filmy` (
  `film_id` INT NOT NULL AUTO_INCREMENT,
  `tytuł` VARCHAR(45) NULL,
  `gatunek` VARCHAR(45) NULL,
  `czas` INT NULL,
  `kategoria` VARCHAR(45) NULL,
  PRIMARY KEY (`film_id`));
  
  CREATE TABLE `Laboratorium-Filmoteka`.`zagrali` (
  `aktor_id` INT NOT NULL,
  `film_id` INT NOT NULL,
  PRIMARY KEY (`aktor_id`, `film_id`));

INSERT INTO `Laboratorium-Filmoteka`.`aktorzy` (imię, nazwisko)
SELECT first_name, last_name FROM `sakila`.`actor`
WHERE first_name NOT LIKE '%x%' AND first_name NOT LIKE '%q%' AND first_name NOT LIKE '%v%'
AND last_name NOT LIKE '%x%' AND last_name NOT LIKE '%q%' AND last_name NOT LIKE '%v%';

INSERT INTO `Laboratorium-Filmoteka`.`filmy` (tytuł, gatunek, czas, kategoria)
SELECT title, C.name, length, rating FROM `sakila`.`film` F JOIN `sakila`.`film_category` FC ON F.film_id = FC.film_id 
JOIN `sakila`.`category` C ON FC.category_id = C.category_id
WHERE title NOT LIKE '%x%' AND title NOT LIKE '%q%' AND title NOT LIKE '%v%';

INSERT INTO `Laboratorium-Filmoteka`.`zagrali`
SELECT LFA.aktor_id, LFF.film_id FROM `Laboratorium-Filmoteka`.`aktorzy` LFA 
JOIN `sakila`.`actor` SA ON LFA.imię = SA.first_name AND LFA.nazwisko = SA.last_name 
JOIN `sakila`.`film_actor` SFA ON SA.actor_id = SFA.actor_id
JOIN `sakila`.`film` SF ON SFA.film_id = SF.film_id
JOIN `Laboratorium-Filmoteka`.`filmy` LFF ON SF.title = LFF.tytuł;
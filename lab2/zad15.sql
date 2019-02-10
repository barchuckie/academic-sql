USE `Laboratorium-Filmoteka`;

CREATE VIEW agenci_view AS 
SELECT nazwa, wiek, typ FROM Agenci;

CREATE VIEW aktorzy_view AS 
SELECT * FROM aktorzy;

CREATE VIEW filmy_view AS 
SELECT * FROM filmy;

CREATE VIEW kontrakty_view AS 
SELECT * FROM kontrakty;

CREATE VIEW zagrali_view AS 
SELECT * FROM zagrali;

CREATE USER 'thirduser'@'localhost';
GRANT SHOW VIEW ON `laboratorium-filmoteka`.* TO 'thirduser'@'localhost';
GRANT SELECT ON `laboratorium-filmoteka`.`agenci_view` TO 'thirduser'@'localhost';
GRANT SELECT ON `laboratorium-filmoteka`.`aktorzy_view` TO 'thirduser'@'localhost';
GRANT SELECT ON `laboratorium-filmoteka`.`filmy_view` TO 'thirduser'@'localhost';
GRANT SELECT ON `laboratorium-filmoteka`.`kontrakty_view` TO 'thirduser'@'localhost';
GRANT SELECT ON `laboratorium-filmoteka`.`zagrali_view` TO 'thirduser'@'localhost';

SELECT * FROM agenci_view;

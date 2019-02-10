CREATE DATABASE laboratorium3;

USE laboratorium3;

CREATE TABLE `laboratorium3`.`ludzie` (
  `PESEL` CHAR(11) NOT NULL,
  `imię` VARCHAR(30) NULL,
  `nazwisko` VARCHAR(30) NULL,
  `data_urodzenia` DATE NULL,
  `wzrost` FLOAT NULL,
  `waga` FLOAT NULL,
  `rozmiar_buta` INT NULL,
  `ulubiony_kolor` SET('czarny', 'czerwony', 'zielony', 'niebieski', 'biały') NULL,
  PRIMARY KEY (`PESEL`));
  
CREATE TABLE `laboratorium3`.`pracownicy` (
  `PESEL` CHAR(11) NOT NULL,
  `zawód` VARCHAR(50) NULL,
  `pensja` FLOAT NULL,
  PRIMARY KEY (`PESEL`));
  
DELIMITER $$
CREATE PROCEDURE check_ludzie(pesel CHAR(11), data_uro DATE, wzrost FLOAT, waga FLOAT, rozmiar INT)
BEGIN
    IF wzrost < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Wzrost nie może być ujemny';
    END IF;
    IF waga < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Waga nie może być ujemna';
    END IF;
    IF rozmiar < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Rozmiar buta nie może być ujemny';
    END IF;
    IF data_uro > CURDATE() THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Ten człowiek się jeszcze nie narodził';
    END IF;
    
    -- CHECKING PESEL --
    IF data_uro < '1900-01-01' THEN 
		IF MONTH(data_uro) < 10 THEN
			IF SUBSTRING(pesel, 1, 6) <=> CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 8, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Pesel zawiera złą datę na początku';
			END IF;
        ELSE 
			IF SUBSTRING(pesel, 1, 6) <> CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 9, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Pesel zawiera złą datę na początku';
			END IF;
        END IF;
    ELSEIF data_uro >= '1900-01-01' AND data_uro < '2000-01-01' THEN
		IF SUBSTRING(pesel, 1, 6) <> DATE_FORMAT(data_uro, '%y%m%d') THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Pesel zawiera złą datę na początku';
		END IF;
	ELSEIF data_uro >= '2000-01-01' THEN
		IF MONTH(data_uro) < 10 THEN
			IF SUBSTRING(pesel, 1, 6) <> CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 2, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Pesel zawiera złą datę na początku';
			END IF;
        ELSE 
			IF SUBSTRING(pesel, 1, 6) <> CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 3, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3)) THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Pesel zawiera złą datę na początku';
			END IF;
        END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE check_pracownicy(pesel CHAR(11), pensja FLOAT)
BEGIN
	IF pesel NOT IN (SELECT PESEL FROM ludzie) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nie ma takiego człowieka w bazie danych';
    END IF;
    IF pensja < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Pensja nie może być ujemna';
    END IF;
    IF DATE_SUB(CURDATE(), INTERVAL 18 YEAR) < (SELECT data_urodzenia FROM ludzie L WHERE L.PESEL = pesel) THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Pracownik musi być pełnoletni';
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `laboratorium3`.`ludzie_BEFORE_INSERT`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`ludzie_BEFORE_INSERT` BEFORE INSERT ON `ludzie` FOR EACH ROW
BEGIN
	CALL check_ludzie(NEW.PESEL, NEW.data_urodzenia, NEW.wzrost, NEW.waga, NEW.rozmiar_buta);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `laboratorium3`.`ludzie_BEFORE_UPDATE`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`ludzie_BEFORE_UPDATE` BEFORE UPDATE ON `ludzie` FOR EACH ROW
BEGIN
	CALL check_ludzie(NEW.PESEL, NEW.data_urodzenia, NEW.wzrost, NEW.waga, NEW.rozmiar_buta);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `laboratorium3`.`pracownicy_BEFORE_INSERT`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`pracownicy_BEFORE_INSERT` BEFORE INSERT ON `pracownicy` FOR EACH ROW
BEGIN
	CALL check_pracownicy(NEW.PESEL, NEW.pensja);
END
$$
DELIMITER ;

DROP TRIGGER IF EXISTS `laboratorium3`.`pracownicy_BEFORE_UPDATE`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`pracownicy_BEFORE_UPDATE` BEFORE UPDATE ON `pracownicy` FOR EACH ROW
BEGIN
	CALL check_pracownicy(NEW.PESEL, NEW.pensja);
END
$$
DELIMITER ;



SET GLOBAL log_bin_trust_function_creators = 1;

CREATE FUNCTION rand_imię()
RETURNS VARCHAR(30)
RETURN(SELECT*
        FROM (SELECT 'Adam'
        UNION SELECT 'Michał'
        UNION SELECT 'Agnieszka'
        UNION SELECT 'Jerzy'
        UNION SELECT 'Henryk'
        UNION SELECT 'Janusz'
        UNION SELECT 'Feniks'
        UNION SELECT 'Artur'
        UNION SELECT 'Sara'
        UNION SELECT 'Halina') X
        ORDER BY rand()
        LIMIT 1);

CREATE FUNCTION rand_nazwisko()
RETURNS VARCHAR(30)
RETURN(SELECT*
        FROM (SELECT 'Nowak'
        UNION SELECT 'Jędrzejczak'
        UNION SELECT 'Gollob'
        UNION SELECT 'Kołodziej'
        UNION SELECT 'Kozak'
        UNION SELECT 'Bąbel'
        UNION SELECT 'Futerko'
        UNION SELECT 'Barczak'
        UNION SELECT 'Kruk'
        UNION SELECT 'Pies') X
        ORDER BY rand()
        LIMIT 1);

SET GLOBAL log_bin_trust_function_creators = 0;

DELIMITER $$
CREATE PROCEDURE fill_ludzie()
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE pesel CHAR(11);
    DECLARE imię VARCHAR(30);
    DECLARE nazwisko VARCHAR(30);
    DECLARE data_uro DATE;
    DECLARE wzrost FLOAT;
    DECLARE waga FLOAT;
    DECLARE rozmiar_buta INT;
    DECLARE ulubiony_kolor set('czarny','czerwony','zielony','niebieski','biały');
    DECLARE dzieci INT DEFAULT 0; -- MAX 25
    DECLARE emeryci INT DEFAULT 0; -- MAX 133
    
	WHILE i <= 200 DO
		SET imię = rand_imię();
        SET nazwisko = rand_nazwisko();
        IF dzieci < 25 AND emeryci < 133 THEN
			SET data_uro = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*36500) DAY);
        ELSEIF dzieci < 25 THEN
			SET data_uro = DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*23741) DAY);
		ELSEIF emeryci < 133 THEN
			SET data_uro = DATE_SUB(DATE_SUB(CURDATE(), INTERVAL 18 YEAR), INTERVAL FLOOR(RAND()*30000) DAY);
		ELSE
			SET data_uro = DATE_SUB(DATE_SUB(CURDATE(), INTERVAL 18 YEAR), INTERVAL FLOOR(RAND()*17166) DAY);
		END IF;
        SET wzrost = 1 + RAND();
        SET waga = 50 + RAND()*60;
        SET rozmiar_buta = 36 + FLOOR(RAND()*10);
        SET ulubiony_kolor = POW(2, FLOOR(RAND()*5));
        
        IF data_uro < '1900-01-01' THEN 
			IF MONTH(data_uro) < 10 THEN
				SET pesel = CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 8, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3), FLOOR(10000 + RAND()*89999));
			ELSE 
				SET pesel = CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 9, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3), FLOOR(10000 + RAND()*89999));
			END IF;
		ELSEIF data_uro >= '1900-01-01' AND data_uro < '2000-01-01' THEN
			SET pesel = CONCAT(DATE_FORMAT(data_uro, '%y%m%d'), FLOOR(10000 + RAND()*89999)); 
		ELSEIF data_uro >= '2000-01-01' THEN
			IF MONTH(data_uro) < 10 THEN
				SET pesel = CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 2, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3), FLOOR(10000 + RAND()*89999));
			ELSE 
				SET pesel = CONCAT(SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 1, 2), 3, SUBSTRING(DATE_FORMAT(data_uro, '%y%m%d'), 4, 3), FLOOR(10000 + RAND()*89999));
			END IF;
		END IF;
        
        -- IF pesel NOT IN (SELECT PESEL FROM ludzie) THEN
			INSERT INTO ludzie VALUES (pesel, imię, nazwisko, data_uro, wzrost, waga, rozmiar_buta, ulubiony_kolor);
        
			IF data_uro > DATE_SUB(CURDATE(), INTERVAL 18 YEAR) THEN
				SET dzieci = dzieci + 1;
			ELSEIF data_uro < DATE_SUB(CURDATE(), INTERVAL 65 YEAR) THEN
				SET emeryci = emeryci + 1;
			END IF;
        
			
        -- END IF;
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

DROP PROCEDURE fill_ludzie;
CALL fill_ludzie();
SELECT * FROM ludzie WHERE data_urodzenia < DATE_SUB(CURDATE(), INTERVAL 65 YEAR);
DELETE FROM ludzie WHERE PESEL <> '0';

CREATE FUNCTION rand_pesel_sprzedawca()
RETURNS CHAR(11)
RETURN(SELECT *
        FROM (SELECT PESEL FROM ludzie WHERE data_urodzenia <= DATE_SUB(CURDATE(), INTERVAL 18 YEAR) AND data_urodzenia >= DATE_SUB(CURDATE(), INTERVAL 65 YEAR) AND PESEL NOT IN (SELECT PESEL FROM pracownicy)) X
        ORDER BY rand()
        LIMIT 1);
        
CREATE FUNCTION rand_pesel()
RETURNS CHAR(11)
RETURN(SELECT *
        FROM (SELECT PESEL FROM ludzie WHERE data_urodzenia <= DATE_SUB(CURDATE(), INTERVAL 18 YEAR)  AND PESEL NOT IN (SELECT PESEL FROM pracownicy)) X
        ORDER BY rand()
        LIMIT 1);

DELIMITER $$
CREATE PROCEDURE fill_pracownicy()
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE pesel CHAR(11);
    DECLARE pen FLOAT;
    
    WHILE i <= 77 DO
		SET pesel = rand_pesel_sprzedawca();
		INSERT INTO pracownicy VALUES (pesel, 'sprzedawca', RAND()*10000);
		SET i = i + 1;
    END WHILE;
    SET i = 1;
    WHILE i <= 50 DO
		SET pesel = rand_pesel();
		INSERT INTO pracownicy VALUES (pesel, 'aktor', RAND()*10000);
		SET i = i + 1;
    END WHILE;
    SET i = 1;
    WHILE i <= 33 DO
		SET pesel = rand_pesel();
		INSERT INTO pracownicy VALUES (pesel, 'agent', RAND()*10000);
		SET i = i + 1;
    END WHILE;
    SET i = 1;
    WHILE i <= 13 DO
		SET pesel = rand_pesel();
		IF i > 1 THEN
			SET pen = ((SELECT MAX(pensja) FROM pracownicy WHERE zawód = 'informatyk')/3 + RAND()*2*(SELECT MIN(pensja) FROM pracownicy WHERE zawód = 'informatyk'));
			INSERT INTO pracownicy VALUES (pesel, 'informatyk', pen);
		ELSE
			INSERT INTO pracownicy VALUES (pesel, 'informatyk', 7000 + RAND()*3000);
		END IF;
		SET i = i + 1;
    END WHILE;
    SET i = 1;
    WHILE i <= 2 DO
		SET pesel = rand_pesel();
		INSERT INTO pracownicy VALUES (pesel, 'reporter', RAND()*10000);
		SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;
DROP PROCEDURE fill_pracownicy;
CALL fill_pracownicy();
DELETE FROM pracownicy WHERE PESEL <> '0';

SELECT * FROM pracownicy WHERE zawód = 'informatyk';
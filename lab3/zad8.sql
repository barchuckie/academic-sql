CREATE DATABASE lab3_logs;

CREATE TABLE `lab3_logs`.`pensja_log` (
  `old_val` FLOAT NULL,
  `new_val` FLOAT NULL,
  `date` DATETIME NOT NULL,
  `user` VARCHAR(255) NOT NULL);

DELIMITER $$
CREATE PROCEDURE add_log(old_val FLOAT, new_val FLOAT, date DATETIME, user VARCHAR(255))
BEGIN
	INSERT INTO `lab3_logs`.`pensja_log` VALUES (old_val, new_val, date, user);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `laboratorium3`.`pracownicy_AFTER_INSERT`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`pracownicy_AFTER_INSERT` AFTER INSERT ON `pracownicy` FOR EACH ROW
BEGIN
	CALL add_log(NULL, NEW.pensja, NOW(), CURRENT_USER);
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS `laboratorium3`.`pracownicy_AFTER_UPDATE`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`pracownicy_AFTER_UPDATE` AFTER UPDATE ON `pracownicy` FOR EACH ROW
BEGIN
	CALL add_log(OLD.pensja, NEW.pensja, NOW(), CURRENT_USER);
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS `laboratorium3`.`pracownicy_AFTER_DELETE`;

DELIMITER $$
USE `laboratorium3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `laboratorium3`.`pracownicy_AFTER_DELETE` AFTER DELETE ON `pracownicy` FOR EACH ROW
BEGIN
	CALL add_log(OLD.pensja, NULL, NOW(), CURRENT_USER);
END$$
DELIMITER ;

SELECT * FROM `lab3_logs`.`pensja_log`;

UPDATE pracownicy SET pensja = 4032.8 WHERE PESEL = '34030931566';

SELECT * FROM pracownicy WHERE zawód = 'reporter';




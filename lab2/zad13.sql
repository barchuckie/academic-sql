DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`filmy_AFTER_DELETE`;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`filmy_AFTER_DELETE` AFTER DELETE ON `filmy` FOR EACH ROW
BEGIN
	DELETE FROM zagrali WHERE zagrali.film_id = OLD.film_id;
END$$
DELIMITER ;
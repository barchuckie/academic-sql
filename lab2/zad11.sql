USE `Laboratorium-Filmoteka`;

DELIMITER $$
CREATE PROCEDURE update_aktorzy()
BEGIN
    UPDATE `Laboratorium-Filmoteka`.`aktorzy` A
	SET liczba_filmow = (SELECT COUNT(film_id) FROM `Laboratorium-Filmoteka`.`zagrali` Z WHERE A.aktor_id=Z.aktor_id ORDER BY Z.aktor_id)
	WHERE A.aktor_id > 0;
    
    UPDATE `Laboratorium-Filmoteka`.`aktorzy` A
	SET lista_filmow = (SELECT GROUP_CONCAT(tytul) FROM `Laboratorium-Filmoteka`.`zagrali` Z  
	JOIN `Laboratorium-Filmoteka`.`filmy` F ON Z.film_id = F.film_id 
	WHERE A.aktor_id = Z.aktor_id AND A.liczba_filmow < 4  GROUP BY Z.aktor_id)
	WHERE A.aktor_id > 0;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`zagrali_AFTER_INSERT`;

DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`zagrali_AFTER_INSERT` AFTER INSERT ON `zagrali` FOR EACH ROW
BEGIN
	CALL update_aktorzy();
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`zagrali_AFTER_UPDATE`;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`zagrali_AFTER_UPDATE` AFTER UPDATE ON `zagrali` FOR EACH ROW
BEGIN
	CALL update_aktorzy();
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`zagrali_AFTER_DELETE`;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`zagrali_AFTER_DELETE` AFTER DELETE ON `zagrali` FOR EACH ROW
BEGIN
	CALL update_aktorzy();
END$$
DELIMITER ;
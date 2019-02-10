USE `Laboratorium-Filmoteka`;

DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`Kontrakty_BEFORE_INSERT`;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`Kontrakty_BEFORE_INSERT` BEFORE INSERT ON `Kontrakty` FOR EACH ROW
BEGIN
	#zad4
	CALL check_kontrakty(NEW.początek, NEW. koniec, NEW.gaża);
    
    #zad12
    IF NEW.aktor NOT IN (SELECT aktor_id FROM aktorzy) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Podany aktor nie istnieje';
    END IF;
    
    IF NEW.agent NOT IN (SELECT licencja FROM Agenci) THEN
		INSERT INTO Agenci (licencja)
        VALUE(NEW.agent);
    END IF;
    
    IF NEW.aktor IN (SELECT aktor FROM Kontrakty K WHERE (NEW.początek BETWEEN K.początek AND K.koniec) OR (NEW.koniec BETWEEN K.początek AND K.koniec)) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Podany aktor ma kontrakt w tym terminie';
	END IF;
    
END$$
DELIMITER ;

SELECT * FROM Kontrakty;

INSERT INTO Kontrakty(agent, aktor, początek, koniec, gaża)
			VALUES ('Licencja321', 1, '2010-09-22', '2010-10-23', 100);
USE `Laboratorium-Filmoteka`;

DELIMITER $$
CREATE PROCEDURE longestCoop()
BEGIN
    DECLARE tmpLicence VARCHAR(30);
    DECLARE licence VARCHAR(30);
    DECLARE name VARCHAR(90);
    DECLARE age INT;
    DECLARE type SET('osoba indywidualna','agencja','inny');
    DECLARE longestPeriod INT DEFAULT 0;
    DECLARE dayCount INT;
    DECLARE agentIterator INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    
    WHILE agentIterator <= (SELECT COUNT(licencja) FROM Agenci) DO
		SET tmpLicence = CONCAT('Licencja', agentIterator);
		SET dayCount = (SELECT MAX(DATEDIFF(koniec, początek)) FROM Kontrakty WHERE agent = tmpLicence);
        IF dayCount > longestPeriod THEN
			SET longestPeriod = dayCount;
            SET licence = tmpLicence;
        END IF;
        SET agentIterator = agentIterator + 1;
    END WHILE;
    
    SELECT licencja, DATEDIFF(koniec, początek) FROM Agenci JOIN Kontrakty ON licencja = agent WHERE licencja = licence;
    
    SET name = (SELECT nazwa FROM Agenci WHERE licencja = licence);
    SET age = (SELECT wiek FROM Agenci WHERE licencja = licence);
    SET type = (SELECT typ FROM Agenci WHERE licencja = licence);
END $$
DELIMITER ;

CALL longestCoop();

SELECT MAX(DATEDIFF(koniec, początek)) FROM Kontrakty WHERE agent = 'Licencja133';

SELECT licencja FROM Agenci;
SELECT agent FROM Kontrakty;
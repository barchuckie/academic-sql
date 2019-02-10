USE `Laboratorium-Filmoteka`;

DELIMITER $$
CREATE PROCEDURE fill_historical_contract()
BEGIN
    DECLARE x INT DEFAULT 1;
    DECLARE początek DATE;
    DECLARE koniec DATE;
    DECLARE agent VARCHAR(30);
    DECLARE aktor INT;
    
    WHILE x <= 30 DO
		SET początek = date_add('2000-01-01', INTERVAL RAND()*7000 DAY);
        SET koniec = date_add(początek, INTERVAL 1 + RAND()*1000 DAY);
        SET agent = (SELECT licencja FROM Agenci ORDER BY RAND() LIMIT 1);
        SET aktor = (SELECT aktor_id FROM aktorzy ORDER BY RAND() LIMIT 1);
        
        IF aktor IN (SELECT aktor FROM Kontrakty K WHERE koniec < K.początek OR początek > K.koniec) THEN
			INSERT INTO Kontrakty(agent, aktor, początek, koniec, gaża)
			VALUES (agent, aktor, początek, koniec, RAND()*10000);
			SET x = x + 1;
        END IF;
    END WHILE;
END$$
DELIMITER ;

ALTER TABLE Kontrakty MODIFY gaża INT COMMENT "zł miesięcznie";

GRANT EXECUTE ON PROCEDURE fill_historical_contract TO '244968'@'localhost';
CALL fill_historical_contract();

SELECT * FROM Kontrakty;

INSERT INTO Kontrakty(agent, aktor, początek, koniec, gaża)
			VALUES ('Licencja321', 190, '2010-09-22', '2010-09-23', 100);
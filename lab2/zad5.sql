USE `Laboratorium-Filmoteka`;


DELIMITER $$
CREATE PROCEDURE fill_agents()
BEGIN
    DECLARE x INT DEFAULT 1;
	WHILE x <= 1000 DO
		SET @rand = RAND();
		IF (@rand < 0.33) THEN
            INSERT INTO Agenci 
				VALUES (CONCAT('Licencja', x),
					CONCAT('Agent', x), 
                    FLOOR(21 + (RAND() * 44)),
					'osoba indywidualna');
		ELSEIF (@rand < 0.66 AND @rand >= 0.33) THEN
			INSERT INTO Agenci
            VALUES (CONCAT('Licencja', x),
					CONCAT('Agent', x), 
                    FLOOR(21 + (RAND() * 44)),
					'agencja');
        ELSE
			INSERT INTO Agenci
            VALUES (CONCAT('Licencja', x),
					CONCAT('Agent', x), 
                    FLOOR(21 + (RAND() * 44)),
					'inny');
        END IF;
        SET x = x + 1;
        END WHILE;
END$$
DELIMITER ;

CALL fill_agents();

DELIMITER $$
CREATE PROCEDURE fill_contracts()
BEGIN
    DECLARE x INT DEFAULT 1;
    DECLARE początek DATE;
    DECLARE koniec DATE;
    DECLARE agent VARCHAR(30);
	
    WHILE x <= (SELECT COUNT(aktor_id) FROM aktorzy) DO
		SET początek = date_add('2000-01-01', INTERVAL RAND()*7000 DAY);
        SET koniec = date_add(początek, INTERVAL 1 + RAND()*1000 DAY);
        SET agent = (SELECT licencja FROM Agenci ORDER BY RAND() LIMIT 1);
        
        INSERT INTO Kontrakty(agent, aktor, początek, koniec, gaża)
        VALUES (agent, x, początek, koniec, RAND()*10000);
        
        SET x = x + 1;
        END WHILE;
END$$
DELIMITER ;

CALL fill_contracts();
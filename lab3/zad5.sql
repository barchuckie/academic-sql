USE laboratorium3;

DELIMITER $$
CREATE PROCEDURE zapytanie(IN agg VARCHAR(50), IN kol VARCHAR(50))
BEGIN
	IF (agg NOT IN ('AVG','COUNT','MAX','MIN','SUM','STD','VARIANCE')) THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Funkcja nie jest agregująca';
	END IF;
    
    IF (kol NOT IN ('pesel','imię','nazwisko','data_urodzenia','wzrost','waga','rozmiar_buta','ulubiony_kolor',
    'DISTINCT pesel','DISTINCT imię','DISTINCT nazwisko','DISTINCT data_urodzenia','DISTINCT wzrost','DISTINCT waga',
    'DISTINCT rozmiar_buta','DISTINCT ulubiony_kolor')) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nieprawidłowa nazwa kolumny';
	END IF;
    
    SET @Q =  CONCAT('SELECT \'', agg, '\', \'', kol, '\', ', agg, '(', kol, ') FROM ludzie');
    PREPARE stmt FROM @Q;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;

CALL zapytanie('COUNT', 'DISTINCT rozmiar_buta');
USE laboratorium3;

DELIMITER $$
CREATE PROCEDURE suma(IN kolumna SET('wzrost', 'waga', 'pensja'), IN nazwa_zawodu SET('aktor', 'agent', 'informatyk', 'reporter', 'sprzedawca'))
BEGIN
    DECLARE eps FLOAT DEFAULT 0.05;
    DECLARE delta FLOAT;
    
    IF kolumna = 1 THEN
		SET delta = 1;
	ELSEIF kolumna = 2 THEN
		SET delta = 60;
	ELSE
 		SET delta = 10000;
	END IF;
    
    -- SELECT SUM(kolumna) FROM pracownicy P JOIN ludzie L ON P.PESEL = L.PESEL WHERE zawód = nazwa_zawodu;
    SET @Q =  CONCAT('SELECT SUM(', kolumna, ') INTO @X FROM pracownicy P JOIN ludzie L ON P.PESEL = L.PESEL WHERE zawód = \'', nazwa_zawodu, '\'');
    PREPARE stmt FROM @Q;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    SELECT @X + RAND()*((eps/(2*delta))*EXP(-(@X*eps)/delta)) AS SUMA;
    SET @X = NULL;
    SET @Q = NULL;
END $$
DELIMITER ;

CALL suma('pensja', 'informatyk');
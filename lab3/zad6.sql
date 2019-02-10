USE laboratorium3;

DELIMITER $$
CREATE PROCEDURE wypłata(budget FLOAT, job VARCHAR(50))
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE pes CHAR(11);
	DECLARE encrypted_pes CHAR(11);
    DECLARE suma FLOAT;
    DECLARE pen FLOAT;
    DECLARE peselCursor CURSOR FOR 
    (SELECT PESEL, pensja FROM pracownicy WHERE zawód = job);
    DECLARE CONTINUE HANDLER
	FOR NOT FOUND SET done = TRUE;
    CREATE TABLE wypłaty (PESEL CHAR(11) NOT NULL, stan_wypłaty SET('wypłacono', 'nie wypłacono'), PRIMARY KEY(PESEL));
    SET suma = 0;
    
	START TRANSACTION;
    OPEN peselCursor;
    read_loop: LOOP
		FETCH peselCursor INTO pes, pen;
        IF done THEN
			LEAVE read_loop;
		END IF;
        SET suma = suma + pen;
        SET encrypted_pes = CONCAT('********', SUBSTRING(pes, 9, 3));
        INSERT INTO wypłaty(PESEL) VALUES (encrypted_pes);
	END LOOP;
    CLOSE peselCursor;
    
    IF suma <= budget THEN
		UPDATE wypłaty SET stan_wypłaty = 1 WHERE PESEL <> '0';
	ELSE
		UPDATE wypłaty SET stan_wypłaty = 2 WHERE PESEL <> '0';
	END IF;
    COMMIT;
    
    SELECT * FROM wypłaty;
    DROP TABLE wypłaty;
END $$
DELIMITER ;

CALL wypłata(160000, 'informatyk');
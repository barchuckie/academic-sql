USE `Laboratorium-Filmoteka`;

DELIMITER $$
CREATE PROCEDURE avg_contract(licence VARCHAR(30))
BEGIN
    IF licence NOT IN (SELECT licencja FROM Agenci) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Zły numer licencji';
	END IF;
	SELECT AVG(gaża) FROM Agenci A JOIN Kontrakty K ON A.licencja = K.agent WHERE licencja = licence GROUP BY licencja;
END$$
DELIMITER ;

CALL avg_contract('Licencja478');
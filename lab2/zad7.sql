USE `Laboratorium-Filmoteka`;

DELIMITER $$
CREATE PROCEDURE show_contract(first_name VARCHAR(45), last_name VARCHAR(45))
BEGIN
    SELECT agent, DATEDIFF(koniec, CURDATE()) AS do_końca FROM Kontrakty JOIN aktorzy
    ON aktor = aktor_id WHERE imie = first_name AND nazwisko = last_name;
END$$
DELIMITER ;
SET @licencja = 'Licencja478';
SET @str = CONCAT("SELECT COUNT(DISTINCT aktor) AS liczba_klientów FROM Kontrakty WHERE agent = ? GROUP BY agent;"); 
PREPARE stmt FROM @str;
EXECUTE stmt USING @licencja;
USE `Laboratorium-Filmoteka`;

-- Użytkownik 244968 nie może utworzyć widoku... --
CREATE VIEW zad14 AS
SELECT imie, nazwisko, agent, DATEDIFF(koniec, CURDATE()) AS do_końca
FROM aktorzy A JOIN Kontrakty K ON A.aktor_id = K.aktor
WHERE CURDATE() BETWEEN K.początek AND K.koniec;

-- ... ale może go użyć --
SELECT * FROM zad14;

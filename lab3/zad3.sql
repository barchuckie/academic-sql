USE `Laboratorium-Filmoteka`;

-- --------------------------------------------------
SELECT imię FROM aktorzy WHERE imię LIKE 'J%'; 
-- Drugi z zad1 (i_nazwisko_idx)

-- --------------------------------------------------
SELECT nazwisko FROM aktorzy WHERE liczba_filmow >= 12; 
-- Żaden nie działa

-- --------------------------------------------------
SELECT DISTINCT tytuł FROM filmy F JOIN zagrali Z1 ON F.film_id = Z1.film_id JOIN zagrali Z2 ON Z1.aktor_id = Z2.aktor_id
JOIN zagrali Z3 ON Z3.film_id = Z2.film_id JOIN aktorzy A ON Z3.aktor_id = A.aktor_id 
WHERE A.imię = 'Zero' AND A.nazwisko = 'Cage'; 
-- i_nazwisko_idx na wybraniu Zero Cage
-- sam aktor_idx na wybraniu filmów z aktorami z filmów z Cagem (Z1), czyli aktor_id musiał być równe aktor_id z Z2
-- primary (w tym aktor_idx) na Z2 oraz Z3, bo było wybieranie z aktor_id, jak i film_id
-- (primary na F, czyli wybranie tytułów, gdzie id musiało być równe film_id z Z1)

-- --------------------------------------------------
SELECT aktor, koniec FROM Kontrakty 
WHERE koniec = (SELECT MIN(koniec) FROM Kontrakty WHERE koniec >= CURDATE());
-- Index z zad2

-- --------------------------------------------------
CREATE VIEW powtórzenia_imion AS
SELECT imię, COUNT(nazwisko) AS liczba FROM aktorzy GROUP BY imię;

SELECT imię, liczba FROM powtórzenia_imion WHERE liczba = (SELECT MAX(liczba) FROM powtórzenia_imion);
-- Żaden nie działa
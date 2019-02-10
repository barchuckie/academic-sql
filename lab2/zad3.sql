ALTER TABLE `Laboratorium-Filmoteka`.`aktorzy`
ADD `liczba_filmow` INT;

ALTER TABLE `Laboratorium-Filmoteka`.`aktorzy`
ADD `lista_filmow` VARCHAR(255);

#SET SQL_SAFE_UPDATES=0;
UPDATE `Laboratorium-Filmoteka`.`aktorzy` A
SET liczba_filmow = (SELECT COUNT(film_id) FROM `Laboratorium-Filmoteka`.`zagrali` Z WHERE A.aktor_id=Z.aktor_id ORDER BY Z.aktor_id)
WHERE A.aktor_id > 0;
#SET SQL_SAFE_UPDATES=1;

UPDATE `Laboratorium-Filmoteka`.`aktorzy` A
SET lista_filmow = (SELECT GROUP_CONCAT(tytuł) FROM `Laboratorium-Filmoteka`.`zagrali` Z  
JOIN `Laboratorium-Filmoteka`.`filmy` F ON Z.film_id = F.film_id 
WHERE A.aktor_id = Z.aktor_id AND A.liczba_filmow < 4  GROUP BY Z.aktor_id)
WHERE A.aktor_id > 0;
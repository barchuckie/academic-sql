USE `Laboratorium-Filmoteka`;

CREATE INDEX koniec_idx USING BTREE ON Kontrakty (koniec);

SELECT aktor FROM Kontrakty WHERE koniec > CURDATE() AND koniec <= DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
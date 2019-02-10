CREATE TABLE `Laboratorium-Filmoteka`.`Agenci` (
  `licencja` VARCHAR(30) NOT NULL,
  `nazwa` VARCHAR(90) NULL,
  `wiek` INT NULL,
  `typ` SET('osoba indywidualna', 'agencja', 'inny') NULL,
  PRIMARY KEY (`licencja`));
  
  CREATE TABLE `Laboratorium-Filmoteka`.`Kontrakty` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `agent` VARCHAR(30) NULL,
  `aktor` INT NULL,
  `początek` DATE NULL,
  `koniec` DATE NULL,
  `gaża` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `aktorzy_idx` (`aktor` ASC) VISIBLE,
  INDEX `agent_idx` (`agent` ASC) VISIBLE,
  CONSTRAINT `aktor`
    FOREIGN KEY (`aktor`)
    REFERENCES `Laboratorium-Filmoteka`.`aktorzy` (`aktor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `agent`
    FOREIGN KEY (`agent`)
    REFERENCES `Laboratorium-Filmoteka`.`Agenci` (`licencja`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
DROP TRIGGER IF EXISTS `Laboratorium-Filmoteka`.`Agenci_BEFORE_INSERT`;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`Agenci_BEFORE_INSERT` BEFORE INSERT ON `Agenci` FOR EACH ROW
BEGIN
	IF NEW.wiek < 21 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Agent musi mieć przynajmniej 21 lat';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Laboratorium-Filmoteka`.`Kontrakty_BEFORE_INSERT` BEFORE INSERT ON `Kontrakty` FOR EACH ROW
BEGIN
	CALL check_kontrakty(NEW.początek, NEW. koniec, NEW.gaża);
END$$
DELIMITER ;

DELIMITER $$
USE `Laboratorium-Filmoteka`$$
CREATE PROCEDURE check_kontrakty(początek DATE, koniec DATE, gaża INT)
BEGIN
	IF koniec <= początek THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Kontrakt może się kończyć najwcześniej dzień po dacie rozpoczęcia';
	END IF;
    IF gaza < 0 THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Gaża nie może być ujemna';
    END IF;
END $$
DELIMITER ;
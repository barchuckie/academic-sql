USE `Laboratorium-Filmoteka`;

CREATE INDEX tytuł_idx ON filmy (tytuł);

CREATE INDEX i_nazwisko_idx ON aktorzy (imię (1), nazwisko);

CREATE INDEX aktor_idx ON zagrali (aktor_id); #already existed
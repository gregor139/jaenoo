-- jaenoo
-- Time Machine
-- Author: Gregor Duerr, Switzerland

-- Personendaten Beschreibung: https://de.wikipedia.org/wiki/Hilfe:Personendaten
-- Personendaten Download:     https://tools.wmflabs.org/persondata/data/pd_dump.txt

-- MacOS
LOAD DATA LOCAL INFILE '/Users/gregor/jaenoo/data_files/personen/pd_dump.csv' INTO TABLE STAGING.stg_pd_dump FIELDS TERMINATED BY '|';

-- Windows
LOAD DATA LOCAL INFILE 'E:\\grd\\TTC\\jaenoo\\data_files\\persons\\pd_dump.csv' INTO TABLE STAGING.stg_pd_dump FIELDS TERMINATED BY '|';
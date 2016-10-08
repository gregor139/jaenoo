# jaenoo
Time Machine
Author: Gregor Duerr, Switzerland

-- Personendaten Beschreibung: https://de.wikipedia.org/wiki/Hilfe:Personendaten
-- Personendaten Download:     https://tools.wmflabs.org/persondata/data/pd_dump.txt
LOAD DATA LOCAL INFILE '/Users/gregor/jaenoo/data_Files/Personen/pd_dump.csv' INTO TABLE STAGING.stg_personen FIELDS TERMINATED BY '|';


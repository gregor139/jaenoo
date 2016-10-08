# jaenoo
Time Machine
Author: Gregor Duerr, Switzerland

DROP TABLE IF EXISTS STAGING.stg_personen;
CREATE TABLE STAGING.stg_personen(
id BIGINT,
name1 VARCHAR(500),
name2 VARCHAR(500),
name3 VARCHAR(500),
profession VARCHAR(500),
birth_date VARCHAR(500),
birth_location VARCHAR(500),
death_date VARCHAR(500),
death_location VARCHAR(500));

-- jaenoo
-- Time Machine
-- Author: Gregor Duerr, Switzerland

DROP TABLE IF EXISTS STAGING.stg_pd_dump_tp;
CREATE TABLE STAGING.stg_pd_dump_tp(
id BIGINT,
name1 VARCHAR(500),
name2 VARCHAR(500),
name3 VARCHAR(500),
profession VARCHAR(500),
birth_date DATE,
birth_location VARCHAR(500),
death_date DATE,
death_location VARCHAR(500));

-- jaenoo
-- Time Machine
-- Author: Gregor Duerr, Switzerland

DROP TABLE IF EXISTS STAGING.stg_many_rows;
CREATE TABLE STAGING.stg_many_rows(id bigint);

INSERT INTO STAGING.stg_many_rows SELECT 1 FROM STAGING.stg_pd_dump;
INSERT INTO STAGING.stg_many_rows SELECT 1 FROM STAGING.stg_pd_dump;

-- jaenoo
-- Time Machine
-- Author: Gregor Duerr, Switzerland

-- time span
SET @d0 = "0002-01-01";
SET @d1 = "2016-12-31";
SET @date = date_sub(@d0, interval 1 day);

-- set up the time dimension table
DROP TABLE IF EXISTS DATASTORE.DIM_DATE;
CREATE TABLE DATASTORE.DIM_DATE (
date date DEFAULT NULL,
id int NOT NULL,
century smallint DEFAULT NULL,
year smallint NOT NULL,
month smallint NOT NULL,
day smallint NOT NULL,
year_week smallint NOT NULL,
week smallint NOT NULL,
quarter smallint NOT NULL,
weekday smallint NOT NULL,
month_name char(10) NOT NULL,
day_name char(10) NOT NULL,
PRIMARY KEY (id)
);

-- Load data
INSERT INTO DATASTORE.DIM_DATE
SELECT @date := date_add(@date, interval 1 day) as date,
# integer ID that allows immediate understanding
date_format(@date, "%Y%m%d") as id,
floor(year(@date)/100)+1 as century,
year(@date) as year,
month(@date) as month,
day(@date) as day,
date_format(@date, "%x") as year_week,
week(@date, 3) as week,
quarter(@date) as quarter,
weekday(@date)+1 as weekday,
monthname(@date) as month_name,
dayname(@date) as day_name
FROM STAGING.stg_many_rows T
WHERE date_add(@date, interval 1 day) <= @d1
ORDER BY date
;

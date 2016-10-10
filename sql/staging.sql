drop database IF EXISTS STAGING;
CREATE SCHEMA `STAGING` DEFAULT CHARACTER SET LATIN1 ;

drop table IF EXISTS STAGING.stg_pd_dump;
create table STAGING.stg_pd_dump(
id bigint,
name1 varchar(500),
name2 varchar(500),
name3 varchar(500),
profession varchar(500),
birth_date varchar(500),
birth_location varchar(500),
death_date varchar(500),
death_location varchar(500));

-- Personendaten Beschreibung: https://de.wikipedia.org/wiki/Hilfe:Personendaten
-- Personendaten Download:     https://tools.wmflabs.org/persondata/data/pd_dump.txt
LOAD DATA LOCAL INFILE '/Users/gregor/Documents/OneDrive/Documents/Jaenoo/Personen/pd_dump.csv' INTO TABLE STAGING.stg_pd_dump FIELDS TERMINATED BY '|';
565927 row(s) affected, 43 warning(s): 1262 Row 12155 was truncated; it contained more data than there were input columns 1262 Row 13892 was truncated; it contained more data than there were input columns 1262 Row 30063 was truncated; it contained more data than there were input columns 1262 Row 31413 was truncated; it contained more data than there were input columns 1262 Row 32767 was truncated; it contained more data than there were input columns 1262 Row 36420 was truncated; it contained more data than there were input columns 1262 Row 39572 was truncated; it contained more data than there were input columns 1262 Row 39865 was truncated; it contained more data than there were input columns 1262 Row 69383 was truncated; it contained more data than there were input columns 1262 Row 82609 was truncated; it contained more data than there were input columns 1262 Row 85529 was truncated; it contained more data than there were input columns 1262 Row 94617 was truncated; it contained more data than there were input columns 1262 Row 99539 was truncated; it contained more data than there were input columns 1262 Row 100484 was truncated; it contained more data than there were input columns 1262 Row 101350 was truncated; it contained more data than there were input columns 1262 Row 102137 was truncated; it contained more data than there were input columns 1262 Row 102228 was truncated; it contained more data than there were input columns 1262 Row 102270 was truncated; it contained more data than there were input columns 1262 Row 107026 was truncated; it contained more data than there were input columns 1262 Row 127602 was truncated; it contained more data than there were input columns 1262 Row 128425 was truncated; it contained more data than there were input columns 1262 Row 129344 was truncated; it contained more data than there were input columns 1262 Row 162676 was truncated; it contained more data than there were input columns 1262 Row 219735 was truncated; it contained more data than there were input columns 1262 Row 226094 was truncated; it contained more data than there were input columns 1262 Row 226411 was truncated; it contained more data than there were input columns 1262 Row 233830 was truncated; it contained more data than there were input columns 1262 Row 280656 was truncated; it contained more data than there were input columns 1262 Row 285547 was truncated; it contained more data than there were input columns 1262 Row 379869 was truncated; it contained more data than there were input columns 1262 Row 383447 was truncated; it contained more data than there were input columns 1262 Row 390205 was truncated; it contained more data than there were input columns 1262 Row 396662 was truncated; it contained more data than there were input columns 1262 Row 410170 was truncated; it contained more data than there were input columns 1262 Row 444486 was truncated; it contained more data than there were input columns 1262 Row 446796 was truncated; it contained more data than there were input columns 1262 Row 448094 was truncated; it contained more data than there were input columns 1262 Row 457690 was truncated; it contained more data than there were input columns 1262 Row 459534 was truncated; it contained more data than there were input columns 1262 Row 489795 was truncated; it contained more data than there were input columns 1262 Row 522528 was truncated; it contained more data than there were input columns 1262 Row 552532 was truncated; it contained more data than there were input columns 1262 Row 561107 was truncated; it contained more data than there were input columns Records: 565927  Deleted: 0  Skipped: 0  Warnings: 43

select count(*) from STAGING.stg_pd_dump;
-- 565'927

select prs.id, prs.name1, prs.name2, prs.name3, prs.profession, prs.birth_full_date, prs.death_location, prs.death_date, prs.death_full_date from (
select id, name1, name2, name3, profession,
birth_location, birth_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(birth_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as birth_full_date,
death_location, death_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(death_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as death_full_date
from STAGING.stg_pd_dump) prs
order by prs.name1;

 

-- All dates
select id, name1, name2, name3, profession,
birth_location,
birth_date,
case when birth_date like '%Jahrhundert%' and birth_date not like '%oder%' then replace(replace(birth_date,'Jahrhundert',''),'.','') end as birth_century,
case when concat('',birth_date * 1) = birth_date then birth_date end as birth_year,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(birth_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as birth_full_date,
death_location,
death_date,
case when death_date like '%Jahrhundert%' then death_date end as death_century,
case when concat('',death_date * 1) = death_date then birth_date end as death_year,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(death_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as death_full_date
from STAGING.stg_pd_dump
order by name1;

-- Century only:
select id, birth_date as birth_year
from STAGING.stg_pd_dump
where birth_date like '%Jahrhundert%'
order by name1;

-- Year only:
select id, birth_date as birth_year
from STAGING.stg_pd_dump
where concat('',birth_date * 1) = birth_date
order by name1;

-- Full date:
select id, birth_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(birth_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y')
as birth_date
from STAGING.stg_pd_dump
where birth_date not like '%Jahrhundert%'
and concat('',birth_date * 1) <> birth_date
order by name1;

SELECT DATE('30.09.2013', 'DD.MM.YYYY') AS valid;

DROP TABLE IF EXISTS STAGING.stg_many_rows;
create table STAGING.stg_many_rows(id bigint);

insert into STAGING.stg_many_rows select 1 from STAGING.stg_pd_dump;
insert into STAGING.stg_many_rows select 1 from STAGING.stg_pd_dump;

# time span
SET @d0 = "0002-01-01";
SET @d1 = "2016-12-31";
SET @date = date_sub(@d0, interval 1 day);

# set up the time dimension table
DROP TABLE IF EXISTS STAGING.DIM_DATE;
CREATE TABLE STAGING.DIM_DATE (
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

# Load data
INSERT INTO STAGING.DIM_DATE
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

 

select to_char(current_timestamp,'YYYY')

SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d');

 

select * from STAGING.DIM_DATE order by id desc;

select count(*) from DIM_DATE;
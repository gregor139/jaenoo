create table sakila.stg_personen(
id bigint,
name1 varchar(500),
name2 varchar(500),
name3 varchar(500),
profession varchar(500),
birth_date varchar(500),
birth_location varchar(500),
death_date varchar(500),
death_location varchar(255));

LOAD DATA INFILE 'C:\\tmp\\pd_dump.csv' INTO TABLE stg_personen FIELDS TERMINATED BY '|';

select count(*) from  sakila.stg_personen;
-- 565'927

select prs.id, prs.name1, prs.name2, prs.name3, prs.profession, prs.birth_full_date, prs.death_location, prs.death_date, prs.death_full_date from (
select id, name1, name2, name3, profession,
birth_location, birth_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(birth_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as birth_full_date,
death_location, death_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(death_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y') as death_full_date
from sakila.stg_personen) prs
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
from sakila.stg_personen
order by name1;

-- Century only:
select id, birth_date as birth_year
from sakila.stg_personen
where birth_date like '%Jahrhundert%'
order by name1;

-- Year only:
select id, birth_date as birth_year
from sakila.stg_personen
where concat('',birth_date * 1) = birth_date
order by name1;

-- Full date:
select id, birth_date,
STR_TO_DATE(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(birth_date, 'Januar', 'Jan'), 'Februar', 'Feb'),'März','Mar'),'April', 'Apr'),'Mai','May'),'Juni','Jun'),'Juli','Jul'),'August','Aug'),'September','Sep'),'Oktober','Oct'),'November','Nov'),'Dezember','Dec'),'%d.%b%Y')
as birth_date
from sakila.stg_personen
where birth_date not like '%Jahrhundert%'
and concat('',birth_date * 1) <> birth_date
order by name1;

SELECT DATE('30.09.2013', 'DD.MM.YYYY') AS valid;

# time span
SET @d0 = "0002-01-01";
SET @d1 = "2016-12-31";
 
SET @date = date_sub(@d0, interval 1 day);
 
# set up the time dimension table
DROP TABLE IF EXISTS DIM_DATE;
CREATE TABLE DIM_DATE (
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
  month_name  char(10) NOT NULL,
  day_name char(10) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO DIM_DATE
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
FROM  sakila.stg_personen T
WHERE date_add(@date, interval 1 day) <= @d1
ORDER BY date
;

select  to_char(current_timestamp,'YYYY')
SELECT DATE_FORMAT(SYSDATE(), '%Y-%m-%d');

select * from DIM_DATE order by id asc;

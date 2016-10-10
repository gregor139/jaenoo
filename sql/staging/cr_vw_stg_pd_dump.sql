-- jaenoo
-- Time Machine
-- Author: Gregor Duerr, Switzerland

DROP VIEW IF EXISTS STAGING.v_all_stg_pd_dump;
CREATE VIEW STAGING.v_all_stg_pd_dump AS
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

select * from tb_toddler;
Select * from tb_minor;
Select * from tb_youngadult;
Select * from tb_adult;
Select * from tb_senioradult;

-- joining table

SELECT T.Entity, T.Code, T.Year,
	T.DN_Toddler, M.DN_Minor, Y.DN_Youngadult, A.DN_Adult, S.DN_SeniorAdult
from tb_toddler T
join tb_minor M on T.Code=M.Code AND T.Entity=M.Entity AND T.Year=M.Year
JOIN tb_youngadult Y on T.Code=Y.Code AND T.Entity=Y.Entity AND T.Year=Y.Year
JOIN tb_adult A on T.Code=A.Code AND T.Entity=A.Entity AND T.Year=A.Year
JOIN tb_senioradult S on T.Code=S.Code AND T.Entity=S.Entity AND T.Year=S.Year
where T.Entity IN ('Indonesia', 'Malaysia', 'Singapore', 'Thailand', 'Brunei', 'Philippines', 'Cambodia', 'Myanmar', 'Laos', 'Vietnam');

-- creating table

drop table if exists tb_death_asean
create table tb_death_asean
(
Entity varchar (100), 
Code varchar (100), 
Year date,
TB_DN_Toddler integer,
TB_DN_Minor integer,
TB_DN_YoungAdult integer,
TB_DN_Adult integer,
TB_DN_SeniorAdult integer
)

select* from tb_death_asean;

-- rename column

alter table tb_death_asean
rename column entity to Country,
rename column Code to CountryCode;

-- changing data type

alter table tb_death_asean
modify year integer;

-- inserting data

insert into tb_death_asean
SELECT T.Entity, T.Code, T.Year,
	T.DN_Toddler, M.DN_Minor, Y.DN_Youngadult, A.DN_Adult, S.DN_SeniorAdult
from tb_toddler T
join tb_minor M on T.Code=M.Code AND T.Entity=M.Entity AND T.Year=M.Year
JOIN tb_youngadult Y on T.Code=Y.Code AND T.Entity=Y.Entity AND T.Year=Y.Year
JOIN tb_adult A on T.Code=A.Code AND T.Entity=A.Entity AND T.Year=A.Year
JOIN tb_senioradult S on T.Code=S.Code AND T.Entity=S.Entity AND T.Year=S.Year
where T.Entity IN ('Indonesia', 'Malaysia', 'Singapore', 'Thailand', 'Brunei', 'Philippines', 'Cambodia', 'Myanmar', 'Laos', 'Vietnam');

 -- total case per country each year
 
select Country, 
sum(TB_DN_Toddler) totaldn_toddler, sum(TB_DN_Minor) totaldn_minor, sum(TB_DN_YoungAdult) totaldn_YoungAdult, sum(TB_DN_Adult) totaldn_adult, sum(TB_DN_SeniorAdult) totaldn_senioradult,
(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)) Total_DN
from tb_death_asean
where year between 1999 and 2019
group by Country;


-- 1. percentage of adult death number in the country compared to total death number for each category within the year 1999 to 2019
with table_totaldn
as (
select Country, year,
sum(TB_DN_Toddler) totaldn_toddler, sum(TB_DN_Minor) totaldn_minor, sum(TB_DN_YoungAdult) totaldn_YoungAdult, sum(TB_DN_Adult) totaldn_adult, sum(TB_DN_SeniorAdult) totaldn_senioradult,
(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)) Total_DN
from tb_death_asean
where year between 1999 and 2019
group by Country, year)
select Country, year, totaldn_adult, (totaldn_adult/Total_DN)*100 as death_percentage
from table_totaldn
order by country;

-- 2. Death number percentage compared to total death number for each category from 1999 to 2019

select Country, year,
(sum(TB_DN_Toddler)/(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)))*100 toddlerdn_percentage,
(sum(TB_DN_Minor)/(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)))*100 minordn_percentage,
(sum(TB_DN_YoungAdult)/(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)))*100 youngadultdn_percentage,
(sum(TB_DN_Adult)/(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)))*100 adultdn_percentage,
(sum(TB_DN_SeniorAdult)/(sum(TB_DN_Toddler)+sum(TB_DN_Minor)+sum(TB_DN_YoungAdult)+sum(TB_DN_Adult)+sum(TB_DN_SeniorAdult)))*100 senioradultdn_percentage
from tb_death_asean
where year between 1999 and 2019
group by Country, year;


--  total case per year in asean
select Year, sum(TB_DN_Toddler), sum(TB_DN_Minor), sum(TB_DN_YoungAdult), sum(TB_DN_Adult), sum(TB_DN_SeniorAdult)
from tb_death_asean
group by Year
order by Year;

-- Percentage death number compared with grand total death number for each country in asean in the year 1999
with table_dntotal
as (
select Year, sum(TB_DN_Toddler) tdn_toddler, sum(TB_DN_Minor), sum(TB_DN_YoungAdult), sum(TB_DN_Adult), sum(TB_DN_SeniorAdult)
from tb_death_asean
where year between 1999 and 2019
group by Year)
select a.Country, a.Year, (a.TB_DN_Toddler/b.tdn_toddler)*100 as percentage
from tb_death_asean a
join table_dntotal b on a.Year=b.Year
where a.Year='1999'
order by percentage desc;

-- Creating another table for further analysis
select *
from population_demography;

alter table population_demography
rename column 'Countryname' to Country

 DROP TABLE AseanPopulationDemography
 CREATE TABLE AseanPopulationDemography
(
CountryName Varchar (65),
Year integer,
ToddlerPopulation integer,
MinorPopulation integer,
YoungAdultPopulation integer,
AdultPopulation integer,
SeniorAdultPopulation integer,
TotalPopulation integer
)

INSERT INTO AseanPopulationDemography
SELECT Country, Year,
	(Populationataged1+Populationaged1to4years) as ToddlerPopulation,
	(Populationaged5to9years+Populationaged10to14years) as MinorPopulation,
	(Populationaged15to19years+Populationaged20to29years+Populationaged30to39years+Populationaged40to49years) as YoungAdultPopulation,
	(Populationaged50to59years) as AdultPopulation,
	(Populationaged60to69years+Populationaged70to79years+Populationaged80to89years+Populationaged90to99years+Populationolderthan100years) as SeniorAdultPopulation,
	(Populationataged1+Populationaged1to4years+Populationaged5to9years+Populationaged10to14years+Populationaged15to19years+Populationaged20to29years+Populationaged30to39years+Populationaged40to49years+Populationaged50to59years+Populationaged60to69years+Populationaged70to79years+Populationaged80to89years+Populationaged90to99years+Populationolderthan100years) as TotalPopulation
FROM population_demography
WHERE Year BETWEEN '1990' AND '2019'
 AND Country IN ('Indonesia', 'Malaysia', 'Singapore', 'Thailand', 'Brunei', 'Philippines', 'Cambodia', 'Myanmar', 'Laos', 'Vietnam');
 
 
select *
from AseanPopulationDemography;

-- Percentage death number compared with total population based on age category for each country in asean
SELECT T.Country, T.year,
	(T.TB_DN_Toddler/P.ToddlerPopulation)*100 as Toddler_DNPercentage,
    (T.TB_DN_Minor/P.MinorPopulation)*100 as Minor_DNPercentage,
    (T.TB_DN_YoungAdult/P.YoungAdultPopulation)*100 as YoungAdult_DNPercentage,
    (T.TB_DN_Adult/P.AdultPopulation)*100 as Adult_DNPercentage,
    (T.TB_DN_SeniorAdult/P.SeniorAdultPopulation)*100 as SeniorAdult_DNPercentage
FROM tb_death_asean T
JOIN AseanPopulationDemography P on T.Country=P.Countryname AND T.Year=P.Year;

 -- Precentage of total death caused by TB compared to total population in each country
With Total_TBDN
as (
select Country, Year, (TB_DN_Toddler+TB_DN_Minor+TB_DN_YoungAdult+TB_DN_Adult+TB_DN_SeniorAdult) as Total_DN
from tb_death_asean)
Select T.Country, T.Year, (T.Total_DN/P.TotalPopulation)*100 as TBDN_Percentage
From Total_TBDN T
Join AseanPopulationDemography P on T.Country=P.CountryName AND T.Year=P.Year;


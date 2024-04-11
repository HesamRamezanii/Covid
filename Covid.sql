CREATE TABLE covidvdeath
(
    iso_code character varying(20) ,
    continent character varying(50) ,
    location character varying(100) ,
    date date,
    population bigint,
    total_cases integer,
    new_cases integer,
    new_cases_smoothed real,
    total_deaths integer,
    new_deaths integer,
    new_deaths_smoothed real,
    total_cases_per_million real,
    new_cases_per_million real,
    new_cases_smoothed_per_million real,
    total_deaths_per_million real,
    new_deaths_per_million real,
    new_deaths_smoothed_per_million real,
    reproduction_rate real,
    icu_patients integer,
    icu_patients_per_million real,
    hosp_patients integer,
    hosp_patients_per_million real,
    weekly_icu_admissions real,
    weekly_icu_admissions_per_million real,
    weekly_hosp_admissions real,
    weekly_hosp_admissions_per_million real
)


CREATE TABLE covidvaccination
(
    iso_code character varying(20) ,
    continent character varying(50) ,
    location character varying(100) ,
    date date,
    new_tests integer,
    total_tests integer,
    total_tests_per_thousand real,
    new_tests_per_thousand real,
    new_tests_smoothed integer,
    new_tests_smoothed_per_thousand real,
    positive_rate real,
    tests_per_case real,
    tests_units character varying(100) ,
    total_vaccinations bigint,
    people_vaccinated bigint,
    people_fully_vaccinated bigint,
    new_vaccinations bigint,
    new_vaccinations_smoothed bigint,
    total_vaccinations_per_hundred real,
    people_vaccinated_per_hundred real,
    people_fully_vaccinated_per_hundred real,
    new_vaccinations_smoothed_per_million integer,
    stringency_index real,
    population_density real,
    median_age real,
    aged_65_older real,
    aged_70_older real,
    gdp_per_capita real,
    extreme_poverty real,
    cardiovasc_death_rate real,
    diabetes_prevalence real,
    female_smokers real,
    male_smokers real,
    handwashing_facilities real,
    hospital_beds_per_thousand real,
    life_expectancy real,
    human_development_index real
)


select * from covidvaccination
select * from covidvdeath


--find max death in the world
select distinct location , population , MAx(total_deaths) over(partition by location)
from covidvdeath
where total_deaths is not null
order by 3 desc



--find max total cases in countris  
select distinct location , MAX(total_cases) as total_cases
from covidvdeath
group by location
having MAX(total_cases) is not null
ORDER BY 2 desc 



--find max total death in countris  
select distinct location , MAX(total_deaths) as total_deaths
from covidvdeath
group by location
having MAX(total_deaths) is not null
ORDER BY 2 desc 


--compare population vs icu and age
select cd.location , population , max(icu_patients) as icu_patients , aged_70_older
from covidvdeath as cd
Inner join covidvaccination as cv
ON cd.location = cv.location
group by cd.location , population , aged_70_older
having max(icu_patients) is not null
order by 3 desc , 4 desc


--compare male vs female smokers
select cd.location , population , female_smokers , male_smokers 
from covidvdeath as cd
inner join covidvaccination as cv
on cd.location = cv.location 
group by cd.location , population , female_smokers , male_smokers 



--start vaccination in countris
select cd.continent , cd.location , cd.date , cv.new_vaccinations
from covidvdeath as cd
inner join covidvaccination as cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2



--sum of asia population 
with asia as
(select distinct continent , location , population from covidvdeath
where continent like '%Asia%')

select continent , location , population , sum(population) 
over(partition by continent) as sum_of_populations
from asia



--world population
with world as
(select distinct continent , population from covidvdeath)

select continent , sum(population) from world 
where continent is not null
group by continent




--total vaccination in countries
select continent , location , max(total_vaccinations) as total_vaccinations
from covidvaccination
where continent is not null
and location is not null
and total_vaccinations is not null
group by continent , location
order by 2



--compare life expectancy
select distinct location , life_expectancy from covidvaccination
where life_expectancy is not null
order by 2 desc


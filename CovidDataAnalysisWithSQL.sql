
select*
from PortfolioProject..covidDeaths


--SELECT TH DATA

select location, continent, date, total_cases, total_deaths, population
from PortfolioProject..covidDeaths
where continent is not null
order by 3,4

--looking at total cases vs Total Deaths
--lielihood of dying if you catch covid in mentioned country
select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
FROM PortfolioProject..covidDeaths
where location like '%states%' AND total_cases!=0
order by 1,2


--looking at total cases vs population
--shows the percentage of population that was infected
select location, date, total_cases, population, (cast(total_cases as int) / cast(population as float))*100.00 as InfectedPopulation
FROM PortfolioProject..covidDeaths
where location like '%states%'
order by 1,2

--countries with highest infection rate compared to population

---select location, MAX(total_cases) AS HighestInfectionCount , MAX((cast(total_cases as int))/(cast(population as int)))*100 as infected
---from PortfolioProject..covidDeaths
-----Group by location , population

--breakdown by location
select location, MAX(cast(total_deaths as int)) AS DeathCount
from PortfolioProject..covidDeaths
where continent is not null
Group by location
order by DeathCount desc 

--breakdown by continents
select continent, MAX(cast(total_deaths as int)) AS DeathCount
from PortfolioProject..covidDeaths
where continent is not null
Group by continent
order by DeathCount desc

--global numbers 

select sum(cast(new_cases as bigint)) as "Total Cases", sum(cast(new_deaths as bigint)) as "Total Deaths", SUM(cast(new_deaths as int))/sum(cast(new_cases as bigint))*100.00 as DeathPercentage
FROM PortfolioProject..covidDeaths
---where location like '%states%' AND total_cases !=0
---where continent is not null AND new_cases !=0
--Group by date
order by 2,1


---total population vs vaccination
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths  d
Join PortfolioProject..covidVaccinations  v
     ON d.location=v.location
	 and d.date=v.date
where d.continent is not null
order by 2,3


---USE CTE

WITH PopvsVac (continent, location, date, population , new_vaccinations, RollingPeopleVaccinated)
as
(

select d.continent, d.location, d.date, cast(d.population as bigint), v.new_vaccinations,
SUM(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths  d
Join PortfolioProject..covidVaccinations  v
     ON d.location=v.location
	 and d.date=v.date
where d.continent is not null and d.population !=0
--order by 2,3
)


SELECT*, (RollingPeopleVaccinated/population)*100 AS RollingPercentage
from PopvsVac


----TEMP TABLE
DROP TABLE if exists #percentvaccinated 
Create table #percentvaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric

)
Insert into #percentvaccinated


select d.continent, d.location, d.date, population bigint, v.new_vaccinations,
SUM(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths  d
Join PortfolioProject..covidVaccinations  v
     ON d.location=v.location
	 and d.date=v.date
where d.continent is not null 
--order by 2,3



SELECT*, (RollingPeopleVaccinated/population)*100 AS RollingPercentage
from #percentvaccinated



------creating view for visualizations


CREATE VIEW percent_vaccinated 
as

select d.continent, d.location, d.date, convert(bigint, d.population) AS populations, v.new_vaccinations,
SUM(convert(bigint, v.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeaths  d
Join PortfolioProject..covidVaccinations  v
     ON d.location=v.location
	 and d.date=v.date
where d.continent is not null 

--order by 2,3

Select*
from percent_vaccinated










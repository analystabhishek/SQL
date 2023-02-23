
delete coviddeaths;
truncate coviddeaths;


select * from coviddeaths;
delete Covidvaccination;

select * from covidVaccinations;

select * from covidDeaths;

--Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2;

--Looking at Total Cases vs Total Deaths


select Location, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercenatge
from covidDeaths
order by 1,2;

--Shows likelihood of dying if you contract covid in your country
select Location, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercenatge
from covidDeaths
where location like '%india%'
order by 1,2;

--Data shows that The United States Of America reached highest peak point in second pendemic 

select Location, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercenatge
from covidDeaths
where location like '%states%'
order by 1,2;

--Looking at Total Cases vs Population
--Shows what percentage of population got covid
select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercenatge
from covidDeaths
where location like '%germany%'
order by 1,2;

--In the United States OF America 
select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from covidDeaths
where location like '%states%'
order by 1,2;

--Looking at countries with Highest Infection Rtae compared to Population
select Location,Population, Max(total_cases) as HighestInfectionCount,
Max((total_cases/population))*100 as PercentPopulationInfected
from covidDeaths
group by location, Population
order by PercentPopulationInfected desc;

select Location,Population, Max(total_cases) as HighestInfectionCount,
Max((total_cases/population))*100 as PercentPopulationInfected
from covidDeaths
where location like '%india%'
group by location, Population
order by PercentPopulationInfected desc;


--Showing countries with Highest Death count per population

select Location, Max(Total_deaths) as TotalDeathCount
from covidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc

--Let's Break Things Down By CONTINENT

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from covidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select sum(new_cases) as total_cases,
sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercent
from covidDeaths
--where continent is not null
--group by date
order by 1,2


--Total Population vs Vaccinations
--Shows Percentage of Population that has recieved at least one Covid Vaccine

Select DEATHS.continent, DEATHS.location, DEATHS.date, DEATHS.population, VACCINATION.new_vaccinations
, SUM(CONVERT(int,VACCINATION.new_vaccinations)) OVER (Partition by DEATHS.Location Order by DEATHS.location, DEATHS.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths as DEATHS
Join CovidVaccinations as VACCINATION
	On DEATHS.location = VACCINATION.location
	and DEATHS.date = VACCINATION.date
where DEATHS.continent is not null 
order by 2,3


--Looking at Total Population vs Vaccinations

select DEATHS.continent, DEATHS.location, DEATHS.date, DEATHS.population, VACCINATION.new_vaccinations,
sum(convert(int,VACCINATION.new_vaccination)) over (partition by DEATHS.location order by DEATHS.location,
DEATHS.date) as RollingPeopleVaccinated
from covidDeaths as DEATHS
join CovidVaccinations as VACCINATION
on DEATHs.location = VACCINATION.location
and DEATHs.date = VACCINATION.date


--USE CTE to perform Calculation on Partition By in previous query


with PopvsVac (continent, Location, Date, Population, New_vaccination, RollingPeoplevaccinated)
as
(
select DEATHS.continent, DEATHS.location, DEATHS.date, DEATHS.population, VACCINATION.new_vaccinations,
sum(convert(int,VACCINATION.new_vaccinations)) over (partition by DEATHS.location order by DEATHS.location,
DEATHS.date) as RollingPeopleVaccinated
from covidDeaths as DEATHS
join CovidVaccinations as VACCINATION
on DEATHs.location = VACCINATION.location
and DEATHs.date = VACCINATION.date
where DEATHS.continent is not null

)

select *,(RollingPeoplevaccinated/population)*100
from popvsvac






--Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select DEATHS.continent, DEATHS.location, DEATHS.date, DEATHS.population, VACCINATION.new_vaccinations
, SUM(CONVERT(int,VACCINATION.new_vaccinations)) OVER (Partition by DEATHS.Location Order by DEATHS.location, DEATHS.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths DEATHS
Join CovidVaccinations VACCINATION
	On DEATHS.location = VACCINATION.location
	and DEATHS.date = VACCINATION.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Craete view to store data for later visualization
Create View PercentPopulationVaccinated as
Select DEATHS.continent, DEATHS.location, DEATHS.date, DEATHS.population, VACCINATION.new_vaccinations
, SUM(CONVERT(int,VACCINATION.new_vaccinations)) OVER (Partition by DEATHS	.Location Order by DEATHS.location, DEATHS.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths as DEATHS
Join CovidVaccinations as VACCINATION
	On DEATHS.location = VACCINATION.location
	and DEATHS.date = VACCINATION.date
where DEATHS.continent is not null 


sselect *from PercentPopulationvaccinated

--Queries used for Tableau Project

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



--Just a double check based off the data provided
-- numbers are extremely close so we will keep them - 
--The Second includes "International"  Location


Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) 
as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 
as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where location = 'World'
Group By date
order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
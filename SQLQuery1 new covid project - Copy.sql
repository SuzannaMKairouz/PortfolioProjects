
Select *
From dbo.CovidData
Where continent is not null
order by 3,4 

--- select data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.CovidData
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows likelihood of dying if you contract covid in your country 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.CovidData
Where location like '%states%'
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Population 
-- Shows what percentage of population got Covid 
Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From dbo.CovidData
Where location like '%states%' and continent is not null
order by 1,2

-- Looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From dbo.CovidData
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- LET'S BREAK THINGS DOWN BY CONTINENT 


--- Showing Countries with highest Death Count per population
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From dbo.CovidData
--Where location like '%states%'
Where continent is null
Group by location
order by TotalDeathCount desc


-- Showing the continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount 
From dbo.CovidData
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS 

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From dbo.CovidData
--Where location like '%states%' 
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From dbo.CovidData
--Where location like '%states%' 
Where continent is not null
--Group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

Select date, location, continent, population, total_deaths, total_vaccinations
From dbo.CovidData
Where continent is not null
order by 3,4 

Select continent, location, date, population, new_vaccinations, SUM(CONVERT(bigint,new_vaccinations)) OVER (Partition by location Order by location, date)
as RollingPeopleVaccinated
From dbo.CovidData
where continent is not null 
order by 2, 3

-- Creating View to store data for later visualizations

Create View GlobalNumbers as 
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From dbo.CovidData
--Where location like '%states%' 
Where continent is not null
Group by date
--order by 1,2



SELECT *
FROM ..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4

--SELECT *
--FROM ..CovidVaccinations
--ORDER BY 3, 4

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2


-- Looking at Total Cases vs Total Deaths
-- Shows likelyhood of dying if you contract Covid in your country
SELECT location, date, total_cases, total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
FROM ..CovidDeaths
WHERE location like 'Canada'
AND continent is not null
ORDER BY 1, 2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS ContractionPercentage
FROM ..CovidDeaths
WHERE location like 'Canada'
AND continent is not null
ORDER BY 1, 2


-- Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS ContractionPercentage
FROM ..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY 4 DESC


-- Showing Countries with Highest Death Count per Population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM ..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY 2 DESC


--LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per Population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM ..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY 2 DESC


-- Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, CAST(SUM(CAST(new_deaths AS int))/NULLIF(SUM(new_cases), 0) * 100 AS DECIMAL(10, 2)) AS NewDeathPercentage
FROM ..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2;

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, CAST(100.0 * SUM(CAST(new_deaths AS float)) / NULLIF(SUM(new_cases), 0) AS DECIMAL(10, 5)) AS NewDeathPercentage
FROM ..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;


-- Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
FROM ..CovidDeaths dea
Join ..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2, 3

-- USE CTE

WITH PopvsVas (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
FROM ..CovidDeaths dea
Join ..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated * 100.0 / NULLIF(Population, 0)) AS Percentage_Vaccinated
From PopvsVas


-- TEMP TABLE

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
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
FROM ..CovidDeaths dea
Join ..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3

SELECT *, (RollingPeopleVaccinated * 100.0 / NULLIF(Population, 0)) AS Percentage_Vaccinated
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS Rolling_People_Vaccinated
FROM ..CovidDeaths dea
Join ..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3


-- New Table

SELECT *
FROM PercentPopulationVaccinated
--SELECT *
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3, 4

-- Select Data that we're going to use.

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2 

-- Looking at Total Deaths vs Total Cases
-- The likelihood of dying from COVID if you contract it Pakistan.
--SELECT 
--	location, 
--	date, 
--	total_cases, 
--	total_deaths, 
--	CONVERT(DECIMAL(15, 3), (CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), total_cases)))*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location = 'India'
--ORDER BY 1,2 

-- Shows the percentage of total population that has contracted COVID in Pakistan.
--SELECT 
--	location, 
--	date, 
--	total_cases, 
--	population, 
--	CONVERT(DECIMAL(15, 3), (CONVERT(DECIMAL(15, 3), total_cases) / CONVERT(DECIMAL(15, 3), population)))*100 AS DeathPercentageByPopulation
--FROM PortfolioProject..CovidDeaths
---- WHERE location = 'Pakistan'
--ORDER BY 1,2 

-- Looking at the Highest Infection Rate compared to Population.

--SELECT 
--	location, 
--	population,
--	MAX(total_cases) AS HighestInfectionCount,  
--	CONVERT(DECIMAL(15, 3), MAX((CONVERT(DECIMAL(15, 3), total_cases) / CONVERT(DECIMAL(15, 3), population))))*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC

-- Looking the Highest Death Rate compared to Population.
--SELECT 
--	location, 
--	population,
--	MAX(total_deaths) AS HighestDeathCount,  
--	CONVERT(DECIMAL(15, 3), MAX((CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), population))))*100 AS PercentPopulationDied
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY PercentPopulationDied DESC

-- BREAKING THIS DOWN

-- Looking at the continents with the highest death count.
--SELECT 
--	continent, 
--	--population,
--	MAX(cast(total_deaths AS int)) AS HighestDeathCount
--	-- CONVERT(DECIMAL(15, 3), MAX((CONVERT(DECIMAL(15, 3), total_deaths) / CONVERT(DECIMAL(15, 3), population))))*100 AS PercentPopulationDied
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY HighestDeathCount DESC

-- GLOBAL NUMBERS

--SELECT 
--	date,
--	SUM(new_cases) as total_cases,
--	SUM(new_deaths) as total_deaths,
--	CONVERT(DECIMAL(15, 3), MAX((CONVERT(DECIMAL(15, 3), new_deaths) / CONVERT(DECIMAL(15, 3), new_cases))))*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL 
--AND new_cases != 0 
--AND new_deaths != 0
--GROUP BY date
--ORDER BY 1,2

-- JOINING THE TWO TABLES.
-- Looking at Total Population vs Total Vaccinations and createing a CTE


--WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--AS 
--(
--SELECT Deaths.continent,
--		Deaths.location,
--		Deaths.date,
--		Deaths.population, 
--		Vacs.new_vaccinations,
--		SUM(CONVERT(decimal, Vacs.new_vaccinations)) 
--			OVER (PARTITION BY Deaths.location ORDER BY Deaths.location, Deaths.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths AS Deaths
--JOIN PortfolioProject..CovidVaccinations AS Vacs
--	ON Deaths.location = Vacs.location
--	AND Deaths.date = Vacs.date
--WHERE Deaths.continent IS NOT NULL
----ORDER BY 2,3
--)


--SELECT *, 
--(RollingPeopleVaccinated/population)*100 AS PercentVaccinated
--FROM PopvsVac
--ORDER BY location


-- TEMP TABLE
--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinated numeric,
--RollingPeopleVaccinated numeric 
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT Deaths.continent,
--		Deaths.location,
--		Deaths.date,
--		Deaths.population, 
--		Vacs.new_vaccinations,
--		SUM(CONVERT(decimal, Vacs.new_vaccinations)) 
--			OVER (PARTITION BY Deaths.location ORDER BY Deaths.location, Deaths.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths AS Deaths
--JOIN PortfolioProject..CovidVaccinations AS Vacs
--	ON Deaths.location = Vacs.location
--	AND Deaths.date = Vacs.date
---- WHERE Deaths.continent IS NOT NULL
---- ORDER BY 2,3

--SELECT *, 
--(RollingPeopleVaccinated/population)*100 AS PercentVaccinated
--FROM #PercentPopulationVaccinated
----ORDER BY location


-- Creating View for Visualizations down the line.
--DROP VIEW IF EXISTS PercentPopulationVaccinated
--CREATE VIEW PercentPopulationVaccinated AS
--SELECT Deaths.continent,
--		Deaths.location,
--		Deaths.date,
--		Deaths.population, 
--		Vacs.new_vaccinations,
--		SUM(CONVERT(decimal, Vacs.new_vaccinations)) 
--			OVER (PARTITION BY Deaths.location ORDER BY Deaths.location, Deaths.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths AS Deaths
--JOIN PortfolioProject..CovidVaccinations AS Vacs
--	ON Deaths.location = Vacs.location
--	AND Deaths.date = Vacs.date
--WHERE Deaths.continent IS NOT NULL


Select * 
from PercentPopulationVaccinated
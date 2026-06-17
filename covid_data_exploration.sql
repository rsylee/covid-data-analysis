USE covid_analysis_project;

SELECT location, date, total_cases, total_deaths, 
ROUND((total_deaths / total_cases) *100, 3) AS death_percentage
FROM coviddeaths
WHERE location LIKE '%states%' # to only show United States
ORDER BY 1, 2;

# Looking at Total Cases vs Population
# Shows what percentage of population got covid
SELECT location, date, population, total_cases, 
ROUND((total_cases / population) *100, 3) AS infection_percentage
FROM coviddeaths
# WHERE location LIKE '%states%'
ORDER BY 1, 2;

# Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS higest_infection_count, 
ROUND(MAX(total_cases / population) * 100, 3) AS infection_percentage
FROM coviddeaths
WHERE location LIKE '%states%'
GROUP BY  location, population
ORDER BY infection_percentage DESC;

# (1) Showing countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count DESC;

# (2) Showing continent with highest death count per population
# so now break things down by CONTINENTS
SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM coviddeaths
WHERE continent = '' # is imported as '' (instead of null)
GROUP BY location
ORDER BY total_death_count DESC; 

# global numbers
SELECT date,
       SUM(new_cases) AS total_cases, 
       SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths,
       SUM(CAST(new_deaths AS UNSIGNED)) / SUM(new_cases) * 100 AS death_percentage
FROM coviddeaths
# WHERE location LIKE '%states%'
WHERE continent != ''
GROUP BY date
# remove date from group by and select to see total cases and total deaths across all dates
# this will only show one row
ORDER BY 1, 2;

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM coviddeaths d
JOIN covidvaccinations v
	ON d.location = v.location AND d.date = v.date
WHERE d.continent != ''
order by 2,3;

SELECT d.continent, COUNT(*)
FROM coviddeaths d
JOIN covidvaccinations v
    ON d.location = v.location AND d.date = v.date
WHERE d.continent != ''
GROUP BY d.continent;

SELECT d.location, d.date, d.population, v.new_vaccinations,
       SUM(CAST(v.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_vaccinated
FROM coviddeaths d
JOIN covidvaccinations v
    ON d.location = v.location 
    AND d.date = v.date
WHERE d.continent != ''
ORDER BY d.location, d.date;

# with CTE
WITH pop_vs_vac AS (
    SELECT d.location, d.date, d.population, v.new_vaccinations,
           SUM(CAST(v.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_vaccinated
    FROM coviddeaths d
    JOIN covidvaccinations v
        ON d.location = v.location 
        AND d.date = v.date
    WHERE d.continent != ''
)
SELECT *, (rolling_vaccinated/population)*100 AS percent_vaccinated
FROM pop_vs_vac
ORDER BY location, date;

# with temp table
DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TEMPORARY TABLE PercentPopulationVaccinated (
    continent VARCHAR(255),
    location VARCHAR(255),
    date VARCHAR(50),
    population DECIMAL(20,2),
    new_vaccinations DECIMAL(20,2),
    rolling_vaccinated DECIMAL(20,2)
);

INSERT INTO PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, 
       NULLIF(v.new_vaccinations, ''),
       SUM(CAST(NULLIF(v.new_vaccinations, '') AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_vaccinated
FROM coviddeaths d
JOIN covidvaccinations v
    ON d.location = v.location 
    AND d.date = v.date
WHERE d.continent != '';

SELECT *, (rolling_vaccinated/population)*100 AS percent_vaccinated
FROM PercentPopulationVaccinated;

# creating view to store data for later visualization
CREATE VIEW PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, 
       NULLIF(v.new_vaccinations, '') AS new_vaccinations,
       SUM(CAST(NULLIF(v.new_vaccinations, '') AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.date) AS rolling_vaccinated
FROM coviddeaths d
JOIN covidvaccinations v
    ON d.location = v.location 
    AND d.date = v.date
WHERE d.continent != '';

SELECT * FROM PercentPopulationVaccinated;
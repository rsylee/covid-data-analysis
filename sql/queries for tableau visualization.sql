USE covid_analysis_project;
DROP TABLE coviddeaths;

SELECT COUNT(*) FROM coviddeaths;

#adjust data types
SET SQL_SAFE_UPDATES = 0;

UPDATE coviddeaths SET new_deaths = NULL WHERE new_deaths = '';
UPDATE coviddeaths SET total_deaths = NULL WHERE total_deaths = '';
UPDATE coviddeaths SET new_cases = NULL WHERE new_cases = '';
UPDATE coviddeaths SET total_cases = NULL WHERE total_cases = '';

ALTER TABLE coviddeaths ADD COLUMN date_fixed DATE;
UPDATE coviddeaths SET date_fixed = STR_TO_DATE(date, '%m/%d/%y');

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE coviddeaths DROP COLUMN date;
ALTER TABLE coviddeaths RENAME COLUMN date_fixed TO date;

ALTER TABLE coviddeaths 
MODIFY COLUMN new_deaths INT,
MODIFY COLUMN total_deaths INT,
MODIFY COLUMN new_cases INT,
MODIFY COLUMN total_cases INT;

#1
SELECT SUM(new_cases) AS total_cases, 
       SUM(new_deaths) AS total_deaths,
       SUM(new_deaths) / SUM(new_cases) * 100 AS death_percentage
FROM coviddeaths
WHERE continent != ''
ORDER BY 1, 2;

#2
SELECT location, SUM(new_deaths) AS total_death_count
FROM coviddeaths
WHERE (continent = '' OR continent IS NULL)
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC;

#3
SELECT location, population, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

#4
SELECT location, population, date, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;

#5
SELECT location, date, population, total_cases, total_deaths
FROM coviddeaths
WHERE continent != ''
ORDER BY 1, 2;


WITH PopvsVac AS (
    SELECT d.continent, d.location, d.date, d.population, 
           NULLIF(v.new_vaccinations, '') AS new_vaccinations,
           SUM(CAST(NULLIF(v.new_vaccinations, '') AS UNSIGNED)) OVER (PARTITION BY d.location ORDER BY d.date) AS RollingPeopleVaccinated
    FROM coviddeaths d
    JOIN covidvaccinations v
        ON d.location = v.location
        AND d.date = v.date
    WHERE d.continent != ''
)
SELECT *, (RollingPeopleVaccinated/population) * 100 AS PercentPeopleVaccinated
FROM PopvsVac;


SELECT location, population, date, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;
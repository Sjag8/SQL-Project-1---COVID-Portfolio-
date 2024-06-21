/*
Covid 19 Data Exploration 

Skills used: Joins, Windows Functions and other SQL Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT * 
FROM portfolio_project.coviddeaths
order by 3,4 ;

SELECT * 
FROM portfolio_project.covidvaccinations
order by 3,4 ;

Select *
From Portfolio_Project.CovidDeaths
Where continent is not null 
order by 3,4;

-- Retrieve all columns from the COVID deaths dataset for a specific country
select *
from portfolio_project.coviddeaths
where location = 'India' ;

-- Retrieve the total number of deaths reported for each country
SELECT location, SUM(total_deaths) AS total_deaths
FROM portfolio_project.coviddeaths
GROUP BY location;

-- Retrieve the latest date recorded in the COVID deaths dataset
SELECT MAX(date) AS latest_date
FROM portfolio_project.coviddeaths;

-- DATA ANALYSIS
-- Calculate the total number of deaths reported for each continent
SELECT continent, sum(total_deaths) AS total_deaths
FROM portfolio_project.coviddeaths
GROUP BY continent;

-- Calculate the total number of deaths reported per day globally
SELECT date, SUM(new_deaths) AS total_deaths_per_day
FROM portfolio_project.coviddeaths
GROUP BY date;

-- Calculate the percentage increase in deaths compared to the previous day for each country
SELECT location, date, new_deaths,
       (new_deaths - LAG(new_deaths) OVER (PARTITION BY location ORDER BY date)) * 100.0 / NULLIF(LAG(new_deaths) OVER (PARTITION BY location ORDER BY date), 0) AS percent_increase
FROM portfolio_project.coviddeaths;

-- Find the country with the highest number of deaths and the date when it occurred
SELECT location, date, total_deaths
FROM portfolio_project.coviddeaths
WHERE total_deaths= (SELECT MAX(total_deaths) FROM portfolio_project.coviddeaths);

-- DATA COMPARISON
-- Compare the total number of deaths reported in different continents
SELECT  continent, SUM(total_deaths) AS total_deaths
FROM portfolio_project.coviddeaths
GROUP BY continent;

-- Compare the mortality rate (deaths per capita) between different countries
SELECT location , total_deaths, population, 
       (total_deaths * 1000000.0 / population) AS mortality_rate_per_million
FROM portfolio_project.coviddeaths;

-- TEMPORAL ANALYSIS 
-- Identify the date with the highest number of deaths globally
SELECT date, MAX(total_deaths) AS max_total_deaths
FROM portfolio_project.coviddeaths
GROUP BY date;

-- Determine the average number of deaths reported per day over a specific period
SELECT  AVG(new_deaths) AS average_deaths_per_day
FROM portfolio_project.coviddeaths
WHERE date BETWEEN 'start_date' AND 'end_date';

-- Determine the average number of deaths reported per day over a specific period with specifies loaction= 'India'
SELECT location, AVG(new_deaths) AS average_deaths_per_day
FROM portfolio_project.coviddeaths
WHERE date BETWEEN 'start_date' AND 'end_date'
AND location = 'India';

-- DATA FILTERING AND AGGREGATION:
-- Retrieve the top 10 countries with the highest number of deaths
SELECT location, SUM(total_deaths) AS total_deaths
FROM portfolio_project.coviddeaths
GROUP BY location
ORDER BY total_deaths DESC
LIMIT 10;

-- Retrieve the countries where the number of deaths exceeded a certain threshold on a specific date
SELECT location , total_deaths
FROM portfolio_project.coviddeaths
WHERE total_deaths > total_cases
AND date = '3/10/2020';

-- Calculate the average number of deaths reported per day for each month
SELECT MONTH(date) AS month, AVG(new_deaths) AS average_deaths_per_day
FROM portfolio_project.coviddeaths
GROUP BY MONTH(date);

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_project.coviddeaths
Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Infection Rate compared to Population
SELECT 
    Location,
    Population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    portfolio_project.coviddeaths
WHERE
    location LIKE '%states%'
GROUP BY location , Population
ORDER BY PercentPopulationInfected DESC


-- VACCINATION DATA ANALYSIS:
-- Join the COVID deaths dataset with the COVID vaccinations dataset to analyze the relationship between vaccination rates and death rates
-- Assuming a common column like 'location' exists in both datasets

SELECT * FROM portfolio_project.covidvaccinations
JOIN portfolio_project.coviddeaths
ON coviddeaths.location = covidvaccinations.location
AND coviddeaths.date = covidvaccinations.date;

-- Relationship Between Vaccination and Death Rates:
SELECT d.location, d.total_deaths, v.total_vaccinations
FROM portfolio_project.coviddeaths d
JOIN portfolio_project.covidvaccinations v ON d.location = v.location;

-- Percentage of Population Vaccinated in Each Country:
SELECT v.location AS country,
       (v.people_vaccinated * 100.0 / d.population) AS percent_vaccinated
FROM portfolio_project.covidvaccinations v
JOIN portfolio_project.coviddeaths d ON v.location = d.location;

-- Countries with Highest and Lowest Vaccination Rates:
SELECT v.location AS country,
       (v.people_vaccinated * 100.0 / d.population) AS percent_vaccinated
FROM portfolio_project.covidvaccinations v
JOIN portfolio_project.coviddeaths d ON v.location = d.location
ORDER BY percent_vaccinated DESC
LIMIT 1;

SELECT v.location AS country,
       (v.people_vaccinated * 100.0 / d.population) AS percent_vaccinated
FROM portfolio_project.covidvaccinations v
JOIN portfolio_project.coviddeaths d ON v.location = d.location
ORDER BY percent_vaccinated ASC
LIMIT 1;

-- Identify Any Outliers or Anomalies in the Data:
SELECT location, date, total_deaths
FROM portfolio_project.coviddeaths
WHERE total_deaths > (SELECT AVG(total_deaths) + (3 * STDDEV(total_deaths)) FROM portfolio_project.coviddeaths);


-- Data Cleaning and Validation:
-- Check for Missing Values in COVID Deaths Dataset:
 SELECT COUNT(*) AS missing_values_count
FROM portfolio_project.coviddeaths
WHERE total_deaths IS NULL OR population IS NULL;

-- Data Visualization Queries:
-- Plotting Trend of Deaths Over Time for a Country:
SELECT date, new_deaths
FROM portfolio_project.coviddeaths
WHERE location = 'your_country'
ORDER BY date;

-- Visualizing Vaccination Rates Across Countries:
SELECT location, people_vaccinated_per_hundred
FROM portfolio_project.covidvaccinations
ORDER BY people_vaccinated_per_hundred DESC;


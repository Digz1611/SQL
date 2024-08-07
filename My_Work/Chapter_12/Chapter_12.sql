-- Chapter 12 

-- Listing 12-1: Using a subquery in a WHERE clause
-- This query selects counties where the population is in the top 10%
-- It first calculates the 90th percentile population using a subquery
SELECT geo_name,
       state_us_abbreviation,
       p0010001  -- Total population
FROM us_counties_2010
WHERE p0010001 >= (
    -- Subquery to find the 90th percentile population
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010
    )
ORDER BY p0010001 DESC;  -- Order by population in descending order


-- Listing 12-2: Using a subquery in a WHERE clause for DELETE
-- Create a new table us_counties_2010_top10 as a copy of us_counties_2010
CREATE TABLE us_counties_2010_top10 AS
SELECT * FROM us_counties_2010;

-- Delete counties from the new table if their population is below the 90th percentile
DELETE FROM us_counties_2010_top10
WHERE p0010001 < (
    -- Subquery to find the 90th percentile population
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
    FROM us_counties_2010_top10
    );

-- Count the remaining rows in the us_counties_2010_top10 table
SELECT count(*) FROM us_counties_2010_top10;


-- Listing 12-3: Subquery as a derived table in a FROM clause
-- Calculate the average and median population for counties, and the difference between them
SELECT round(calcs.average, 0) as average,  -- Average population, rounded to nearest whole number
       calcs.median,  -- Median population
       round(calcs.average - calcs.median, 0) AS median_average_diff  -- Difference between average and median
FROM (
     -- Subquery to calculate average and median population
     SELECT avg(p0010001) AS average,  -- Average population
            percentile_cont(.5)
                WITHIN GROUP (ORDER BY p0010001)::numeric(10,1) AS median  -- Median population
     FROM us_counties_2010
     )
AS calcs;


-- Listing 12-4: Joining two derived tables
-- Calculate the number of meat/poultry/egg plants per million people by state
SELECT census.state_us_abbreviation AS st,  -- State abbreviation
       census.st_population,  -- State population
       plants.plant_count,  -- Number of plants in the state
       round((plants.plant_count/census.st_population::numeric(10,1)) * 1000000, 1) AS plants_per_million  -- Plants per million people
FROM
    (
         -- Subquery to count the number of plants by state
         SELECT st,
                count(*) AS plant_count  -- Count of plants
         FROM meat_poultry_egg_inspect
         GROUP BY st
    )
    AS plants
JOIN
    (
        -- Subquery to sum the population by state
        SELECT state_us_abbreviation,
               sum(p0010001) AS st_population  -- Total state population
        FROM us_counties_2010
        GROUP BY state_us_abbreviation
    )
    AS census
ON plants.st = census.state_us_abbreviation  -- Join on state abbreviation
ORDER BY plants_per_million DESC;  -- Order by plants per million in descending order


-- Listing 12-5: Adding a subquery to a column list
-- Select county data and add the US median population as a column
SELECT geo_name,  -- County name
       state_us_abbreviation AS st,  -- State abbreviation
       p0010001 AS total_pop,  -- County population
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS us_median  -- US median population
FROM us_counties_2010;


-- Listing 12-6: Using a subquery expression in a calculation
-- Select county data, calculate the difference between county population and US median, filter by this difference
SELECT geo_name,  -- County name
       state_us_abbreviation AS st,  -- State abbreviation
       p0010001 AS total_pop,  -- County population
       (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
        FROM us_counties_2010) AS us_median,  -- US median population
       p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
                   FROM us_counties_2010) AS diff_from_median  -- Difference from median
FROM us_counties_2010
WHERE (p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
                   FROM us_counties_2010))
       BETWEEN -1000 AND 1000;  -- Filter counties within +/- 1000 of the median

-- BONUS: Subquery expressions
-- Examples using IN, EXISTS, and NOT EXISTS expressions

-- Create retirees table and insert data
CREATE TABLE retirees (
    id int,
    first_name varchar(50),
    last_name varchar(50)
);

INSERT INTO retirees 
VALUES (2, 'Lee', 'Smith'),
       (4, 'Janet', 'King');

-- Select employees who are also retirees using IN operator
SELECT first_name, last_name
FROM employees
WHERE emp_id IN (
    SELECT id
    FROM retirees);

-- Select all employees if there are any retirees (EXISTS evaluates to true)
SELECT first_name, last_name
FROM employees
WHERE EXISTS (
    SELECT id
    FROM retirees);

-- Using a correlated subquery to find matching values from employees in retirees
SELECT first_name, last_name
FROM employees
WHERE EXISTS (
    SELECT id
    FROM retirees
    WHERE id = employees.emp_id);


-- Listing 12-7: Using a simple CTE to find large counties
-- Define a CTE to select counties with population >= 100,000
WITH large_counties (geo_name, st, p0010001) AS
    (
        SELECT geo_name, state_us_abbreviation, p0010001
        FROM us_counties_2010
        WHERE p0010001 >= 100000
    )
-- Count the number of large counties per state
SELECT st, count(*)
FROM large_counties
GROUP BY st
ORDER BY count(*) DESC;  -- Order by count in descending order

-- Bonus: You can also write this query without a CTE
SELECT state_us_abbreviation, count(*)
FROM us_counties_2010
WHERE p0010001 >= 100000
GROUP BY state_us_abbreviation
ORDER BY count(*) DESC;


-- Listing 12-8: Using CTEs in a table join
-- Use CTEs to calculate population and plant counts by state, then join them
WITH
    counties (st, population) AS
    (
        SELECT state_us_abbreviation, sum(population_count_100_percent)
        FROM us_counties_2010
        GROUP BY state_us_abbreviation
    ),
    plants (st, plants) AS
    (
        SELECT st, count(*) AS plants
        FROM meat_poultry_egg_inspect
        GROUP BY st
    )
-- Join the CTEs on state abbreviation and calculate plants per million people
SELECT counties.st,
       population,
       plants,
       round((plants/population::numeric(10,1))*1000000, 1) AS per_million
FROM counties
JOIN plants ON counties.st = plants.st
ORDER BY per_million DESC;  -- Order by plants per million in descending order


-- Listing 12-9: Using CTEs to minimize redundant code
-- Use a CTE to calculate the US median population
WITH us_median AS 
    (
        SELECT percentile_cont(.5) 
        WITHIN GROUP (ORDER BY p0010001) AS us_median_pop
        FROM us_counties_2010
    )
-- Select county data, include US median population, and calculate difference
SELECT geo_name,
       state_us_abbreviation AS st,
       p0010001 AS total_pop,
       us_median_pop,
       p0010001 - us_median_pop AS diff_from_median 
FROM us_counties_2010
CROSS JOIN us_median
WHERE (p0010001 - us_median_pop)
       BETWEEN -1000 AND 1000;  -- Filter counties within +/- 1000 of the median

-- Cross tabulations
-- Install the crosstab() function via the tablefunc module
CREATE EXTENSION tablefunc;


-- Listing 12-10: Creating and filling the ice_cream_survey table
-- Create ice_cream_survey table with response ID, office, and flavor
CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office varchar(20),
    flavor varchar(20)
);

-- Import data from a CSV file into the ice_cream_survey table
COPY ice_cream_survey
FROM 'C:\Code_College\Java_Bootcamp\SQL\My_Work\Chapter_12\ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);


-- Listing 12-11: Generating the ice cream survey crosstab
-- Create a crosstab query to pivot ice cream survey data
SELECT *
FROM crosstab(
    'SELECT office, flavor, count(*) FROM ice_cream_survey GROUP BY office, flavor ORDER BY office',
    'SELECT flavor FROM ice_cream_survey GROUP BY flavor ORDER BY flavor'
)
AS (office varchar(20), chocolate bigint, strawberry bigint, vanilla bigint);


-- Listing 12-12: Creating and filling a temperature_readings table
-- Create temperature_readings table with reading ID, station name, date, max temp, min temp
CREATE TABLE temperature_readings (
    reading_id bigserial PRIMARY KEY,
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer
);

-- Import data from a CSV file into the temperature_readings table
COPY temperature_readings 
     (station_name, observation_date, max_temp, min_temp)
FROM 'C:\Code_College\Java_Bootcamp\SQL\My_Work\Chapter_12\temperature_readings.csv'
WITH (FORMAT CSV, HEADER);


-- Listing 12-13: Generating the temperature readings crosstab
-- Create a crosstab query to pivot temperature readings data by month
SELECT *
FROM crosstab(
    'SELECT station_name, date_part(''month'', observation_date), percentile_cont(.5) WITHIN GROUP (ORDER BY max_temp) FROM temperature_readings GROUP BY station_name, date_part(''month'', observation_date) ORDER BY station_name',
    'SELECT month FROM generate_series(1,12) month'
)
AS (station varchar(50), jan numeric(3,0), feb numeric(3,0), mar numeric(3,0), apr numeric(3,0), may numeric(3,0), jun numeric(3,0), jul numeric(3,0), aug numeric(3,0), sep numeric(3,0), oct numeric(3,0), nov numeric(3,0), dec numeric(3,0));


-- Listing 12-14: Re-classifying temperature data with CASE
-- Classify max temperature readings into categories
SELECT max_temp,
       CASE 
           WHEN max_temp >= 90 THEN 'Hot'
           WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
           WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
           WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
           WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
           ELSE 'Inhumane'
       END AS temperature_group
FROM temperature_readings;


-- Listing 12-15: Using CASE in a Common Table Expression
-- Use a CTE to classify temperatures and count occurrences by station and temperature group
WITH temps_collapsed (station_name, max_temperature_group) AS
    (
        SELECT station_name,
               CASE 
                   WHEN max_temp >= 90 THEN 'Hot'
                   WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
                   WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
                   WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
                   WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
                   ELSE 'Inhumane'
               END
        FROM temperature_readings
    )
-- Count the number of occurrences per station and temperature group
SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, count(*) DESC;  -- Order by station name and count in descending order

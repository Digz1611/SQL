-- Chapter 2
SELECT * FROM teachers;


-- Listing 2-2: Querying a subset of columns
SELECT some_column, another_column, amazing_column FROM teachers;


-- Listing 2-3: Querying distinct values in the school column
SELECT DISTINCT school
FROM teachers;


-- Listing 2-4: Querying distinct pairs of values in the school and salary columns
SELECT DISTINCT school, salary
FROM teachers;


-- Listing 2-5: Sorting a column with ORDER BY
SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;


-- Listing 2-6: Sorting multiple columns with ORDER BY
SELECT last_name, school, hire_date
FROM teachers
ORDER BY school ASC, hire_date DESC;


-- Listing 2-7: Filtering rows using WHERE
SELECT last_name, school, hire_date
FROM teachers
WHERE school = 'Myers Middle School';



-- Table 2-1: Comparison and Matching Operators in PostgreSQL
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

SELECT school
FROM teachers
WHERE school != 'F.D. Roosevelt HS';

SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;



-- Listing 2-8: Filtering with LIKE and ILIKE
SELECT first_name
FROM teachers
WHERE first_name LIKE 'sam%';

SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';


-- Listing 2-9: Combining operators using AND and OR
SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
	AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
    OR last_name = 'Bush';

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
    AND (salary < 38000 OR salary > 40000);


-- Listing 2-10: A SELECT statement including WHERE and ORDER BY
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;



-- Try It Yourself:
-- 1.
SELECT school, first_name, last_name
FROM teachers
ORDER BY school ASC, last_name ASC;
-- 2.
SELECT first_name, last_name, salary
FROM teachers
WHERE first_name LIKE 'S%' AND salary > 40000
LIMIT 1;
-- 3.
SELECT first_name, last_name, hire_date, salary,
RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;
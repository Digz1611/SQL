--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 3 Code Examples
--------------------------------------------------------------

-- Listing 3-1: Character data types in action

CREATE TABLE char_data_types (
    varchar_column varchar(10),
    char_column char(10),
    text_column text
);

INSERT INTO char_data_types
VALUES
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');

COPY char_data_types TO 'C:\YourDirectory\typetest.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- Listing 3-2: Number data types in action

CREATE TABLE number_data_types (
    numeric_column numeric(20,5),
    real_column real,
    double_column double precision
);

INSERT INTO number_data_types
VALUES
    (.7, .7, .7),
    (2.13579, 2.13579, 2.13579),
    (2.1357987654, 2.1357987654, 2.1357987654);

SELECT * FROM number_data_types;

-- Listing 3-3: Rounding issues with float columns
-- Assumes table created and loaded with Listing 3-2

SELECT
    numeric_column * 10000000 AS "Fixed",
    real_column * 10000000 AS "Float"
FROM number_data_types
WHERE numeric_column = .7;

-- Listing 3-4: Timestamp and interval types in action

CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);

INSERT INTO date_time_types
VALUES
    ('2018-12-31 01:00 EST','2 days'),
    ('2018-12-31 01:00 PST','1 month'),
    ('2018-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

SELECT * FROM date_time_types;

-- Listing 3-5: Using the interval data type
-- Assumes script 3-4 has been run

SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM date_time_types;

-- Listing 3-6: Three CAST() examples

SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM date_time_types;

SELECT numeric_column,
       CAST(numeric_column AS integer),
       CAST(numeric_column AS varchar(6))
FROM number_data_types;

-- Does not work:
SELECT CAST(char_column AS integer) FROM char_data_types;

-- Alternate notation for CAST is the double-colon:
SELECT timestamp_column::varchar(10)
FROM date_time_types;





-- 1. Appropriate Data Type for Mileage Column
-- Question:Your company delivers fruit and vegetables to local grocery stores, and you need to track the mileage driven by each driver each day to a tenth of a mile. Assuming no driver would ever travel more than 999 miles in a day, what would be an appropriate data type for the mileage column in your table? Why?

-- Answer: The appropriate data type for the mileage column would be `NUMERIC(5,1)`.

-- 2. Appropriate Data Types for Drivers’ Names
-- Question: In the table listing each driver in your company, what are appropriate data types for the drivers’ first and last names? Why is it a good idea to separate first and last names into two columns rather than having one larger name column?

-- Answer: The appropriate data type for both the first and last names would be `VARCHAR`.

-- 3. Converting Malformed Date String to Timestamp
-- Question: Assume you have a text column that includes strings formatted as dates. One of the strings is written as '4//2017'. What will happen when you try to convert that string to the timestamp data type?

-- Answer: When you try to convert the string '4//2017' to the `timestamp` data type, you will encounter an error.
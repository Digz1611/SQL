-- Project-1

-- Create department Table
CREATE TABLE department (
    depart_id SERIAL PRIMARY KEY,      -- Unique identifier for each department
    depart_name VARCHAR(100),          -- Name of the department
    depart_city VARCHAR(100)           -- City where the department is located
);

-- Insert values into department Table
INSERT INTO department (depart_name, depart_city) 
VALUES  
    ('IT','Pretoria'),                 -- Insert IT department located in Pretoria
    ('HR','Germany');                  -- Insert HR department located in Germany

-- Retrieve all data from department table
SELECT * FROM department;



-- Create roles Table
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,        -- Unique identifier for each role
    role_title VARCHAR(100)            -- Title of the role (e.g., Software Engineer, Manager)
);

-- Insert values into roles Table
INSERT INTO roles (role_title) 
VALUES 
    ('Software Engineer'),             -- Insert Software Engineer role
    ('Manager');                       -- Insert Manager role

-- Retrieve all data from roles table
SELECT * FROM roles;



-- Create salaries Table
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,      -- Unique identifier for each salary record
    salary_pa NUMERIC(10, 2)           -- Salary per annum (with two decimal places)
);

-- Insert values into salaries Table
INSERT INTO salaries (salary_pa)
VALUES  
    (78000.00),                        -- Insert a salary of 78000 per annum
    (40000.00);                        -- Insert a salary of 40000 per annum

-- Retrieve all data from salaries table
SELECT * FROM salaries;



-- Create overtime_hours Table
CREATE TABLE overtime_hours (
    overtime_id SERIAL PRIMARY KEY,    -- Unique identifier for each overtime record
    overtime_hours INTEGER             -- Number of overtime hours worked
);

-- Insert values into overtime_hours Table
INSERT INTO overtime_hours (overtime_hours)
VALUES  
    (2),                               -- Insert 2 overtime hours
    (1);                               -- Insert 1 overtime hour

-- Retrieve all data from overtime_hours table
SELECT * FROM overtime_hours;



-- Create employees Table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,    -- Unique identifier for each employee
    first_name VARCHAR(100),           -- Employee's first name
    surname VARCHAR(100),              -- Employee's surname
    gender VARCHAR(6),                 -- Employee's gender (Male/Female)
    address TEXT,                      -- Employee's address
    email VARCHAR(100) UNIQUE,         -- Employee's email, must be unique
    depart_id INTEGER REFERENCES department(depart_id),  -- Foreign key referencing department
    role_id INTEGER REFERENCES roles(role_id),           -- Foreign key referencing roles
    salary_id INTEGER REFERENCES salaries(salary_id),    -- Foreign key referencing salaries
    overtime_id INTEGER REFERENCES overtime_hours(overtime_id) -- Foreign key referencing overtime hours
);

-- Insert values into employees Table
INSERT INTO employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES  
    ('Diego', 'Langeveldt', 'Male', '141st street', 'digz@gmail.com', 1, 1, 1, 1),  -- Insert first employee record
    ('Zoella', 'Smith', 'Female', '7th street', 'anna@gmail.com', 2, 2, 2, 2);        -- Insert second employee record

-- Retrieve all data from employees table
SELECT * FROM employees;



-- Join all the tables to show the employee's complete info
SELECT 
    e.first_name,                     -- Employee's first name
    e.surname,                        -- Employee's surname
    d.depart_name,                    -- Department name
    r.role_title,                     -- Role title
    s.salary_pa,                      -- Salary per annum
    o.overtime_hours                  -- Overtime hours
FROM Employees e
LEFT JOIN 
    Department d ON e.depart_id = d.depart_id  -- Join with department table based on depart_id
LEFT JOIN 
    roles r ON e.role_id = r.role_id          -- Join with roles table based on role_id
LEFT JOIN 
    salaries s ON e.employee_id = s.salary_id -- Join with salaries table based on employee_id
LEFT JOIN 
    overtime_hours o ON e.employee_id = o.overtime_id;  -- Join with overtime_hours table based on employee_id



-- DROP all Tables 
DROP TABLE IF EXISTS department CASCADE;       
DROP TABLE IF EXISTS roles CASCADE;            
DROP TABLE IF EXISTS salaries CASCADE;        
DROP TABLE IF EXISTS overtime_hours CASCADE;    
DROP TABLE IF EXISTS employees CASCADE;         

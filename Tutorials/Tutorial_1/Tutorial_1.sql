-- Project-1

--Create the Department table
CREATE TABLE Department (
    depart_id SERIAL PRIMARY KEY,
    depart_name VARCHAR(100),
    depart_city VARCHAR(100)
);

-- Insert sample data into the Department table
INSERT INTO Department (depart_name, depart_city) 
VALUES 
('HR', 'New York'), 
('Engineering', 'San Francisco'),
('Marketing', 'Chicago');

SELECT * FROM Department;
DROP TABLE Department;


-- Create the Roles table
CREATE TABLE Roles (
    role_id SERIAL PRIMARY KEY,
    role VARCHAR(100)
);

--Insert sample data into the Roles table
INSERT INTO Roles (role) 
VALUES 
('Manager'), 
('Engineer'), 
('Technician')

SELECT * FROM Roles;
DROP TABLE Roles;


-- Create the Salaries table
CREATE TABLE Salaries (
    salary_id SERIAL PRIMARY KEY,
    salary_pa NUMERIC(10, 2)
);

-- Insert sample data into the Salaries table
INSERT INTO Salaries (salary_pa) 
VALUES 
(60000), 
(80000), 
(50000);

SELECT * FROM Salaries;
DROP TABLE Salaries;


-- Create the Overtime Hours table
CREATE TABLE Overtime_Hours (
    overtime_id SERIAL PRIMARY KEY,
    overtime_hours INTEGER
);

-- Insert sample data into the Overtime Hours table
INSERT INTO Overtime_Hours (overtime_hours) 
VALUES 
(10), 
(15), 
(20);

SELECT * FROM Overtime_Hours;
DROP TABLE Overtime_Hours;


-- Create the Employees table
CREATE TABLE Employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    surname VARCHAR(100),
    gender VARCHAR(10),
    address TEXT,
    email VARCHAR(100) UNIQUE,
    depart_id INTEGER REFERENCES Department(depart_id),
    role_id INTEGER REFERENCES Roles(role_id),
    salary_id INTEGER REFERENCES Salaries(salary_id),
    overtime_id INTEGER REFERENCES Overtime_Hours(overtime_id)
);

-- Insert sample data into the Employees table
INSERT INTO Employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id) 
VALUES 
('John', 'Doe', 'Male', '123 Street', 'john.doe@example.com', 1, 1, 1, 1),
('Jane', 'Smith', 'Female', '456 Avenue', 'jane.smith@example.com', 2, 2, 2, 2);

SELECT * FROM Employees;
DROP TABLE Employees;




-- Left Join Function 
SELECT 
    e.first_name, 
    e.surname, 
    d.depart_name, 
    r.role, 
    s.salary_pa, 
    o.overtime_hours
FROM 
    Employees e
LEFT JOIN 
    Department d ON e.depart_id = d.depart_id
LEFT JOIN 
    Roles r ON e.role_id = r.role_id
LEFT JOIN 
    Salaries s ON e.salary_id = s.salary_id
LEFT JOIN 
    Overtime_Hours o ON e.overtime_id = o.overtime_id;




-- RUN or DROP any Table
SELECT * FROM Department;
DROP TABLE Department;
SELECT * FROM Roles;
DROP TABLE Roles;
SELECT * FROM Salaries;
DROP TABLE Salaries;
SELECT * FROM Overtime_Hours;
DROP TABLE Overtime_Hours;
SELECT * FROM Employees;
DROP TABLE Employees;

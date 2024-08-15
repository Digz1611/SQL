-- Create the profession table
CREATE TABLE profession (
    prof_id SERIAL PRIMARY KEY,  
    profession VARCHAR(100) UNIQUE  
);

-- Create the zip_code table
CREATE TABLE zip_code (
    zip_code CHAR(4) PRIMARY KEY CHECK (zip_code ~ '^[0-9]{4}$'), 
    city VARCHAR(100),  
    province VARCHAR(100)  
);

-- Create the status table
CREATE TABLE status (
    status_id SERIAL PRIMARY KEY,
    status VARCHAR(100)  
);

-- Create the interests table
CREATE TABLE interests (
    interest_id SERIAL PRIMARY KEY,  
    interest VARCHAR(100)  
);

-- Creating the seeking table 
CREATE TABLE seeking (
    seeking_id SERIAL PRIMARY KEY,  
    seeking VARCHAR(100)           
);

-- Create the my_contacts table
CREATE TABLE my_contacts (
    contact_id SERIAL PRIMARY KEY,  
    last_name VARCHAR(100),  
    first_name VARCHAR(100),  
    phone VARCHAR(15),  
    email VARCHAR(100),  
    gender CHAR(1),  
    birthday DATE,  
    prof_id INT REFERENCES profession(prof_id),  
    zip_code CHAR(4) REFERENCES zip_code(zip_code),  
    status_id INT REFERENCES status(status_id)  
);

-- Create the contact_interest table
CREATE TABLE contact_interest (
    contact_id INT REFERENCES my_contacts(contact_id) ON DELETE CASCADE,
    interest_id INT REFERENCES interests(interest_id) ON DELETE CASCADE,  
    PRIMARY KEY (contact_id, interest_id) 
);

-- Create the contact_seeking table
CREATE TABLE contact_seeking (
    contact_id INT REFERENCES my_contacts(contact_id) ON DELETE CASCADE,
    seeking_id INT REFERENCES seeking(seeking_id) ON DELETE CASCADE, 
    PRIMARY KEY (contact_id, seeking_id)
);


-- Insert data into the zip_code table
-- This data includes postal codes, cities, and provinces for 9 provinces, with two cities per province
INSERT INTO zip_code (zip_code, city, province) VALUES
('1000', 'Pretoria', 'Gauteng'),
('1001', 'Cape Town', 'WP'),
('2000', 'Bloemfontein', 'Freestate'),
('2001', 'Nelspruit', 'Mpumelanga');


-- Insert data into the profession table
-- This table stores unique professions
INSERT INTO profession (profession) VALUES
('Engineer'),   -- prof_id = 1
('Doctor'),     -- prof_id = 2
('Teacher'),    -- prof_id = 3
('Artist'),     -- prof_id = 4
('Lawyer'),     -- prof_id = 5
('Nurse'),      -- prof_id = 6
('Accountant'), -- prof_id = 7
('Architect'),  -- prof_id = 8
('Chef'),       -- prof_id = 9
('Writer');     -- prof_id = 10


-- Insert data into the status table
-- This table stores statuses such as Active and Inactive
INSERT INTO status (status) VALUES
('Active'),     -- status_id = 1
('Inactive'),   -- status_id = 2
('Pending'),    -- status_id = 3
('Suspended'),  -- status_id = 4
('Retired');    -- status_id = 5


-- Insert data into the interests table
-- This table stores different interests like Hiking and Swimming
INSERT INTO interests (interest) VALUES
('Hiking'),       -- interest_id = 1
('Swimming'),     -- interest_id = 2
('Reading'),      -- interest_id = 3
('Traveling'),    -- interest_id = 4
('Cooking'),      -- interest_id = 5
('Photography'),  -- interest_id = 6
('Music'),        -- interest_id = 7
('Gardening'),    -- interest_id = 8
('Dancing'),      -- interest_id = 9
('Gaming');       -- interest_id = 10


-- Insert data into the seeking table
-- This table stores what contacts are seeking, like Friendship or Networking
INSERT INTO seeking (seeking) VALUES
('Friendship'),   -- seeking_id = 1
('Networking'),   -- seeking_id = 2
('Relationship'), -- seeking_id = 3
('Adventure'),    -- seeking_id = 4
('Learning'),     -- seeking_id = 5
('Business'),     -- seeking_id = 6
('Collaboration'),-- seeking_id = 7
('Mentorship'),   -- seeking_id = 8
('Support'),      -- seeking_id = 9
('Volunteering'); -- seeking_id = 10


-- Insert more contacts into the my_contacts table
INSERT INTO my_contacts (last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id) VALUES
('Doe', 'John', '555-555-5555', 'john.doe@example.com', 'M', '1990-01-01', 1, '1000', 1),
('Smith', 'Jane', '555-555-5556', 'jane.smith@example.com', 'F', '1985-05-15', 2, '2000', 2),
('Brown', 'Charlie', '555-555-5557', 'charlie.brown@example.com', 'M', '1980-12-12', 1, '1001', 1),
('Johnson', 'Emily', '555-555-5558', 'emily.johnson@example.com', 'F', '1995-07-20', 3, '2001', 2),
('Williams', 'Patricia', '555-555-5559', 'patricia.williams@example.com', 'F', '1988-04-15', 2, '1000', 1),
('Jones', 'Michael', '555-555-5560', 'michael.jones@example.com', 'M', '1975-03-30', 4, '2000', 1),
('Garcia', 'David', '555-555-5561', 'david.garcia@example.com', 'M', '1982-11-02', 3, '1001', 2),
('Martinez', 'Maria', '555-555-5562', 'maria.martinez@example.com', 'F', '1992-06-25', 1, '2001', 1),
('Rodriguez', 'James', '555-555-5563', 'james.rodriguez@example.com', 'M', '1987-08-18', 4, '1000', 1),
('Martinez', 'Sophia', '555-555-5564', 'sophia.martinez@example.com', 'F', '1991-10-30', 2, '2000', 2),
('Hernandez', 'Isabella', '555-555-5565', 'isabella.hernandez@example.com', 'F', '1984-09-05', 3, '1001', 1),
('Lopez', 'Alexander', '555-555-5566', 'alexander.lopez@example.com', 'M', '1993-02-17', 4, '2001', 2),
('Gonzalez', 'Mia', '555-555-5567', 'mia.gonzalez@example.com', 'F', '1989-11-23', 1, '1000', 1),
('Wilson', 'Olivia', '555-555-5568', 'olivia.wilson@example.com', 'F', '1983-01-07', 3, '2000', 1),
('Anderson', 'William', '555-555-5569', 'william.anderson@example.com', 'M', '1978-12-19', 2, '1001', 2);


-- Assigning interests to the contacts (ensuring each contact has more than two interests)
INSERT INTO contact_interest (contact_id, interest_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 4), (2, 5),
(3, 2), (3, 3), (3, 4),
(4, 1), (4, 3), (4, 5),
(5, 2), (5, 4), (5, 5),
(6, 1), (6, 2), (6, 3),
(7, 3), (7, 4), (7, 5),
(8, 1), (8, 2), (8, 3),
(9, 2), (9, 3), (9, 4),
(10, 1), (10, 2), (10, 5),
(11, 1), (11, 3), (11, 4),
(12, 2), (12, 4), (12, 5),
(13, 1), (13, 2), (13, 3),
(14, 3), (14, 4), (14, 5),
(15, 1), (15, 2), (15, 5);

-- Assigning seeking types to the contacts
INSERT INTO contact_seeking (contact_id, seeking_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2),
(3, 2),
(4, 1), (4, 2),
(5, 2),
(6, 1), (6, 2),
(7, 2),
(8, 1), (8, 2),
(9, 2),
(10, 1),
(11, 1), (11, 2),
(12, 2),
(13, 1), (13, 2),
(14, 2),
(15, 1);


-- Combined LEFT JOIN query to display profession, zip_code, city, province, status, interests, and seeking for each contact without duplicates
SELECT 
    c.first_name,
    c.last_name,
    p.profession,
    z.zip_code,
    z.city,
    z.province,
    s.status,
    STRING_AGG(DISTINCT i.interest, ', ' ORDER BY i.interest) AS interests,
    STRING_AGG(DISTINCT se.seeking, ', ' ORDER BY se.seeking) AS seeking_types
FROM my_contacts c
LEFT JOIN profession p ON c.prof_id = p.prof_id
LEFT JOIN zip_code z ON c.zip_code = z.zip_code
LEFT JOIN status s ON c.status_id = s.status_id
LEFT JOIN contact_interest ci ON c.contact_id = ci.contact_id
LEFT JOIN interests i ON ci.interest_id = i.interest_id
LEFT JOIN contact_seeking cs ON c.contact_id = cs.contact_id
LEFT JOIN seeking se ON cs.seeking_id = se.seeking_id
GROUP BY 
    c.contact_id,
    c.first_name,
    c.last_name,
    p.profession,
    z.zip_code,
    z.city,
    z.province,
    s.status;
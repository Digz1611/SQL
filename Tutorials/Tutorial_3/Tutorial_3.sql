-- Project-3

-- Creating the Products Menu Table to store product information
CREATE TABLE ProductsMenu (
    Id INT PRIMARY KEY,           -- Unique identifier for each product
    Name VARCHAR(100),            -- Name of the product
    Price DECIMAL(10, 2)          -- Price of the product with two decimal places
);

-- Creating the Cart Table to store items added to the cart by users
CREATE TABLE Cart (
    ProductId INT,                -- Identifier for the product added to the cart
    Qty INT,                      -- Quantity of the product in the cart
    FOREIGN KEY (ProductId) REFERENCES ProductsMenu(Id), -- Reference to ProductsMenu table
    PRIMARY KEY (ProductId)       -- Primary key based on ProductId
);

-- Creating the Users Table to store user information
CREATE TABLE Users (
    User_ID INT PRIMARY KEY,       -- Unique identifier for each user
    Username VARCHAR(100)          -- Username of the user
);

-- Recreate the OrderHeader table with OrderID as an auto-incrementing primary key
CREATE TABLE OrderHeader (
    OrderID SERIAL PRIMARY KEY,    -- Unique order ID, auto-incrementing
    UserID INT,                    -- Reference to the user who made the order
    OrderDate TIMESTAMP,           -- Date and time when the order was made
    FOREIGN KEY (UserID) REFERENCES Users(User_ID)  -- Foreign key to Users table
);

-- Creating the OrderDetails Table to store details of each order
CREATE TABLE OrderDetails (
    OrderHeader INT,               -- Identifier for the order (references OrderHeader table)
    ProdID INT,                    -- Identifier for the product (references ProductsMenu table)
    Qty INT,                       -- Quantity of the product in the order
    FOREIGN KEY (OrderHeader) REFERENCES OrderHeader(OrderID),  -- Foreign key to OrderHeader table
    FOREIGN KEY (ProdID) REFERENCES ProductsMenu(Id),           -- Foreign key to ProductsMenu table
    PRIMARY KEY (OrderHeader, ProdID)  -- Composite primary key based on OrderHeader and ProdID
);

-- Inserting sample data into the ProductsMenu table
INSERT INTO ProductsMenu (Id, Name, Price) VALUES
(1, 'Coke', 10.00),   -- Insert product Coke with price 10.00
(2, 'Milk', 15.00),   -- Insert product Milk with price 15.00
(3, 'Chips', 5.00),   -- Insert product Chips with price 5.00
(4, 'Bread', 12.50);  -- Insert product Bread with price 12.50

-- Inserting sample data into the Users table
INSERT INTO Users (User_ID, Username) VALUES
(1, 'Diego'),         -- Insert user Diego with User_ID 1
(2, 'Keagan'),        -- Insert user Keagan with User_ID 2
(3, 'Pierre');        -- Insert user Pierre with User_ID 3

-- Inserting sample data into the Cart table
INSERT INTO Cart (ProductId, Qty) VALUES
(1, 2),  -- Insert 2 Cokes into the cart
(2, 1);  -- Insert 1 Milk into the cart


-- Adding an item to the cart
-- Assuming we want to add 1 Coke (ProductId = 1) to the cart

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE ProductId = 1) THEN
        -- If the product exists in the cart, update the quantity
        UPDATE Cart
        SET Qty = Qty + 1
        WHERE ProductId = 1;
    ELSE
        -- If the product doesn't exist in the cart, insert it with quantity 1
        INSERT INTO Cart (ProductId, Qty)
        VALUES (1, 1);
    END IF;
END $$;


-- Removing an item from the cart
-- Assuming we want to remove 1 Coke (ProductId = 1) from the cart

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE ProductId = 1 AND Qty > 1) THEN
        -- If the quantity is more than 1, decrease it by 1
        UPDATE Cart
        SET Qty = Qty - 1
        WHERE ProductId = 1;
    ELSE
        -- If the quantity is 1, remove the item from the cart
        DELETE FROM Cart
        WHERE ProductId = 1;
    END IF;
END $$;


-- Checking out
-- Assume the UserID for the order is 1 (Diego)

DO $$
DECLARE
    newOrderID INT;
BEGIN
    -- Step 1: Insert into OrderHeader
    INSERT INTO OrderHeader (UserID, OrderDate)
    VALUES (1, NOW())  -- Insert the order with UserID 1 and the current date and time
    RETURNING OrderID INTO newOrderID;  -- Get the newly created OrderID

    -- Step 2: Insert into OrderDetails
    INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
    SELECT newOrderID, ProductId, Qty FROM Cart;  -- Insert each item in the cart into OrderDetails

    -- Step 3: Clear the Cart
    DELETE FROM Cart;  -- Remove all items from the cart after checkout
END $$;


-- Display all orders with their details
SELECT oh.OrderID, oh.OrderDate, u.Username, p.Name, od.Qty
FROM OrderHeader oh
INNER JOIN Users u ON oh.UserID = u.User_ID
INNER JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
INNER JOIN ProductsMenu p ON od.ProdID = p.Id;




-- Dropping all tables to clean up the database
DROP TABLE IF EXISTS ProductsMenu CASCADE;  
DROP TABLE IF EXISTS Cart CASCADE;         
DROP TABLE IF EXISTS Users CASCADE;        
DROP TABLE IF EXISTS OrderHeader CASCADE;   
DROP TABLE IF EXISTS OrderDetails CASCADE;  

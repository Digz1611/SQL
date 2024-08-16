-- Project-3

-- Creating the Products Menu Table to store product information
CREATE TABLE ProductsMenu (
    Id INT PRIMARY KEY,         
    Name VARCHAR(100),          
    Price DECIMAL(10, 2)        
);

-- Creating the Cart Table to store items added to the cart by users
CREATE TABLE Cart (
    ProductId INT,             
    Qty INT,                   
    FOREIGN KEY (ProductId) REFERENCES ProductsMenu(Id), 
    PRIMARY KEY (ProductId)    
);

-- Creating the Users Table to store user information
CREATE TABLE Users (
    User_ID INT PRIMARY KEY,    
    Username VARCHAR(100)       
);

-- Recreate the OrderHeader table with OrderID as an auto-incrementing primary key
CREATE TABLE OrderHeader (
    OrderID SERIAL PRIMARY KEY,   -- Use SERIAL for PostgreSQL
    UserID INT,
    OrderDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(User_ID)
);

-- Creating the OrderDetails Table to store details of each order
CREATE TABLE OrderDetails (
    OrderHeader INT,           
    ProdID INT,                 
    Qty INT,                    
    FOREIGN KEY (OrderHeader) REFERENCES OrderHeader(OrderID), 
    FOREIGN KEY (ProdID) REFERENCES ProductsMenu(Id),          
    PRIMARY KEY (OrderHeader, ProdID)  
);

-- Inserting sample data into the ProductsMenu table
INSERT INTO ProductsMenu (Id, Name, Price) VALUES
(1, 'Coke', 10.00),
(2, 'Milk', 15.00),
(3, 'Chips', 5.00),
(4, 'Bread', 12.50);

-- Inserting sample data into the Users table
INSERT INTO Users (User_ID, Username) VALUES
(1, 'Diego'),
(2, 'Keagan'),
(3, 'Pierre');

-- Inserting sample data into the Cart table
INSERT INTO Cart (ProductId, Qty) VALUES
(1, 2),  -- 2 Cokes
(2, 1);  -- 1 Chips


-- Adding an item to the cart
-- Assuming we want to add 1 Coke (ProductId = 1) to the cart

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM Cart WHERE ProductId = 1) THEN
        -- If the product exists, update the quantity
        UPDATE Cart
        SET Qty = Qty + 1
        WHERE ProductId = 1;
    ELSE
        -- If the product doesn't exist, insert it with quantity 1
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
-- Assume the UserID for the order is 1 (Dan)

DO $$
DECLARE
    newOrderID INT;
BEGIN
    -- Step 1: Insert into OrderHeader
    INSERT INTO OrderHeader (UserID, OrderDate)
    VALUES (1, NOW())  -- Assuming '1' is the UserID and using the current date and time
    RETURNING OrderID INTO newOrderID;

    -- Step 2: Insert into OrderDetails
    INSERT INTO OrderDetails (OrderHeader, ProdID, Qty)
    SELECT newOrderID, ProductId, Qty FROM Cart;

    -- Step 3: Clear the Cart
    DELETE FROM Cart;
END $$;


-- Display all orders with their details
SELECT oh.OrderID, oh.OrderDate, u.Username, p.Name, od.Qty
FROM OrderHeader oh
INNER JOIN Users u ON oh.UserID = u.User_ID
INNER JOIN OrderDetails od ON oh.OrderID = od.OrderHeader
INNER JOIN ProductsMenu p ON od.ProdID = p.Id;


DROP TABLE IF EXISTS ProductsMenu CASCADE;
DROP TABLE IF EXISTS Cart CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS OrderHeader CASCADE;
DROP TABLE IF EXISTS OrderDetails CASCADE;





-- Question 1 Achieving 1NF (First Normal Form) 🛠️


-- Step 1: Remove the 'Products' column (it violates 1NF)
ALTER TABLE ProductDetail
DROP COLUMN Products;

-- Step 2: Create 'Customers' table to store customer information
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Step 3: Create 'Orders' table to store orders, linking to the Customers table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) -- Foreign key constraint
);

-- Step 4: Create 'Products' table to store product information
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL
);

-- Step 5: Create 'OrderProducts' junction table to map orders to products (many-to-many relationship)
CREATE TABLE OrderProducts (
    OrderID INT,
    ProductID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    PRIMARY KEY (OrderID, ProductID)
);

-- Step 6: Insert unique customers into 'Customers' table
INSERT INTO Customers (CustomerName) VALUES
('John Doe'),        -- CustomerID = 1
('Jane Smith'),      -- CustomerID = 2
('Emily Clark');     -- CustomerID = 3

-- Step 7: Insert orders into 'Orders' table with corresponding customer IDs
INSERT INTO Orders (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Step 8: Insert products into 'Products' table
INSERT INTO Products (ProductName) VALUES
('Laptop'),        -- ProductID = 1
('Mouse'),         -- ProductID = 2
('Tablet'),        -- ProductID = 3
('Keyboard'),      -- ProductID = 4
('Phone');         -- ProductID = 5

-- Step 9: Insert order-product mappings into 'OrderProducts' table
-- Order 101: Laptop, Mouse
INSERT INTO OrderProducts VALUES (101, 1), (101, 2);

-- Order 102: Tablet, Keyboard, Mouse
INSERT INTO OrderProducts VALUES (102, 3), (102, 4), (102, 2);

-- Order 103: Phone
INSERT INTO OrderProducts VALUES (103, 5);







-- Question 2 Achieving 2NF (Second Normal Form) 🧩


-- Step 1: Create a 'Customers' table to store customer information
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

-- Step 2: Insert unique customers into the 'Customers' table
INSERT INTO Customers (CustomerName) 
SELECT DISTINCT CustomerName FROM OrderDetails;

-- Step 3: Create an 'Orders' table to store orders, linking to the 'Customers' table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Step 4: Insert data into the 'Orders' table from the original 'OrderDetails' table
INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT OrderID, 
       (SELECT CustomerID FROM Customers WHERE CustomerName = od.CustomerName) AS CustomerID
FROM OrderDetails od;

-- Step 5: Create a new 'OrderDetails' table (without the 'CustomerName' column)
CREATE TABLE OrderDetails2 (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 6: Insert data into the 'OrderDetails2' table (now without partial dependencies)
INSERT INTO OrderDetails2 (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Step 7: Optionally, drop the old 'OrderDetails' table (if no longer needed)
DROP TABLE OrderDetails;


-- Creating a Table
CREATE TABLE Products (
    productid INT PRIMARY KEY,
    lowfats CHAR(1),
    recyclable CHAR(1)
);

-- Inserting Values
INSERT INTO Products (productid, lowfats, recyclable)
VALUES
    (0, 'Y', 'N'),
    (1, 'Y', 'Y'),
    (2, 'N', 'Y'),
    (3, 'Y', 'Y'),
    (4, 'N', 'N');

-- Checking the table we created
SELECT *
FROM Products

-- Generating the output
SELECT productid
FROM Products
WHERE lowfats = 'Y' AND recyclable = 'Y';

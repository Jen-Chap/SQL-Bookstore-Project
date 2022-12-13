CREATE DATABASE bookstore;
USE bookstore;

#Creating tables
CREATE TABLE Bookinfo(
Book_ID INTEGER,
Book_title VARCHAR(100) NOT NULL,
Author_firstname VARCHAR(50),
Author_surname VARCHAR(50),
Release_date INTEGER,
PRIMARY KEY (Book_ID)
 );

CREATE TABLE Stock(
Book_ID INTEGER,
Book_title VARCHAR(100) NOT NULL,
No_instock INTEGER NOT NULL,
PRIMARY KEY(Book_title),
FOREIGN KEY (Book_ID) REFERENCES Bookinfo(Book_ID)
);

CREATE TABLE Price(
Book_ID INTEGER,
Our_price DECIMAL(6,2) NOT NULL,
PRIMARY KEY(Book_ID));

CREATE TABLE Reviews(
Book_ID INTEGER,
Book_title VARCHAR(100) NOT NULL,
Rating INTEGER,
Comments VARCHAR(255),
PRIMARY KEY(Book_title),
FOREIGN KEY (Book_ID) REFERENCES Bookinfo(Book_ID));

CREATE TABLE Customers(
Cust_ID INTEGER,
Firstname VARCHAR(50),
Surname VARCHAR(50),
Email VARCHAR(100),
Num_orders INTEGER,
PRIMARY KEY(Cust_ID));

CREATE TABLE Orders(
Order_ID INTEGER,
Order_date DATE,
Cust_ID INTEGER,
Book_ID INTEGER,
Num_copies INTEGER,
PRIMARY KEY(Order_ID),
FOREIGN KEY (Cust_ID) REFERENCES Customers(Cust_ID),
FOREIGN KEY (Book_ID) REFERENCES Bookinfo(Book_ID));

#Inserting data
INSERT INTO Bookinfo 
VALUES 
(1, "War and Peace", "Leo", "Tolstoy", 1869),
(2, "Pride and Prejudice", "Jane", "Austen", 1813),
(3, "Jane Eyre", "Charlotte", "Bronte", 1847),
(4, "Lord of the Rings", "J.R.R", "Tolkein", 1954),
(5, "1984", "George", "Orwell", 1949),
(6, "The Hitchhiker's Guide to the Galaxy", "Douglas", "Adams", 1979),
(7, "The Lion, the Witch & the Wardrobe", "C.S.", "Lewis", 1950),
(8, "Animal Farm", "George", "Orwell", 1945),
(9, "The Handmaid's Tale", "Margaret", "Atwood", 1985),
(10, "Sense & Sensibility", "Jane", "Austen", 1811),
(11, "Emma", "Jane", "Austen", 1815),
(12, "The life of Pi", "Yann", "Martel", 2001),
(13, "Brave New World", "Aldous", "Huxley", 1932);

INSERT INTO Stock
VALUES
(1, "War and Peace", 20),
(2, "Pride and Prejudice", 1),
(3, "Jane Eyre", 32),
(4, "Lord of the Rings", 0),
(5, "1984", 24),
(6, "The Hitchhiker's Guide to the Galaxy", 19),
(7, "The Lion, the Witch & the Wardrobe", 9),
(8, "Animal Farm", 29),
(9, "The Handmaid's Tale", 12),
(10, "Sense & Sensibility", 40),
(11, "Emma", 17),
(12, "The life of Pi", 6),
(13, "Brave New World", 24);

INSERT INTO Price
VALUES
(1, 10.99),
(2, 15.00),
(3, 5.00),
(4, 8.99),
(5, 7.50),
(6, 3.50),
(7, 4.00),
(8, 2.00),
(9, 12.99),
(10, 5.00),
(11, 10.99),
(12, 12.99),
(13, 7.99);

INSERT INTO Reviews
VALUES
(1, "War and Peace", 4, "Too long"),
(2, "Pride and Prejudice", 9, "Beautiful romance story that brings you to tears"),
(3, "Jane Eyre", 7, "Full of adventure and joy"),
(4, "Lord of the Rings", 6, "There's a lot of walking"),
(5, "1984", 10, "Fantastic commentry on the current and potential future world"),
(6, "The Hitchhiker's Guide to the Galaxy", 7, "A bit of fun"),
(7, "The Lion, the Witch & the Wardrobe", 9, "A classic for adults and children alike"),
(8, "Animal Farm", 9, "Not suitable for vegetarians"),
(9, "The Handmaid's Tale", 7, "An intelligent read"),
(10, "Sense & Sensibility", 8, "A sensible read"),
(11, "Emma", 7, "Great book"),
(12, "The life of Pi", 8, "An exciting adventure"),
(13, "Brave New World", 10, "Best book I've ever read!");

INSERT INTO Customers
VALUES
(1, "Maria", "Smith", "ms12@gmail.com", 2),
(2, "Mark", "Jones", "mj23@gmail.com", 1),
(3, "Karen", "Williams", "karen@gmail.com", 13),
(4, "Colin", "Brown", "col123@gmail.com", 6),
(5, "Brady", "Johnson", "bj9@gmail.com", 7),
(6, "Holly", "Moore", "hols@gmail.com", 2),
(7, "Jonathan", "Moore", "johnny12@gmail.com", 10),
(8, "Scott", "Dean", "scotts120nd@gmail.com", 3),
(9, "Lucy", "Wilson", "luceee@gmail.com", 1),
(10, "Mia", "Clark", "mcclark@gmail.com", 8);

INSERT INTO Orders
VALUES
(1, '2022-01-23', 5, 2, 1),
(2, '2022-01-23', 5, 1, 2),
(3, '2022-03-02', 1, 5, 1),
(4, '2022-04-12', 4, 8, 1),
(5, '2022-05-07', 7, 3, 3),
(6, '2022-05-16', 6, 9, 1),
(7, '2022-05-16', 6, 13, 1),
(8, '2022-06-23', 1, 3, 2),
(9, '2022-07-20', 10, 5, 1),
(10, '2022-08-01', 9, 2, 1),
(11, '2022-09-18', 8, 8, 1),
(12, '2022-09-23', 2, 7, 1);

#Left joining Book info and Orders table (order date & no sold)
SELECT Bookinfo.Book_title, Bookinfo.Author_firstname, Bookinfo.Author_surname, Orders.Order_date, Orders.Num_copies
FROM Bookinfo
LEFT JOIN Orders
ON Bookinfo.Book_ID = Orders.Book_ID;

#Create stored function to see loyalty scheme level for customers
DELIMITER //
CREATE FUNCTION loyalty_level(
        Num_orders INTEGER)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE loyalty_level VARCHAR(10);
    
    IF Num_orders >= 10 THEN
	    SET loyalty_level = 'Gold';
	ELSEIF (Num_orders >= 3 AND Num_orders < 10) THEN
        SET loyalty_level = 'Silver';
	ELSEIF Num_orders < 3 THEN
        SET loyalty_level = 'Bronze';
	END IF;
        
        RETURN (loyalty_level);
END //
DELIMITER ;

#Call loyalty level function
SELECT 
firstname, surname, loyalty_level(Num_orders)
FROM 
Customers
ORDER BY
firstname;

#Subquery to filter customers who haven't placed an order in 2022 to send returners email discount
SELECT 
    Cust_ID, Firstname, Surname, email
FROM
    Customers
WHERE 
    Cust_ID NOT IN (
    SELECT Cust_ID
	FROM Orders)
ORDER BY Firstname, Surname;

#Grouping by how many orders customers have placed in 2022

SELECT 
	o.Cust_ID,
    c.firstname,
    c.surname,
    COUNT(*)
FROM 
	Orders o
INNER JOIN customers c
ON c.cust_ID = o.cust_ID
GROUP BY o.Cust_ID
ORDER BY c.surname;

#Creating a view for a review page website 
CREATE VIEW Website AS
SELECT b.Book_title, b.Author_surname, r.rating, r.comments
FROM Bookinfo b
JOIN Reviews r
ON b.Book_ID = r.Book_ID;

SELECT * FROM Website;


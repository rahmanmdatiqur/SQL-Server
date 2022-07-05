
/*													
		SQL Project Name : Dealarship Management System
		Trainee Name : Md. AtiqurRahman  
		Trainee ID : 1270028       
		Batch ID : ESAD-CS/PNTL-A/51/01 
	    Project Submission Date: 07/06/2022
*/ 

																															*/

USE DMS
GO

SELECT * FROM Customers
SELECT * FROM Employees
SELECT * FROM Suppliers
SELECT * FROM Products
SELECT * FROM Category
SELECT * FROM Shippers
SELECT * FROM Orders
SELECT * FROM OrdersDetails
SELECT * FROM Items
SELECT * FROM Suppliers


INSERT INTO Customers
VALUES 
		(101,'Rakibul','Hasib','Feni','Chitagong','Bangladesh',01399886574,'rakibhasib@gmail.com'),
		(102,'Faruk','Hossain','Mirpur','Barisal','Bangladesh',01844676543,'faruk@gmil.com'),
		(103,'Abdul','Ahad','Badda','Feni','Bangladesh',01922778809,'ahad@gmil.com'),
		(104,'Nur','Hossain','Kazipara','Dhaka','Bangladesh',0176545890,'nur@gmil.com'),
		(105,'Rahima','sarkar','Mohammadpur','Dhaka','Bangladesh',0178590436,'rahima@gmil.com')		
GO

SELECT * FROM Customers
GO
INSERT INTO Employees VALUES
		(201,'Md. Hasan','Moakhali','Dhaka','Bangladesh','01648908762','rabin@gmil.com'),
		(202,'Md. Jamil','Badda','Dhaka','Bangladesh','01798765432','rabbi@gmil.com'),
		(203,'Md. Raju','Tongi','Dhaka','Bangladesh','01834987652','sieam@gmil.com'),
		(204,'Md. kartik','Savar','Mymensing','Bangladesh','0192378654','ferdoes@gmil.com'),
		(205,'Md. Azad','uttara','Dhaka','Bangladesh','01689087633','abbas@gmil.com')
GO

INSERT INTO Suppliers VALUES
		('Intel','Robert','Sales Manager','ER Road','Washington','America',default),
		('ASUS','Devit','Sales executive','30/B','chicago','America',default),
		('Dell','Robinson','Manager','18/C','california','America',default),
		('LENEVO','Zinxo','Production Manager','7/D','Beijing','China',default),
		('ACCER','windol','Sales Manager','6/E','Taipei','Taiwan',default)
GO

SELECT * FROM Suppliers
GO

INSERT INTO Products
VALUES
		(1,'MONITOR',12000.00,100),
		(2,'KEYBOARD',3000.00,50),
		(3,'MOUSE',2000.00,20),
		(4,'HEADPHONE',1500.00,30),
		(5,'LAPTOP',45000.00,70)		
SELECT * FROM Products
GO

INSERT INTO Category VALUES

		(DEFAULT,'MONITOR'),
		(DEFAULT,'KEYBOARD'),
		(DEFAULT,'MOUSE'),
		(DEFAULT,'HEADPHONE'),
		(DEFAULT,'LAPTOP')
GO

SELECT * FROM Category
GO

INSERT INTO Shippers VALUES
		('REDX','01614556690'),
		('SUNDORBAN','01724568798'),
		('SA','01932457189')

SELECT * FROM Shippers
GO


INSERT INTO Orders VALUES
		(1,101,201,'2022-01-01','2022-02-20',1,12000.00),
		(2,102,201,'2022-01-02','2022-01-05',2,3000.00),
		(3,103,202,'2022-02-01','2022-02-20',3,2000.00),
		(4,104,203,'2022-02-20','2022-03-04',2,2500.00),
		(5,105,204,'2022-03-01','2022-03-25',3,45000.00)
				
GO		
SELECT * FROM Orders
GO


INSERT INTO OrdersDetails VALUES
		(1,1,12000.00,5,.05),
		(2,2,3000.00,4,.05),
		(3,3,2000.00,10,.05),
		(4,3,2500.00,12,.05),
		(5,4,45000.00,20,.05)		
GO
SELECT * FROM OrdersDetails
GO

INSERT INTO Items VALUES
		(1,100,'2020-01-10',DEFAULT,1,1,2),
		(2,100,'2020-02-12','2021-11-10',2,0,1),
		(3,100,'2020-03-12',DEFAULT,5,1,2),
		(4,100,'2020-04-16',DEFAULT,3,1,3),
		(5,100,'2020-05-18',DEFAULT,4,1,4),
		(2,100,'2020-06-19',DEFAULT,2,1,5),
		(3,100,'2020-04-22',DEFAULT,1,1,6),
		(4,100,'2020-07-25',DEFAULT,5,1,7),
		(5,100,'2020-08-27',DEFAULT,2,1,9),
		(1,100,'2020-09-30',DEFAULT,1,1,7),
		
GO	

SELECT * FROM Items
GO
--inserting data through stored procedure
		EXEC sp_InsertCustomers 111,'kamal','uddin','farmgate','Dhaka','Bangladesh','01912786543','kamaluddin@gmil.com'
		EXEC sp_InsertCustomers 112,'karim','Uddin','rampura','Dhaka','Bangladesh','01644789076','karim@gmil.com'
		EXEC sp_InsertCustomers 113,'Rafik','alom','mirpur','Dhaka','Bangladesh','01930987654','rafiq@gmil.com'
		EXEC sp_InsertCustomers 114,'hasan','mahmud','dhanmondi','Dhaka','Bangladesh','01719067654','hasan@gmil.com'
		EXEC sp_InsertCustomers 115,'Abul','kalam','moakhali','Dhaka','Bangladesh','01920897654','razzak@gmil.com'
		EXEC sp_InsertCustomers 116,'Abdur','razzak','uttara','Dhaka','Bangladesh','01929879032','razzak@gmil.com'
		EXEC sp_InsertCustomers 117,'Anik','Hossain','khilkhet','Dhaka','Bangladesh','0194567865','anik@gmil.com'
		
GO
SELECT * FROM Customers
GO
--simple query
SELECT * FROM Items
GO

--JOIN QUARY TO FIND OUT ORDER DETAILS
SELECT * FROM Orders O
JOIN OrdersDetails OD ON OD.OrderId=O.OrderId
WHERE O.CustomerId = 105
GO

/* **************************************************************************************************
								JOIN QUARY WITH AGGREGATE COLUMN WITH GROUP BY,ORDERBY CLAUSE
										   TO FIND OUT CUSTOMER WISE TOTAL DISCOUNT                        */
------********************************************************************************************************		
SELECT O.CustomerId,SUM(od.UnitPrice*od.Quantity* OD.Discount) 'Discount_per_Customer' FROM Orders O
JOIN OrdersDetails OD ON OD.OrderId=O.OrderId
GROUP BY O.CustomerId
ORDER BY O.CustomerId DESC
GO

--SUBQUERY TO FIND OUT THE ORDERS DETAILS OF A SPECIFIC CUSTOMER
SELECT * FROM Orders O
JOIN Customers C ON C.CustomerId = O.CustomerId
WHERE O.CustomerId=(SELECT CustomerId FROM Customers WHERE CustomerFName='Hasan')
GO

--USING ROLLUP IN QUERY WITH HAVING CLAUSE TO FIND OUT THE CUSTOMER AND PRODUCT WSIE NET ORDER AMOUNT WHO HAVE MORE THAN 50000 ORDER AMOUNT
SELECT CUSTOMERID,PRODUCTID,SUM(UnitPrice*Quantity*(1-DISCOUNT)) AS 'NET_ORDER_AMOUNT' FROM Orders O
JOIN OrdersDetails OD ON O.OrderId=OD.OrderId
GROUP BY ROLLUP (CustomerId,PRODUCTID)
HAVING SUM(UnitPrice*Quantity*(1-DISCOUNT)) >=50000
ORDER BY CustomerId
GO


---***********************************************************************************************
-----

--Show table Details
EXEC sp_help 'contacts'
GO

--Data Insert
INSERT INTO contacts(id,name) VALUES(1,'Kamal Khan')
--Show Data
SELECT * FROM contacts
GO
--Nullability Constraint


INSERT INTO contact(id,name) VALUES(1,'Zinat Ara')
GO
SELECT * FROM contact
GO
--IDENTITY

CREATE TABLE contacts2
(
	id INT IDENTITY NOT NULL,
	name VARCHAR(45) NULL
)
GO
INSERT INTO contacts2(name) VALUES('Zinat Ara')
INSERT INTO contacts2(name) VALUES('Zinat Khan')
INSERT INTO contacts2(name) VALUES('Zahir Ahmed')
GO
SELECT * FROM contacts2
GO

--break IDENTITY
SET IDENTITY_INSERT contacts2 ON
INSERT INTO contacts2(id, name) VALUES(920,'Yeasin')
SET IDENTITY_INSERT contacts2 OFF
GO
INSERT INTO contacts2(name) VALUES('Kamal Hossain')
GO
--UNIQUE IDENTIFIER
CREATE TABLE products
(
	id UNIQUEIDENTIFIER NOT NULL,
	name VARCHAR(30)
)
GO
INSERT INTO products(id,name) VALUES(NEWID(),'Mouse')
INSERT INTO products(id,name) VALUES(NEWID(),'Keyboard')
GO
SELECT * FROM products
GO
SELECT LEN(id) 'Length' FROM products
SELECT GETDATE() as Today
GO

-----*********************************************************************************************

-- USING  SEARCHED CASE FUNCTION TO FIND OUT THE CUSTOMER WHO HAVE GET 20 OR MORE PERCENT DISCOUNT ON THEIR PURCHASE

SELECT ORDERID,SUM(Quantity*UnitPrice) AS 'Total Amount ordered',
CASE
	WHEN SUM(Quantity*UnitPrice)>= 80000
		THEN '20% DISCOUNT'
	WHEN SUM(Quantity*UnitPrice)>= 60000
		THEN '15% DISCOUNT'
	ELSE 'DEFAULT DISCOUNT'
END AS DISCOUNT
FROM OrdersDetails
GROUP BY OrderId

--Check for view
select * from V_OrdersDetails
GO

--Check for stored procedure
EXEC sp_Customers
GO

--INSERTING data using STORED PROCEDURE
DECLARE @id INT
EXEC @id= sp_InsertEmployeesWithReturn 212,'Kalam','BADDA','DHAKA','BANGLADESH','1995-02-10','2015-10-15','01746789302','kalam@gmail.com'
PRINT 'New product inserted with Id : '+STR(@id)
GO

--TEST FOR SCALAR VALUED FUNCTION for calculating MONTH WISE TOTAL SALES
SELECT DBO.fn_OrdersDetailS(02,2020) AS TOTAL_SALES_AMOUNT
GO

--TEST FOR SCALAR VALUED FUNCTION TO CALCULATING PRODUCT WISE TOTAL SALES
SELECT DBO.fn_ordersamountPerProduct(1) AS product_wise_total_sales
GO

--TEST FOR SINGLE STATEMENT TABLE VALUED FUNCTION TO BRING OUT THE NET AMOUNT OF SPECIFIC CUSTOMER
SELECT * FROM fn_OrderdetailsSimpleTable(105)
GO

--TEST FOR MULTI-STATEMENT TABLE VALUED FUNCTION TO BRING OUT THE TOTAL AMOUNT OF SPECIFIC INVENTORY PURCHASED AT A SPECIFIC DATE
SELECT * FROM fn_ItemsMultiStatement('2019-01-15')
GO

--TEST FOR AFTER TRIGGER THAT DOES NOT LET TO DELETE ANY DATA FROM ORDERS TABLE
DELETE FROM Orders
WHERE OrderId=1
GO


--TEST FOR AFTER TRIGGER TO INSERT DATA--

INSERT INTO Items VALUES(2,50,'2019-12-15',DEFAULT,3,1,4)
INSERT INTO Items VALUES(3,50,'2019-11-12',DEFAULT,4,0,8)
GO

SELECT * FROM Items
SELECT * FROM Products
GO

--TEST TRIGGERS FOR DELETE DATA
DELETE FROM Items WHERE PId=1
GO

SELECT * FROM Items
SELECT * FROM Products
GO

--TEST TRIGGERS FOR UPDATE DATA
UPDATE Items
SET Quantity=40
WHERE ItemId=10
GO

SELECT * FROM Items
SELECT * FROM Products
GO

--Test INSTED OF TRIGERS FOR INSERT DATA INTO A VIEW
INSERT INTO V_Suppliers VALUES ('WALTON','MR. Habib','Manager','Gazipur','Gazipur','Bangladesh',DEFAULT)
GO

--Test INSTED OF TRIGERS FOR INSERT DATA INTO TABLE. IF THE STOCK IS LESS THAN THE ORDER AMOUNT DATA CAN'T BE INSERTED. ROLLBACKED

INSERT INTO OrdersDetails VALUES(21,11,12000.00,10,.05)
GO

INSERT INTO OrdersDetails VALUES(22,10,20000.00,50,.05)
GO

SELECT * FROM OrdersDetails
SELECT * FROM Items





     -----End---
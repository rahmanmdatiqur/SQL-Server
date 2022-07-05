/*							
									SQL Project Name :Dealarship Management System (DMS)
									Trainee Name : Md. AtiqurRahman  
									Trainee ID : 1270028       
									Batch ID : ESAD-CS/PNTL-A/51/01 
									Project Submission Date: 07/06/2022
*/
---***************************************** START MY PROJECT *********************************************************
-- 01: CREATE DATABASE DMS

USE master
GO

DROP DATABASE IF EXISTS DMS
GO

CREATE DATABASE DMSDB
ON
(
    NAME = 'DMS_Data',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DMS_Data_data.mdf',
    SIZE = 50MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10%
)
LOG ON
(
    NAME = 'DMS_Log',
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\DMS_Data_log.ldf',
    SIZE = 25MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 1MB
)
GO
--
CREATE DATABASE DMS
go

USE DMS
GO
CREATE TABLE Customers
(
	CustomerId INT PRIMARY KEY,
	CustomerFName NVARCHAR(20) NOT NULL,
	CustomerLName NVARCHAR(20)  NULL,
	CustomerAddress VARCHAR(100) NULL,
	City VARCHAR(40) NULL ,
	Country VARCHAR(50) NULL,
	PhoneNo CHAR(15) DEFAULT NULL,
	Email VARCHAR(80) NULL
)
GO
CREATE TABLE Employees
(
	EmployeeId INT PRIMARY KEY,
	EmpName NVARCHAR(50) NOT NULL,
	EmpAddress VARCHAR(100) NOT NULL,
	Empcity VARCHAR(20) NOT NULL,
	Empcountry VARCHAR(30) NULL,
	Phone VARCHAR(20) NOT NULL,
	Email VARCHAR(50) NULL
)
GO
CREATE TABLE Suppliers
(
	SupplierId INT PRIMARY KEY IDENTITY,
	CompanyName VARCHAR(50) NOT NULL,
	ContactName VARCHAR(30) NULL,
	ContactTitle VARCHAR(30) NULL,
	SupAddress VARCHAR(100) NULL,
	City VARCHAR(20) NULL,
	Country VARCHAR(20) NULL,
	Phone  VARCHAR(20) NOT NULL DEFAULT 'N/A',
)
GO
CREATE TABLE Products
(
	ProductId INT PRIMARY KEY,
	ProductName VARCHAR(100),
	UnitPrice MONEY,
	Stock INT DEFAULT 0
)
GO

CREATE TABLE Category
(
	id INT IDENTITY PRIMARY KEY,
	CategoryId UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	CategoryName VARCHAR(50) NOT NULL
)
GO
CREATE TABLE Shippers
(
	ShipperId INT IDENTITY PRIMARY KEY,
	CompanyName VARCHAR(50) NOT NULL,
	Phone NVARCHAR(20)
)
GO

CREATE TABLE Orders
(
	OrderId INT PRIMARY KEY,
	CustomerId INT REFERENCES Customers(Customerid),
	EmployeeId INT REFERENCES Employees(Employeeid),
	OrderDate DATE NOT NULL,
	ShipDate DATE NOT NULL DEFAULT GETDATE(),
	ShippingCompany INT REFERENCES Shippers(Shipperid),
	Freight MONEY NULL,
)
GO
CREATE TABLE OrdersDetails
(
	OrderId INT REFERENCES Orders(Orderid),
	ProductId INT REFERENCES Products(ProductId),
	UnitPrice FLOAT NOT NULL,
	Quantity INT NOT NULL,
	Discount FLOAT NOT NULL DEFAULT 0,
	DiscountedAmount AS UnitPrice*Quantity*Discount,
	PRIMARY KEY(OrderId,ProductId)
)
GO

CREATE TABLE Items
(
	itemId INT IDENTITY PRIMARY KEY,
	SupplierId INT REFERENCES Suppliers(Supplierid),
	Quantity INT NOT NULL DEFAULT 0,
	PurchaseDate DATE NOT NULL,
	StockOutDate DATE NULL,
	Category INT REFERENCES Category(Id),
	Available BIT NOT NULL,
	PId INT REFERENCES Products(productid)
)
GO

CREATE TABLE City
(
	CityId INT NOT NULL UNIQUE,
	CityName VARCHAR(20) NOT NULL
)
GO

--Create Table contacts
CREATE TABLE contacts
(
	id INT,
	[name] VARCHAR(40)
)
GO

--Create Table 
CREATE TABLE contacts2
(
	id INT IDENTITY NOT NULL,
	name VARCHAR(45) NULL
)
GO
----------------------
---ALTER TABLE (ADD, DELETE COLUMN, DROP COLUMN)

-- ADD COLUMN TO A EXISTING TABLE 
	ALTER TABLE city
	ADD Zipcode VARCHAR(10)
GO
--DELETE COLUMN FROM A EXISTING TABLE
	ALTER TABLE city
	DROP COLUMN ZipCode
GO

--DROP A TABLE
	IF OBJECT_ID('city') IS NOT NULL
	DROP TABLE City
GO
------------------
               ---01 INDEX 

--CREATING A NON-CLUSTERED INDEX FOR CUSTOMER TABLE
	CREATE UNIQUE NONCLUSTERED INDEX IX_Customer
	ON Customers(CUSTOMERID)
GO
-----------------
                 ---02 VIEW

--Create a view for update, insert and delete data from base table
CREATE VIEW V_Suppliers
AS
SELECT * FROM Suppliers
GO

--Inserting data using view
INSERT INTO V_Suppliers VALUES
		('ASUS','MR.RAJIB','Manager','45/A','DELHI','INDIA',DEFAULT)
GO

--as suppliers is referenced to others table, we can not delete it using view. but I write the syntax of deleting data using view
	DELETE FROM V_Suppliers
	WHERE CompanyName='Dell'
GO

--Create a view to find out the customers who have ordered more the 3000 tk

CREATE VIEW V_OrdersDetails
	WITH ENCRYPTION
	AS
	SELECT TOP 5 PERCENT OD.OrderId,OD.ProductId,O.CustomerId,OD.Quantity,OD.UnitPrice 
	FROM OrdersDetails OD
	JOIN Orders O ON OD.OrderId=O.OrderId
	WHERE (UnitPrice*Quantity) >=3000
	WITH CHECK OPTION
GO

---------------------------
                         --03 Store procedure

CREATE PROC sp_Customers
	WITH ENCRYPTION
	AS
	SELECT * FROM Customers
	WHERE City='Dhaka'
GO

CREATE PROC sp_InsertCustomers
						@customerid INT,
						@customerFname VARCHAR(20),
						@customerLname VARCHAR(20)=NULL,
						@address VARCHAR(50)=NULL,
						@city VARCHAR(20),
						@country VARCHAR(20),
						@phoneNo VARCHAR(20),
						@email VARCHAR(50)
AS
BEGIN
	INSERT INTO Customers(CustomerId,CustomerFName,CustomerLName,CustomerAddress,City,Country,PhoneNo,Email)
	VALUES(@customerid,@customerFname,@customerLname,@address,@city,@country,@phoneNo,@email)
END
GO

--A Stored procedure for deleting data 
CREATE PROC sp_deleteCustomers
						@customerFname VARCHAR(20)
AS 
	DELETE FROM Customers WHERE CustomerFName=@customerFname
GO

--A Stored procedure for inserting data with return values
CREATE PROC sp_InsertEmployeesWithReturn
						@employeeid INT,
						@empName VARCHAR(20),
						@empAddress VARCHAR(50),
						@city VARCHAR(20),
						@country VARCHAR(20),						
						@hiredate DATE,						
						@phone VARCHAR(20),
						@email VARCHAR(50)=NULL
AS
DECLARE @id INT 
INSERT INTO Employees VALUES(@employeeid,@empName,@empAddress,@city,@country,@hiredate,@phone,@email)
SELECT @id=IDENT_CURRENT('Employees')
RETURN @id
GO


--test with data insert

DECLARE @id INT
EXEC @id= sp_InsertEmployeesWithReturn 208,'MD.Abdur Rahman','UTTARA','DHAKA','BANGLADESH','2015-10-15','0173456780','rahmanam@gmail.com'
PRINT 'New product inserted with Id : '+STR(@id)
GO

--A Stored procedure for inserting data with output parameter
CREATE PROC sp_InsertEmployeesWithOutPutParameter
						@employeeid INT,
						@empName VARCHAR(20),
						@empAddress VARCHAR(50),
						@city VARCHAR(20),
						@country VARCHAR(20),
						@hiredate DATE,						
 					    @phone VARCHAR(20),
						@email VARCHAR(50)=NULL,
						@Eid INT OUTPUT
AS
INSERT INTO Employees VALUES(@employeeid,@empName,@empAddress,@city,@country,@hiredate,@phone,@email)
SELECT @Eid=IDENT_CURRENT('Employees')
GO


--test with data insert
DECLARE @eid INT
EXEC sp_InsertEmployeesWithOutPutParameter 210,'MD. Abdur Rahman','UTTARA','DHAKA','BANGLADESH','1998-02-7','2020-10-10','01644444','rahman@gmail.com',@eid OUTPUT
SELECT @eid 'New Id'
GO
-------------------
                   --04 FUNCTIONS 

--(a). Scalar valued function for calculating the total sales amount
CREATE FUNCTION fn_OrdersDetails
					(@month int,@year int)
RETURNS INT
AS
	BEGIN
		DECLARE @amount MONEY
		SELECT @amount=SUM(UNITPRICE*QUANTITY) FROM Orders 
		JOIN OrdersDetails ON Orders.OrderId=OrdersDetails.OrderId
		WHERE YEAR(OrderDate)=@year AND MONTH(OrderDate)=@month
		RETURN @amount
	END	
GO

--(b). Scalar valued function for calculating the total  amount according to PRODUCT
CREATE FUNCTION fn_ordersamountPerProduct
					(@productid INT)
RETURNS MONEY
AS
	BEGIN
		DECLARE @amount MONEY
		SELECT @amount= SUM(UNITPRICE*QUANTITY)FROM OrdersDetails WHERE ProductId=@productid
		RETURN @amount
	END
GO

--(c). single statement table valued funtion(as single statement we won't use BEGIN END block)
CREATE FUNCTION fn_OrderdetailsSimpletable(@customerid INT)
RETURNS TABLE
AS 
RETURN
(
	SELECT SUM(UnitPrice*Quantity) AS 'Total Amount',
	SUM(UnitPrice*Quantity*Discount) AS 'Total Discount',
	SUM(UnitPrice*Quantity*(1-Discount)) AS 'Net Amount'
	FROM Orders O 
	JOIN OrdersDetails OD ON O.OrderId=OD.OrderId
	WHERE O.CustomerId=@CUSTOMERID
)
GO

--(d) Multi-Statement table-valued function(More than one statement. So we will use BEGIN AND END STATEMENT)

CREATE FUNCTION fn_ItemsMultiStatement(@purchasedate DATE)
RETURNS @salesDetails TABLE
(
	ProductID INT,
	Totolamount MONEY,
	Category VARCHAR(30)
)
AS
BEGIN
		 INSERT INTO @salesDetails
		 SELECT PId,
		 SUM(UnitPrice*QUANTITY),
		 Category
		 FROM Items I
		 JOIN Products P ON P.ProductId=I.PId
		 WHERE PurchaseDate=@purchasedate
		 GROUP BY PId,CATEGORY
		 ORDER BY PId ASC
		 RETURN
END
GO

---------------------
   --05 TRIGGERS  
																													*/
--(a):after trigger for not deleting any data from orders data
	create trigger tr_orders
	ON Orders
	FOR DELETE
	AS
		BEGIN
				PRINT'YOU CAN NOT DELETE AN EMPLOYEE DATA'
				ROLLBACK TRANSACTION
		END
	GO
-- after trigger for insert data into items table 
CREATE TRIGGER tr_itemsInsert
ON items
FOR INSERT
AS
	BEGIN
			DECLARE @pid INT, @Q INT
			SELECT @pid=pid , @q=quantity FROM inserted

			UPDATE Products
			SET Stock=Stock+@Q
			WHERE ProductId=@pid
	END
GO
--create  trigger for delete data into items table

CREATE TRIGGER tr_DeleteItems
ON items
FOR DELETE
AS
	BEGIN
			DECLARE @Pid INT, @q INT
			SELECT @Pid=pid,@q=quantity FROM deleted

			UPDATE Products
			SET Stock=Stock-@q
			WHERE ProductId=@Pid
	END
GO

--Test
DELETE FROM Items
GO


--create for trigger for update data in the items table

CREATE TRIGGER tr_Updateitems
ON items
FOR UPDATE
AS
	BEGIN
			IF UPDATE (QUANTITY)
			BEGIN
						DECLARE @ID INT, 
								@DQ INT,
								@IQ INT,
								@change INT

						SELECT @ID=I.PId,@DQ=D.Quantity,@IQ=I.Quantity
						FROM inserted I
						JOIN deleted D ON D.PId=I.PId
						SET @change=@iq-@DQ
						UPDATE Products
						SET Stock=Stock+@change
						WHERE ProductId=@ID
			END
	END
GO

--Test
INSERT INTO Items VALUES()
GO

--After triggers for orders and sales &distribution management
		CREATE TRIGGER tr_ordersitems
		ON ordersdetails
		FOR INSERT 
		AS
			BEGIN 
					DECLARE @Q INT,@Pid int
					SELECT @Q=Quantity,@pid=ProductId FROM inserted

					UPDATE items
					SET Quantity=Quantity-@Q
					WHERE PId=@Pid
			END
		GO

--(b)Create instead of triggers on view for inserting data 

CREATE TRIGGER tr_V_Suppliers
ON V_Suppliers
INSTEAD OF INSERT
AS
	BEGIN
			INSERT INTO Suppliers(SupplierId,CompanyName,ContactName,ContactTitle,SupAddress,City,Country,Phone)
			SELECT SupplierId,CompanyName,ContactName,ContactTitle,SupAddress,City,Country,Phone FROM inserted
	END
GO


--creating an instead of trigger for not inserting orders when stock of particular product has ended. 

CREATE TRIGGER tr_OutOfStock
ON OrdersDetails
INSTEAD OF INSERT
AS
	BEGIN
			DECLARE @Pid INT, @quantity INT,@stock INT
			SELECT @Pid=ProductId, @quantity=Quantity FROM inserted
			SELECT @stock= SUM(Quantity) FROM Items WHERE Pid=@pid
			
			IF @stock>=@quantity
					BEGIN 
							INSERT INTO OrdersDetails(OrderId,ProductId,UnitPrice,Quantity,Discount)	
							SELECT OrderId,ProductId,UnitPrice,Quantity,Discount FROM inserted
					END

			ELSE
					BEGIN
							RAISERROR('SORRY, THERE IS NOT ENOUGH STOCK.',10,1)
							ROLLBACK TRANSACTION
					END
	END
GO

SELECT * FROM OrdersDetails
SELECT * FROM Items
							-----End-----




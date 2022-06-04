USE db_pyblog;

CREATE TABLE Products (
  Id INT IDENTITY(1, 1) PRIMARY KEY
,ProductCode VARCHAR(100)
  ,ProductName VARCHAR(100)
,ProductColor VARCHAR(50)
,Price INT
,PriceTax INT
,Size VARCHAR(1)
)
 
 
INSERT INTO Products
VALUES ('A42-12','Blue Jean','White',12,8,'L')
  , ('X74-12','Shirt','Blue',10,18,'S')
  , ('A19-01',NULL,'Purple',9,1,'M')
  , ('P-765','T-Shirt','Red',10,0,NULL)
  , ('Z-OP12',NULL,'Pink',28,0,'M')
  , ('AL-1211','Short','Yellow',6,12,'S')
  
 
CREATE TABLE SizeTable(
[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
[SizeCode] [varchar](1) NULL,
[SizeDefination] [varchar](100) NULL)
 
INSERT INTO SizeTable
VALUES ('M','Medium') ,('S','Small'),('L','Large'),('C','Child')




------------------------------------------------------------
------ Counting SQL NULL values --------------------
------------------------------------------------------------

 SELECT * FROM Products
 
  SELECT COUNT(ProductName) AS 'Number Of Product'  FROM Products
 
-- Null values are not counted with COUNT()
  SELECT COUNT(ISNULL(ProductName,'')) AS 'Number Of Product' FROM Products


------------------------------------------------------------
----- Typical division by zero
------------------------------------------------------------


SELECT ProductName
  , Price
  , (Price / PriceTax) * 100 AS [PriceTaxRatio]
FROM Products
 


-- Solution
SELECT ProductName
  , Price
  , (Price / NULLIF(PriceTax,0)) * 100 AS [PriceTaxRatio]
FROM Products


------------------------------------------------------------
---- String concatenations!!  ------------------------
------------------------------------------------------------


SELECT  ProductName, ProductColor ,
  ProductName + '-' + ProductColor AS [Long Product Name]
FROM Products


-- Solution (to avoid NULL Values)
 SELECT  ProductName, ProductColor ,
  CONCAT(ProductName , '-' , ProductColor) AS [Long Product Name]
FROM Products



------------------------------------------------------------
--- Not USE NOT IN for NOT NULLABLE columns
------------------------------------------------------------


  SELECT * FROM Products
  WHERE Size NOT IN (SELECT 
  SizeCode FROM SizeTable)

    SELECT * FROM SizeTable 
  WHERE SizeCode!= NULL


  -- Solution

    SELECT * FROM SizeTable AS S
  WHERE  
  NOT EXISTS  (SELECT *  From Products AS P
  WHERE S.SizeCode = P.Size)


  --- NON SARGable predicates

    SELECT SalesOrderDetailID ,ModifiedDate FROM Sales.SalesOrderDetail
            WHERE YEAR(ModifiedDate)=2011

      CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ModifiedDate
  ON [Sales].[SalesOrderDetail] ([ModifiedDate])


  
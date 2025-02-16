USE PRACTICA 

CREATE TABLE USUARIOS
(
id_us INT IDENTITY(1,1) PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(100) NOT NULL,
dni INT NOT NULL
)
CREATE TABLE PRODUCTOS
(
id_prod INT IDENTITY(1,1) PRIMARY KEY,
nombre_prod VARCHAR(50) NOT NULL,
cod_prod VARCHAR(10) NOT NULL
)

CREATE TABLE VENTAS
(
id_venta INT IDENTITY(1,1) PRIMARY KEY,
idproducto INT FOREIGN KEY REFERENCES PRODUCTOS(id_prod),
idusuario INT FOREIGN KEY REFERENCES USUARIOS(id_us),
totalPrecio FLOAT,
totalDescuento FLOAT,
totalNeto FLOAT,
cantidad INT
)

DROP TABLE  USUARIOS

INSERT INTO USUARIOS VALUES('Rogger','Barrientos',70262920)
INSERT INTO USUARIOS VALUES('Amigo','NN',7034565)
INSERT INTO USUARIOS VALUES('JUAN','PEREZ',877854455)
INSERT INTO USUARIOS VALUES('KLYDMAN','VBSDD',78745554)

INSERT INTO PRODUCTOS VALUES('Celular','ABC')
INSERT INTO PRODUCTOS VALUES('Televisor','DD')

INSERT INTO VENTAS VALUES(1,1,500.5,40.5,460,1)
INSERT INTO VENTAS VALUES(1,2,1000,100,900,2)


SELECT * FROM USUARIOS

SELECT * FROM PRODUCTOS

SELECT * FROM VENTAS

SELECT * FROM USUARIOS U WHERE U.apellido = 'Barrientos'

--ACTUALIZAR PRODUCTOS
UPDATE PRODUCTOS SET nombre_prod = 'samsung' WHERE id_prod = 1
--BORRAR DATOS 
DELETE FROM PRODUCTOS WHERE id_prod = 1
--BORRAR OBJETOS
DROP TABLE PRODUCTOS




USE AdventureWorks2019

SELECT * FROM Production.Product

SELECT P.ProductID, P.Name as 'Nombre Producto' FROM Production.Product P

SELECT P.ProductID, P.Name FROM Production.Product P WHERE P.SafetyStockLevel >=600 AND P.SafetyStockLevel <= 1000;

SELECT P.ProductID, P.Name FROM Production.Product P WHERE P.SafetyStockLevel BETWEEN 600 AND 1000


--between
SELECT * FROM Sales.SalesOrderHeader S WHERE S.OrderDate BETWEEN '2011-06-12' AND '2011-08-12'

--LIKE
SELECT * FROM Production.Product P WHERE P.Name LIKE '%D'

-- NOT LIKE
SELECT * FROM Production.Product P WHERE P.Name NOT LIKE '%D'

-- MONTH
SELECT * FROM Sales.SalesOrderHeader S WHERE MONTH(S.OrderDate) = 6
-- YEAR
SELECT * FROM Sales.SalesOrderHeader S WHERE YEAR(S.OrderDate) = 2012

--INNER JOIN
SELECT A.Name AS 'Nombre Producto',B.Name AS 'Nombre SubCategoria',
C.Name AS 'Nombre Categoria',D.*
FROM Production.Product A 
INNER JOIN 
Production.ProductSubcategory B 
ON A.ProductSubcategoryID = B.ProductSubcategoryID
INNER JOIN 
Production.ProductCategory C
ON C.ProductCategoryID = B.ProductCategoryID
INNER JOIN Production.ProductInventory D
ON D.ProductID = A.ProductID

--cross join-cruzar tablas
-- TOP 5/10
SELECT TOP 5 * FROM Production.Product P
SELECT TOP 10 * FROM Production.Product P ORDER BY P.SafetyStockLevel DESC,P.Name DESC

--
SELECT TOP 5 A.SalesOrderID,H.LastName + ' '+ H.FirstName AS 'Vendedor',D.Name as 'Producto',E.Name AS 'Subcategoria',F.Name AS 'Categoria',A.OrderQty,C.Name as 'Nombre territorio' FROM Sales.SalesOrderDetail A
INNER JOIN Sales.SalesOrderHeader B
ON A.SalesOrderID= B.SalesOrderID
INNER JOIN Sales.SalesTerritory C
ON C.TerritoryID = B.TerritoryID
INNER JOIN Production.Product D
ON D.ProductID = A.ProductID
INNER JOIN Production.ProductSubcategory E
ON E.ProductSubcategoryID = D.ProductSubcategoryID
INNER JOIN Production.ProductCategory F
ON F.ProductCategoryID = E.ProductCategoryID
INNER JOIN Sales.SalesPerson G 
ON B.SalesPersonID = G.BusinessEntityID
INNER JOIN Person.Person H
ON H.BusinessEntityID = G.BusinessEntityID
ORDER BY  A.OrderQty DESC

SELECT * FROM Sales.SalesOrderHeader


---
SELECT B.Name, SUM(A.Quantity) AS 'Cantidad', SUM(C.OrderQty) AS 'Total ordenes vendidas' FROM Production.ProductInventory A
INNER JOIN Production.Product B ON
A.ProductID = B.ProductID
INNER JOIN Sales.SalesOrderDetail C
ON C.ProductID = B.ProductID
GROUP BY B.Name
--ORDER BY


--HAVING: SE USA A PARTIR DE UNA AGREGACIÓN O UN RESULTADO O ULSANDO GROUP BY

USE AdventureWorks2019

SELECT B.TerritoryID,A.ProductID,SUM(A.OrderQty) AS 'TOTAL UNIDADES' FROM Sales.SalesOrderDetail A 
INNER JOIN Sales.SalesOrderHeader B
ON A.SalesOrderID = B.SalesOrderID 
GROUP BY B.TerritoryID,A.ProductID
HAVING SUM(A.OrderQty)  > 300


--PERFORMANCE DE PRODUCTOS

SELECT * FROM Production.Product A
SELECT * FROM Production.ProductCostHistory
Select * from Production.ProductListPriceHistory

SELECT D.Name,AVG(B.StandardCost) AS 'Promedio Costo historico',AVG(C.ListPrice) AS 'Promedio Precio historico',
COUNT(A.ProductID) AS 'TotalTrx',SUM(A.OrderQty) AS 'Unidades vendidas' FROM Sales.SalesOrderDetail A
INNER JOIN Production.ProductCostHistory B 
ON A.ProductID = B.ProductID
INNER JOIN Production.ProductListPriceHistory C
ON C.ProductID = A.ProductID
INNER JOIN Production.Product D 
ON D.ProductID = B.ProductID
GROUP BY D.Name

--SUBCONSULTAS 
--Cuando no se usa metodo de agregación como group by entonces no es necesario usar having, sino where

SELECT A.Name, B.PromedioCosto,C.PromedioPrecio,D.[TOTAL UNIDADES],D.TotalTrx FROM Production.Product A 
INNER JOIN
	(SELECT ProductID,AVG(StandardCost) AS 'PromedioCosto' FROM Production.ProductCostHistory
	GROUP BY ProductID) B
ON B.ProductID = A.ProductID
INNER JOIN 
	(SELECT ProductID,AVG(ListPrice) AS 'PromedioPrecio' FROM Production.ProductListPriceHistory
	GROUP BY ProductID) C
ON A.ProductID = C.ProductID
INNER JOIN
	(SELECT ProductID,SUM(OrderQty) AS 'TOTAL UNIDADES', COUNT(DISTINCT(SalesOrderID)) AS 'TotalTrx' FROM Sales.SalesOrderDetail 
	GROUP BY ProductID) D
ON D.ProductID = A.ProductID
WHERE [TOTAL UNIDADES] > 5000


--FUNCIONES PARA LETRAS
SELECT 'hola mundo',
SUBSTRING('hola mundo',1,4)

SELECT LEFT('hola mundo',5)
SELECT RIGHT('hola mundo',5)

SELECT LEFT(Name,5) FROM Production.Product

--cuantos caracteres hay en una cadena
SELECT LEN('hola mundo')

SELECT LEN(Name) FROM Production.Product
--BUSCAR
SELECT CHARINDEX('o','hola mundo'),CHARINDEX('l','hola mundo'),CHARINDEX('o','hola mundo',5)

--REPLACE
SELECT REPLACE('hola mundo','hola','adios')

SELECT 'adrian alarcon', REPLACE('adrian alarcon',SUBSTRING('adrian alarcon',1,1),UPPER(SUBSTRING('adrian alarcon',1,1)))



--VISTAS
CREATE VIEW EVOLUTIVOVENTAS
AS

SELECT YEAR(A.OrderDate) 'ANIO VENTA',MONTH(A.OrderDate) 'MES VENTA', SUM(B.OrderQty) as 'Total cantidad',SUM(B.LineTotal) as 'Total monto' 
INTO #Proyecciones
FROM Sales.SalesOrderHeader A
INNER JOIN Sales.SalesOrderDetail B
ON A.SalesOrderID = B.SalesOrderID
GROUP BY YEAR(A.OrderDate),MONTH(A.OrderDate) 
ORDER BY YEAR(A.OrderDate) ASC, MONTH(A.OrderDate)  ASC

SELECT * FROM EVOLUTIVOVENTAS

select * from #Proyecciones

UPDATE PRODUCTOS SET nombre_prod = 'samsung' WHERE id_prod = 1

UPDATE  #Proyecciones SET [Total monto] = [Total monto]*0.2


--CTEs
SELECT * FROM Production.Product A

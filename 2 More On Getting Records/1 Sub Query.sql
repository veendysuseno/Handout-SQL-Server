USE Northwind;
GO

/*
	Sub Query adalah query di dalam query, atau bisa dibilang nested query.
	Sub Query bisa dalam bentuk scallar, multi-valued, atau table-valued.
*/

/*	
	Table-valued sub-query adalah subquery yang menghasilkan sebuah table, yang bisa dipakai oleh query lain.
	Table-valued sub-query disebut juga sebagai Derived Table, Check di Chapter berikutnya untuk melihat lebih detail mengenai Derived Table
*/

--Memilih dari table yang baru saja dibuat, dimana seluruh productnya sudah discontinue.
SELECT conProd.ProductName, sup.ContactName, sup.CompanyName
FROM (
	SELECT *
	FROM dbo.Products AS prod
	WHERE Discontinued = 1
) AS conProd
JOIN dbo.Suppliers AS sup ON conProd.SupplierID = sup.SupplierID
ORDER BY conProd.ProductName ASC;

--Di sini, query memilih seluruh product yang continue di join dengan seluruh supplier dengan negara berbahasa inggris, di join dengan seluruh category diluar 3.
SELECT con_prod.ProductName, eng_sup.CompanyName, eng_sup.ContactName, non_con_cat.CategoryName
FROM (
	SELECT prod.ProductID, prod.ProductName, prod.CategoryID, prod.SupplierID
	FROM dbo.Products AS prod
	WHERE prod.Discontinued = 0
) AS con_prod
JOIN (
	SELECT sup.SupplierID, sup.CompanyName, sup.ContactName
	FROM dbo.Suppliers AS sup
	WHERE sup.Country IN ('USA', 'UK', 'Australia', 'Singapore')
) AS eng_sup ON con_prod.SupplierID = eng_sup.SupplierID
JOIN(
	SELECT cat.CategoryID, cat.CategoryName
	FROM dbo.Categories AS cat
	WHERE cat.CategoryID != 3
) AS non_con_cat ON con_prod.CategoryID = non_con_cat.CategoryID;

/*
	Multi-valued subquery adalah sub-query yang menghasilkan satu deret value dalam satu column.
	Berikut ini beberapa contoh multi-valued sub-query.
*/
SElECT emp.FirstName, emp.LastName, emp.Title
FROM dbo.Employees AS emp
WHERE emp.Country IN (
	SELECT DISTINCT sup.Country
	FROM dbo.Suppliers AS sup
);

SELECT prod.ProductName, prod.UnitPrice
FROM dbo.Products AS prod
WHERE prod.SupplierID IN (
	SELECT sup.SupplierID
	FROM dbo.Suppliers AS sup
	WHERE sup.Country IN ('Spain', 'Germany', 'UK', 'Italy', 'Norway', 'Denmark', 'Netherland', 'Finland', 'Italy', 'France')
);

/*
	Scallar sub-query adalah sub-query yang menghasilkan 1 informasi saja di dalam 1 row dan 1 column.
	Ini contoh scallar sub-query.
*/
SELECT ord.OrderID, ord.OrderDate, ord.ShipCountry
FROM dbo.[Order Details] AS ordet
JOIN dbo.Orders AS ord ON ordet.OrderID = ord.OrderID
WHERE ordet.Quantity = (
	SELECT MAX(ordet.Quantity) AS MaxQuantity
	FROM dbo.[Order Details] AS ordet
);

--memilih total order detail termahal
SELECT DISTINCT ord.OrderID AS ID, cus.ContactName AS Customer, emp.FirstName AS Employee, 
(
	SELECT MAX(ordDet.Quantity * ordDet.UnitPrice)
	FROM dbo.[Order Details] AS ordDet
	WHERE ordDet.OrderID = ord.OrderID
) AS [Highest Total Detail]
FROM dbo.Orders AS ord 
JOIN dbo.Customers AS cus ON ord.CustomerID = cus.CustomerID
JOIN dbo.Employees AS emp ON ord.EmployeeID = emp.EmployeeID;


/*
	EXIST adalah operator yang digunakan pada subquery untuk melihat apakah subquery mengembalikan data atau tidak.
	sifatnya seperti inner join dengan subquerynya.

	EXIST bisa menjadi alternative dari JOIN, tapi secara proses berbeda. Karena ketika record, 
	exist data pada row akan langsung di return (di-check satu-persatu), sedangkan JOIN akan membuat table digabung terlebih dahulu.
*/

SELECT sup.ContactName, sup.CompanyName
FROM dbo.Suppliers AS sup
WHERE EXISTS (
	SELECT *
	FROM dbo.Products AS prod
	WHERE prod.UnitPrice > 60 AND prod.SupplierID = sup.SupplierID
);

/*
	Bila EXIST return NULL, atau tidak return apa-apa EXIST akan membuat query mengeluarkan seluruh records.
	Bisa dibilang defaultnya seluruhnya akan exist.
*/
SELECT sup.ContactName, sup.CompanyName
FROM dbo.Suppliers AS sup
WHERE EXISTS (
	SELECT NULL
);

/*NOT EXIST adalah kebalikan dari pada exist, operatornya akan mencari hal yang tidak ada pada recordnya di sub-query*/
SELECT sup.SupplierID, sup.ContactName, sup.CompanyName
FROM dbo.Suppliers AS sup
WHERE NOT EXISTS (
	SELECT prod.ProductID
	FROM dbo.Products AS prod
	WHERE prod.UnitPrice > 60 AND prod.SupplierID = sup.SupplierID
);

/*Sebaliknya juga daripada EXIST, NOT EXIST tidak akan mengembalikan apa-apa by default bila sub-query bersifat NULL.*/
SELECT sup.ContactName, sup.CompanyName
FROM dbo.Suppliers AS sup
WHERE NOT EXISTS (
	SELECT NULL
);

/*ANY mirip seperti EXIST, tetapi dia sifatnya match dengan multi-valued query, 
apabila setidaknya ada 1 saja yang match dengan WHERE atau HAVING, maka dia akan mengembalikan record row tersebut. */
SELECT prod.ProductName
FROM dbo.Products AS prod
WHERE prod.ProductID = ANY(
	SELECT ordDet.ProductID
	FROM dbo.[Order Details] AS ordDet
	WHERE ordDet.ProductID > 5
);

/*Dalam hal ini, ALL tidak mengembalikan apapun, karena di dalam ALL, seluruh record harus memiliki value tersebut,
  contohnya dalam hal ini, apa bila terpilih sebuah product dengan ID 5, maka seluruh record dalam subquerynya harus 5, bila salah satu saja bukan 5, maka tidak match.
*/
SELECT prod.ProductID
FROM dbo.Products AS prod
WHERE prod.ProductID = ALL(
	SELECT ordDet.ProductID
	FROM dbo.[Order Details] AS ordDet
	WHERE ordDet.ProductID > 5
);

--5 pasti kembali, karena total record memiliki id 5
SELECT prod.ProductID
FROM dbo.Products AS prod
WHERE prod.ProductID = ALL(
	SELECT ordDet.ProductID
	FROM dbo.[Order Details] AS ordDet
	WHERE ordDet.ProductID = 5
);
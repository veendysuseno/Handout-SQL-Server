USE Northwind;

/*Nama kota yang sama akan keluar lebih dari satu karena multiple records.*/
SELECT emp.City
FROM dbo.Employees AS emp;

/*Distinct digunakan untuk mengeliminasi row yang sama persis apa bila menggunakan select biasa.*/
SELECT DISTINCT emp.City
FROM dbo.Employees AS emp;

/*Aggregate Functions adalah fungsi yang digunakan untuk melakukan perhitungan di satu atau lebih nilai dan mengembalikan satu nilai.
  Contoh Aggregate functions seperti COUNT, AVG, MAX, MIN, SUM.*/

/*COUNT menghitung jumlah row pada satu group.*/
SELECT COUNT(emp.EmployeeID) AS [Jumlah Employee], emp.City
FROM dbo.Employees AS emp
GROUP BY emp.City;

/*AVG menghitung rata-rata row pada satu group.*/
SELECT AVG(prod.UnitPrice) AS [Harga Rata rata], prod.SupplierID AS supplier
FROM dbo.Products AS prod
GROUP BY prod.SupplierID;

/*MAX memilih nilai maximum pada satu group.*/
SELECT MAX(prod.UnitPrice) AS [Harga Terbesar], prod.SupplierID AS supplier
FROM dbo.Products AS prod
GROUP BY prod.SupplierID;

/*MIN memilih nilai minimum pada satu group*/
SELECT MIN(prod.UnitPrice) AS [Harga Terkecil], prod.SupplierID AS supplier
FROM dbo.Products AS prod
GROUP BY prod.SupplierID;

/*SUM menjumlahkan nilai total pada satu group*/
SELECT SUM(prod.UnitPrice) AS [Jumlah Total], prod.SupplierID AS supplier
FROM dbo.Products AS prod
GROUP BY prod.SupplierID;

/*
	Ada juga beberapa statistic aggregate functions, seperti 
	STDEV (Standard Deviation) dan VAR (Variance of Value) yang bisa kalian coba.
*/

/*HAVING ditambakan di sql, karena WHERE tidak bisa dikombinasikan dengan aggregate functions*/
SELECT COUNT(emp.EmployeeID) AS [Jumlah Employee], emp.City
FROM dbo.Employees AS emp
GROUP BY emp.City
HAVING COUNT(emp.EmployeeID) >= 2;

SELECT AVG(prod.UnitPrice) AS [Harga Rata rata], prod.SupplierID AS supplier
FROM dbo.Products AS prod
GROUP BY prod.SupplierID
HAVING AVG(prod.UnitPrice) BETWEEN 25 AND 30;

/*
	Pemakaian Aggregate function bisa digabung dengan DISTINCT.
	Perhatikan 2 contoh berikut ini, hasilnya akan berbeda.
*/

/*
	Contoh di bawah ini menghitung total semua macam barang berdasarkan Suppliernya. 
	Menghitungnya berdasarkan UnitsOnOrder (COUNT(UnitsOnOrder))tidak ada pengaruhnya apabila seluruh UnitsOnOrder tidak ada yang NULL.
	Ini sama saja dengan COUNT(*) atau COUNT(ProductID)
*/
SELECT prod.SupplierID, COUNT(prod.UnitsOnOrder) AS Jumlah
FROM dbo.Products as prod
GROUP BY prod.SupplierID;

/*
	Dengan ditambahnya DISTINCT pada UnitsOnOrder di dalam COUNT, maka total yang dihitung hanya berdasarkan total UnitsOnOrder yang berbeda.
	Apabila seluruh product dari supplier tersebut tidak ada yang order sama sekali, maka hasilnya akan 1.
*/
SELECT prod.SupplierID, COUNT(DISTINCT prod.UnitsOnOrder) AS Jumlah
FROM dbo.Products as prod
GROUP BY prod.SupplierID;

/*
	ORDER BY digunakan untuk mengurutkan record data secara alphabetical order
	By default, order by bersifat ascending
*/
SELECT CONCAT(emp.FirstName, ' ', emp.LastName) AS [Complete Name]
FROM dbo.Employees AS emp
ORDER BY emp.FirstName;

/*Walaupun secara default ascending, kita tetap bisa memberi sign ASC.*/
SELECT CONCAT(emp.FirstName, ' ', emp.LastName) AS [Complete Name]
FROM dbo.Employees AS emp
ORDER BY emp.FirstName ASC;

/*DESC digunakan untuk mungurutkan hasil menjadi descending.*/
SELECT CONCAT(emp.FirstName, ' ', emp.LastName) AS [Complete Name]
FROM dbo.Employees AS emp
ORDER BY emp.FirstName DESC;

/*ORDER BY bisa digunakan untuk lebih dari 1 column, dan diprioritaskan dari yang urutan lebih awal.*/
SELECT emp.City, CONCAT(emp.FirstName, ' ', emp.LastName) AS [Complete Name]
FROM dbo.Employees AS emp
ORDER BY emp.City, emp.FirstName;

/*Pemakaian ASC dan DESC bisa dikombinasikan untuk column yang berbeda.*/
SELECT emp.City, CONCAT(emp.FirstName, ' ', emp.LastName) AS [Complete Name]
FROM dbo.Employees AS emp
ORDER BY emp.City DESC, emp.FirstName ASC;

/*ORDER BY juga bisa digunakan untuk numeric data type dan data type lainnya*/
SELECT prod.ProductName, prod.UnitPrice
FROM dbo.Products as prod
ORDER BY prod.UnitPrice ASC;

SELECT prod.ProductName, prod.UnitPrice
FROM dbo.Products as prod
ORDER BY prod.UnitPrice DESC;

/*ORDER BY Bisa digunakan untuk date juga.*/
SELECT emp.FirstName AS [nama depan], emp.HireDate
FROM dbo.Employees AS emp
ORDER BY emp.HireDate ASC;

/*Select Top digunakan untuk urutan teratas */
SELECT TOP 3 prod.ProductName, prod.UnitPrice
FROM dbo.Products as prod
ORDER BY prod.UnitPrice DESC;

/*Bisa menggunakan percent juga*/
SELECT TOP 50 percent prod.ProductName, prod.UnitPrice
FROM dbo.Products as prod
ORDER BY prod.UnitPrice DESC;

/*Contoh penggunaan lengkap secara berurutan*/
SELECT TOP 5 prod.SupplierID AS Supplier, SUM(prod.UnitPrice) AS Total
FROM dbo.Products AS prod
WHERE prod.Discontinued = 0
GROUP BY prod.SupplierID
HAVING SUM(prod.UnitPrice) > 20
ORDER BY SUM(prod.UnitPrice) ASC;

/*
	Strange Query Processing Order, nomor-nomor ini menceritakan urutan query di proses.
	Walaupun select ditulis terlebih dahulu, tapi sebenarnya di proses pada tahap ke 5.

	5 SELECT
	1 FROM
	2 WHERE
	3 GROUP BY
	4 HAVING
	6 ORDER BY

	Urutan Processing bisa dilihat dari Execution Plan
*/

/*
	OFFSET kebalikan dari TOP, yang artinya skip beberapa rows.
	Bisa dilihat Alejandra sampai Aria di skip atau dilewati.
*/
SELECT cus.ContactName
FROM dbo.Customers AS cus
ORDER BY cus.ContactName
OFFSET 9 ROWS;

/*
	FETCH NEXT/FIRST: sifatnya sama seperti top, tapi TOP tidak bisa digunakan bersamaan dengan OFFSET, karena waktu eksekusinya.
*/
SELECT cus.ContactName
FROM dbo.Customers AS cus
ORDER BY cus.ContactName
OFFSET 9 ROWS
FETCH NEXT 5 ROWS ONLY;

SELECT cus.ContactName
FROM dbo.Customers AS cus
ORDER BY cus.ContactName
OFFSET 9 ROWS
FETCH FIRST 5 ROWS ONLY;

USE Northwind;

/*
	GROUPING SETS function digunakan untuk melakukan grouping dalam set atau kombinasi.
	Seperti contoh dibawah ini, di group berdasarkan supplier company dan category name.

	Sehingga seluruh data yang ditampilkan adalah Total Price dari Category Name dan Supplier.
*/
SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY 
	GROUPING SETS(
		(sup.CompanyName, cat.CategoryName)
	);

/*
	Kombinasi dari Group SETS bisa digabungkan, dalam hal ini kita mencoba kombinasi dari:
	-) Existing Supplier dan Category
	-) Existing Supplier saja dan Category NULL
	-) Existing Category saja dan Supplier NULL
	-) NULL untuk keduanya.
*/
SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY 
	GROUPING SETS(
		(sup.CompanyName, cat.CategoryName),
		(sup.CompanyName),
		(cat.CategoryName),
		()
	);

/*
	CUBE seperti GROUPING SETS dengan kombinasi yang lengkap, 
	Sama seperti GROUPING SETS yang di atas.

	Dengan kombinasi
	(column 1,  column 2)
	(column 1)
	(column 2)
	()
*/
SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY CUBE(sup.CompanyName, cat.CategoryName);

/*CUBE bisa ditulis dengan tata cara penulisan lain, misalnya dengan WITH clause*/
SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY sup.CompanyName, cat.CategoryName WITH CUBE;

/*
	ROLLUP juga merupakan kombinasi yang sifatnya sama seperti GROUPSETS,
	tetapi lain dengan CUBE, ROLLUP mengkombinasikan:

	(column 1,  column 2)
	(column 1)
	()
*/
SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY ROLLUP(cat.CategoryName, sup.CompanyName);

SELECT cat.CategoryName AS Category, sup.CompanyName AS Supplier, 
SUM(prod.UnitPrice) AS TotalPrice, COUNT(prod.ProductID) AS Count
FROM dbo.Products AS prod
JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
JOIN dbo.Categories AS cat ON prod.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName, ROLLUP(sup.CompanyName);
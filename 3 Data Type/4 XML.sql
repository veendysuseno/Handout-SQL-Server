USE Northwind;

/*
	FOR XML digunakan untuk mengembalikan query dalam format XML.
	XML (Xtensible Markup Language) adalah bahasa mark up seperti html yang biasanya digunakan untuk pengiriman data ke aplikasi lain,
	atau membuat sebuah settingan pada sebuah aplikasi.

	Ada 4 XML mode:
	1. RAW
	2. AUTO
	3. EXPLICIT (Tidak akan dibahas)
	4. PATH
*/

/*RAW Mode: mengembalikan single XML element untuk setiap row, seluruh data akan di-tampilkan pada xml attribute*/
SELECT cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country
FROM dbo.Customers AS cus
FOR XML RAW;

--Ini akan memberi nama untuk setiap row pada xml nya
SELECT cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country
FROM dbo.Customers AS cus
FOR XML RAW ('Customer');

SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product');

--ROOT digunakan untuk membuat root element, by default namanya adalah <root> tag
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product'), ROOT;

SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product'), ROOT ('ProductsList');

SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product'), ROOT ('ProductsList'), ELEMENTS;

--Banyak dari column region yang bernilai null, dan xml akan kehilangan elementnya.
SELECT sup.CompanyName, sup.ContactName, sup.Region, prod.ProductName, prod.Discontinued
FROM dbo.Suppliers as sup
JOIN dbo.Products as prod ON sup.SupplierID = prod.SupplierID
FOR XML RAW ('Supplier'), ROOT ('List'), ELEMENTS;

--Kita bisa menggantinya dengan menggunakan namespace XSINIL (xsi:nil). namespacing pada xml tidak akan dibahas pada pelajaran ini.
SELECT sup.CompanyName, sup.ContactName, sup.Region, prod.ProductName, prod.Discontinued
FROM dbo.Suppliers as sup
JOIN dbo.Products as prod ON sup.SupplierID = prod.SupplierID
FOR XML RAW ('Supplier'), ROOT ('List'), ELEMENTS XSINIL;

--Gunakan XMLSCHEMA untuk menambahkan xsd pada XML, kita tidak akan membahas XML schema pada pelajaran ini.
SELECT sup.CompanyName, sup.ContactName, sup.Region, prod.ProductName, prod.Discontinued
FROM dbo.Suppliers as sup
JOIN dbo.Products as prod ON sup.SupplierID = prod.SupplierID
FOR XML RAW ('Supplier'), ROOT ('List'), ELEMENTS XSINIL, XMLSCHEMA;

/*
	AUTO Mode: di sini xml tag akan dibentuk berdasarkan pernyataan SELECT statementya.
	Lihat contoh AUTO di bawah, setiap alias di generate sebagai tag sendiri di sini.
*/

--Pada Auto mode, Row tidak bisa diberi nama, karena akan bertentangan dengan featuresnya
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML AUTO;

/*Bandingkan dengan yang RAW*/
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product');

SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML AUTO, ROOT('List'), ELEMENTS;

/*
	EXPLICIT tidak akan dibahas pada pelajaran ini.
	EXPLICIT Mode adalah cara super specific mengontrol hasil dari XML dengan banyak persyaratan dan peraturan untuk membuatnya.
*/

/*
	PATH Mode: sama seperti RAW Mode dengan ELEMENTS, PATH Mode menciptakan XML pada langsung menggunakan tag xm/ xml elements
*/
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML PATH;

SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML PATH('Product');

--Tidak akan ada bedanya dengan ini.
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML RAW ('Product'), ELEMENTS;

--Pemakaian function lainnya sama seperti pada RAW.
SELECT cat.CategoryName, pro.ProductName, pro.UnitPrice
FROM dbo.Categories as cat
JOIN dbo.Products as pro ON cat.CategoryID = pro.CategoryID
FOR XML PATH('Product'), ROOT('List'), ELEMENTS XSINIL;
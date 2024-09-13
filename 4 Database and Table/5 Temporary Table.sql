USE Northwind;

/*
 Temporary Table adalah table sementara, dimana table ini hanya menampung data sementara di dalam database.
 Data-data temporary table diperoleh dari table normal untuk waktu yang limited.

 Temporary table digunakan saat ada data yang banyak di dalam table, dan kita harus berulang kali berinteraksi dengan sebagian kecil dari data yang banyak.
 Daripada harus difilter berkali-kali, Temporary table bisa dimanfaatkan untuk menampungnya sementara.
*/

SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle
INTO #customerWithNullRegion
FROM dbo.Customers AS cus
WHERE cus.Region IS NULL;

--Temporary Tables bisa ditemuka di Databases > System Databases > tempdb > Temporary Tables
SELECT * FROM #customerWithNullRegion;

CREATE TABLE #customerWithRegion(
	CustomerID varchar(5) PRIMARY KEY,
	CompanyName varchar(40) NOT NULL,
	ContactName varchar(30) NULL,
	ContactTitle varchar(30) NULL
);

INSERT INTO #customerWithRegion
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle
FROM dbo.Customers AS cus
WHERE cus.Region IS NOT NULL;

--Global Temporary Table: bisa diakses semua koneksi, tidak koneksi yang membuatnya saja.
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle
INTO ##customerFromUK
FROM dbo.Customers AS cus
WHERE cus.Country = 'UK';

USE master;
GO 
SELECT * 
FROM ##customerFromUK;

--Seluruh temporary table akan hilang begitu koneksi dari query ini tertutup
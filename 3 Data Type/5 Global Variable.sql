USE Northwind;

/*
	Microsoft SQL server menyediakan banyak Global Variables yang bisa membantu kita.
	Global Variables adalah variable special yang siap digunakan, tanpa harus deklarasi terlebih dahulu. System akan memaintain mereka secara konstan.
	Global Variables bisa dipakai dengan menggunakan prefix sign @@.

	Kita akan mencoba sebagian dari pada global variables ini. Sisanya akan dibahas pada chapter lain atau bisa dicoba sendiri.
*/

/*ROWCOUNT: digunakan untuk menghitung jumlah row dari hasil seleksi query. Yang terjadi satu sebelumnya.*/
SELECT *
FROM dbo.Employees;
SELECT @@ROWCOUNT AS [Total Number of Employee];

--Yang ini mengembalikan nilai 1, karena yang dilihat dari query ini [Total Number of Employee] hasil row count yang sebelumnya.
SELECT @@ROWCOUNT AS [After Count];

SELECT prod.ProductID
FROM dbo.Products AS prod
WHERE prod.UnitPrice > 100;
SELECT @@ROWCOUNT AS [Total Row product];

--VERSIONS: Untuk mendapatkan versi dari MSSQL Server
SELECT @@VERSION AS [DBMS Versions];

--CONNECTIONS: Untuk mendapatkan informasi login attemps
SELECT GETDATE() AS 'Today''s Date and Time',  
@@CONNECTIONS AS 'Login Attempts'

USE College;

--IDENTITY: digunakan untuk mendapatkan nomor auto increment atau nomor identity dari row yang terakhir kali di insert ke dalam satu table
/*
INSERT INTO dbo.Car(StudentNumber, PoliceNumber, Model, Brand, Color)
VALUES ('12/2019/0001', 'B888LM', 'Golf', 'VW', 'White');
SELECT @@IDENTITY AS 'Identity';
*/

--LANGID & LANGUAGE: digunakan untuk mendapat id atau nama dari default language yang di set di sql server.
SET LANGUAGE British;
SELECT @@LANGID AS 'Language ID'
SELECT @@LANGUAGE AS 'Language Name';
SET LANGUAGE 'us_english' 
SELECT @@LANGID AS 'Language ID'
SELECT @@LANGUAGE AS 'Language Name';

--Mendapatkan nama server yang ada.
SELECT @@SERVERNAME AS 'Server Name';

/*
	Sisanya dapat dilihat di dalam link berikut:
	https://code.msdn.microsoft.com/Global-Variables-in-SQL-749688ef
*/
/*Berikut ini adalah beberapa function lain yang disediakan system yang berguna untuk melakukan beberapa operation pada query.*/

USE Northwind;

/*
	ISNULL() adalah fungsi yang digunakan untuk mengganti null dari sebuah column menjadi sesuatu yang lain.
	Misalnya untuk column region di bawah ini, dibanding harus ditampilkan NULL, pada selection, apabila informasi region tidak 
	tersedia, maka Not Applicable yang akan ditampilkan.
*/
SELECT sup.CompanyName, sup.Country, ISNULL(sup.Region, 'Not Applicable') AS Region, sup.City
FROM dbo.Suppliers AS sup;

/*Kita juga bisa memanfaatkan ISNULL dengan cara menggunakan alternative null satu column dengan column lain.*/
SELECT sup.CompanyName, sup.Country, ISNULL(sup.Region, sup.Country) AS [Region Or Country]
FROM dbo.Suppliers AS sup;

/*
	Atau kita bisa menggunakan COALESCE() untuk melakukan-nya ISNULL sekali banyak.
	Seperti contoh di bawah COALESCE(sup.HomePage, sup.Fax, sup.Region, sup.Country), ini artinya column yang pertamakali NOT NULL akan di print.

	Kurang lebih bisa dikatakan seperti if else atau select case, dimana memprioritaskan HomePage terlebih dahulu,
	lalu diikuti dengan Fax, Region, baru kalau semuanya NULL akan mem-print Country.
*/
SELECT sup.CompanyName, COALESCE(sup.HomePage, sup.Fax, sup.Region, sup.Country) AS [HomePage/ Fax/ Region/ Country]
FROM dbo.Suppliers AS sup;

/*Update database GirlFlower terlebih dulu dengan GirlFlower.bak yang baru.*/
USE GirlFlower;

/*
	NULLIF digunakan untuk mengembalikan null apabila 2 value di dalam parameters sama, apabila tidak sama, 
	maka parameter pertama akan digunakan.

	Pada contoh di bawah ini, NetPrice akan ditampilkan apabila valuenya berbeda dengan GrossPrice.
	tapi apabila sama, hasilnya akan NULL.
*/
SELECT flo.[Name], NULLIF(NetPrice, GrossPrice)
FROM dbo.Flower AS flo;

/*
	Di sini kita bisa mengkombinasikan ISNULL dan NULLIF, sehingga apabila tidak ada perbedaan dari Gross Price dan Net Price,
	maka hasilnya akan 0.
*/
SELECT flo.[Name], ISNULL(NULLIF(NetPrice, GrossPrice), 0) AS [Check Differences]
FROM dbo.Flower AS flo;

/*
	EXISTS adalah operator yang digunakan untuk menentukan, apakah ada setidaknya 1 row di dalam satu query yang mengembalikan table value.
	Apabila ditemukan 1 row atau lebih, EXISTS akan mengembalikan nilai true, apabila tidak ada row yang dikembalikan sama sekali akan bernilai false.

	NOTE: Apabila ada row yang bernilai NULL, NULL akan dianggap sebagai 1 row.
*/

SELECT grl.[Name] AS [Cewek yang suka bunga]
FROM dbo.Girl AS grl
WHERE EXISTS(
	SELECT flo.[Name]
	FROM dbo.Flower AS flo
	WHERE flo.GirlID = grl.ID
);

SELECT grl.[Name] AS [Cewek yang suka lebih dari 1 bunga]
FROM dbo.Girl AS grl
WHERE EXISTS(
	SELECT flo.GirlID, COUNT(flo.ID)
	FROM dbo.Flower AS flo
	WHERE flo.GirlID = grl.ID
	GROUP BY flo.GirlID
	HAVING COUNT(flo.ID) > 1
);

IF EXISTS(
	SELECT flo.GirlID, COUNT(flo.ID)
	FROM dbo.Flower AS flo
	GROUP BY flo.GirlID
	HAVING COUNT(flo.ID) > 1
)
BEGIN
	PRINT 'Ditemukan perempuan yang suka lebih dari 1 bunga';
END

USE Northwind;

/*
	OBJECT_ID adalah function yang digunakan untuk mendapatkan nomor id dari object apa saja yang dicari.
	OBJECT_ID mengembalikan id dalam tipe data integer. (Setiap object di dalam sql server memiliki nomor identifikasi yang unik).
	Apabila object tidak ditemukan, hasil dari OBJECT_ID akan NULL.

	OBJECT_ID memiliki 2 parameter, yaitu object_name dan object_type, keduanya harus ditulis dalam varchar/nchar seperti di bawah ini:

	OBJECT_ID(object_name, object_type) 
	object_name adalah nama object yang ingin di cari,
	sedangkan object_type adalah code dari jenis object yang dicari.

	object type, harus ditulis dalam code seperti di bawah ini:
		AF = Aggregate function (CLR)
		C = CHECK constraint
		D = DEFAULT (constraint or stand-alone)
		EC = Edge constraint
		F = FOREIGN KEY constraint
		FN = SQL scalar function
		FS = Assembly (CLR) scalar-function
		FT = Assembly (CLR) table-valued function
		IF = SQL inline table-valued function
		IT = Internal table
		P = SQL Stored Procedure
		PC = Assembly (CLR) stored-procedure
		PG = Plan guide
		PK = PRIMARY KEY constraint
		R = Rule (old-style, stand-alone)
		RF = Replication-filter-procedure
		S = System base table
		SN = Synonym
		SO = Sequence object
		SQ = Service queue
		TA = Assembly (CLR) DML trigger
		TF = SQL table-valued-function
		TR = SQL DML trigger
		TT = Table type
		U = Table (user-defined)
		UQ = UNIQUE constraint
		V = View
		X = Extended stored procedure
*/

--Function OBJECT_ID ini mengembalikan ID dari table dbo.Categories.
SELECT OBJECT_ID('dbo.Categories', 'U');

--Bisa dilihat kalau ID nya berbeda-beda dan unik kalau di compare dengan table lain.
SELECT OBJECT_ID('dbo.Customers', 'U');

--Apabila kita berusaha mencari object yang namanya tidak existing, maka akan NULL returnnya.
SELECT OBJECT_ID('dbo.X', 'U');

--Di bawah ini object_id dipakai untuk mendapatkan nomor id dari view dan table value function.
SELECT OBJECT_ID('dbo.Orders Qry', 'V');
SELECT OBJECT_ID('dbo.GetProductsByCategory', 'TF');

/*ObjectID bisa dimanfaatkan untuk melacak keberadaan suatu object, contohnya pada kasus dibawah, kita lacak eksistensi sebuah table.
  Apabila table tersebut exist, kita bisa drop table tersebut, apabila tidak operasi dari drop table akan di skip dan tidak akan mengakibatkan error.
*/
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL 
	DROP TABLE dbo.OrderDetails;

USE Bioskop;

/*
	CHOOSE adalah function yang digunakan untuk me-replace integer index menjadi suatu text, contohnya di sini untuk setiap Studio:
	1 adalah IMAX class
	2 adalah Regular class
	3 adalah Regular class
	4 adalah Small class
*/
SELECT the.Studio AS [Studio Number], CHOOSE(the.Studio, 'IMAX', 'Regular', 'Regular', 'Small') AS [Room Type], 
the.Movies AS [Movie]
FROM dbo.Theater AS the;

select * from Theater

/*System metadata function: adalah function yang tersedia di dalam system mengembalikan informasi mengenai database atau database object.*/
USE Northwind;

/*DB_NAME() Digunakan untuk check database yang sedang terkoneksi*/
SELECT DB_NAME() AS current_database;

/*Kita juga bisa melihat SQL Server version kita dengan menggunakan code-code ini.*/
SELECT @@VERSION AS SQL_Version;
SELECT SERVERPROPERTY('ProductVersion') AS version;
SELECT SERVERPROPERTY('Collation') AS collation;


USE Hospital;

/*
	Kita bisa mendapatkan table name di setiap schema dan bisa juga menghitung total columnnya untuk setiap table.
	Note: mengenai schema akan dijelaskan di chapter berikutnya.
*/


SELECT tbl.[name] AS [Table Name], tbl.max_column_id_used AS [Total Column]
FROM sys.tables AS tbl
WHERE schema_id = SCHEMA_ID(N'Apotek');

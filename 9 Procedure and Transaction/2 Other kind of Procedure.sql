USE Ecommerce;

/*System Store Procedure adalah Procedure yang sudah berada di dalam system, yang bisa menyediakan general metadata.*/
EXECUTE sp_help; --digunakan untuk melihat seluruh database object yang ada di dalam database dengan current connection.
EXECUTE sp_helplanguage; --digunakan untuk melihat seluruh feature yang berkaitan dengan bahasa.

USE Company;
/*Temporary Procedure adalah SP yang sifatnya sama seperti temporary table. Sifatnya temporary dan akan menghilang begitu koneksi terputus.*/
CREATE PROCEDURE #TempGetDepartmentEmployee AS
	SELECT emp.[Name] AS [Employee Name], dep.[Name] AS [Department]
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID
GO
EXECUTE #TempGetDepartmentEmployee
GO

/*Global Temporary Procedure sama seperti global temporary table, dimana bisa diakses semua koneksi tidak ekslusif di satu koneksi saja.
	Tetapi sifatnya juga sangat temporary atau sementara.*/
CREATE PROCEDURE ##TempGetDepartmentEmployee AS
	SELECT emp.[Name] AS [Employee Name], dep.[Name] AS [Department]
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID
GO
EXECUTE ##TempGetDepartmentEmployee;
GO

/*TAMBAHAN!: SYNONYM adalah cara membuat alias untuk database object, seperti table, user defined-function, store procedure, and sequence.*/
USE Ecommerce;
CREATE SYNONYM pembeli FOR dbo.Buyer;
CREATE SYNONYM menghitungProductPenjual FOR dbo.CountProductBySeller;
CREATE SYNONYM mengentriPenjualan FOR dbo.ProceedPurchase;

SELECT *
FROM pembeli;

DECLARE @count AS INT;

EXECUTE menghitungProductPenjual
	@seller_id = 'S1',
	@product_count = @count OUTPUT;

DECLARE @CartTable AS CartTableType
	INSERT INTO @CartTable
		VALUES (2, 'P11'), (2, 'P12');

EXECUTE mengentriPenjualan
	@buyer_id = 'B3',
	@shipment_name = 'JNE',
	@cart_table = @CartTable;
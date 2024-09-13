USE Ecommerce;

/*
	Function adalah sederetan perintah SQL yang digunakan untuk mengerjakan spesifik task, tetapi perbedaanya dengan View adalah
	function bisa menerima parameter (input), me-return value (mengembalikan hasil /outputnya).

	Dilihat dari asal-usulnya, function bisa dibedakan menjadi 2 macam:
	1. SQL Server Built In Function: adalah function-function yang sudah disediakan oleh Microsoft SQL Server sendiri.
	2. User Defined Function: adalah Function yang dibuat oleh developer sendiri, bukan function yang sifatnya built-in dari sql server.
*/

/*
	Untuk membuat User-Defined Function, gunakan syntax seperti di bawah ini:

	CREATE FUNCTION digunakan untuk membuat function dan parameters.
	RETURNS DATATYPE digunakan untuk menyatakan tipe data output/hasil/return daripada function tersebut.
	Penulisan Parameter ditandai dengan () atau parameter bracket. Parameter adalah format input yang dimiliki oleh function, 
	dimana penulisannya sama seperti deklarasi variable.

	Note: untuk membuat user defined function, function block harus satu-satunya berada di dalam batch.
*/
CREATE FUNCTION dbo.Penjumlahan(@angkaPertama AS INT, @angkaKedua AS INT)
RETURNS INT AS
BEGIN
	RETURN @angkaPertama + @angkaKedua;
END

/*Coba call function dengan select atau dengan print.*/
SELECT dbo.Penjumlahan(5, 4) AS Hasil;
PRINT dbo.Penjumlahan(5,4);

/*ALTER FUNCTION digunakan untuk merubah existing function.*/
ALTER FUNCTION dbo.Penjumlahan(@angkaPertama AS INT, @angkaKedua AS DECIMAL(5,2), @angkaKetiga AS INT)
RETURNS DECIMAL(5,2) AS
BEGIN
	RETURN @angkaPertama + @angkaKedua + @angkaKetiga
END

/*Cobalah call function yang sudah diupdate.*/
SELECT dbo.Penjumlahan(4, 2.5, 6) AS Hasil;

/*Buatlah function lain dengan nama perkalian dan mengembalikan hasil perkaliannya.*/
CREATE FUNCTION dbo.Perkalian(@angkaPertama AS INT, @angkaKedua AS INT)
RETURNS INT AS
BEGIN
	RETURN @angkaPertama * @angkaKedua;
END

/*Kalian tidak akan bisa membuat function baru dengan nama yang sama*/
CREATE FUNCTION dbo.Perkalian(@angkaPertama AS INT, @angkaKedua AS INT)
RETURNS INT AS
BEGIN
	RETURN @angkaPertama * @angkaKedua;
END

/*Sekalipun dengan parameter yang berbeda, (tidak bisa melakukan overloading di dalam sql server).*/
CREATE FUNCTION dbo.Perkalian(@angkaPertama AS INT, @angkaKedua AS INT, @angkaKetiga AS INT)
RETURNS INT AS
BEGIN
	RETURN @angkaPertama * @angkaKedua * @angkaKetiga;
END

/*
	Dilihat dari tipe return value-nya, function bisa dibedakan menjadi 3 macam:

	1. Scalar Function: adalah function dimana function tersebut mengembalikan nilai dalam satu data atau satu variable.
	Scalar Function bisa dilihat seperti contoh di atas.

	2. Table Value Function: adalah function dimana function tersebut mengembalikan nilai dalam bentuk table.
*/

/*Inline Table Valued Function/ Table Valued Function tidak memiliki BEGIN atau END block dan 
di returns sebagai virtual table dengan statement RETURNS TABLE*/
CREATE FUNCTION dbo.ViewAllStudentByLevel(@level AS VARCHAR(100))
RETURNS TABLE AS RETURN
	SELECT stud.*--stud.FirstName, stud.LastName
	FROM dbo.Student AS stud
	join Subject on stud.StudentNumber = Subject.StudentNumber
	where Subject.Level = @level
	WHERE stud.Penjurusan LIKE @penjurusan

CREATE FUNCTION dbo.ProductMultiplication(@quantity AS INT, @product_code AS VARCHAR(20))
RETURNS MONEY AS
BEGIN
	DECLARE @product_price AS MONEY;
	SELECT @product_price = prod.Price
	FROM dbo.Product as prod
	WHERE prod.Code = @product_code
	RETURN @product_price * @quantity;
END

/*
	Sama seperti pada view, function juga bisa menggunakan SCHEMABINDING.
	Dengan adanya SCHEMABINDIND, seluruh table yang digunakan pada function ini tidak bisa dimodifikasi.
	SCHEMABINDING akan meningkatkan performance tetapi mengurangi ke flexible-an.
*/

USE Ecommerce;

CREATE FUNCTION dbo.ReduceProduct(@productCode AS VARCHAR(20), @totalReduce AS INT)
RETURNS INT WITH SCHEMABINDING AS
BEGIN
	DECLARE @oldStock AS INT;	
	SELECT @oldStock = prod.Stock
	FROM dbo.Product AS prod
	WHERE prod.Code = @productCode

	IF(@totalReduce > @oldStock)
	BEGIN
		PRINT 'Out Of Stock';
		RETURN -1;
	END

	DECLARE @currentStock AS INT = @oldStock - @totalReduce;
	UPDATE dbo.Product
		SET Stock = @currentStock
		WHERE Code = @productCode;
	RETURN @currentStock;
END;
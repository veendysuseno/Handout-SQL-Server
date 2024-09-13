USE Northwind;
/*
	Sebelum belajar mengenai control flow yang lain, kita akan mengenal BEGIN... END Statement.

	BEGIN...END statement digunakan untuk membuat statement block (atau sedikit mirip dengan code block {} pada
	programming language seperti java, c++, c#, dan lain sebagainya, tetapi BEGIN END tidak membatasi variable scope). 
*/

/*
	BEGIN...END Sering kali digunakan sebagai statement pembatas di dalam suatu Procedure atau Function (Dipelajari di chapter lain)
	Atau di dalam sebuah query sebagai bentuk kebiasaan saja (pembatas proses), walaupun gak begitu memberikan pengaruh.

	Tetapi BEGIN...END harus digunakan dalam control flow, yang akan kita pelajari, misalnya:
	IF...ELSE, CASE dan WHILE loop.
*/
BEGIN
	SELECT TOP 10 prod.ProductID
	FROM dbo.Products AS prod;

	SELECT @@ROWCOUNT AS TotalSecondInside;
END

/*
	IF adalah conditional statement, dimana bila kondisinya benar, begin block berikutnya akan dieksekusi.
	Note: Bagi yang sudah memiliki dasar belajar bahasa pemrograman, konsep if pasti sudah tidak asing lagi.
*/
DECLARE @number INT = 23;
IF @number = 23 -- jika @number adalah 23
BEGIN
	PRINT 'The number is equal to 23';
END

IF @number >= 23 -- jika @number lebih besar sama dengan 23
BEGIN
	PRINT 'The number is equal or bigger than 23';
END

IF @number <> 23 -- jika @number tidak sama dengan 23.
BEGIN
	PRINT 'The number is not equal to 23';
END
ELSE -- else adalah scenario alternative yang terjadi jika if tidak terpenuhi.
BEGIN
	PRINT 'The number is equal to 23'
END

DECLARE @kata VARCHAR(20) = 'the word';
IF @kata = 'the word'
BEGIN
	PRINT 'katanya match';
END

--Apabila kita tidak menggunakan BEGIN..END, maka statement terakhir akan ikut kena print.
DECLARE @angkaPertama INT = 8;
IF @angkaPertama <> 8 
	PRINT 'Angka pertama bukan 8';
	PRINT 'Angka pertama bisa apa saja yang penting bukan 8';

--Apabila kita menggugunakan BEGIN...END block, maka akan sangat berbeda hasilnya. Keduanya jadi merupakan satu kesatuan batch.
DECLARE @angkaKedua INT = 9;
IF @angkaKedua <> 9 
BEGIN
	PRINT 'Angka kedua bukan 9';
	PRINT 'Angka kedua bisa apa saja yang penting bukan 9';
END

--Contoh lain dalam penggunaan IF dan ELSE
BEGIN
	SELECT prod.ProductName AS [Name], prod.QuantityPerUnit AS Quantity, FORMAT(prod.UnitPrice, 'N', 'en-US') AS Price
	FROM dbo.Products AS prod
	WHERE prod.UnitPrice > 100;

	DECLARE @totalRow AS INT = @@ROWCOUNT;
	IF (@totalRow = 0)
	BEGIN
		PRINT 'No Product is found';
	END
	ELSE
	BEGIN
		PRINT CONCAT(CAST(@totalRow AS VARCHAR(5)), ' Product(s) is/are found');
	END
END

/*
	Diantara IF dan ELSE, kita bisa meletakan ELSE IF di antaranya.
	ELSE IF adalah cabang alternatif dari IF, apabila if tidak memenuhi persyaratan, maka ELSE IF akan di check terlebih dahulu sebelum pada akhirnya masuk ke else.
	ELSE IF bisa dibuat lebih dari satu kemungkinan.

	Contoh di bawah adalah contoh sebuah system vending machine, dimana kita bisa membeli minuman hanya dengan menekan tombol 1 - 3.
	Outputnya akan jatuh sesuai dengan variablenya.
*/
DECLARE @pressedButton INT = 2;
IF @pressedButton = 1
BEGIN
	PRINT 'Coca-cola';
END
ELSE IF @pressedButton = 2
BEGIN
	PRINT 'Sprite';
END
ELSE IF @pressedButton = 3
BEGIN
	PRINT 'Fanta';
END
ELSE
BEGIN
	PRINT 'Undetected';
END

/*
	Cara diatas dapat dilakukan juga dengan alternative lain, misalnya dengan CASE.
	CASE digunakan untuk membuat suatu statement pada kemungkinan yang biasanya relative lebih dari satu.
*/
PRINT
CASE
	WHEN @pressedButton = 1 THEN 'Coca-cola'
	WHEN @pressedButton = 2 THEN 'Sprite'
	WHEN @pressedButton = 4 THEN 'Fanta'
	ELSE 'Undetected'
END;

/*
	Lebih dari pada IF dan ELSE, CASE bisa digunakan pada SELECT statement selayaknya column.
	Berikut ini adalah contoh penggunaan CASE pada query statement.
*/
SELECT prod.ProductName AS [Name],
CASE
	WHEN prod.UnitPrice < 10 THEN 'Cheap'
	WHEN prod.UnitPrice >= 10 AND prod.UnitPrice < 20 THEN 'Regular'
	WHEN prod.UnitPrice > 20 THEN 'Expensive'
	ELSE 'N/A'
END AS PriceLevel
FROM dbo.Products AS prod;

SELECT prod.ProductName AS [Name],
CASE
	WHEN prod.Discontinued = 1 THEN 'Discontinue'
	WHEN prod.Discontinued = 0 THEN 'Available'
	ELSE 'N/A'
END AS [Availability]
FROM dbo.Products AS prod;

USE Penerbangan;

/*
	IIF function adalah function if yang bisa bekerja di SELECT statement, tetapi hanya melihat dari hasil statement true atau false. True akan mendapatkan
	return value dari parameter ke 2, dan false akan mendapatkan return value dari parameter ketiga.

	IIF(Conditional, return_parameter if true, return_parameter if false);
*/
SELECT tic.TicketNumber, IIF(tic.Used = 1, 'Used', 'Not Used') AS [Availability]
FROM dbo.Ticket AS tic;
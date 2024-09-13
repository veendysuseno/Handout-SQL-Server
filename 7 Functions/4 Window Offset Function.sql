/*
	WINDOW OFFSET Function adalah window function yang mengembalikan value dari row yang bukan berasal dari yang ditunjuk saat ini.
*/
USE Northwind;

/*
	LAG adalah fungsi yang memiliki kemampuan untuk membaca row sebelumnya.
	Di sebut lag karena kesannya terlambat membaca rownya.
*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LAG(prod.UnitPrice) OVER (ORDER BY prod.UnitPrice) AS LowerPrice
FROM dbo.Products AS prod
ORDER BY prod.UnitPrice;

/*LAG dengan Partition akan mengakibatkan LAG-nya direset setiap satu partisi.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LAG(prod.UnitPrice) OVER (PARTITION BY prod.CategoryID ORDER BY prod.UnitPrice) AS LowerPrice
FROM dbo.Products AS prod
ORDER BY prod.CategoryID, prod.UnitPrice;

/*LEAD: adalah kebalikan dari LAG, apabila LAG terlambat satu row, LEAD membaca 1 row ke depan.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LEAD(prod.UnitPrice) OVER (ORDER BY prod.UnitPrice) AS HigherPrice
FROM dbo.Products AS prod
ORDER BY prod.UnitPrice;

/*LEAD dengan PARTITION sama seperti LAG dengan PARTITION, row akan susul menyusul sampai satu partisi, dan semuanya akan di-reset lagi.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LEAD(prod.UnitPrice) OVER (PARTITION BY prod.CategoryID ORDER BY prod.UnitPrice) AS HigherPrice
FROM dbo.Products AS prod
ORDER BY prod.CategoryID, prod.UnitPrice;

/*FIRST_VALUE: Mengambil value pada urutan pertama saja, lalu menduplikat-nya untuk setiap row.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
FIRST_VALUE(prod.UnitPrice) OVER (ORDER BY prod.UnitPrice) AS LowestPrice
FROM dbo.Products AS prod
ORDER BY prod.CategoryID, prod.UnitPrice;

/*FIRST_VALUE: Mengambil value pada urutan pertama untuk setiap potong partisi.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
FIRST_VALUE(prod.UnitPrice) OVER (PARTITION BY prod.CategoryID ORDER BY prod.UnitPrice) AS LowestPrice
FROM dbo.Products AS prod
ORDER BY prod.CategoryID, prod.UnitPrice;

/*
	LAST_VALUE: Sama seperti first value, hanya saja fungsi-nya mengambil nilai terakhir dari seluruh data.
		namun pemakaian LAST_VALUE tidak sesimple FIRST_VALUE, karena SQL tidak akan bisa mencari batas bawahnya tanpa 
		menggunakan BOUND.

	diperlukan:
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	untuk mendefine bahwa partition mulai dari awal row sampai akhir row.
*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LAST_VALUE(prod.UnitPrice) OVER 
	(ORDER BY prod.UnitPrice 
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS HighestPrice
FROM dbo.Products AS prod
ORDER BY prod.UnitPrice;

/*Yang di bawah ini contoh dengan menggunakan partition.*/
SELECT prod.ProductName, prod.CategoryID, prod.UnitPrice, 
LAST_VALUE(prod.UnitPrice) OVER 
	(PARTITION BY prod.CategoryID 
	ORDER BY prod.UnitPrice 
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS HighestPrice
FROM dbo.Products AS prod
ORDER BY prod.CategoryID, prod.UnitPrice;
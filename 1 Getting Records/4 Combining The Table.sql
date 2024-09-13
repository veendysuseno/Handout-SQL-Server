/*
	Handout dibawah ini menggunakan database GirlFlower dan NorthWind, silahkan restore GirlFlower.bak sebelum menggunakan script ini.

	Table Girl, menunjukan master data perempuan.
	Table Store, menunjukan master data toko bunga.
	Table Flower, menunjukan bunga, disertai dengan Toko yang menjualnya dan perempuan yang menyukai bunga ini.
*/

Use GirlFlower1

/*JOIN digunakan untuk menggabungkan 2 table atau lebih, atau men-denormalisasi table*/

/*JOIN atau bisa ditulis INNER JOIN adalah cara menggabungkan 2 table dengan konsep irisan.
  Bi dilihat hasil dari query ini, terlihat relasi antara flower dengan girl.
  Flower yang tidak memiliki relation dengan girl tidak akan keluar di hasil.*/

SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
JOIN dbo.Girl AS grl ON flo.GirlID = grl.ID;

/*LEFT JOIN atau LEFT OUTER JOIN adalah cara menggabungkan 2 table dengan konsep mengutamakan table yang di from pertama kali.
 Nama bunga akan keluar walaupun tidak ada girl yang menyukainya.*/
SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
LEFT JOIN dbo.Girl AS grl ON flo.GirlID = grl.ID;

/*RIGHT JOIN atau RIGHT OUTER JOIN adalah cara menggabungkan 2 table dengan konsep mengutamakan table secondarynya.
  Nama perempuan akan keluar walaupun dia tidak menyukai satu bunga pun.*/
SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
RIGHT JOIN dbo.Girl AS grl ON flo.GirlID = grl.ID;

/*FULL JOIN atau FULL OUTTER JOIN adalah cara menggabungkan 2 table dengan konsep full gabungan dari 2 table.
  Seluruh nama akan keluar walau tidak berkaitan satu sama lain.*/
SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
FULL JOIN dbo.Girl AS grl ON flo.GirlID = grl.ID;

/*SELF JOIN adalah trick menggabungkan table dengan table itu sendiri.
  Ini adalah contoh menampilkan nama bunga yang berasal dari toko yang sama.*/
SELECT floA.ID, floB.ID, floA.StoreID, floB.StoreID  --floA.[Name], floB.[Name]
FROM dbo.Flower AS floA, dbo.Flower AS floB
WHERE floA.ID <> floB.ID AND floA.StoreID = floB.StoreID;

/*CROSS JOIN tidak menghubungkan table dengan table lewat foreign key.
CROSS JOIN menghubungkan kedua table dengan setiap possible combination. (kombinasi mathematika)*/
SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
CROSS JOIN dbo.Girl AS grl;

/*
	APPLY digunakan untuk mengaplikasikan (menggabungkan) sebuah table dengan table lainnya dalam table value expression.
	APPLY akan mengaplikasikan row satu persatu dari expresi table yang diluar dan yang diaplikasikan di dalamnya.
*/
SELECT flo.[Name], tambahan.Test
FROM dbo.Flower AS flo
CROSS APPLY(
	SELECT 'Testing' AS Test
) AS tambahan;


SELECT flo.[Name], 'Testing' Test
FROM dbo.Flower AS flo


/*
	Dengan Filter, APPLY bisa digunakan persis dengan JOIN, bahkan sampai 

	APPLY terdiri dari 2 macam:

	1. CROSS APPLY: hanya mengembalikan informasi column dari left table row, apabila yang di dalam atau di kanan match dengan yang di kiri.
	(Note: persis dengan INNER JOIN)

	2. OUTER APPLY: terus mengembalikan informasi column dari left table row, walaupun tidak ada yang match pada table di kanan.
	(Note: persis dengan LEFT OUTER JOIN)
*/

SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
CROSS APPLY(
	SELECT *
	FROM dbo.Girl
	WHERE GirlID = flo.GirlID
) AS grl;

SELECT flo.[Name] AS flower, grl.[Name] AS girl
FROM dbo.Flower AS flo
OUTER APPLY(
	SELECT *
	FROM dbo.Girl
	WHERE GirlID = flo.GirlID
) AS grl;

USE Northwind

/*
	UNION (Gabungan): menggabungkan data column dari 2 atau lebih table, selama columnya memiliki tipe data yang sama.
	Note: Lebih masuk akal apabila columnnya memiliki informasi yang sama sifatnya juga.
	Contoh dibawah ini menggabungkan seluruh negara dari table customer dan supplier.
*/
SELECT cus.Country
FROM dbo.Customers AS cus
UNION
SELECT sup.Country
FROM dbo.Suppliers AS sup;

/*
	Menggabungkan lebih dari satu column, dalam hal ini kita mengeluarkan seluruh
	customer dan supplier beserta negaranya masing-masing.
*/
SELECT cus.ContactName, cus.Country
FROM dbo.Customers AS cus
UNION
SELECT sup.ContactName, sup.Country
FROM dbo.Suppliers AS sup;

/*
	Tentu saja kita bisa menggabungkan 2 column yang berbeda informasi tetapi masih satu macam tipe data, 
	tetapi ini tidak masuk akal.
*/
SELECT cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country
FROM dbo.Suppliers AS sup;

/*Menggabungkan 2 hal dengan tipe data yang berbeda akan menghasilkan error*/
/*
	SELECT cus.ContactName
	FROM dbo.Customers AS cus
	UNION
	SELECT ord.Freight
	FROM dbo.Orders AS ord;
*/

/*Menggabungkan 2 informasi dengan jumlah column yang berbeda juga menghasilkan error*/
/*
	SELECT cus.ContactName, cus.Country
	FROM dbo.Customers AS cus
	UNION
	SELECT sup.ContactName
	FROM dbo.Suppliers AS sup;
*/

/*
	UNION ALL: Mirip seperti UNION, hanya saja resultnya bisa duplikat, 
	bisa diibaratkan ini seperti union yang tidak memiliki sifat DISTINCT.

	Bisa dilihat di contoh, beberapa nama negara akan muncul lebih dari satu kali.
*/
SELECT cus.Country
FROM dbo.Customers AS cus
UNION ALL
SELECT sup.Country
FROM dbo.Suppliers AS sup;

/*Contoh di bawah ini, antara UNION dan UNION all tidak berbeda, karena setiap row nya sama-sama bersifat unik.*/
SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION ALL
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup;

SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup;

/*
	INTERSECT (Irisan), hanya akan menampilkan hasil, dimana record nya muncul di kedua hasil SELECT.
	Bisa dilihat, negara yang muncul hasil dari query di bawah ini adalah hanya negara yang ada di dalam kedua table customer dan supplier.
	Argentina tidak akan muncul karena negara tersebut hanya ada di table Customer, bukan di Suppliers.
*/
SELECT cus.Country
FROM dbo.Customers AS cus
INTERSECT
SELECT sup.Country
FROM dbo.Suppliers AS sup;

/*Contoh penggunaan INTERSECT lebih dari satu column. Hanya kombinasi yang sifatnya irisan yang akan muncul.*/
SELECT cus.Country, cus.City
FROM dbo.Customers AS cus
INTERSECT
SELECT sup.Country, sup.City
FROM dbo.Suppliers AS sup;

/*EXCEPT (+) adalah kebalikan dari INTERSECT, yaitu seluruh component dimana tidak muncul dikedua table.*/
SELECT cus.Country
FROM dbo.Customers AS cus
EXCEPT
SELECT sup.Country
FROM dbo.Suppliers AS sup;

/*EXCEPT menggunakan lebih dari satu column*/
SELECT cus.Country, cus.City
FROM dbo.Customers AS cus
EXCEPT
SELECT sup.Country, sup.City
FROM dbo.Suppliers AS sup;

/*
	Menggunakan ORDER BY, GROUP BY, HAVING, TOP, OFFSET, FETCh dan aggregate function pada hasil UNION bisa sedikit tricky.
	Di bawah ini adalah beberapa contoh yang bisa diberikan.
*/

--Menggunakan ORDER BY pada hasil UNION
(SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup)
ORDER BY ContactName;

SELECT *
FROM (SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup) AS reg
ORDER BY reg.ContactName;

--Penggunaannya dengan GROUP BY dan aggregate function
SELECT reg.Country, COUNT(*) AS [count]
FROM (SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup) AS reg
GROUP BY reg.Country
ORDER BY reg.Country;

--Pengunaannya dengan HAVING
SELECT reg.Country, COUNT(*) AS [count]
FROM (SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup) AS reg
GROUP BY reg.Country
HAVING COUNT(*) > 3
ORDER BY reg.Country;

--Penggunaannya dengan OFFSET dan FETCH
SELECT reg.Country, COUNT(*) AS [count]
FROM (SELECT cus.Country, cus.City, cus.ContactName
FROM dbo.Customers AS cus
UNION
SELECT sup.Country, sup.City, sup.ContactName
FROM dbo.Suppliers AS sup) AS reg
GROUP BY reg.Country
HAVING COUNT(*) > 3
ORDER BY reg.Country
OFFSET 3 ROWS
FETCH NEXT 5 ROWS ONLY;

--Memilih 1 teratas dulu, baru melakukan UNION.
SELECT * FROM
(SELECT TOP 1 cus.Country
FROM dbo.Customers AS cus
ORDER BY cus.Country DESC) AS cusCoun
UNION
SELECT * FROM
(SELECT TOP 1 sup.Country
FROM dbo.Suppliers AS sup
ORDER BY sup.Country DESC) AS supCoun;

(SELECT top 1 cus.Country
FROM dbo.Customers AS cus
ORDER BY cus.Country DESC
union
SELECT TOP 1 sup.Country
FROM dbo.Suppliers AS sup
ORDER BY sup.Country DESC
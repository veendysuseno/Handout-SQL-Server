USE Northwind;

/*
	Pivot table adalah 2 dimensional table, dimana tablenya memiliki 1 horizontal column, dan 1 vertical column.
	Pivoting adalah aktifitas merubah/ merotasi orientasi column, dimana yant tadinya value menjadi column.

	Pivoting dapat dilakukan dengan cara 3 langkah:
	1. Memilih semua column yang hanya ingin di orientasi, seluruhnya harus tidak bersifat unique atau distinct
	2. Menjabarkan seluruh distinct value yang akan dijadikan column, seluruhnya harus di declare.
	3. Harus menggunakan aggregate function untuk value yang akan dijabarkan, related dengan columnnya.
*/

/*
	1. Di sini kita melakukan langkah pertama, kita mendapatkan 3 column yang ingin kita rotasi, Supplier, Category dan Stock dari product.
	Supplier dan Category sifatnya duplikat, sedangkan stock sifatnya unik tergantung dari kombinasi dari supplier dan categorynya.

	Kita akan membuat supplier dan category menjadi menjadi columns.
	Supplier value akan menjadi vertical column (Y) dan
	Category value akan menjadi horizontal column (X)
*/

SELECT prod.SupplierID AS supplier, prod.CategoryID AS category, prod.UnitsInStock AS stock
FROM dbo.Products AS prod;

/*
	2. Siapkan seluruh categoryID pada SELECT statement, ini nantinya akan menjadi horizontal column.
	3. Gunakan aggregate function pada stock, pada contoh di bawah ini kita menggunakan SUM, jadi apabila ada stock yang berada di kombinasi dan supplier yang sama, mereka akan di jumlah.
*/
SELECT pvt.supplier, [1], [2], [3], [4], [5], [6], [7], [8]
FROM (
	SELECT prod.SupplierID AS supplier, prod.CategoryID AS category, prod.UnitsInStock AS stock
	FROM dbo.Products AS prod
)AS sumProd
PIVOT(SUM(sumProd.stock) FOR sumProd.category IN ([1], [2], [3], [4], [5], [6], [7], [8])) AS pvt
ORDER BY pvt.supplier;

/*Di sini saya menggunakan join agar supplier dan categorynya memiliki nama.*/
SELECT pvt.supplier, [Beverages], [Condiments], [Confections], [Dairy Products], [Grains/Cereals]
FROM (
	SELECT sup.SupplierID, sup.CompanyName AS supplier, cat.CategoryName AS category, prod.UnitsInStock AS stock
	FROM dbo.Products AS prod
	JOIN dbo.Suppliers AS sup ON prod.SupplierID = sup.SupplierID
	JOIN dbo.Categories As cat ON prod.CategoryID = cat.CategoryID
)AS sumProd
PIVOT(SUM(sumProd.stock) FOR sumProd.category IN ([Beverages], [Condiments], [Confections], [Dairy Products], [Grains/Cereals])) AS pvt
ORDER BY pvt.SupplierID;

/*Pada contoh kali ini, saya akan menggunakan database University*/
Use University;

/*
	UNPIVOT adalah kebalikan dari PIVOT, UNPIVOT adalah aktivitas merubah pivot table menjadi table biasa.
*/

/*
	Pada table ini kita lihat, bawah horizontal columnnya bisa dibuat menjadi value, dan itu merupakan nama-nama student.
*/
SELECT studMrk.SubjectName, studMrk.Adrian, studMrk.Marcus, studMrk.Felicia, studMrk.Cicilia
FROM dbo.StudentMark AS studMrk;

SELECT upvt.SubjectName, upvt.StudentName, upvt.Mark
FROM(
	SELECT studMrk.SubjectName, studMrk.Adrian, studMrk.Marcus, studMrk.Felicia, studMrk.Cicilia
	FROM dbo.StudentMark AS studMrk) as pvt
UNPIVOT
	(Mark FOR StudentName IN (Adrian, Marcus, Felicia, Cicilia)) AS upvt;
-- dengan UNPIVOT kita bisa membuat column baru dan memutuskan kalau seluruh horizontal column akan menjadi value.
USE Northwind;

/*
	Window Function adalah Function yang disediakan dari system Transact-SQL dimana function ini
	memiliki kemampuan untuk menganalisa dan menghitung sekelompok group row dan mengembalikannya lagi dalam beberapa row.

	Di sini kita akan melihat contoh-contoh Window Ranking Function.
	Window Ranking Function adalah window function yang tujuannya adalah menomorkan setiap row dalam urutan yang diinginkan.
*/

/*Row Number dan over digunakan untuk penomoran row berdasarkan OVER dengan specific ORDER BY*/
SELECT emp.EmployeeID, emp.FirstName, emp.LastName,
ROW_NUMBER() OVER (ORDER BY emp.FirstName) As RowNumber
FROM dbo.Employees emp
ORDER BY emp.EmployeeID;

SELECT emp.EmployeeID, emp.FirstName, emp.LastName,
ROW_NUMBER() OVER (ORDER BY emp.FirstName) As RowNumber
FROM dbo.Employees emp
ORDER BY RowNumber;

SELECT emp.EmployeeID, emp.FirstName, emp.LastName, emp.Country,
ROW_NUMBER() OVER (PARTITION BY emp.Country ORDER BY emp.FirstName) As RowNumber
FROM dbo.Employees emp
--ORDER BY RowNumber;

SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, ContactTitle,
ROW_NUMBER() OVER(ORDER BY cus.ContactTitle) AS RowNumber
FROM dbo.Customers AS cus;

/*
	RANK mengurutkan semua seperti ROW_NUMBER, bedanya Rank akan menduplicat rank number pada yang nilainya sama.
	Contohnya seperti di bawah ini, di ranking berdasarkan ContactTitle, untuk seluruh Accounting Manager akan mendapat rank 1,
	tetapi ketika adanya perubahan pada ContactTitle, akan terjadi nomor yang di-skip, misalnya setelah 10 Accounting Manager, next 
	Assistant Sales Agent, number akan langsung di update menjadi 11.
*/
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, ContactTitle,
RANK() OVER(ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus;

SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country,
RANK() OVER(ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus;

/*
	RANK dengan PARTITION: Rank utamanya tetap akan mengalami perubahan rank setiap ada perubahan di factor order by-nya,
	namun perubahan tersebut akan di reset, setiap kali adanya perubahan partisi.

	Contohnya saja seperti di bawah ini, dari kelompok negara Argentina dan Austria, terdapat 5 data
	begitu pindah ke Austria, RankNumber pasti akan kembali ke 1 lagi.

	Tapi di sini ada 3 Argentina dengan Contact Title yang berbeda-beda:
	Sales Agent, Argentina, 1
	Sales Agent, Argentina, 1 (skip number: 2)
	Sales Representative, Argentina, 3

	Numbernya akan di update apabila adanya perubahan Contact Title.
*/
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country,
RANK() OVER(PARTITION BY cus.Country ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus
ORDER BY cus.Country, cus.ContactTitle;

/*
	DENSE RANK hampir sama seperti rank, perbedaanya adalah DENSERANK tidak ada skip number.
*/
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country,
DENSE_RANK() OVER(ORDER BY cus.ContactTitle) AS DenseRank
FROM dbo.Customers AS cus;

/*
	DENSE RANK dengan partition sama persis seperti seperti RANK dengan partition.
	seperti contoh di atas, sehingga:
	Sales Agent, Argentina, 1
	Sales Agent, Argentina, 1
	Sales Representative, Argentina, 2	
*/
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country,
DENSE_RANK() OVER(PARTITION BY cus.Country ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus
ORDER BY cus.Country, cus.ContactTitle;

/*
	NTILE sifatnya seperti rank dense, hanya saja bisa dikelompokan setiap n variations. 
	Jadi update perubahan rank yangnya terjadi setelah 4 beda ContactTitle terjadi.
*/

SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle,
NTILE(4) OVER(ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus;

/*
	NTILE dengan partition sifatnya sama seperti rank dense dengan partition, hanya saja dengan n variations.
*/
SELECT cus.CustomerID, cus.CompanyName, cus.ContactName, cus.ContactTitle, cus.Country,
NTILE(100) OVER(PARTITION BY cus.Country ORDER BY cus.ContactTitle) AS RankNumber
FROM dbo.Customers AS cus
ORDER BY cus.ContactTitle;
/*
	Materi ini menggunakan contoh database Northwind.
	Tolong terlebih dulu me-restore database Northwind yang sudah diberikan.
*/
-- Comment satu baris pada sql juga bisa ditulis seperti ini

/*
Use Digunakan untuk menghubungkan connection satu query file dengan satu database.
*/
USE Northwind;

/*
	statement SELECT menunjukan informasi dari column yang akan di display,
	statement FROM menunjukan table data yang digunakan untuk query ini.

	Di contoh ini berarti, menampilkan 2 column FirstName dan LastName dari table Employee
*/
SELECT FirstName, LastName
FROM dbo.Employees;

/*Menampilkan seluruh column dari sebuah table*/
SELECT *
FROM dbo.Employees;

/*Menampilkan column dengan alias, atau mengganti column labelnya dengan menggunakan AS*/
SELECT Title AS jobtitle, FirstName AS [name]
FROM dbo.Employees;
--NOTE: suatu key word yang sudah terpakai seperti Name, bisa digantikan dengan  menggunakan square bracket [Name], begitu juga untuk penggunaan lebih dari satu kata dengan spasi.

/*Alias bisa ditulis tanpa menggunakan AS, yaitu dengan menggunakan spasi saja, tapi lebih baik dengan AS untuk menghilangkan ambigu*/
SELECT Title [Job Title], FirstName [Nama Pertama]
FROM dbo.Employees;
--NOTE: Square bracket dimanfaatkan untuk nama column yang lebih dari satu kata dan menggunakan spasi.

/*Bisa juga ditulis dengan menggunakan string quotation, tetapi ini berbeda dengan alias.*/
SELECT Title 'Job Title', FirstName 'Nama Pertama'
FROM dbo.Employees;

/*Menggabungkan lebih dari satu column ke dalam satu column dengan menggunakan CONCAT*/
SELECT CONCAT(TitleOFCourtesy, ' ', FirstName, ' ', LastName) AS [Complete Name], Title AS [Job Title]
FROM dbo.Employees;

/*Memilih dari lebih dari 1 table*/
SELECT FirstName, CompanyName
FROM dbo.Employees, dbo.Customers;

/*Menulis informasi nama table di depan setiap column untuk menghindari ambigu.*/
SELECT CONCAT(dbo.Employees.TitleOFCourtesy, ' ', dbo.Employees.FirstName, ' ', dbo.Employees.LastName) AS [Complete Name], dbo.Employees.Title AS [Job Title]
FROM dbo.Employees;

/*Contoh ambigu yang bisa terjadi, baik customers dan shippers memiliki CompanyName*/
SELECT dbo.Customers.CompanyName, dbo.Shippers.CompanyName
FROM dbo.Customers, dbo.Shippers;

/*Penulisan table di depan nama column bisa terlalu panjang, kita juga bisa membuat alias di depan nama table.*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp;
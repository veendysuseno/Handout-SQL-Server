USE Northwind;

/*
	Statement Where digunakan untuk filter data yang diambil sesuai dengan kondisi yang diinginkan
	Dalam hal ini keluarkan seluruh data employees, dimana ID nya adalah 2.
	= digunakan untuk untuk mencari kecocokan dimana valuenya sama dengan yang tertulis.
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID = 2;

/*
	Statement di bawah ini sebaliknya dengan statement di atas.
	Dalam hal ini query mengeluarkan seluruh record dimana Employee ID nya tidak sama dengan 2.	
	<> digunakan untuk mencari ketidak cocokan, atau mencari record dimana valuenya tidak sama dengan yang tertulis.
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID <> 2;

/*tanda != bisa digunakan sebagai alternative dari <>. Kebiasaan menulis dengan != */
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID != 3;

/*
	memilih record dimana employee ID lebih besar dari 3.
	>, < tanda ini bisa digunakan sebagai operator lebih besar dan lebih kecil.
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID > 3;

/*
	memilih record dimana employee ID adalah 3 dan lebih kecil dari 3.
	<=, >= tanda ini bisa digunakna sebagai operator lebih besar sama dengan dan lebih kecil sama dengan.
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID <= 3;

/*
	BETWEEN dapat digunakan untuk memfilter data dimana data dari satu point ke point lain.
	Dalam hal ini data difilter dimana record akan menunjukan hasil dimana employeenya memiliki id 3, 4, 5, 6
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID BETWEEN 3 AND 6;

/*
	NOT BETWEEN adalah operator yang sifatnya kebalikan dari BETWEEN.
	Dalam hal ini akan di cari record dimana employeenya memiliki id selain 3, 4, 5, 6
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID NOT BETWEEN 3 AND 6;

/*
	Operator AND / dan, adalah operator dimana mem-filter data berdasarkan Irisan di dalam scope.
	Seluruh data yang di-filter harus memenuhi 2 statement yang ditentukan.

	3, 4, 5, 6: Karena ke-empat angka ini lebih besar sama dengan tiga, tapi juga lebih besar sama dengan enam.
	1 dan 2 lebih kecil sama dengan enam, tetapi tidak lebih besar sama dengan 3.
*/
SELECT emp.EmployeeID, CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.EmployeeID >= 3 AND emp.EmployeeID <= 6;

/*
	Operator OR / atau, adalah operator dimana mem-filter data berdasarakan Gabungan di dalam scope.
	Seluruh data yang di-filter harus memenuhi salah satu statement yang ditentukan.
*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title], emp.City
FROM dbo.Employees AS emp
WHERE emp.City = 'Seattle' OR emp.City = 'London';

/*AND dan OR tidak tertutup pada satu column saja. Berikut ini adalah contoh penggunaan IN dan OR sekaligus pada column yang berbeda*/
SELECT *
FROM dbo.Employees AS emp
WHERE emp.EmployeeID >= 1 AND emp.EmployeeID <= 3 OR emp.City = 'London';

/*IN sama seperti multiple OR statement di dalamn satu column*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title], emp.City
FROM dbo.Employees AS emp
WHERE emp.City IN ('Seattle', 'Tacoma', 'Kirkland');

/*
	IN pada statement dibawah ini mendapat input dari select statement lainnya.
	IN pada statement ini mendapatkan list nama-nama negara dari employee, lalu digunakan untuk mencari pada table supplier.

	Bisa dikatakan statement di bawah ini: Mencari seluruh supplier dimana negaranya exist di dalam table employee.
*/
SELECT sup.CompanyName, sup.Country
FROM dbo.Suppliers as sup
WHERE sup.Country IN (SELECT emp.Country FROM dbo.Employees AS emp);

/*
	LIKE melihat string pattern untuk menyamakan, ini berarti kita mencari seluruh data yang job titlenya mengandung Representative.
	LIKE menggunakan WILDCARD untuk mencari sesuatu yang mirip.
*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.Title LIKE '%Representative%';

/*
	WILDCARD menggantikan character

	% : digantikan dengan 0 atau lebih character. contoh: bl% finds bl, black, blue, and blob
	_ : digantikan dengan 1 character. contoh: h_t finds hot, hat, and hit
	[] : digantikan dengan character apa saja di dalam bracket. contoh: h[oa]t finds hot and hat, but not hit
	^  : menggantikan character yang tidak ada di dalam bracket. contoh: h[^oa]t finds hit, but not hot and hat
	- : mendeskripsikan cakupan character. contoh: c[a-b]t finds cat and cbt
*/

/*Di luar employee yang punya job title mengandung Representative.*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Title AS [Job Title]
FROM dbo.Employees AS emp
WHERE emp.Title NOT LIKE '%Representative%';

/*NULL syntax: Null adalah dimana table cell tidak memiliki data sama sekali pada nullable column.
  NUll tidak bisa di check dengan operator seperti =, <, <>, atau !=*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Region as Region
FROM dbo.Employees AS emp
WHERE emp.Region IS NOT NULL;

SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.Region as Region
FROM dbo.Employees AS emp
WHERE emp.Region IS NULL;

/*Untuk membandingkan date bisa menggunakan string format seperti di bawah ini.*/
SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.HireDate = '19931017';

SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.HireDate = '1993-10-17';

SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.HireDate = '10-17-1993';

SELECT CONCAT(emp.TitleOFCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS [Complete Name], emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.HireDate > '10-17-1993';
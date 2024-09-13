USE Northwind;

/*
	Derived Table adalah table expression yang muncul di dalam FROM clause di query. 
	Derived table digunakan saat penggunaan alias tidak mungkin karena suatu proses di dalam sql sudah digunakan sebelum aliasnya diketahui.
*/

/*Ini akan menghasilkan error dikarenakan baik hasil COUNT maupun MONTH belum selesai diproses.*/
/*
	SELECT emp.Country, COUNT(*) AS Jumlah
	FROM dbo.Employees AS emp
	GROUP BY emp.Country
	ORDER BY cou_ct.Country;

	SELECT MONTH(emp.HireDate) AS Bulan
	FROM dbo.Employees AS emp
	GROUP BY Bulan;
*/

--Gunakan derived table untuk solve masalah ini
SELECT * 
FROM (
	SELECT emp.Country, COUNT(*) AS Jumlah
	FROM dbo.Employees AS emp
	GROUP BY emp.Country
) AS cou_ct
ORDER BY cou_ct.Country;

SELECT mg.Bulan
FROM (
	SELECT MONTH(emp.HireDate) AS Bulan
	FROM dbo.Employees AS emp
) AS mg
GROUP BY mg.Bulan;

/*
	Derived Table harus punya:
	1. Alias untuk hasilnya
	2. Nama untuk semua columnya
	3. Tidak menggunakan ORDER BY tanpa TOP/ OFFSET/ FETCH
*/

--Ini akan menghasilkan error karena ORDER BY invalid di dalam derived table
/*
	SELECT * 
	FROM (
		SELECT emp.Country, COUNT(*) AS Jumlah`
		FROM dbo.Employees AS emp
		GROUP BY emp.Country
		ORDER BY emp.Country ASC
	) AS cou_ct
	ORDER BY cou_ct.Country;
*/

--Dengan adanya OFFSET, derived table bisa menggunakan ORDER BY
SELECT *
FROM(
	SELECT cus.Country, COUNT(*) AS Total
	FROM dbo.Customers AS cus
	GROUP BY cus.Country
	ORDER BY cus.Country
	OFFSET 3 ROWS
) AS cus_cou
ORDER BY cus_cou.Country;

--Menggunakan TOP juga bisa membuat derived table bisa menggunakan ORDER BY
SELECT *
FROM(
	SELECT TOP 10 cus.Country, COUNT(*) AS Total
	FROM dbo.Customers AS cus
	GROUP BY cus.Country
	ORDER BY cus.Country
) AS cus_cou
ORDER BY cus_cou.Country;

/*Persistent and Derived Table*/
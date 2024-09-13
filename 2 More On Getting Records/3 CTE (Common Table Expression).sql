--Contoh di script ini menggunakan Database query
USE Company;

/*
	CTE (Common Table Expression) adalah sebuah table yang dihasilkan oleh simple query, diberi nama dan di simpan secara sementara.	
	CTE digunakan sebagai alat bantu yang pembuatan JOIN dan sub-query yang complex.

	CTE diawali dengan keyword WITH
*/

--EmployeeCountPerDepartment digunakan sebagai temporary table 
WITH EmployeeCountPerDepartment(DepartmentID, TotalEmployees) AS
(
	SELECT emp.DepartmentID, COUNT(*) AS TotalEmployees
	FROM dbo.Employee AS emp
	GROUP BY emp.DepartmentID
)
SELECT dep.[Name], ec.TotalEmployees
FROM dbo.Department AS dep
JOIN EmployeeCountPerDepartment AS ec ON dep.ID = ec.DepartmentID
ORDER BY ec.TotalEmployees;

/*
	Column disebelah nama CTE adalah nama dari column CTE itu sendiri, apabila tidak diberikan akan sama dengan nama column SELECT di dalamnya.
*/

--Contoh pemakaian lebih dari 1 CTE
WITH PayrollAndITCount(DepartmentName, Total) AS
(
	SELECT dep.[Name], COUNT(emp.ID) AS TotalEmployees
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID
	WHERE dep.[Name] IN ('Payroll', 'IT')
	GROUP BY dep.[Name]
),
HRAndAdminCount(DepartmentName, Total) AS
(
	SELECT dep.[Name], COUNT(emp.ID) AS TotalEmployees
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID
	WHERE dep.[Name] IN ('HR', 'Admin')
	GROUP BY dep.[Name]
)
SELECT * FROM PayrollAndITCount
UNION
SELECT * FROM HRAndAdminCount;

--SELECT statementnya sudah tidak bisa menggunakan CTE yang ada. CTE hanya bisa digunakan untuk satu block statement berikutnya.
--SELECT * FROM PayrollAndITCount;

/*
	Recursive CTE: adalah Common Table Expression yang menggunakan CTE itu sendiri di dalam CTEnya.
	CTE memiliki kemampuan untuk melakukan ini, bisa dilihat contohnya seperti di bawah ini.
*/

WITH EmployeeHierarchy AS(
	SELECT emp.ID, emp.[Name], emp.Gender, emp.DepartmentID, emp.SupervisorID
	FROM dbo.Employee AS emp
	WHERE emp.SupervisorID IS NULL
	UNION ALL
	SELECT emp.ID, emp.[Name], emp.Gender, emp.DepartmentID, emp.SupervisorID
	FROM dbo.Employee AS emp
	JOIN EmployeeHierarchy AS eh ON emp.SupervisorID = eh.ID	
)
SELECT *
FROM EmployeeHierarchy;

/*
	Keuntungan-keuntungan dalam penggunaan CTE:
	- Lebih mudah dibaca
	- Pengganti dari View (View akan dijelaskan di topic berikutnya)
	- Bisa menggunakan Recursion (Recursive CTE)
*/


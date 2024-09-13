USE Company;

/*
	User-defined table type adalah table yang dibuat, gunakanya sebagai tipe data dalam specific table, dimana user-defined table bisa digunakan
	sebagai variable atau temporary storage, yang nantinya bisa kita passing ke dalam parameter.

	Karena adanya user-defined table type, sebuah table jadi memungkin-kan untuk dijadikan argument atau dipassing ke dalam function.
	Parameter yang bisa menerima sebuah user-defined table sebagai argumentnya, disebut juga Table-Valued Parameter.

	Keuntungan dari Table-Valued Parameters dan User-Defined Table type adalah memberikan performance yang lebih baik dari Temporary Table,
	dan menyederhanakan alur pemrograman T-SQL
*/

CREATE TYPE dbo.JobInDepartment AS TABLE
(
	ID INT NOT NULL PRIMARY KEY,
	JobTitle VARCHAR(50) NOT NULL,
	Department VARCHAR(20) NOT NULL
);

GO

/*
	Pemakaiannya persis seperti variable biasa, tapi variable ini sebenarnya adalah sebuah table
	dengan tipe data yang sudah di buat sebelumnya.

	Untuk melihat user-defined table type yang dibuat, check di dalam DB.
	Company/ Programmability/ Types/ User-Defined Table Types
*/
DECLARE @new_table AS dbo.JobInDepartment;

INSERT INTO @new_table(ID, JobTitle, Department)
SELECT job.ID, job.[Name], dep.[Name]
FROM dbo.JobTitle AS job
JOIN dbo.Department AS dep ON job.DepartmentID = dep.ID;
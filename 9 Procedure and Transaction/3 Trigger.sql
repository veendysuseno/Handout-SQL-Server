/*
	Pada chapter ini akan ditunjukan cara-cara melakukan eksekusi sebuah SP tetapi tidak direct execution atau 
	eksekusinya berjalan otomatis di satu waktu tertentu.
	Note: Kalau di bahasa pemrograman sifatnya seperti event-handler atau event-listener.
*/
/*
	TRIGGER adalah Store Procedure yang tereksekusi secara otomatis saat ada event-event tertentu, tanpa harus secara manual di EXECUTE.
	event-event yang memicu TRIGGER adalah event-event DML seperti INSERT, UPDATE, dan DELETE.

	Cara membuat trigger adalah dengan menggunakan CREATE TRIGGER.
	Penulisannya sama seperti SP, hanya saja Trigger tidak memiliki parameter dan diberi trigger conditionnya.
*/
USE CompanyDemo;

/*
	Trigger di bawah ini akan bekerja apabila table employee di insert.
	Lalu akan langsung menunjukan seluruh hasilnya.
*/
CREATE TRIGGER dbo.ShowAfterInsertEmployee
ON dbo.Employee
AFTER INSERT
AS
BEGIN
	SELECT emp.[Name], emp.Gender, dep.[Name]
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID;
END;

/*Trigger yang aktif setelah ada peristiwa delete di table employee*/
CREATE TRIGGER dbo.ShowAfterDeleteEmployee
ON dbo.Employee
AFTER DELETE
AS
BEGIN
	SELECT emp.[Name], emp.Gender
	FROM dbo.Employee AS emp
END;

/*Kita bisa menggunakan feature output untuk mengupdate log dengan trigger.*/
CREATE TRIGGER dbo.UpdatingDeptLog
ON dbo.Department
AFTER UPDATE
AS
BEGIN
	INSERT INTO dbo.UpdateDepartmentLog([Date], UpdatedID)
	VALUES
	(GETDATE(), (SELECT TOP 1 INSERTED.ID FROM INSERTED));
END;

INSERT INTO dbo.Employee(ID, [Name], Gender, DepartmentID)
VALUES
(7, 'Sunny', 'Female', 1);

DELETE dbo.Employee
	WHERE ID = 7;

UPDATE dbo.Department
	SET [Name] = 'Product'
	WHERE ID = 1;

/*Selain menggunakan AFTER kita bisa menggunakan INSTEAD yang artinya trigger akan mencegah DML yang dieksekusi dan
	Mendelegasinya ke dalam proses baru di dalam trigger.*/
CREATE TRIGGER dbo.PreventInsertDepartment
ON dbo.Department
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO dbo.TemporalDepartment(ID, [Name], [Date])
	VALUES
	((SELECT TOP 1 INSERTED.ID FROM INSERTED),(SELECT TOP 1 INSERTED.[Name] FROM INSERTED), GETDATE())
END;

INSERT INTO dbo.Department(ID, [Name])
VALUES (6, 'Design');

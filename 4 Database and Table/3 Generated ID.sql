/*
	ROWVERSION dan TIMESTAMP bersifat synonym, keduanya adalah tipe data yang merepresentasikan 
	binary number yang di generate secara otomatis dan sifatnya unik 
	di database.

	Tapi pada pelajaran ini kita akan membahas ROWVERSION lebih banyak, karena timestamp sudah mulai deprecated.
*/
/*
	Pada SQL server nama timestamp sedikit missleading, walaupun dibilang timestamp, value dari timestamp tidak menyimpan informasi waktu sama sekali.
	Lain dengan timestamp ada Oracle DBMS.
*/

USE Kampus;
select * from ClassRoom
select *  from PresentationRoom
select * from TutorialRoom

/*Buatlah 3 buah table, dimana table ini menggunakan ROWVERSION dan TIMESTAMP*/
CREATE TABLE dbo.ClassRoom(
	ID INT NOT NULL IDENTITY(1,1),
	RoomNumber INT NOT NULL,
	[Subject] VARCHAR(50) NOT NULL,
	BeginTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	RowNumber ROWVERSION NOT NULL,
	CONSTRAINT PK_ClassRoom_ID PRIMARY KEY (ID)
);
CREATE TABLE dbo.PresentationRoom(
	ID INT NOT NULL IDENTITY(1,1),
	RoomNumber INT NOT NULL,
	[Subject] VARCHAR(50) NOT NULL,
	BeginTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	RowNumber ROWVERSION NOT NULL,
	CONSTRAINT PK_PresentationRoom_ID PRIMARY KEY (ID)
);
CREATE TABLE dbo.TutorialRoom(
	ID INT NOT NULL IDENTITY(1,1),
	RoomNumber INT NOT NULL,
	[Subject] VARCHAR(50) NOT NULL,
	BeginTime TIME NOT NULL,
	EndTime TIME NOT NULL,
	TIMESTAMP,
	CONSTRAINT PK_TutorialRoom_ID PRIMARY KEY (ID)
);
/*Pemakaian terhadap ROWVERSION seperti Data Type pada umumnya, tetapi penggunaan TIMESTAMP, kita bisa menulisnya tanpa nama variable (akan default not null.*/

INSERT INTO dbo.ClassRoom(RoomNumber, [Subject], BeginTime, EndTime)
VALUES
(1, 'Java Fundamental', '09:30', '11:30'),
(2, 'C# Fundamental', '08:00', '10:00');

INSERT INTO dbo.PresentationRoom(RoomNumber, [Subject], BeginTime, EndTime)
VALUES
(3, 'Human Computer Interaction', '11:30', '13:30'),
(4, 'Database Fundamental', '10:00', '12:00');

/*
	Setelah menginput beberapa data di atas, check RowVersion dari masing-masing table.
	System akan menginputnya secara otomatis, ditambahkan satu persatu dari setiap input.

	Perhatikan bahwa Row version dari kedua table terus lanjut untuk satu database, tidak di reset sama sekali seperti IDENTITY.
*/
SELECT * FROM dbo.ClassRoom;
SELECT * FROM dbo.PresentationRoom;

/*@@DBTS atau (Data Base Time Stamp) adalah perintah yang digunakan untuk mendapatkan nomor row version atau timestamp terakhir.*/
SELECT @@DBTS;

/*Bahkan melakukan update akan memperbaru row versionnya dari yang terakhir kali.*/
UPDATE dbo.PresentationRoom
 SET [Subject] = 'HTML & CSS'
 WHERE RoomNumber = 3;

/*Karena TIMESTAMP dan ROWVERSION bersifat synonym, value baru yang diciptakan TIMESTAMP akan lanjut dari ROWVERSION*/
INSERT INTO dbo.TutorialRoom(RoomNumber, [Subject], BeginTime, EndTime)
VALUES
(5, 'Data Structure', '11:30', '13:30'),
(6, 'Networking Infrastructure', '10:00', '12:00');

SELECT * FROM dbo.ClassRoom;
SELECT * FROM dbo.PresentationRoom;
SELECT * FROM dbo.TutorialRoom;

INSERT INTO dbo.PresentationRoom(RoomNumber, [Subject], BeginTime, EndTime)
VALUES
(3, 'Test', '11:30', '13:30'),
(4, 'Test2', '10:00', '12:00');


truncate table ClassRoom

/*Kalau mencoba meng-convert timestamp ke dalam integer, hasilnya akan seperti di bawah ini.*/
DECLARE @final_row_number AS ROWVERSION = @@DBTS;
SELECT CONVERT (INT, @final_row_number);

/*
	Kita bisa me-utilisasi row versioning untuk kebutuhan audit, misalnya dengan 3 table seperti di atas,
	Saya bisa mencari tahu row mana yang terakhir kali di update dan urutan update nya di database.
*/
WITH AuditTrail(RowNumber, RoomNumber) AS (
	SELECT  cl.RowNumber, cl.RoomNumber
	FROM dbo.ClassRoom AS cl
	UNION
	SELECT pr.RowNumber, pr.RoomNumber
	FROM dbo.PresentationRoom AS pr
	UNION
	SELECT tut.[TIMESTAMP] AS RowNumber, tut.RoomNumber
	FROM dbo.TutorialRoom AS tut
)
SELECT aud.RoomNumber
FROM AuditTrail AS aud
WHERE aud.RowNumber  = @@DBTS;

/*
	UNIQUEIDENTIFIER atau sering disebut juga dengan GUID (Global Unique Identifier) adalah system mengenerate nomor unik dari sebuah function.
	UNIQUEIDENTIFIER menggunakan 16 byte memory dan selalu men-generate kombinasi unik, bahkan antar database.

	UNIQUEIDENTIFIER biasa digunakan sebagai ID dan PK untuk sebuah table.
*/

DECLARE @unik AS UNIQUEIDENTIFIER
SET @unik = NEWID();
SELECT @unik AS [kode unik];
--GUID bisa digenerate dari function NEWID()

/*Buatlah sebuah table dengan UNIQUEIDENTIFIER sebatai PK nya.*/
CREATE TABLE dbo.Tutor(
	ID UNIQUEIDENTIFIER NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	BirthPlace VARCHAR(50) NOT NULL,
	EmployeeStatus VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Tutor_ID PRIMARY KEY (ID)
);

/*INSERT VALUE nya dengan menggunakan NEWID()*/
INSERT INTO dbo.Tutor(ID, [Name], BirthDate, BirthPlace, EmployeeStatus)
VALUES
(NEWID(), 'Andreas', '1988/11/27', 'Jakarta', 'Permanent'),
(NEWID(), 'Felicia', '1989/05/04', 'Bandung', 'Kontrak');

select * from Tutor

/*Lalu buat juga table ke dua dengan menggunakan GUID, saya akan menunjukan kelebihan GUID dibanding menggunakan IDENTITY*/
CREATE TABLE dbo.Lecturer(
	ID UNIQUEIDENTIFIER NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	BirthPlace VARCHAR(50) NOT NULL,
	EmployeeStatus VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Lecturer_ID PRIMARY KEY (ID)
);
INSERT INTO dbo.Lecturer(ID, [Name], BirthDate, BirthPlace, EmployeeStatus)
VALUES
(NEWID(), 'Agus', '1988/08/27', 'Jakarta', 'Permanent'),
(NEWID(), 'Lex', '1989/05/08', 'Bandung', 'Kontrak');

/*Buat table baru di dalam database baru, yang menggunakan GUID juga.*/
CREATE DATABASE School;
GO
USE School;

/*Strategy yang lebih praktis adalah menggunakan NEWID() di DEFAULT CONSTRAINT, agar function tidak perlu di invoke setiap kali inserting value.*/
CREATE TABLE dbo.Teacher(
	ID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[Name] VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	BirthPlace VARCHAR(50) NOT NULL,
	EmployeeStatus VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Teacher_ID PRIMARY KEY (ID)
);

INSERT INTO dbo.Teacher([Name], BirthDate, BirthPlace, EmployeeStatus)
VALUES
('Marcus', '1990/11/11', 'Jakarta', 'Permanent'),
('Harris', '1989/05/04', 'Bandung', 'Kontrak'),
('Calvin', '1977/08/27', 'Jakarta', 'Permanent');

/*
	Kembali lah ke database College dan buat sebuah table yang mirip dengan table Tutor, Lecturer dan Teacher.
	Kita beri nama GlobalTrainer karena nantinya seluruh informasi dari ketiga table akan saya gabgun dan insert ke dalam sini.
*/
USE College;

CREATE TABLE dbo.GlobalTrainer(
	ID UNIQUEIDENTIFIER NOT NULL,
	[Name] VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	BirthPlace VARCHAR(50) NOT NULL,
	EmployeeStatus VARCHAR(50) NOT NULL,
	CONSTRAINT PK_GlobalTrainer_ID PRIMARY KEY (ID)
);

/*
	Dari hasil query ini, apakah kalian sadar salah satu keunggulan menggunakan GUID?
	Ya, kalau ID dari Tutor, Lecturer dan Teacher menggunakan IDENTITY, query statement ini akan error,
	karena PK dari ketiga table ini pasti akan ada yang duplikat.
*/
INSERT INTO dbo.GlobalTrainer(ID, [Name], BirthDate, BirthPlace, EmployeeStatus)
SELECT tut.ID, tut.[Name], tut.BirthDate, tut.BirthPlace, tut.EmployeeStatus
FROM dbo.Tutor AS tut
UNION
SELECT lec.ID, lec.[Name], lec.BirthDate, lec.BirthPlace, lec.EmployeeStatus
FROM dbo.Lecturer AS lec
UNION
SELECT tea.ID, tea.[Name], tea.BirthDate, tea.BirthPlace, tea.EmployeeStatus
FROM School.dbo.Teacher AS tea


/*
Untuk SQL 2017 ONLY:
Terkadang di SQL 2017, terjadi keanehan seperti di IDENTITY yang seharusnya rolling numbernya
bertambah 1 setiap updatenya. Tapi terkadang identitynya bisa bertambah 1000 ke depan.
Itu dikarenakan adanya Feature Identity Cache di dalam SQL 2017.

Gunakan:
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = OFF
GO
Untuk mematikan identity yang akan lompat jauh 1000 ke depan
*/

USE Company;

CREATE TABLE dbo.JobTitle(
	ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	DepartmentID INT NOT NULL FOREIGN KEY REFERENCES dbo.Department(ID),
	[Description] VARCHAR(500) NOT NULL
);

/*
	SET IDENTITY_INSERT adalah operation yang digunakan untuk mematikan dan menyalakan fungsi auto increment 
	pada IDENTITY,
	dan apakah bisa di insert manual atau tidak.

	pada saat IDENTITY INSERT ON, berarti fungsi manualnya ON dan automaticnya OFF.
*/
SET IDENTITY_INSERT dbo.JobTitle OFF;

INSERT INTO dbo.JobTitle([Name], DepartmentID, [Description])
VALUES
('Project Manager', 1, 'Lead developer team and manage project.'),
('Analyst', 1, 'Menganalisa requirement');

/*
	Ada beberapa cara untuk mendapatkan Identity Number yang di tambahkan secara otomatis oleh IDENTITY:

	1. SCOPE_IDENTITY(): mendapatkan identity terakhir yang diciptakan table, selama prosesnya masih berasal dari dalam batch.
	2. IDENT_CURRENT(): mendapatkan identity terakhir yang diciptakan table dari scope manapun atau pun user mana pun.
	3. @@IDENTITY: mendapatkan identity terakhir yang digenerate selama masih di dalam current connection, tidak perduli berbedaan scope/batch.
*/

SELECT SCOPE_IDENTITY() AS [scope identity];
SELECT IDENT_CURRENT('dbo.JobTitle') AS [ident current];
SELECT @@IDENTITY AS [global identity];

SET IDENTITY_INSERT dbo.JobTitle ON;

INSERT INTO dbo.JobTitle(ID, [Name], DepartmentID, [Description])
VALUES
(100, 'Senior Web Developer', 1, 'Mendevelop web aplikasi'),
(101, 'IT Infrastructure', 1, 'Merancang network');

/*DBCC CHECKIDENT di bawah ini digunakan untuk melakuka reset terhadap auto icrement kembali ke 0*/
DBCC CHECKIDENT ('dbo.JobTitle', RESEED, 0);

/*
	SEQUENCE: Sequence digunakan untuk membuat auto increment number dan merupakan alternative dari IDENTITY,
	tetapi dengan beberapa perbedaan yang mencolok.

	Sebelum membahas perbedaannya lebih jauh, buatlah database dan table seperti di bawah ini.
*/

CREATE DATABASE Counting;
GO
USE Counting;

CREATE TABLE dbo.Candidate(
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Name] VARCHAR(100) NOT NULL
);
CREATE TABLE dbo.Student(
	ID INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL
);
CREATE TABLE dbo.Staff(
	ID INT NOT NULL,
	[Name] VARCHAR(100) NOT NULL
);
CREATE TABLE dbo.Item(
	[Name] VARCHAR(100) NOT NULL PRIMARY KEY,
	BayNumber INT NOT NULL
);
CREATE TABLE dbo.Stock(
	[Name] VARCHAR(100) NOT NULL PRIMARY KEY,
	BayNumber INT NOT NULL
);

/*
	IDENTITY langsung di tulis di dalam column table yang hendak kita buatkan,
	sequence harus dibuat terpisah dengan menggunakan CREATE SEQUENCE statement.

	Sequence bisa dilihat di ssms pada Programmability/Sequences
*/
CREATE SEQUENCE dbo.SequenceCounter AS INT
START WITH 1
INCREMENT BY 1;

/*
	IDENTITY terikat dan khusus melakukan increment pada satu table.
	SEQUENCE bisa di share dan bersifat global terhadap seluruh table di dalam database.
*/
INSERT INTO dbo.Candidate([Name])
VALUES ('Ben'), ('Cindy'), ('Harry'), ('Sherry');

SELECT NEXT VALUE FOR dbo.SequenceCounter;

INSERT INTO dbo.Student(ID, [Name])
VALUES 
(NEXT VALUE FOR dbo.SequenceCounter, 'Michael'),
(NEXT VALUE FOR dbo.SequenceCounter, 'Maria'),
(NEXT VALUE FOR dbo.SequenceCounter, 'Nelson');

select * from Candidate
select * from Student
select * from Staff

INSERT INTO dbo.Staff(ID, [Name])
VALUES
(NEXT VALUE FOR dbo.SequenceCounter, 'Handi'),
(NEXT VALUE FOR dbo.SequenceCounter, 'Budi');


/*
	Sequence juga memiliki kemampuan bisa menggunakan MINVALUE dan MAXVALUE
	untuk membatasi jumlah minimum dan maximum sequence.
*/
CREATE SEQUENCE dbo.MaxSequenceCounter
AS INT
START WITH 2
INCREMENT BY 1
MINVALUE 1
MAXVALUE 5;

/*Sebagai contoh, perintah INSERT INTO dibawah ini tidak bisa dilakukan karena MAX VALUE nya hanya sampai 5.*/
INSERT INTO dbo.Item([Name], BayNumber)
VALUES
('Buku Tulis', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Tinta Printer', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Koran', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Pensil', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Pen', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Spidol', NEXT VALUE FOR dbo.MaxSequenceCounter);

/*DROP SEQUENCE digunakan untuk menghapus SEQUENCE.*/
DROP SEQUENCE dbo.MaxSequenceCounter;

/*CYCLE digunakan untuk melakukan rotasi perhitungan.*/
CREATE SEQUENCE dbo.MaxSequenceCounter
AS INT
START WITH 2
INCREMENT BY 1
MINVALUE 1
MAXVALUE 5
CYCLE;

INSERT INTO dbo.Stock([Name], BayNumber)
VALUES
('Buku Tulis', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Tinta Printer', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Koran', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Pensil', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Pen', NEXT VALUE FOR dbo.MaxSequenceCounter),
('Spidol', NEXT VALUE FOR dbo.MaxSequenceCounter);
USE master;

/*
	Pada pelajaran chapter ini kita akan memulai dengan mengenal simple DML.
	DDL (Data Definition Language) adalah perintah-perintah pada SQL yang 
	digunakan untuk membuat atau merubah struktur dari database dan table.
*/

/*CREATE DATABASE: adalah function yang digunakan untuk menciptakan 
database yang baru.*/
CREATE DATABASE [Nama Database];
CREATE DATABASE College;

/*
	Command GO digunakan untuk memberi signal akhir dari batch SQL statement.
	Batch adalah satu group process pada SQL yang dieksekusi secara bersamaan.

	GO di bawah ini menandakan, CREATE DATABASE College harus selesai di eksekusi terlebih dahulu, dan table sudah dibuat terlebih dahulu
	baru bisa diisi dan dimanipulasi.

	GO bukan lah T-SQL syntax, dia adalah statement yang bisa di atur di SSMS pada:
	Options -> Query Executions
*/
GO

/*Perhatikan contoh pembuatan variable di bawah ini, dimana ada GO di tengahnya.*/
DECLARE @global AS VARCHAR(50) = 'Global';
--DECLARE @global AS VARCHAR(50) = 'Global 2';
PRINT @global;
BEGIN
	DECLARE @name AS VARCHAR(50) = 'Berita';
	DECLARE @local AS VARCHAR(50) = 'Local 1';
	PRINT @global;
END

GO

BEGIN
	DECLARE @name AS VARCHAR(50) = 'Sandy'; --variable @name bisa dipakai lagi karena setelah GO statement.
	--Local dan global sudah hilang dari temporary memory, sehingga variablenya sudah tidak diketahui.
	--PRINT @local;
	--PRINT @global;
END
PRINT @Name;


--USE College;

/*ALTER DATABASE digunakan untuk merubah database, dan MODIFY NAME digunakan untuk merubah nama database.*/
ALTER DATABASE College
	MODIFY NAME = Kampus;

/*
	CREATE TABLE adalah perintah sql yang digunakan untuk membuat dan merancang table baru.
	di dalamnya buatlah column-column yang ingin dibuat, dilengkapi tipe data dan nullable fieldnya.

	Nullable fieldnya bisa diatur sebagai NULL atau NOT NULL.
	NULL artinya data pada column tersebut bisa dikosongkan, NOT NULL artinya data pada row di column itu tidak boleh kosong sama sekali.
*/
CREATE TABLE dbo.Student(
	StudentNumber varchar(20),
	FirstName varchar(50),
	MiddleName varchar(50),
	LastName varchar(50),
	Gender char(1),
	BirthDate datetime,
	PhoneNumber varchar(50),
	Email varchar(100),
	[Address] varchar(500),
	RegisterDate datetime
);

/*ALTER TABLE digunakan untuk merubah rancangan table.*/
ALTER TABLE dbo.Student
	ADD Major varchar(100) NOT NULL;

/*Alter existing column*/
ALTER TABLE dbo.Student
	ALTER COLUMN PhoneNumber varchar(20) NULL;



ALTER TABLE dbo.Student
	DROP COLUMN Email;

/*DROP TABLE adalah perintah yang digunakan untuk menghapus table beserta seluruh isinya.*/
DROP TABLE dbo.Student;

/*DROP DATABASE digunakan untuk menghapus Database yang ada*/
/*
	USE master;
	DROP DATABASE University;
*/

/*
	Constraints adalah hal yang digunakan untuk memberi batasan-batasan dan kemampuan setiap column di dalam table. 

	NULL/NOT NULL: Menentukan apakah kolom pada row boleh kosong atau tidak. NULL adalah table cell kosong, 
		yang benar-benar tidak memiliki data apa pun.

	UNIQUE adalah sebuah constraint atau batasan yang membuat kolom tersebut harus berbeda di setiap rownya.

	PRIMARY KEY (PK) adalah identitas unik yang wajib dimiliki setiap row di setiap table, jadi selalu ada cara untuk menemukan
		row data yang hanya ada satu-satunya di dalam table tersebut. Setiap table hanya bisa memiliki satu Primary KEY,
		tetapi primary key bisa berasal dari satu column atau kombinasi lebih dari satu column.
		Primary key sudah pasti UNIQUE dan NOT NULL.

	FOREIGN KEY (FK) adalah column pada table yang digunakan untuk menghubungkan satu table dengan table lainnya,
		dengan cara mereferensikan isi dari foreign key ke primary key miliki table lain.
		Oleh karena itu data type foreign key pada table ke primary key table lain harus sama.

	CHECK adalah constraint yang digunakan untuk membatasi input, agar hanya value di range tertentu yang 
		bisa di input pada column tersebut.

	DEFAULT adalah suatu nilai/value default, apabila column tidak di isi dengan value lain.

	INDEX adalah digunakan untuk meningkatkan performance dalam pencarian data lebih cepat, tetapi 
		dengan konsekuensi meng-update data jadi lebih lambat, karena index harus di update juga.

*/

/*
	StudentNumber adalah PRIMARY KEY (PK) dari Student bersifat unik dan tidak ada duplikatnya. 
	Tetapi lebih lagi digunakan sebagai identitas utama dari satu row.

	IDCardNumber (nomor KTP) juga bersifat unik, tetapi bukan primary key dari table ini.

	MiddleName, LastName, Address bersifat NULLable, sehingga tidak wajib diisi datanya.
*/
CREATE TABLE dbo.Student(
	StudentNumber varchar(20) PRIMARY KEY,
	FirstName varchar(50) NOT NULL,
	MiddleName varchar(50) NULL,
	LastName varchar(50) NULL,
	IDCardNumber varchar(100) NOT NULL UNIQUE,
	Gender char(1) NOT NULL,
	BirthDate datetime NOT NULL,
	PhoneNumber varchar(50) NULL,
	Email varchar(100) NOT NULL,
	[Address] varchar(500) NULL,
	RegisterDate datetime NOT NULL
);

/*
	IDENTITY(seed, increment) adalah fungsi yang digunakan untuk membuat fungsi auto increment number,
	sehingga ID dari table dbo.Car akan digenerate automatically oleh sql server pada saat nanti di masukan datanya.

	Pada table ini juga terdapat column StudentNumber, StudentNumber pada table ini adalah sebuah Foreign Key (FK),
	Foreign Key artinya column ini terhubung dengan PK table lain, dalam hal ini terhubung dengan dbo.Student.

	Relation dari Student dengan Car ini disebut juga relation 1 to Many.
	Yang artinya 1 Student bisa memiliki banyak Car.
*/

CREATE TABLE dbo.Car(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	StudentNumber varchar(20) NOT NULL FOREIGN KEY REFERENCES dbo.Student(StudentNumber),
	PoliceNumber varchar(10) NOT NULL UNIQUE,
	Model varchar(100) NOT NULL,
	Brand varchar(100) NOT NULL,
	Color varchar(50) NULL
);

/*
	Table ini menggunakan Composite Primary Key, yaitu menggunakan Major dan Name sebagai Primary Keynya.
	Composite Primary Key: adalah Primary Key yang terdiri dari lebih dari 1 column. Sehingga keunikannya dilihat dari kombinasinya.
	Primary Key dari Subject adalah gabungan dari Major(Penjurusan) dan Name(Nama Mata Pelajaran).

	CreditPoint adalah nilai kelulusan dari mata pelajaran ini, nilai terkecil adalah 10 dan terbesarnya adalah 90.
	CHECK digunakan memvalidasi bahwa data harus sesuai dengan criterianya.

	Level diberikan constraint default, pada saat column ini tidak di insert dengan value apapun, datanya akan berisikan 'Bachelor'.
*/
CREATE TABLE dbo.[Subject](
	Major varchar(50) NOT NULL,
	[Name] varchar(50) NOT NULL,
	StudentNumber varchar(20) NOT NULL FOREIGN KEY REFERENCES dbo.Student(StudentNumber),
	[Description] varchar(200) NULL,
	CreditPoint int CHECK (CreditPoint <= 90 AND CreditPoint >= 10),
	[Level] varchar(20) DEFAULT 'Bachelor',
	PRIMARY KEY (Major, [Name])
);

/*
	Satu subject memiliki banyak topic, topic adalah hal-hal yang dipelajari di dalam satu subject.
	Topic terhubung ke Subject dengan menggunakan Composite Foreign Key, karena Subject juga memiliki composite Primary Key
*/

CREATE TABLE dbo.Topic(
	ID int NOT NULL PRIMARY KEY,
	Major varchar(50) NOT NULL,
	SubjectName varchar(50) NOT NULL,
	Topic varchar(50) NOT NULL,
	[Description] varchar(200) NULL,
	FOREIGN KEY (Major, SubjectName) REFERENCES dbo.[Subject](Major, [Name])
)

/*Contoh Syntax DROP existing DEFAULT CONSTRAINT dan ADD DEFAULT CONSTRAINT yang baru*/

ALTER TABLE dbo.[Subject]
	DROP CONSTRAINT DF__Subject__Level__37A5467C;

ALTER TABLE dbo.[Subject]
	ADD CONSTRAINT DF_Level DEFAULT 'Bachelor' FOR [Level];

/*Contoh Syntax DROP existing dan ADD CHECK CONSTRAINT yang baru*/

ALTER TABLE dbo.[Subject]
	DROP CONSTRAINT CK__Subject__CreditP__36B12243;

ALTER TABLE dbo.[Subject]
	ADD CONSTRAINT CK_CreditPoint CHECK (CreditPoint <= 90 AND CreditPoint >= 10);

/*Contoh Syntax DROP existing dan ADD PK yang baru*/

ALTER TABLE dbo.Topic
	DROP CONSTRAINT PK__Topic__3214EC2767AE7E57;

ALTER TABLE dbo.Topic 
	ADD CONSTRAINT PK_Topic PRIMARY KEY (ID);

/*Contoh Syntax DROP existing dan ADD FK yang baru*/

ALTER TABLE dbo.Car
	DROP CONSTRAINT FK__Car__StudentNumb__32E0915F;

ALTER TABLE dbo.Car
	ADD CONSTRAINT FK_Car FOREIGN KEY (StudentNumber) REFERENCES dbo.Student(StudentNumber);

/*Contoh Syntax DROP existing dan ADD UNIQUE CONSTRAINT yang baru*/

ALTER TABLE dbo.Car
	DROP CONSTRAINT UQ__Car__3E4A0C1251DCB410;

ALTER TABLE dbo.Car
	ADD CONSTRAINT UC_PoliceNumber UNIQUE (PoliceNumber);

/*Apabila ingin memberi CONSTRAINT saat membuat table baru, dan ingin CONSTRAINTnya langsung diberi nama, bisa */

CREATE TABLE dbo.Student(
	StudentNumber varchar(20) NOT NULL,
	FirstName varchar(50) NOT NULL,
	MiddleName varchar(50) NULL,
	LastName varchar(50) NULL,
	IDCardNumber varchar(100) NOT NULL,
	Gender char(1) NOT NULL,
	BirthDate datetime NOT NULL,
	PhoneNumber varchar(50) NULL,
	Email varchar(100) NOT NULL,
	[Address] varchar(500) NULL,
	RegisterDate datetime NOT NULL,
	CONSTRAINT PK_Student_StudentNumber PRIMARY KEY (StudentNumber),
	CONSTRAINT UQ_Student_IDCardNumber UNIQUE (IDCardNumber)
);

CREATE TABLE dbo.Car(
	ID int NOT NULL IDENTITY(1,1),
	StudentNumber varchar(20) NOT NULL ,
	PoliceNumber varchar(10) NOT NULL,
	Model varchar(100) NOT NULL,
	Brand varchar(100) NOT NULL,
	Color varchar(50) NULL,
	CONSTRAINT PK_Car_ID PRIMARY KEY(ID),
	CONSTRAINT FK_Car_StudentNumber FOREIGN KEY (StudentNumber) REFERENCES dbo.Student(StudentNumber),
	CONSTRAINT UQ_Car_PoliceNumber UNIQUE (PoliceNumber)
);

CREATE TABLE dbo.[Subject](
	Major varchar(50) NOT NULL,
	[Name] varchar(50) NOT NULL,
	StudentNumber varchar(20) NOT NULL,
	[Description] varchar(200) NULL,
	CreditPoint int NOT NULL,
	[Level] varchar(20) NOT NULL CONSTRAINT [DF_Level] DEFAULT 'Bachelor',
	CONSTRAINT PK_Subject_Major_Name PRIMARY KEY (Major, [Name]),
	CONSTRAINT FK_Subject_StudentNumber FOREIGN KEY (StudentNumber) REFERENCES dbo.Student(StudentNumber),
	CONSTRAINT CH_Subject_CreditPoint CHECK (CreditPoint <= 90 AND CreditPoint >= 10)
);

CREATE TABLE dbo.Topic(
	ID int NOT NULL,
	Major varchar(50) NOT NULL,
	SubjectName varchar(50) NOT NULL,
	Topic varchar(50) NOT NULL,
	[Description] varchar(200) NULL,
	CONSTRAINT PK_Topic_ID PRIMARY KEY (ID),
	CONSTRAINT FK_Topic_Major_SubjectName FOREIGN KEY (Major, SubjectName) REFERENCES dbo.[Subject](Major, [Name])
)

/*BACKUP DATABASE digunakan untuk membuat backup database dalam bentuk file dengan format .bak*/
BACKUP DATABASE Northwind TO DISK = 'C:\Backup\Northwind.bak';

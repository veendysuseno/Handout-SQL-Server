/*
	SCHEMA: atau database schema adalah cara mengelompokan object group seperti table, view, dan store procedure.
	Schema juga dimanfaatkan dari sisi security untuk mengatur permission terhadap user login untuk single schema saja.
*/

/*Hapus database Hospital dan buat lagi seperti di bawah ini.*/
CREATE DATABASE Hospital;
GO
USE Hospital;
GO
CREATE SCHEMA Perawatan;
GO
CREATE SCHEMA Apotek;
GO

/*Kita tidak akan lagi menggunakan dbo sebagai schema.*/
CREATE TABLE Perawatan.Patient(
	ID INT NOT NULL IDENTITY(1,1),
	[Name] VARCHAR(200) NOT NULL,
	BirthDate DATE NOT NULL,
	Gender VARCHAR(10) NOT NULL,
	BloodType VARCHAR(5) NOT NULL,
	CONSTRAINT PK_Patient_ID  PRIMARY KEY (ID)
);
CREATE TABLE Perawatan.Room(
	RoomNumber VARCHAR(10) NOT NULL,
	Class VARCHAR(50) NOT NULL,
	MaximumPatient INT NOT NULL,
	[Description] VARCHAR(500) NULL
	CONSTRAINT PK_Room_RoomNumber PRIMARY KEY (RoomNumber)
);
CREATE TABLE Apotek.Medicine(
	ID INT NOT NULL IDENTITY(1,1),
	[Name] VARCHAR(200) NOT NULL,
	Company VARCHAR(20) NOT NULL,
	[Description] VARCHAR(500) NOT NULL,
	Price MONEY NOT NULL,
	CONSTRAINT PK_Medicine_ID PRIMARY KEY (ID)
);
CREATE TABLE Apotek.Invoice(
	InvoiceNumber UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
	[Name] VARCHAR(200) NOT NULL,
	PurchaseDate DATETIME NOT NULL,
	CONSTRAINT PK_Invoice_InvoiceNumber PRIMARY KEY (InvoiceNumber)
);
CREATE TABLE Apotek.InvoiceDetail(
	ID INT NOT NULL IDENTITY(1,1),
	InvoiceNumber UNIQUEIDENTIFIER NOT NULL,
	MedicineID INT NOT NULL,
	CONSTRAINT PK_InvoiceDetail_ID PRIMARY KEY (ID),
	CONSTRAINT FK_InvoiceDetail_InvoiceNumber FOREIGN KEY (InvoiceNumber) REFERENCES Apotek.Invoice(InvoiceNumber),
	CONSTRAINT FK_InvoiceDetail_MedicineID FOREIGN KEY (MedicineID) REFERENCES Apotek.Medicine(ID)
);

/*
	Kita bisa merubah authorization atau ownership sebuah schema untuk seorang user dengan 
	menggunakan operation ALTER AUTHORIZATION.
*/
ALTER AUTHORIZATION ON SCHEMA::Perawatan TO violet;    
GO  
ALTER AUTHORIZATION ON SCHEMA::Apotek TO jane;
GO

/*
	Atau kita bisa melakukannya lewat SSMS.
	Masuk ke database Hospital/Security/Schemas

	Temukan nama Schemas yang ingin diubah ownershipnya, lalu
	Click kanan, Properties, ubah Schema Ownernya.

	Maka segala hal yang memiliki Schemas tersebut adalah milik dari user tersebut,
	baik itu sebuah Table, Function, View, Procedure dan lain sebagainya.
*/
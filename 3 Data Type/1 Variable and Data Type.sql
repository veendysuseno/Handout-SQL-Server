/*
	Data type adalah sebuah tipe data yang digunakan column atau variable untuk menyimpan data pada chunk of memory.
	Chunk of memory akan mentranslate bit/binary menjadi tipe data yang bersangkutan.

	Variable adalah satu temporary pointer yang bisa menyimpan satu value dengan tipe data yang di deklarasi.

	Seluruh jenis data type di dalam SQL:

	Kelompok bilangan bulat:
		tinyint: bilangan bulat dari 0 - 255
		smallint: bilangan bulat dari -32.768 - 32.767.
		int: -2.147.483.648 - 2.147.483.647
		bigint: -9.223.372.036.854.775.808 - 9.223.372.036.854.775.807
	
	Kelompok bilangan desimal:
		decimal(precision, scale): bilangan desimal berdasarkan presisi dan skala yang ditentukan.
		numeric(precision, scale): sama persis dengan decimal. Sudah banyak perdebatan antara perbedaan decimal dan numeric, tetapi mereka sama persis.
		float(n): n memiliki range dari 1 - 53. Dimana n merupakan jumlah bits binary untuk menyimpan bilangannya (53 adalah default dimana sama dengan 15 digits).
		real: sama persis dengan float(24);
		smallmoney: tipe data finansial dengan range -214.748,3648 - 214.748,3647
		money: tipe data finansial dengan range -922.337.203.685.477,5808 - 922.337.203.685.477,5807

	bit: 1 atau 0, biasa digunakan sebagai pengganti boolean.

	Kelompok penunjuk waktu:
		date: tipe data yang menyimpan hanya tanggal (tidak termasuk waktu/jam) dari 1 January 0001 sama 31 December 9999.
		time: tipe data yang digunakan untuk menyimpan informasi jam saja.
		smalldatetime: tipe data penunjuk hari dan waktu dari tanggal 1 January 1900 sampai 6 June 2079, dengan presisi 1 menit.
		datetime: tipe data penunjuk hari dan waktu dari tanggal 1 January 1753 sampai 31 December 9999, dengan presisi 1 menit.
		datetime2: tipe data penunjuk hari dan waktu dari tanggal 1 January 0001 sampai 31 December 9999, dengan presisi 1 menit. Ini adalah tipe data baru di sql.
		datetimeoffset: membawa informasi datetime beserta perbedaan waktu GMTnya. Rangenya sama dengan datetime2.
	
	Kelompok penyimpan characters:
		char(n): menyimpan sebuah string dengan banyak karakter yang ditentukan di awal. (n maximum 8000 characters) dan ukuran nya fixed
		varchar(n): sama seperti char, tetapi varchar memiliki kemampuan untuk menyusutkan memory saat panjang characters tidak sama dengan maximumnya. (menghemat memory).
		text: sama seperti varchar, hanya saja nilai maximumnya mencapai 2.147.483.647 chars (2 Gb), dan tidak set parameternya. Pemakaian text tidask disarankan, karena datatype ini akan deprecated(expired).
		nchar: menyimpan text dan character unicode, bisa menyimpan sampai 4000 characters, dan ukurannya fixed
		nvarchar(n): sama seperti nchar, tetapi ukuran maximumnya akan bervariasi sesuai dengan isi data.
		ntext: sama seperti nvarchar, hanya saja nilai maximumnya mencapai 1.073.741.823 chars. Pemakaian text tidask disarankan, karena datatype ini akan deprecated(expired).
	
	Kelompok binary data file:
		binary: menyimpan file dalam binary sampai dengan 8 Kb.
		varbinary: sama seperti binary, hanya saja ukurannya flexible up to 8kb.
		image: menyimpan file dalam binary dengan ukuran flexiblenya up to 2 Gb.

	Kelompok generated id:
		timestamp: id unik yang yang digenerate otomatis oleh database. timestamp sudah kuno dan sudah hampir depracted, digantikan oleh rowversion.
		rowversion: adalah versi lebih baru dari timestamp, dan sudah bisa digunakan sejak SQL server 2005.
		uniqueidentifier: tipe data yang digunakan untuk menyimpan GUID (Global Unique Identifier), aplikasi yang akan generate ini.

	Kelompok referensi table:
		table: sebuah set table dengan nilai-nilainya.
		cursor: sebuah set digunakan untuk mengembalikan data 1 row pada satu waktu (database object).

	sql_variant: Open Database Connectivity tidak support ini, jangan dipakai. (digunakan untuk menyimpan text atau image sampai 8016 bytes)
*/

/*Sebuah variable bisa di deklarasi dengan menggunakan DECLARE, dan penulisan variable harus diawali dengan @*/
DECLARE @angkaPertama AS INT = 89;
SELECT @angkaPertama AS [Angka Pertama]; --Variable yang sudah dibuat bisa di SELECT selayaknya sebuah column.

/*Delarasai sebuah variable tidak harus langsung isi valuenya, value dari variable bisa di set belakangan.*/
DECLARE @kataPertama AS VARCHAR(40);
SET @kataPertama = 'Mercury'; --Sebuah string ditulis dengan menggunakan ''
SELECT @kataPertama;

/*Dan bisa juga di replace dengan SET*/
SET @kataPertama = 'Venus';
SELECT @kataPertama, @angkaPertama;

/*Selain di kembalikan nilainya di SELECT, kita juga bisa menggunakan perintah PRINT untuk menulisnya di message*/
PRINT @kataPertama;

/*Bila sebuah variable di declare tanpa di set, maka nilainya akan null, sama seperti pada row yang tidak diisi*/
DECLARE @blank AS VARCHAR(20);
SELECT @blank;
PRINT @blank;

USE Northwind;

--Kita bisa menggunakan variable untuk berbagai kemungkinan.
DECLARE @sold AS VARCHAR(20) = 'Sold: ';
DECLARE @multiplication AS INT = 3;
SELECT CONCAT(@sold, prod.ProductName) AS [Prod Name], prod.UnitPrice * @multiplication AS [3 x Price]
FROM dbo.[Products] AS prod;

--Kita bisa men-select sekaligus memasukan hasil scalar value yang di dapat ke dalam variable
DECLARE @selectedCompanyName AS NVARCHAR(40);
SELECT @selectedCompanyName = cus.CompanyName
FROM dbo.Customers AS cus
WHERE cus.CustomerID = 'HILAA';

PRINT @selectedCompanyName;
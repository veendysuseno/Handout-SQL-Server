USE Northwind;
/*NUMERIC DAN MATH OPERATIONS*/

/*Math Operators selalu bisa digunakan untuk menghitung tipe data numeric, baik itu integer (bilangan bulat) atau bilangan desimal.*/
DECLARE @number INT = 12;
PRINT @number * 2;
PRINT @number + 2;
PRINT @number / 2;
PRINT @number % 5;

SElECT prod.ProductName, prod.UnitPrice * 2
FROM dbo.Products AS prod;

/*
	Perhitungan juga bisa dilakukan oleh beberapa function, contohnya seperti akar dan pangkat.
	SQRT dan POWER
*/

DECLARE @second_number INT =144;
PRINT SQRT(@second_number); --akar pangkat
PRINT POWER(@number, 2);

/*
	DECIMAL(precision, scale)
	precision: (1 - 38): total digit yang bisa di simpan. Note: selalu ingat, apabila scale memiliki 1 digit, sudah pasti ada .0 pada value.
	scale: total digit decimal yang akan disimpan. Berjarak dari (0 - precision)
*/

DECLARE @bilangan_decimal AS DECIMAL(5,2)  = 33.23; 
PRINT @bilangan_decimal;

/*
	DECLARE @salah AS DECIMAL(3.2) = 45.6;
	Ini tidak masuk akal dan akan overflow, karena format decimal ini hanya menyediakan 1 digit bilangan bulat, 
	dan 2 bilangan decimal. 45 tidak bisa disimpan, dan decimalnya adalah 60.
*/

/*
	Ada 3 macam pembulatan:
	FLOOR: Pembulatan ke bawah untuk semua nilai desimal.
	CEILING: Pembulatan ke atas untuk semua nilai desimal.
	ROUND: Pembulatan relative untuk semua nilai desimal.
*/

DECLARE @high AS DECIMAL(5,2) = 56.88, @low AS DECIMAL(5,2) = 56.12;
PRINT FLOOR(@high);
PRINT FLOOR(@low);
PRINT CEILING(@high);
PRINT CEILING(@low);

--Round memiliki parameter angka dibelakang untuk menyatakan berapa jumlah presisinya.
PRINT ROUND(@high, 1);
PRINT ROUND(@high, 0);
PRINT ROUND(@low, 1);
PRINT ROUND(@low, 0);

SELECT prod.ProductName, ROUND(prod.UnitPrice, 0)
FROM dbo.Products AS prod;

/*TIPE DATA STRING*/

DECLARE @word AS VARCHAR(200) = 'Hello World';

/*
	Kita bisa mendefinisikan n dengan penulisan MAX daripada dengan string length, apa bila kita menulis length, maximumnya adalah 8000.
	Tetapi dengan MAX, bisa lebih dari itu, MAX akan menyimpan sampai up to 2gb.

	Beberapa kerugian penggunaan MAX adalah:
	1. Tidak bisa dijadikan Index (Akan dipelajari di chapter berikutnya)
	2. Bila aplikasi tidak memiliki validasi, user bisa se-enaknya menyimpan text sebanyak-banyaknya, ini harus dipertimbangkan terlebih dahulu efeknya.
*/
DECLARE @maximum AS VARCHAR(MAX) = 'Testing Maximum';
DECLARE @unicodeMax AS NVARCHAR(MAX) = 'Testing Maximum Nvarchar';


/*LEN: atau Length adalah function yang digunakan untuk menghitung total panjang char dalam string*/
PRINT LEN(@word);
PRINT LEN(@number);

/*
	DATALENGTH: Hati-hati, jangan tertukar dengan fungsi LEN dengan DATALENGTH, DATALENGTH 
	tidak menghitung jumlah char, tapi menghitung jumlah bit pada variable, ini bisa dibuktikan karena DATALENGTH juga bisa dipakai untuk numeric.
*/
PRINT DATALENGTH(@word);
DECLARE @angka int = 56;
PRINT DATALENGTH(@angka);

/*
	UPPER digunakan untuk merubah semua character pada string menjadi Uppercase atau huruf besar.
	LoWER digunakan untuk merubah semua character pada string menjadi Lowercase atau huruf kecil.
*/
PRINT UPPER(@word);
PRINT LOWER(@word);	

/*CONCAT: digunakan untuk menggabungkan 2 string menjadi satu. Fungsi ini pernah di gunakan di chapter sebelumnya.*/
DECLARE @wordOne VARCHAR(100) = 'This is a group of characters. ';
DECLARE @wordTwo VARCHAR(100) = 'That form into a string.';
PRINT CONCAT(@wordOne, @wordTwo);

/*PATINDEX mencari index dari pattern yang ingin dicari. akan mengembalikan index pertamanya*/
PRINT PATINDEX('%This%', @wordOne);
PRINT PATINDEX('%group%', @wordOne);
PRINT PATINDEX('%is%', @wordOne);

/*
	Triming Function digunakan untuk menghilangkan gap di ujung depan dan belakang dari suatu string (bukan bagian tengah).
	LTRIM: Menghilangkan spasi atau gap pada bagian depan/kiri string
	RTRIM: Menghilangkan spasi atau gap pada bagian belakang/kanan string
*/
DECLARE @wrongInput varchar(200) = '   Test    Big   Gap   ';
PRINT RTRIM(@wrongInput);
PRINT LTRIM(@wrongInput);
PRINT RTRIM(LTRIM(@wrongInput));

/*
	SUBSTRING digunakan untuk mengambil potongan string dari satu index ke n banyak character selanjutnya.
	SUBSTRING(string_variable, index _start, panjang_char)
*/
PRINT SUBSTRING(@wordOne, 2, 6);

/*
	CHARINDEX: digunakan untuk mendapatkan index dimana string yang dicarinya dimulai
*/
DECLARE @lorem varchar(200) = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.';
PRINT CHARINDEX('Ipsum', @lorem); --index I pada Ipsum jatuh di index ke 7.

--Parameter ke 3 menunjukan start index mencarinya.
PRINT CHARINDEX('Ipsum', @lorem, 5); --masih ditemukan karena Ipsum mulai pada index ke 7
PRINT CHARINDEX('Ipsum', @lorem, 8); --tidak ditemukan.

/*LEFT: hampir mirip seperti substring, tetapi diambil dari index paling kiri*/
PRINT LEFT(@lorem, 5);

/*RIGHT: hampir mirip seperti substring, tetapi diambil dari index paling kanan*/
PRINT RIGHT(@lorem, 9);

/*REPLACE: mengganti sepotong string pada variable dengan sepotong string lainnya.*/
PRINT REPLACE(@lorem, 'l', 'x');
PRINT REPLACE(@lorem, 'in', 'am'); --Mengganti satu potong string

/*REPLICATE: print sebuah string berulang kali, jumlah perulangan sesuai dengan parameternya.*/
PRINT REPLICATE('0', 8);
PRINT REPLICATE(@word, 4);

/*STRING_SPLIT: merubah sederetan string menjadi multi-value column*/
ALTER DATABASE Northwind SET COMPATIBILITY_LEVEL = 130; -- Di beberapa SQL Server versi 2016, ini harus digunakan untuk menggunakan STRING_SPLIT.
DECLARE @deretan VARCHAR(50) = 'Sandy,Olga,Jack,Harry';
SELECT VALUE AS [Person] FROM STRING_SPLIT(@deretan, ',');

--select userId, userName, email, groupUserDesc, trim(value) as [SubOrdinateList_UserInternal]
--from [dbo].[View_GetSubordinate]
--	CROSS APPLY STRING _SPLIT(SubOrd, ',') 
--order by userId asc


--SELECT A.userName, A.email, A.groupUserDesc,  Split.a.value('.', 'NVARCHAR(MAX)') DATA
--FROM
--(
--    SELECT tbl.userName, tbl.email, tbl.groupUserDesc, CAST('<X>'+REPLACE(tbl.SubOrd, ',', '</X><X>')+'</X>' AS XML) AS String 
--	from [dbo].[View_GetSubordinate] tbl
--) AS A
--CROSS APPLY String.nodes('/X') AS Split(a);





/*REVERSE: digunakan untuk memutar balikan string ke urutan yang berlawanan.*/
PRINT REVERSE(@lorem);

/*Parsing antara Numeric dan String*/

/*
	STR adalah method yang digunakan untuk meng-convert from Numeric (akan ada pembulatan) to String
	parameter kedua berisi total character, by default 10
	parameter ketiga berisi total angka dibelakang koma untuk desimal
*/
DECLARE @desimal DECIMAL(5,2) = 34.27;
PRINT @desimal;
PRINT STR(@desimal, 5, 2); 
PRINT STR(@desimal, 5, 1);
PRINT STR(@desimal, 2, 1);

/* Ini tidak bisa dilakukan karena adanya tipe data yang berbeda
SELECT prod.ProductName, prod.UnitPrice
FROM dbo.Products AS prod
UNION
SELECT cus.CompanyName, cus.ContactTitle
FROM dbo.Customers AS cus;
*/

--Walaupun contentnya berbeda, tetapi sekarang bisa di UNION
SELECT prod.ProductName, STR(prod.UnitPrice)
FROM dbo.Products AS prod
UNION
SELECT cus.CompanyName, cus.ContactTitle
FROM dbo.Customers AS cus;

/*
	Conversi dari numeric ke string juga bisa dilakukan dengan cara lain,
	misalnya dengan FORMAT, tapi format bukan hanya meng-conversinya menjadi string, tetapi melakukan formating juga.

	Dalam hal ini dilakukan formating dengan format uang.
	FORMAT(value, format, culture)

	culture bisa didapat dari:
	https://www.w3schools.com/tags/ref_country_codes.asp
	https://www.w3schools.com/tags/ref_language_codes.asp

	format untuk numeric:
	N: Number
	G: General
	C: Currency (Mata Uang)
*/
DECLARE @uang MONEY = 34500.50;
PRINT FORMAT(@uang, 'N', 'en-US');
PRINT FORMAT(@uang, 'N', 'id-ID');
PRINT FORMAT(@uang, 'G', 'id-ID');
PRINT FORMAT(@uang, 'C', 'en-US');
PRINT FORMAT(@uang, 'C', 'id-ID');

/*
	PARSE: method yang digunakan untuk merubah string menjadi data type yang lain
*/
DECLARE @variableOne AS VARCHAR(50) = '77';
DECLARE @variableTwo AS VARCHAR(50) = '89.78';
DECLARE @variableThree AS VARCHAR(50) = 'Hello World';
PRINT PARSE(@variableOne AS INT);
PRINT PARSE(@variableTWO AS DECIMAL(5,2));

--Ini tidak bisa dilakukan dikarenakan value dari string tidak related dengan data type baru yang dituju
/*
	PRINT PARSE(@variableTWO AS INT);	
	PRINT PARSE(@variableThree AS INT);
	PRINT PARSE(@variableThree AS DECIMAL(5,2));
*/

--TRY_PARSE sama seperti parse, tapi ketimbang menghasilkan error, try parse akan menghasilkan null.
SELECT TRY_PARSE(@variableTWO AS INT);
SELECT TRY_PARSE(@variableThree AS INT);
SELECT TRY_PARSE(@variableThree AS DECIMAL(5,2));

/*
	PARSE VS CONVERT vs CAST

	PARSE adalah method yang digunakan untuk merubah string menjadi numeric atau date/time.
	PARSE bisa menggunakan Culture untuk merubahnya menjadi specific format negara tertentu, dan mechanismenya membutuhkan
	.NET Framework yang ter-install di dalam system.

	CONVERT & CAST: hampir mirip, performance dari CAST lebih cepat dan CAST sudah ada terlebih dahulu sebelum CONVERT,
	tetapi CAST tidak bisa menggunakan style argument. (akan diperlihatkan style argument di chapter datetime)
*/
DECLARE @bilangan_bulat AS INT = 94;

PRINT CONVERT(INT, @variableOne);
PRINT CONVERT(DECIMAL(5,2), @variableTWO);
PRINT CONVERT(INT, @bilangan_decimal);
PRINT CONVERT(DECIMAL(5,2), @bilangan_bulat);

PRINT CAST(@variableOne AS INT);
PRINT CAST(@variableTWO AS DECIMAL(5,2));
PRINT CAST(@bilangan_decimal AS INT);
PRINT CAST(@bilangan_bulat AS DECIMAL(5,2));

/*STUFF digunakan untuk me-replace string berdasarkan indexnya.*/
DECLARE @initialWord AS VARCHAR(50) = 'SQL Tutorial';
SELECT STUFF(@initialWord, 1, 3, 'HTML');
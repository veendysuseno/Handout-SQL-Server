/*
	Kita bisa set sebuah datetime dengan string value seperti di bawah ini.
	Penulisan ini dalam format USA dan langsung bisa diterima oleh datetime.
*/
DECLARE @natal AS DATETIME = '12/25/2016';

/*GETDATE digunakan untuk mendapatkan tanggal hari ini.*/
PRINT GETDATE();
DECLARE @today AS DATETIME;
SET @today = GETDATE();
SELECT GETDATE();

/*GETUTCDATE digunakan untuk mendapatkan tanggal di london. UTC (Universal Time Coordinated)*/
PRINT GETUTCDATE();

/*
	Current TimeStamp: Current TimeStamp dan GetDate sama persis, 
	Current Time Stamp adalah versi T-SQL dan lebih bersahabat dengan seluruh standard american ANSI complient.
*/
PRINT CURRENT_TIMESTAMP;

/*
	SYSDATETIME digunakan untuk mendapatkan tanggal hari ini dan mengembalikannya dalam tipe data datetime2.
	SYSDATETIME sama dengan GETDATE, hanya saja tipe data yang dikembalikan yang berbeda.
*/
PRINT SYSDATETIME();

/*SYSDATETIME sama seperti GETUTCDATE, hanya saja tipe data yang dihasilkan datetime2.*/
PRINT SYSUTCDATETIME();

/*Seperti yang pernah ditulis di chapter sebelumnya, OFFSET akan berisikan informasi mengenai perubahan GMTnya.*/
DECLARE @halloween DATETIMEOFFSET = '10/31/2016';
PRINT @halloween;

/*SYSDATETIMEOFFSET sama seperti GETDATE, hanya saja tipe data yang dikembalikan adalah DATETIMEOFFSET*/
PRINT SYSDATETIMEOFFSET();

/*
	DATE hanya dapat menyimpan informasi tanggal saja, 
	sedangkan TIME hanya bisa menyimpan informasi jam saja.
*/
DECLARE @valentine DATE = '01/01/0001';
PRINT @valentine;
DECLARE @jam TIME = '15:33';
PRINT @jam;

DECLARE @tanggalanSatu DATETIME = '05/11/2019';

--mendapatkan satu informasi (tahun, bulan, tanggal) dari sebuah variable dengan tipe data yang memiliki date
/*
	DateName return nvarchar

	Jenis-jenis interval yang bisa digunakan di parameter pertama:
	year, quarter, month, dayofyear, day, week, weekday, hour, minute, second, millisecond
*/
PRINT 'DATENAME function';
PRINT DATENAME(year, @tanggalanSatu);
PRINT DATENAME(month, @tanggalanSatu);
PRINT DATENAME(day, @tanggalanSatu);

--Sedangkan untuk datepart mengembalikannya dalam integer.
PRINT 'DATEPART function';
PRINT DATEPART(year, @tanggalanSatu);
PRINT DATEPART(month, @tanggalanSatu);
PRINT DATEPART(day, @tanggalanSatu);

/*Begitu juga dengan function DAY, MONTH, dan YEAR, tetapi ketiga fungsi ini tidak bisa menggunakan interval pada parameternya.*/
PRINT DAY(@tanggalanSatu);
PRINT MONTH(@tanggalanSatu);
PRINT YEAR(@tanggalanSatu);

/*DATETIMEFROMPARTS digunakan untuk mendapatkan datetime (return typenya) dari 3 integer parameter, year(int), month(int), date(int)*/
PRINT DATEFROMPARTS(2014, 10, 25);

/*
	DATETIMEFROMPARTS memiliki override parameternya yang bisa digunakan untuk menginput informasi time
	( year, month, day, hour, minute, seconds, milliseconds): return datetime
*/
DECLARE @complete DATETIME = DATETIMEFROMPARTS(2014, 9, 28, 12, 33, 55, 40);
PRINT @complete;

/*DATETIME2FROMPARTS: sama seperti DATETIMEFROMPARTS, hanya saja tipe data yang dikembalikan adalah DATETIME2.*/
PRINT DATETIME2FROMPARTS(2014, 9, 28, 12, 33, 55, 0, 0);

/*
	TIMEFROMPARTS adalah function yang digunakan untuk membuat time(datatype: time) dengan menggunakan 
	parameter integers (hour, minute, seconds, fractions, precision).
*/ 
PRINT TIMEFROMPARTS( 22, 55, 59, 0, 0 );

/*
	DATEADD (datepart, number, date) adalah fungsi yang digunakan untuk menambah sebuah date/ datetime dengan 
	interval dan integer yang ditentukan.
*/
PRINT DATEADD(month, 2, @halloween);
PRINT DATEADD(day, 2, @natal);
PRINT DATEADD(year, 2, @natal);

/*EOMONTH atau (End Of Month) adalah function yang digunakan untuk mendapatkan tanggal terakhir pada bulan tersebut.*/
DECLARE @tanggalanDua DATETIME = '10/16/2017';
PRINT EOMONTH(@tanggalanDua);

/*DATEDIFF adalah fungsi yang digunakan untuk menghitung jarak dua buah tanggal sesuai dengan interval yang diberikan.*/
DECLARE @from DATETIME = '3/4/2012';
DECLARE @to DATETIME = '7/8/2015';
PRINT DATEDIFF(year, @from, @to);
PRINT DATEDIFF(month, @from, @to);
PRINT DATEDIFF(day, @from, @to);

/*ISDATE adalah fungsi yang digunakan untuk memvalidasi sebuah tanggal, apakah string ini adalah valid sebuah tanggal atau bukan.*/
PRINT ISDATE(@from);
PRINT ISDATE('5/5/2017');
PRINT ISDATE('30/1/2019');
PRINT ISDATE('3/20/2019');

/*FORMAT: selain untuk formatting currency, format juga bisa digunakan untuk */
DECLARE @tanggalan DATETIME = '10/12/2011';
PRINT FORMAT(@tanggalan, 'dd MMMM yyyy', 'en-US');
PRINT FORMAT(@tanggalan, 'dd MMMM yyyy', 'id-ID');
DECLARE @testDate AS DATETIME = '08/01/2011';
PRINT FORMAT(@testDate, 'dd MMMM yyyy', 'id-ID');

/*PARSE: di bawah ini kita mencoba parsing dari string ke datetime.*/
DECLARE @string_date AS VARCHAR(100) = '5/29/2011';
DECLARE @european_date AS VARCHAR(100) = '29/5/2011';
SELECT PARSE(@string_date AS DATETIME USING 'en-US');
--SELECT PARSE(@string_date AS DATETIME USING 'id-ID'); --conversinya salah
SELECT PARSE(@european_date AS DATETIME USING 'id-ID'); 

/*CAST memiliki kelemahan, apabila penulisan stringnya tidak sesuai dengan default format, maka formatting akan gagal.*/
SELECT CAST(@string_date AS DATETIME); -- berhasil karena format sesuai.
--SELECT CAST(@european_date AS DATETIME); Tidak bisa convert karena masalah formatting.

/*Mencoba berbagai format untuk tanggal 29 Mei 2018*/
DECLARE @usa_format AS VARCHAR(50) = '05/29/2018';
DECLARE @ansi_format AS VARCHAR(50) = '2018.05.29';
DECLARE @british_format AS VARCHAR(50) = '29/05/2018';
DECLARE @german_format AS VARCHAR(50) = '29.05.2018';
DECLARE @iso_format AS VARCHAR(50) = '180527';

/*
	CONVERT bisa menyelesaikan permasalahan yang tidak bisa di solve oleh CAST dengan menggunakan style argument.
    format dan style argument bisa di lihat di sini:
	http://www.java2s.com/Tutorial/SQLServer/0260__Data-Convert-Functions/ValuesforthestyleargumentoftheCONVERTfunctionwhenyouconvertadatetimeexpressiontoacharacterexpression.htm
*/
SELECT CONVERT(DATETIME, @usa_format, 101);
SELECT CONVERT(DATETIME, @ansi_format, 102);
SELECT CONVERT(DATETIME, @british_format, 103);
SELECT CONVERT(DATETIME, @german_format, 104);
SELECT CONVERT(DATETIME, @iso_format, 112);

DECLARE @sample_date AS DATETIME = '05/29/2018';
PRINT CONVERT(VARCHAR(100), @sample_date, 101);
PRINT CONVERT(VARCHAR(100), @sample_date, 102);
PRINT CONVERT(VARCHAR(100), @sample_date, 103);
PRINT CONVERT(VARCHAR(100), @sample_date, 104);
PRINT CONVERT(VARCHAR(100), @sample_date, 112);
/*
	Error handling adalah suatu hal yang dilakukan untuk mendelegasi run time error/ execution error dengan menggunakan 
	TRY dan CATCH Blocks.

	TRY block digunakan untuk mencoba suatu code yang dimana memiliki potensi execution error.
	Saat error terjadi di dalam TRY block, maka CATCH block akan di jalankan sebagai delegasi dari TRY block.
*/

DECLARE @contohVariable AS VARCHAR(20) = 'ABC';
BEGIN TRY
	SELECT PARSE(@contohVariable AS INT);	
END TRY
BEGIN CATCH
	SELECT 'Tidak bisa convert menjadi integer' AS ErrorMessage;
END CATCH;

BEGIN TRY
	PRINT 12/0;
END TRY
BEGIN CATCH
	/*Berikut ini adalah function-function yang digunakan untuk melihat detail informasi error yang didapat.*/
	SELECT ERROR_NUMBER() AS ErrorNumber, --Function yang digunakan untuk mendapatkan error number dari suatu percobaan yang dilakukan.
		ERROR_SEVERITY() AS ErrorSeverity, --Function yang digunakan untuk mendapatkan tingkat keparahan error. check di https://blog.sqlauthority.com/2007/04/25/sql-server-error-messages-sysmessages-error-severity-level/
		ERROR_STATE() AS ErrorState, 
		ERROR_PROCEDURE() AS ErrorProcedure, --Untuk mengembalikan nama SP (Store Procedure) dimana error ini terjadi. 
		ERROR_LINE() AS ErrorLine,  --Lokasi line tempat error terjadi.
		ERROR_MESSAGE() AS ErrorMessage; --Function yang digunakan untuk mendapatkan penjelasan dari error yang terjadi.
	PRINT 'Tidak bisa dibagi 0';
END CATCH;

/*
	THROW digunakan untuk melemparkan peringatan run time error dengan sengaja. THROW menerima 3 parameters.

	error_number (51000): adalah int yang berisikan angka dari 50000 sampai 2147483647.
	message ('Tidak ditemukan record.') sebuah string yang menjelaskan errornya.
	state: tinyint berjarak dari = 0 - 255

	alternative daripada THROW adalah dengan menggunakan RAISEERROR, tetapi RAISEERROR adalah function yang digunakan pada
	Microsoft SQL Server 7.0 sampai Microsoft SQL Server 2012, setelah Microsoft SQL 2012 ke atas, disarankan untuk menggunakan THROW.
	https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-2017
*/

--THROW 51000, 'Tidak ditemukan record.', 1; 
BEGIN TRY
	SELECT 5/0 AS Impossible;
END TRY
BEGIN CATCH
	--THROW;
END CATCH;

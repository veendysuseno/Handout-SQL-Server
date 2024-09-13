/*
	Transaction adalah cara untuk mengupdate data dengan DML kepada 1 atau lebih table dan memastikan seluruhnya terupdate 
	atau tidak sama sekali ter-update.

	Untuk melakukan sebuah transaction, kita akan menggunakan macam-macam TCL.
	TCL (Transaction Control Language) adalah perintah-perintah yang digunakan untuk melakukan transaksi di database.

	Note: dalam pelajaran ini kita akan menggunakan Explicit Transaction/ Bukan Implicit Transaction.
*/

USE Ecommerce;

/*
	Seluruh Transaction di awali dengan BEGIN TRANSACTION, tetapi bisa diakhir oleh:
	COMMIT TRANSACTION atau ROLLBACK TRANSACTION.

	COMMIT TRANSACTION adalah scenario dimana transaksi berhasil meng-update multiple table, lalu transaksi dilakukan.
	ROLLBACK TRANSACTION adalah perintah UNDO, dimana seluruh hal yang dilakukan di dalam transaction block atau setelah transaction akan di reset ulang.
*/

--Ini adalah scenario dimana transaction di commit dan selesai
BEGIN TRANSACTION
	DECLARE @shipment AS VARCHAR(20) = 'JNE';
	DECLARE @buyer AS VARCHAR(5) = 'B3';

	DECLARE @CartTable AS dbo.CartTableType;

	INSERT INTO @CartTable
		VALUES (2, 'P11'), (2, 'P12'), (1, 'P31'), (3, 'P41');

	EXECUTE dbo.ProceedPurchase
		@buyer_id = @buyer, 
		@shipment_name = @shipment, 
		@cart_table = @CartTable;
COMMIT TRANSACTION;

GO

--Code dibawah ini tidak akan melakukan apapun karena pada akhirnya di rollback semua.
BEGIN TRANSACTION
	DECLARE @shipment AS VARCHAR(20) = 'J&T';
	DECLARE @buyer AS VARCHAR(5) = 'B2';

	DECLARE @CartTable AS dbo.CartTableType;

	INSERT INTO @CartTable
		VALUES (2, 'P13'), (2, 'P21'), (1, 'P32'), (3, 'P61');

	EXECUTE dbo.ProceedPurchase
		@buyer_id = @buyer, 
		@shipment_name = @shipment, 
		@cart_table = @CartTable;
ROLLBACK TRANSACTION

GO

/*
	Kombinasikan Transaction dengan Try Catch seperti di bawah ini.
	Dimulai dengan try lalu kita begin dan commit transaction, tetapi apabila ada kesalahan dan kegagalan 
	(misalnya koneksi putus di tengah jalannya proses),
	makan di dalam catch block, transaksi akan di rollback.

	Note: Apabila tidak melakukan ini di dalam ecommerce, maka akan ada potensi terjadinya, berkurangnya barang dari penjualan, tetapi pembeli tidak pernah tercatat membeli apa-apa.
	dan ini akan mengacaukan data.
*/
BEGIN TRY
	BEGIN TRANSACTION		
		DECLARE @shipment AS VARCHAR(20) = 'J&T';
		DECLARE @buyer AS VARCHAR(5) = 'B2';

		DECLARE @CartTable AS dbo.CartTableType;

		INSERT INTO @CartTable
			VALUES (2, 'P13'), (2, 'P21'), (1, 'P32'), (3, 'P61');

		EXECUTE dbo.ProceedPurchase
			@buyer_id = @buyer, 
			@shipment_name = @shipment, 
			@cart_table = @CartTable;
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE();
	ROLLBACK TRANSACTION;
END CATCH
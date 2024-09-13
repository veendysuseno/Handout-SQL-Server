/*
	WHILE adalah control flow statement yang digunakan untuk membuat loop/iteration/ eksekusi statement yang
	dilakukan berulang-ulang selama kondisi yang diinginkan tetap true.
*/
/*
	Contoh sederhana dari  WHILE statement, dimana while tidak akan berhenti selama @counter
	lebih kecil dari 10. (Hati-hati menulis statement, dimana loop mungkin tidak akan pernah berhenti)
*/
DECLARE @counter INT = 0;
WHILE(@counter < 10)
BEGIN
	PRINT CONCAT('Perputaran ke ', @counter);
	SET @counter = @counter + 1;
END

/*
	Berikut ini contoh penggunaan while yang lebih concrete untuk kebutuhan business.
	Concert adalah database untuk menonton konser yang berisikan table Booked Audience (Penonton yang kebagian tempat)
	dan Pending Reservation (Orang yang mengantri untuk mendapatkan tempat)
*/
USE Concert;

--Maximum jumlah penonton di konser ini adalah 20 orang.
DECLARE @maxAudience AS INT = 20;

SELECT aud.ID
FROM dbo.BookedAudience AS aud;
DECLARE @currentBooked AS INT = @@ROWCOUNT; --menghitung total row orang yang sudah di book

SELECT res.ID
FROM dbo.PendingReservation AS res;
DECLARE @currentPending AS INT = @@ROWCOUNT; --menghitung total row orang yang masih pending

--Iteration akan jalan bila ada pending dan penonton yang sudah book tidak melebihi kapasitas.
WHILE( @currentPending > 0 AND @currentBooked < @maxAudience)
BEGIN
	DECLARE @selectedPendingID AS INT;
	DECLARE @selectedName AS VARCHAR(100);

	SELECT TOP 1 @selectedPendingID = pen.ID, @selectedName = pen.[Name]
	FROM dbo.PendingReservation AS pen
	ORDER BY pen.RegisterationDate;

	--pindahkan dari pending ke booked
	DELETE dbo.PendingReservation WHERE ID = @selectedPendingID;
	INSERT INTO dbo.BookedAudience([Name], BookDate) VALUES (@selectedName, GETDATE());

	--Set ulang jumlah penonton yang sudah booked dan yang masih pending
	SELECT aud.ID
	FROM dbo.BookedAudience AS aud;
	SET @currentBooked = @@ROWCOUNT;

	SELECT res.ID
	FROM dbo.PendingReservation AS res;
	SET @currentPending = @@ROWCOUNT;
END

GO

/*
	Remove dan Restore kembali database Concert, dan coba lagi query yang sama,
	Tetapi kali ini dengan menggunakan BREAK.
*/
DECLARE @maxAudience AS INT = 20;

SELECT aud.ID
FROM dbo.BookedAudience AS aud;
DECLARE @currentBooked AS INT = @@ROWCOUNT; --menghitung total row orang yang sudah di book

SELECT res.ID
FROM dbo.PendingReservation AS res;
DECLARE @currentPending AS INT = @@ROWCOUNT; --menghitung total row orang yang masih pending

WHILE( @currentPending > 0 AND @currentBooked < @maxAudience)
BEGIN
	DECLARE @selectedPendingID AS INT;
	DECLARE @selectedName AS VARCHAR(100);

	SELECT TOP 1 @selectedPendingID = pen.ID, @selectedName = pen.[Name]
	FROM dbo.PendingReservation AS pen
	ORDER BY pen.RegisterationDate;

	IF(@selectedPendingID = 3)
	BEGIN
		/*
			BREAK adalah "Rem" yang digunakan untuk menghentikan loop pada while.
			Di sini break apabila ID dari pending candidate adalah 3, kalian bisa lihat bahwa "Ime" dan orang lain yang pending
			tidak masuk ke dalam booked audience.
		*/
		BREAK;
	END

	DELETE dbo.PendingReservation WHERE ID = @selectedPendingID;
	INSERT INTO dbo.BookedAudience([Name], BookDate) VALUES (@selectedName, GETDATE());

	SELECT aud.ID
	FROM dbo.BookedAudience AS aud;
	SET @currentBooked = @@ROWCOUNT;

	SELECT res.ID
	FROM dbo.PendingReservation AS res;
	SET @currentPending = @@ROWCOUNT;
END

GO

/*Cobalah sekali lagi, tetapi gantilah BREAK dengan CONTINUE*/
DECLARE @maxAudience AS INT = 20;

SELECT aud.ID
FROM dbo.BookedAudience AS aud;
DECLARE @currentBooked AS INT = @@ROWCOUNT; --menghitung total row orang yang sudah di book

SELECT res.ID
FROM dbo.PendingReservation AS res;
DECLARE @currentPending AS INT = @@ROWCOUNT; --menghitung total row orang yang masih pending

WHILE( @currentPending > 0 AND @currentBooked < @maxAudience)
BEGIN
	DECLARE @selectedPendingID AS INT;
	DECLARE @selectedName AS VARCHAR(100);

	SELECT TOP 1 @selectedPendingID = pen.ID, @selectedName = pen.[Name]
	FROM dbo.PendingReservation AS pen
	ORDER BY pen.RegisterationDate;

	IF(@selectedPendingID = 3)
	BEGIN
		/*
			CONTINUE adalah skip, yang membuat seluruh proses akan diabaikan dan di lewati,
			iteration akan langsung diteruskan ke tahap selanjutnya.
		*/
		CONTINUE;
	END

	DELETE dbo.PendingReservation WHERE ID = @selectedPendingID;
	INSERT INTO dbo.BookedAudience([Name], BookDate) VALUES (@selectedName, GETDATE());

	SELECT aud.ID
	FROM dbo.BookedAudience AS aud;
	SET @currentBooked = @@ROWCOUNT;

	SELECT res.ID
	FROM dbo.PendingReservation AS res;
	SET @currentPending = @@ROWCOUNT;
END
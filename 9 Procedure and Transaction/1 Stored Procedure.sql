USE University;
/*
	Stored Procedure atau SP atau PROCEDURE adalah sekolompok Transact-SQL yang 
	membentuk serangkaian logika
	atau prosedure yang disimpakan ke dalam database sebagai object.

	Keuntungan dari memakai Stored Procedure adalah:
		1. Mengurangi network traffic dan sedikit membantu performance.
		2. Lebih secure ketimbang aplikasi harus menggunakan banyak sql query untuk melakukan satu aktifitas.
		3. Code yang bisa dipakai berulang-ulang.
		4. Lebih mudah di maintain.
*/

/*
	Untuk membuat satu Store Procedure baru, bisa menggunakan code:
	CREATE PROC atau CREATE PROCEDURE, lalu buatlah BEGIN dan END block untuk menandai awalan dan akhir dari satu procedure.
*/

CREATE PROC dbo.SelectAllStudent
AS
BEGIN
	SELECT *
	FROM dbo.Student;
END

/*Untuk meng-eksekusi satu SP yang telah dibuat sebelumnya, gunakan EXECT atau EXECUTE*/
EXEC dbo.SelectAllStudent;

/*
	BEGIN dan END block tidak wajib ditulis untuk membuat SP, terutama apabila hanya mengeksekusi satu statement.
	Tapi ada baiknya di tulis untuk menyatakan kalau semuanya masih termasuk satu kesatuan dalam procedure.

	Di sini juga diberikan contoh bahwa tidak hanya function, SP juga bisa menerima parameters.
*/
CREATE PROCEDURE dbo.FindStudentByPenjurusan
@penjurusan AS varchar(500)
AS
	SELECT stud.FirstName
	FROM dbo.Student AS stud
	WHERE stud.Penjurusan LIKE @penjurusan;
	b

--Pemberian tanda N digunakan untuk unicode declaration, apabila paramaternya memiliki tipe Nvarchar 
--dan kalian ingin memasukan unicode character, harus memakai N di depan string.
EXECUTE dbo.FindStudentByPenjurusan @penjurusan = N'%Information%' ;



/*Berikut ini diberikan contoh sebuah SP yang menerima lebih dari satu parameter dengan tipe data yang berbeda.*/
CREATE PROCEDURE dbo.FindCarByStudentAndColor
@student_id AS int,
@color AS varchar(50)
AS
BEGIN
	SELECT cr.Brand, cr.Model, cr.PoliceNumber
	FROM dbo.Car AS cr
	WHERE cr.StudentID = @student_id AND cr.Color LIKE '%'+ @color +'%'
END

/*Kurang lebih seperti ini lah cara meng-eksekusi SP yang memiliki 2 parameters.*/
EXECUTE dbo.FindCarByStudentAndColor
	@student_id = 21,
	@color = 'Sil';

/*Sama seperti table, function dan view, menghapus SP juga menggunakan DROP*/
DROP PROCEDURE dbo.FindCarByStudentAndColor;

/*Penulisan parameters pada SP juga bisa menggunakan parameter brackets ().*/
CREATE PROCEDURE dbo.FindCarByStudentAndColor
(@student_id AS int,
@color AS varchar(50))
AS
BEGIN
	SELECT cr.Brand, cr.Model, cr.PoliceNumber
	FROM dbo.Car AS cr
	WHERE cr.StudentID = @student_id AND cr.Color LIKE '%'+ @color +'%'
END

USE Ecommerce;

/*
	Berikut ini adalah contoh SP dimana menggunakan Table-Type Parameters, sama seperti function,
	SP juga bisa melakukan hal yang sama.

	Di bawah ini merupakan contoh sebuah procedure yang digunakan pada table e-commerce sederhana
	dalam proses pembelian cart dari pembeli dan meng-update seluruh table yang bersangkutan.
*/
CREATE PROCEDURE dbo.ProceedPurchase
(@buyer_id AS VARCHAR(10),
@shipment_name AS VARCHAR(20),
@cart_table AS CartTableType READONLY)
AS
BEGIN
	DECLARE @totalHargaInvoice AS MONEY;
	SET @totalHargaInvoice = dbo.HitungTotalCart(@shipment_name, @cart_table);

	INSERT INTO dbo.Purchase(BuyerID, ShipmentName, Total, PurchaseDate)
	VALUES (@buyer_id, @shipment_name, @totalHargaInvoice, GETDATE());

	DECLARE @purchase_id AS BIGINT = SCOPE_IDENTITY();
	INSERT INTO dbo.PurchaseDetail(PurchaseID, ProductCode, Quantity, Total)
	SELECT @purchase_id, cart.ProductCode, cart.Quantity, dbo.ProductMultiplication(cart.Quantity, cart.ProductCode)
	FROM @cart_table AS cart
END

/*
	Cart atau isi keranjang yang ingin dibeli.
	Note: CartTableType sudah dibuat sebelumnya di chapter function.
*/
DECLARE @CartTable AS CartTableType
	INSERT INTO @CartTable
		VALUES (2, 'P11'), (2, 'P12');

EXECUTE dbo.ProceedPurchase
	@buyer_id = 'B3',
	@shipment_name = 'JNE',
	@cart_table = @CartTable;

/*
	Procedure tidak memiliki returns statement, oleh karena ini itu OUTPUT Parameter bisa digunakan untuk me-return value yang terjadi
	di dalam procedures. OUTPUT bisa mengembalikan lebih dari 1.
*/
CREATE PROCEDURE dbo.CountProductBySeller(
	@seller_id AS VARCHAR(10),
	@product_count INT OUTPUT
) AS
BEGIN
	SELECT prod.[Name], prod.Category, prod.Description
	FROM dbo.Product AS prod
	WHERE prod.SellerID = @seller_id;

	SELECT @product_count = @@ROWCOUNT;
END;

/*Menerima OUTPUT ke dalam variable @count.*/
DECLARE @count AS INT;
EXECUTE dbo.CountProductBySeller
	@seller_id = 'S1',
	@product_count = @count OUTPUT;
SELECT @count AS 'Number of products found';

USE Company;

/*
	Dibawah ini adalah contoh meng-eksekusi sebuah SP dan langsung meng-insertnya ke dalam sebuah
	User-defined Table variable.
*/
CREATE PROCEDURE dbo.GetDepartmentEmployee AS
BEGIN
	SELECT emp.[Name] AS [Employee Name], dep.[Name] AS [Department]
	FROM dbo.Employee AS emp
	JOIN dbo.Department AS dep ON emp.DepartmentID = dep.ID
END

CREATE TYPE DepartmentEmployeeType AS TABLE
(
	[Employee Name] VARCHAR(200) NOT NULL,
	Department VARCHAR(20) NOT NULL
);

DECLARE @combination_table AS dbo.DepartmentEmployeeType;

INSERT INTO @combination_table
EXECUTE dbo.GetDepartmentEmployee;

SELECT *
FROM @combination_table;
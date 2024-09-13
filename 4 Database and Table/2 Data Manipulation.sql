--Menggunakan database yang baru di buat untuk college.
USE Kampus; 
select * from student

/*DML (Data Manipulation Language): adalah perintah-perintah sql yang digunakan untuk memanipulasi isi data di dalam setiap table.*/

/*INSERT INTO  dan VALUES digunakan untuk menginput data value ke dalam setiap column yang sudah ada di dalam table*/
INSERT INTO dbo.Student VALUES
('12/2019/0001', 'Brian', 'Karl', 'Johnson', '122067890', 'M', '1988-11-27', '0815789990', 'brian.karl@gmail.com', '547 Florence Street', '2019-12-6'),
('12/2019/0002', 'Mark', NULL, 'Seneva', '124567890', 'M', '1988-11-27', '08158953468', 'mark.seneva@gmail.com', '4525 Rollins Road', '2019-12-6'),
('1/2020/0001', 'Tessa', NULL, 'Carolina', '1443337890', 'F', '1990-12-2', '08158988468', 'tessa.carolina@gmail.com', '2552 Heron Way', '2020-1-6');

/*INSERT INTO bisa menggunakan named column, sehingga kita bisa menyebutkan columnya satu-persatu agar bisa jelas dicocokan bersama valuenya.*/
INSERT INTO dbo.Student (StudentNumber, FirstName, MiddleName, LastName, IDCardNumber, Gender, BirthDate, PhoneNumber, Email, [Address], RegisterDate)
VALUES
('12/2020/0001', 'Sudharshan', null , 'Yannick', '1789945590', 'M', '1988-10-24', '0814768890', 'sudharshan@gmail.com', '521 Narwhal Street', '2020-12-6'),
('12/2020/0002', 'Metody', null , 'Winnifred', '87997945590', 'F', '1978-10-18', '0815678890', 'metody@gmail.com', '123 Pitt Street', '2020-12-8');

/*Keuntungan lain dari named column adalah kita bisa bebas mengatur urutan input valuesnya sesuai dengan column namenya.*/
INSERT INTO dbo.Student (RegisterDate, StudentNumber, FirstName, LastName, Gender, BirthDate, IDCardNumber, PhoneNumber, [Address], Email)
VALUES
('2020-12-11', '12/2020/0003', 'Hazel', 'Ray', 'M', '1991-04-05', '9873495720', '0816123455', '78 Harrison Park', 'hazel.ray@gmail.com');

/*UPDATE digunakan untuk meng-update/ edit data di dalam row.*/
UPDATE dbo.Student
	SET FirstName = 'Bruce', Email = 'bruce.karl@gmail.com'
	WHERE StudentNumber = '12/2019/0001';
/*Hati-hati dalam meng-update, tidak menggunakan where akan membuat semua orang memiliki nama dan email bruce.*/

/*DELETE digunakan untuk meng-hapus data di dalam row.*/
DELETE dbo.Student
	WHERE StudentNumber = '1/2020/0001';
/*Sama seperti update, tidak menggunakan where akan membuat semua row data di hapus.*/

/*
	Hati-hati untuk merubah table, kita tidak bisa menambahkan table yang sudah ada datanya, 
	dengan column not null, karena nanti sifatnya akan paradox, not null tapi kenyataannya null.

	Column not null hanya bisa ditambahkan pada saat table masih kosong.
*/
/*
ALTER TABLE dbo.Student
	ADD City varchar(50) NOT NULL;
*/

/*Lain halnya dengan yang nullable, kita masih bisa menambahkan columnnya walaupun table sudah terisi penuh.*/
ALTER TABLE dbo.Student
	ADD MobileNumber varchar(50) NULL, Country varchar(50) NULL;

/*Penambahan isi table yang menggunakan Foreign Key harus berurutan, kalau Foreign Keynya belum exist di PRIMARY KEY yang lain, maka tidak akan bisa.*/
INSERT INTO dbo.Car(StudentNumber, PoliceNumber, Model, Brand, Color)
VALUES
('12/2019/0001', 'B6703SN', 'Avanza', 'Toyota', 'Silver'),
('12/2019/0001', 'B6883AN', 'Brio', 'Honda', 'Velvet'),
('12/2019/0001', 'B8883AJ', 'Jazz', 'Honda', 'Silver'),
('12/2019/0001', 'B6663SN', 'Fortuner', 'Toyota', 'Black'),
('12/2019/0001', 'B1234LM', 'Tucson', 'Hyundai', 'Black');
-- Perhatikan, table Car tidak menginput ID sama sekali, karena ID nya berasal dari ID identity pertambahan otomatis, atau auto increment.

INSERT INTO dbo.[Subject](Major, [Name], StudentNumber, [Description], CreditPoint)
VALUES
('Information Technology', 'OOP', '12/2019/0001', 'Mempelajari konsep Object Oriented Programming', 25),
('Information Technology', 'Data Structure', '12/2019/0001', 'Mempelajari pembuatan struktur collection dalam C++', 30),
('Information Technology', '3D Computer Graphic', '12/2019/0001', NULL, 10),
('Design and Architecture', '3D Computer Graphic', '12/2019/0001', NULL, 10);

INSERT INTO dbo.[Topic](ID, Major, SubjectName, Topic, [Description])
VALUES
(1, 'Information Technology', 'OOP', 'Function and Parameter', 'Declaring function and Invoking function.'),
(2, 'Information Technology', 'OOP', 'Class and Constructor', 'Overriding constructor and instantiate new object.'),
(3, 'Information Technology', 'Data Structure', 'Array', NULL),
(4, 'Information Technology', 'Data Structure', 'Linked List', NULL),
(5, 'Information Technology', 'Data Structure', 'Hash Map', NULL),
(6, 'Information Technology', '3D Computer Graphic', 'Autodesk Maya', NULL),
(7, 'Design and Architecture', '3D Computer Graphic', 'Autodesk Autocad', NULL);

/*SELECT INTO bisa digunakan untuk select apa pun dari table, lalu membuat table baru bersamaan dengan seluruh data yang ada.*/
SELECT IDENTITY(INT, 1,1) AS ID, CONCAT(stud.FirstName, ' ', stud.LastName) AS StudentName, 
stud.IDCardNumber, CONCAT(car.Brand, ' ', car.Model) AS Car, car.PoliceNumber
INTO dbo.[Ownership]
FROM dbo.Student AS stud
LEFT JOIN dbo.Car AS car ON stud.StudentNumber = car.StudentNumber;

/*Atau Alternatifnya, buat dulu table yang akan ditempatkan baru migrasi data yang ada.*/
CREATE TABLE dbo.[Ownership](
	ID INT NOT NULL IDENTITY(1,1),
	StudentName VARCHAR(200) NOT NULL,
	IDCardNumber VARCHAR(100) NOT NULL,
	Car VARCHAR(200) NULL,
	PoliceNumber VARCHAR(10) NULL,
	CONSTRAINT PK_Ownership_ID PRIMARY KEY (ID)
);
INSERT INTO dbo.[Ownership]
SELECT CONCAT(stud.FirstName, ' ', stud.LastName) AS StudentName, stud.IDCardNumber, CONCAT(car.Brand, ' ', car.Model) AS Car, car.PoliceNumber
FROM dbo.Student AS stud
LEFT JOIN dbo.Car AS car ON stud.StudentNumber = car.StudentNumber;

/*
	Kita juga bisa membersihkan sebuah table dengan TRUNCATE.
	TRUNCATE TABLE digunakan untuk clear isi table, kurang lebih fungsinya sama seperti DELETE tanpa filter WHERE.
	Tetapi TRUNCATE sangat disarankan karena performancenya yang lebih baik dari DELETE tanpa filter.
*/
TRUNCATE TABLE dbo.Car;


/*
	Ini jika insert dengan default
*/
  --Insert into Transaksi
  --values (Default, 'Jakarta', 1, '', NULL, '3431241614699981', '081274834399', 1, 5500000, 500000, Default, Default, Default)


/*
	MERGE akan membuat sebuah table di replace dengan table yang baru, objective dari merge adalah membuat isi data table yang lama
	sama persis dengan isi table yang baru diupdate.

	Daripada melakukan langkah menghapus semua isi table lalu mengisinya lagi, kita bisa menggunakan merge untuk efficiency performance
	yang lebih baik.
*/
Use UpdatingEmployee;

MERGE dbo.CurrentEmployee AS cur
USING dbo.NewEmployee AS new
ON cur.EmployeeNo = new.EmployeeNo
WHEN MATCHED THEN
	UPDATE SET
		cur.Department = new.Department,
		cur.[Level] = new.[Level]
WHEN NOT MATCHED BY TARGET THEN
	INSERT (EmployeeNo, [Name], Department, [Level])
		VALUES (EmployeeNo, [Name], Department, [Level])
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;

/*
	MATCHED: Kondisi dimana column yang dicari match dari yang new dan yang current, lalu meng-update dan memperbarui column yang di-inginkan.
	NOT MATCHED BY TARGET/ NOT MATCHED: apabila di dalam column current belum memiliki apa yang new miliki, sehingga akan di add atau ditambahkan ke table.
	NOT MATCHED BY SOURCE: apabila di dalam table yang baru sudah tidak ditemukan informasi row dari table yang lama, sehingga di row yang current akan dihapus.
*/
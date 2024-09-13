USE College;

/*
	OUTPUT clause adalah hal yang baru di introduce di SQL 2015. Digunakan untuk mengambil informasi data row value ketika terjadi INSERT, UPDATE, DELETE atau MERGE
	dalam suatu action.
*/

/*Gunakan INSERTED. untuk mengambil informasi yang baru dimasukan/ baru di insert.*/
INSERT INTO dbo.Car(StudentNumber, PoliceNumber, Model, Brand, Color)
OUTPUT INSERTED.ID, INSERTED.StudentNumber, INSERTED.PoliceNumber, INSERTED.Model, INSERTED.Brand, INSERTED.Color 
VALUES('12/2019/0002', 'B7734LM', 'Sirion', 'Daihatsu', 'Black');

DECLARE @car_output AS TABLE(
	ID INT,
	StudentNumber VARCHAR(20),
	PoliceNumber VARCHAR(10),
	Model VARCHAR(100),
	Brand VARCHAR(100),
	Color VARCHAR(50)
);

/*
	Contoh di atas menunjukan kita mendapatkan seluruh informasi lewat operasi OUTPUT, tetapi data tersebut hanya di tampilkan saja.
	Untuk menyimpan hasil output ke dalam table type variable, bisa dilihat dari contoh di bawah ini:
*/
INSERT INTO dbo.Car(StudentNumber, PoliceNumber, Model, Brand, Color)
OUTPUT INSERTED.ID AS ID, INSERTED.StudentNumber AS StudentNumber, INSERTED.PoliceNumber AS PoliceNumber, INSERTED.Model AS Model, INSERTED.Brand AS Brand, INSERTED.Color AS Color INTO @car_output
VALUES('12/2019/0002', 'B8834LM', 'Aventador', 'Lamborghini', 'Black');

SELECT * FROM @car_output;

/*
	Selain menggunakan keyword INSERT, kita juga bisa menggunakan keyword DELETE pada saat proses menghapus.
*/
UPDATE dbo.Car
	SET PoliceNumber = 'B2222', Model = 'Enzo', Brand = 'Ferrari'
	OUTPUT DELETED.PoliceNumber, INSERTED.Model
	WHERE ID = 1;

DELETE dbo.Car
	OUTPUT DELETED.ID, DELETED.StudentNumber, DELETED.PoliceNumber, DELETED.Model, DELETED.Brand, DELETED.Color
	WHERE ID = 2;
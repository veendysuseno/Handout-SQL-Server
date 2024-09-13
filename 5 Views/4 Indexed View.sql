--USE Atlas;
/*Sebelum memulai mengeksekusi contoh, pastikan Country.ID, State.ID, City.ID adalah PK, dan semua terhubung dalam Foreign Key.*/

/*
	Indexed View adalah view dengan UNIQUE CLUSTERED INDEX.
	Indexed view sangat significant dalam membantu menarik banyak data, terutama apabila ada banyak proses aggregating banyak data dan join banyak table.
	Tetapi indexed view akan kurang baik digunakan apabila banyak perubahan pada table atau pada data di table aslinya.
*/

/*
	Pada pembuatan view kali ini, kalian bisa melihat kita menggunakan WITH SCHEMABINDING dibelakang nama view.
	Schemabinding adalah mechanisme pengunci yang memastikan bahwa table yang bersangkutan tidak bisa di alter atau di drop, 
	terkecuali view ini di alter atau di drop terlebih dahulu.

	Note: Kalau kita mencoba membuat indexed view tanda schemabinding, SQL server akan menghasilkan error
	"Cannot create index on view, because the view is note schema bound".
*/
CREATE VIEW dbo.USACity WITH SCHEMABINDING AS (
	SELECT cit.ID AS [ID], cit.[Name] AS [Name], sta.[Name] AS [State], cou.[Name] AS Country
	FROM dbo.City AS cit
	JOIN dbo.[State] AS sta ON cit.StateID = sta.ID
	JOIN dbo.Country AS cou ON sta.CountryID = cou.ID
	WHERE cou.SortName LIKE '%US%'
);
GO
CREATE UNIQUE CLUSTERED INDEX IX_USACity_ID ON dbo.USACity(ID);

/*Bisa di check resultnya di execution plan*/
SELECT *
FROM dbo.USACity AS us;

--Anda tidak bisa DROP COLUMN query di bawah ini, karena sedang dipakai oleh View ini.
ALTER TABLE dbo.City
	DROP COLUMN [Name];

/*
	Pada saat kita membuat Index View, diciptakan materialized view diciptakan
	Materialized View adalah views yang sudah di record di dalam hard disk terlebih dahulu, jadi lebih seperti table normal.
	Di dalam materialized view, semua aggregation dan join di proses terlebih dahulu, bukan pada saat execution di detik itu.
*/

/*
	Tetapi walaupun kita sudah membuat UNIQUE CLUSTERED INDEX, query optimizer bisa tidak menggunakan index yang baru kita buat pada
	view ini. Ini sering terjadi bila query optimizer merasa bisa melakukannya lebih baik dengan table yang ada.
*/
SELECT us.[Name], us.[State]
FROM dbo.USACity AS us
WHERE us.[State] LIKE '%Arizona%';

/*Untuk memaksa query optimizer menggunakan UNIQUE CLUSTERED INDEX, kita bisa menggunakan perintah WITH (NOEXPAND) seperti di bawah ini.*/
SELECT us.[Name], us.[State]
FROM dbo.USACity AS us WITH (NOEXPAND)
WHERE us.[State] LIKE '%Arizona%';
/*Pada pelajaran kali ini, kita akan menggunakan database Atlas, dimana berisikan table Negara, Provinsi/State, dan Kota.*/
USE Atlas;

/*
	INDEX: adalah sebagian memory pada database yang di reserve untuk dijadikan alat bantu mencari data yang sesuai dengan keinginan.
	Cara kerja index pada database sama seperti index alphabet pada kamus yang bentuknya berlubang-lubang, 
	atau seperti daftar isi pada sebuah buku di halaman pertama,
	atau seperti halaman index pada akhir buku, yang gunanya untuk membantu pembaca dalam mencari halaman yang sesuai.

	Tanpa sadar selama ini kita sudah membuat index dengan sebagian constraint-contraint yang kita gunakan, 
	seperti Primary Key dan Unique Constraint. Tetapi kita bisa membuat INDEX sendiri tanpa constrain-constrain itu.
*/

--Untuk melakukan test sebuah index, cobalah jalankan query di bawah ini dengan menjalankan windows Execution Plan, lalu amatilah.
SELECT cou.SortName
FROM dbo.Country AS cou;
/*
	Query ini dilakukan pada table Country, dimana table country tidak memiliki Primary Key dan Index sama sekali.
	Proses pencarian SortName negara di perlihatkan sebagai "Table Scan" pada Execution Plan.

	Table Scan adalah nama proses dimana proses pencarian dilakukan tanpa menggunakan index sama sekali.
*/

/* Berhati-hatilah dalam menggunakan (MAX) pada tipe data seperti Varchar dan Nchar, karena tidak bisa dijadikan index.
CREATE INDEX idx_country
ON dbo.Country([Name]);
*/

--Buatlah index dengan menggunakan perintah CREATE INDEX
CREATE INDEX IDX_Country_SortName
ON dbo.Country(SortName);

/*
	Hasil index yang telah dibuat bisa di check atau di dalam folder "Indexes" atau bisa juga di check lewat
	sp_helpindex seperti cara di bawah ini.
*/
EXEC sp_helpindex 'dbo.Country';

--Coba jalankan query ini satu kali lagi dan lihat hasil Execution Plannya.
SELECT cou.SortName
FROM dbo.Country AS cou;
/*
	Sebelum diberikan index, physical operation dan logical operation pada query diberi nama Table Scan.
	Setelah diberikan index, physical operation dan logical operation pada query diberi nama Index Scan, dan total Costnya pun berbeda.
	Query yang dilakukan terhadap index terbukti menghemat performance.

	Pada folder index bisa dilihat index yang baru saja kita buat memiliki keterangan (Non-Unique, Non-Clustered)
	Apa yang dimaksud dengan ini? Ya karena index sangat berbeda-beda dan beragam, yang baru kita buat by default adalah Non-Unique dan Non-Clustered Index.
*/

--Tapi cobalah untuk menjalankan query di bawah ini, maka hasilnya akan kembali lagi menjadi Table Scan. Karena query tidak berhubungan dengan SortName.
SELECT cou.[Name]
FROM dbo.Country AS cou;

--Gunakan DROP INDEX untuk menghapus existing index
DROP INDEX IDX_Country_SortName ON dbo.Country;

/*
	Clustered Index: Index yang disimpan di table/di row setiap data.

	Berikut ini beberapa traits yang dimiliki Clustered Index:
	1. Clustered Index selalu di susun (sorted) secara otomatis, dan collection index ini selalu tersusun dalam Binary Tree.
	2. Binary tree adalah teknik men-split data menjadi 2 bagian (cluster) sama rata, dalam hal ini indexnya, lalu di setiap potongan akan dibagi menjadi 2 lagi, 
	   terus di split menjadi 2 sampai akhirnya menunjuk ke setiap invidu data. Binary Tree dalam data structure selalu digunakan untuk performance mencari sesuatu dengan cepat.
	   Bisa diperumpamakan, apabila kita diminta mencari kartu "King Hati" di dalam tumpukan sebuah deck kartu poker yang disusun berurut dari 2 ke AS, maka kita pasti akan
	   membaginya menjadi 2 tumpukan, dan membuang tumpukan teratas, karena tidak mungkin kita temukan kartu King di top 50% teratas. Lalu kita akan split terus kartunya sampai
	   pada akhirnya kita menemukan King Hati. Begitulah cara kerja Binary Tree.
	3. Clustered Index hanya bisa 1 node untuk setiap rownya, dan 1 root node untuk setiap tablenya.
	4. Clustered Index harus selalu sorted dalam sebuah order, sehingga waktu yang digunakan untuk menambah, meng-edit atau menghapus existing data bisa membuat system
	   menyusun atau membereskan lagi Tree dan susunan yang ada, dan ini bisa memakan performance.
	5. Oleh karena sorted dan tersusun dalam binary tree, pencarian data memiliki perfomance yang maximal.
	6. Membuat Primary Key akan secara otomatis membuat Unique Clustered Key.
	7. Cluster Index di simpan di row setiap table, satu untuk masing-masing row dan informasi satu row terikat padanya seperti sebuah kesatuan object.
*/

/*
	Coba tambahkan PK ke dalam table, secara otomatis diciptakan index dengan nama PK_Country_ID.
	Karena PK sudah pasti memiliki tipe Clustered Index.
*/
ALTER TABLE dbo.Country
 ADD CONSTRAINT PK_Country_ID PRIMARY KEY (ID);

/*Begitu juga dengan UNIQUE CONSTRAINT, UNIQUE CONSTRAINT akan langsung menghasilkan UNIQUE INDEX.*/
ALTER TABLE dbo.Country 
 ADD CONSTRAINT UQ_Country_SortName UNIQUE (SortName);

--atau simplenya untuk membuat Clustered Index bisa menggunakan CREATE CLUSTERED INDEX
CREATE CLUSTERED INDEX IX_State_ID
ON dbo.[State](ID);

--atau simplenya untuk membuat Unique Index bisa menggunakan CREATE UNIQUE INDEX
CREATE UNIQUE INDEX IX_City_ID
ON dbo.City(ID);

/*
	Tapi bisa dilihat dari hasil PK, Unique Constraint, bahwa sebenarnya antara Primary Key dan Clustered Key hal yang berbeda.
	Begitu pula Unique Constraint dengan Unique Key adalah hal yang berbeda.
*/

--Kita bisa menghapus 2 Index ini dengan menggunakan DROP INDEX
DROP INDEX IX_City_ID
ON dbo.City;

DROP INDEX IX_State_ID
ON dbo.[State];

--Kita tidak bisa menghapus PK dengan menggunakan DROP INDEX
DROP INDEX PK_Country_ID
ON dbo.Country;

--Kita juga tidak bisa menghapus Unique Constraint menggunakan DROP INDEX
DROP INDEX UQ_Country_Sortname
ON dbo.Country;

--Kita juga bisa membuat UNIQUE CLUSTERED INDEX 
CREATE UNIQUE CLUSTERED INDEX IX_State_ID
ON dbo.[State](ID)

/*Dari SSMS, unique clustered index yang baru saja kita buat, hanya tampil sebagai Clustered Index.
Gunakan sp_helpindex untuk melihat setiap traits dari indexnya.*/
EXEC sp_helpindex 'dbo.State';

/*
	Sebenarnya UNIQUE CONSTRAINT dan UNIQUE INDEX hampir sama.
	UNIQUE CONSTRAINT lebih dilihat dari perspective CONSTRAINT, sedangkan UNIQUE lebih dilihat dari perspective VALUE.
	UNIQUE CONSTRAINT dan UNIQUE KEY membatasi value data pada column tersebut bersifat unik atau tidak ada yang duplikat.

	UNIQUE CONSTRAINT sudah pasti UNIQUE KEY.
*/

/* Kedua INSERT dibawah ini tidak bisa berfungsi karena ada UNIQUE
INSERT INTO dbo.Area(ID, Code, [Name], [Description])
VALUES
(1, 'WS', 'West', 'Daerah Barat'),
(1, 'EA', 'East', 'Daerah Timur');

INSERT INTO dbo.Area(ID, Code, [Name], [Description])
VALUES
(1, 'WS', 'West', 'Daerah Barat'),
(2, 'WS', 'East', 'Daerah Timur');
*/

/*Execution plan akan menghasilkan operation Clustered Index Scan, dan keduanya memiliki additional Filter Process*/
SELECT *
FROM dbo.Country AS cou
WHERE cou.[Name] LIKE '%Jersey%';

SELECT cou.ID
FROM dbo.Country AS cou
WHERE cou.[Name] LIKE '%Jersey%';

/*
	Tetapi Clustered Index akan membantu dalam performance pencarian column clustered index yang bersangkutan, sehingga tidak ada lagi additional Filter.
	WHERE clause pada ID akan membuat operation 2 queries dibawah ini menjadi Clustered Index Seek, dan Estimated Number of Rows menjadi 1.
*/
SELECT *
FROM dbo.Country AS cou
WHERE cou.ID = 110;

SELECT cou.ID
FROM dbo.Country AS cou
WHERE cou.ID = 110;

/*
	COMPOSITE CLUSTERED INDEX, adalah clustered index yang tersusun lebih dari satu column, 
	sama seperti composite key (composite pk akan secara otomatis membuat composite clustered index).

	Ubah index dari country menjadi composite index sebagai berikut ini.
*/
CREATE CLUSTERED INDEX IX_Atlas_ID_SortName
ON dbo.Country(ID, SortName);

/*Coba ke-empat query di bawah ini dan perhatikan Execution Plannya.*/
SELECT *
FROM dbo.Country AS cou
WHERE cou.ID = 110;

SELECT *
FROM dbo.Country AS cou
WHERE cou.SortName LIKE '%XJ%';

SELECT *
FROM dbo.Country AS cou
WHERE cou.ID = 110 AND cou.SortName LIKE '%XJ%';

SELECT cou.ID
FROM dbo.Country AS cou
WHERE cou.[Name] LIKE '%Jersey%';

/*
	Non-Clustered Index: 
	1. Non-Clustered Index tidak di sort (susun) sama sekali dalam sequential order, tetapi walaupun seperti itu non-clustered tree.
	2. Pencarian data lewat index dibantu oleh IAM (Index Allocation Map) di dalam PAGES & EXTENT. IAM bisa diibaratkan seperti halaman daftar isi di paling belakang buku.
	   Note: Walaupun Clustered Index juga terdaftar di IAM, tetapi hanya tercatat 1 root node, dan pencarian dilakukan oleh Sorted Binary Tree.
	3. Non-Clustered Index bisa dibuat banyak untuk satu row/ satu table. Non-Clustered Index bisa dibuat sampai maximal 999 index per table.
	4. Perubahan Data dengan Non-Clustered Index tidak memakan banyak performance sampai seperti Clustered Index, namun dalam kasus pencarian data dengan frekuensi sering
	   Clustered Index lebih cepat dari Non-Clustered Index. Update data pada Non-Clustered Index hanya menambahkan datanya ke paling akhir (siapa cepat dia duluan).
	5. Performance pencarian pada Non-Clustered Index tidak semaximal pada Clustered Index, karena data tidak di simpan pada row yang sama, pencarian Binary Tree juga tidak dalam
	   keadaan sorted.
	6. Non-clustered Index seluruh pointernya disimpan di IAM (Index Allocation Map) dan menunjuk ke columnnya secara independent tanpa ada keterikatan dengan row.
	7. Kita bisa melakukan filter dan menggunakan INCLUDE untuk Non-Clustered Index.
*/

/*Berikut ini cara membuat non-clustered index*/
CREATE NONCLUSTERED INDEX IX_City_ID
ON dbo.City(ID);

/* By default tanpa menulis "NONCLUSTERED", index akan dibuat non-clustered.
CREATE INDEX IX_City_ID
ON dbo.City(ID);
*/

/*
	Saat ini table dbo.City adalah sebuah Heaps.

	Heaps adalah table yang tidak memiliki clustered index sama sekali.
	Satu-satunya kemungkinan heaps digunakan adalah apabila tablenya kecil dan biasa di akses oleh non clustered index.

	Dalah hal ini kita akan menggunakan heaps pada table yang tidak sedikit jumlah rownya.
*/

/*
	Setelah membuat 1 non-clustered index pada dbo.City, cobalah membuat 7 queries di bawah ini.
	Lalu perhatikan hasil execution plannya.
*/
--Query 1
SELECT *
FROM dbo.City AS cit
WHERE cit.ID = 176;
--Query 2
SELECT cit.ID
FROM dbo.City AS cit;
--Query 3
SELECT cit.ID
FROM dbo.City AS cit
WHERE cit.ID = 176;
--Query 4
SELECT *
FROM dbo.City AS cit;
--Query 5
SELECT *
FROM dbo.City AS cit
WITH(INDEX(IX_City_ID));
--Query 6
SELECT cit.ID
FROM dbo.City AS cit
WITH(INDEX(IX_City_ID));
--Query 7
SELECT *
FROM dbo.City AS cit
WITH(INDEX(IX_City_ID))
WHERE cit.ID = 176;
--Query 8
SELECT cit.ID
FROM dbo.City AS cit
WITH(INDEX(IX_City_ID))
WHERE cit.ID = 176;

/*
	Query 1, 5, dan 7 memiliki process yang disebut dengan RID Lookup (Heap).

	RID adalah singkatan dari ROWID atau Row Identifier. 
	Row ID adalah usaha putus asa sebuah query menggunakan non-clustered index untuk mencari informasi column yang bukan index pada sebuah table heap.

	Apabila proses RID Lookup terjadi, query tersebut tidak efektif atau slow performance, mengapa?
	Itu dijelaskan pada point 6 di non-clustered index:
	"6. Non-clustered Index seluruh pointernya disimpan di IAM (Index Allocation Map) dan menunjuk ke columnnya secara independent tanpa ada keterikatan dengan row."

	Contohnya pada query 1, walaupun kita mencari cit.ID yang 176, query tetap harus mencari sisa Name, dan StateID pada row tersebut, karena
	ID tidak memiliki keterikatan dengan Name dan StateID, oleh karena itu query tetap akan melakukan nested loop untuk mencari sisa column.

	Pada Query 2, terjadi Index Scan, bukan Index Seek,
	tetapi performance tetap tidak begitu buruk karena tidak perlu adanya RID Lookup untuk column di luar non-clustered index nya.

	Pada Query 3, performance maximum di Index Seek, dan query tidak mem-perdulikan row atau column lain, sehingga pencariannya langsung dari
	IAM menuju value yang dicari.

	Pada Query 4, index tidak ada influence membantu sama sekali di sini, sehingga total proses berada di Table Scan.

	Pada Query 5, dengan menggunakan WITH(INDEX), kita bisa mengubah yang tadinya table scan menjadi RID Lookup. 
	WITH (INDEX) bisa memaksa query untuk melakukan RID lookup.

	Hasilnya akan sama saja untuk Query 6 - 8.
*/

/*
	Non-Clustered Composite Index, adalah non-clustered index yang tersusun dari composite column atau lebih dari satu column.
	Cobalah hapus dan buat ulang index pada country menjadi NON-CLUSTERED COMPOSITE INDEX seperti di bawah ini.
*/
CREATE NONCLUSTERED INDEX IX_Country_ID_SortName
ON dbo.Country(ID, SortName);

/*Cobalah berexperiment terhadap beberapa query di bawah ini.*/
SELECT cou.ID
FROM dbo.Country AS cou;

SELECT cou.SortName
FROM dbo.Country AS cou;

SELECT cou.ID, cou.SortName
FROM dbo.Country AS cou;

SELECT cou.ID, cou.SortName, cou.[Name]
FROM dbo.Country AS cou;

SELECT cou.ID
FROM dbo.Country AS cou
WHERE cou.ID = 110;

SELECT cou.SortName
FROM dbo.Country AS cou
WHERE cou.SortName = 'XJ';

SELECT cou.ID, cou.SortName
FROM dbo.Country AS cou
WHERE cou.ID = 110;

/*
	Non-Clustered Filtered Index

	Karena non-clustered index hanya dikonsentrasikan pada single value, dan tidak keseluruhan rownya,
	kita tidak harus memasukan seluruh value di dalam satu column untuk dimasukan ke dalam IAM.

	Kita bisa memilih hanya value tertentu untuk masuk ke dalam IAM. Oleh karena itu
	non-clustered index bisa kita filter dengan menggunakan WHERE clause.
*/
--Ini artinya hanya ID 1 - 99 yang masuk kedalam IAM
CREATE NONCLUSTERED INDEX IX_City_ID
ON dbo.City(ID)
WHERE ID < 99;

--Execution Plan akan memasukannya ke dalam Index Seek operation
SELECT cit.ID
FROM dbo.City AS cit
WHERE cit.ID = 67;

--Execution Plan akan memasukannya ke dalam Table Scan operation
SELECT cit.ID
FROM dbo.City AS cit
WHERE cit.ID = 122;

/*
	Non-Clustered Index With Include adalah non cluster index yang mengikutsertakan non-key column ke dalam IAM.
	Sehingga column-column tersebut juga bisa di select dengan performance yang lebih baik.
*/

--Ubahlah key pada country dan gunakan key yang baru di bawah ini dengan include.
CREATE INDEX IX_Country_ID
ON dbo.Country(ID)
INCLUDE (SortName, PhoneCode);

SELECT cou.ID, cou.SortName, cou.PhoneCode
FROM dbo.Country AS cou;

/*Query di bawah ini masih kena table scan. Karena column name tidak di include*/
SELECT cou.ID, cou.[Name]
FROM dbo.Country AS cou;

SELECT cou.ID, cou.SortName, cou.PhoneCode
FROM dbo.Country AS cou
WHERE cou.ID = 13;

SELECT cou.ID, cou.SortName, cou.PhoneCode
FROM dbo.Country AS cou
WHERE cou.SortName = 'AU';

/*Query di bawah ini masih kena table scan. Karena column name tidak di include*/
SELECT cou.ID, cou.SortName, cou.PhoneCode
FROM dbo.Country AS cou
WHERE cou.[Name] = 'Burundi';
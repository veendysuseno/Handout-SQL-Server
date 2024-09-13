/*
	Ada 2 macam security yang ada:
	1. Server Logins: logins diciptakan pada server level. Dengan login seseorang bisa mengakses ke SQL Server Service
	2. Database Users: users diciptakan pada database level. Dengan users, seseorang bisa mengakses ke setiap database yang ada pada service.

	Buatlah contoh Server Login seperti di bawah ini:
	1. Username: velvet, Password: merah, Role: sysadmin
	2. Username: viridian, Password: hijau, Role: securityadmin
	3. Username: cerulean, Password: biru, Role: bulkadmin
	4. Username: vermilion, Password: bata, Role: dbcreator
	5. Username: tan, Password: coklat, Role: public
*/
/*
	CREATE LOGIN adalah perintah yang digunakan untuk membuat logins.
*/
CREATE LOGIN velvet WITH PASSWORD = 'merah', DEFAULT_DATABASE=master;
GO
ALTER SERVER ROLE sysadmin ADD MEMBER velvet;
/*
	Bisa juga sebuah logins dibuat lewat SSMS dengan cara:
	1. Pergi ke Folder Security > Logins
	2. Click kanan > New Login... > Pilih SQL-Server Authentication
	3. Setting seluruhnya di dalam pop-up window.

	Dari 5 logins di atas hanya velvet yang bisa mengakses seluruh database, itu karena role-nya adalah sysadmin.
	Sisa logins yang lain tidak bisa mengakses database dikarenakan tidak memiliki user di setiap database.

	Ada macam-macam role untuk login, sebagian di antaranya kurang lebih:
	1. sysadmin: role yang bisa melakukan aktifitas apa saja di server dan di setiap database.
	2. serveradmin: role yang bisa melakukan konfigurasi di level server bahkan mematikan server, tetapi tidak mendapatkan akses ke informasi database.
    3. securityadmin: role ini bertanggung jawab memanage role lain dan propertiesnya. Mereka juga bisa melakukan DCL (akan dijelaskan nanti) untuk database level permission hanya apabila
		mereka diberi ijin terhadap database tersebut.
	4. bulkadmin: role yang bisa melakukan BULK INSERT (akan di jelaskan nanti)
	5. dbcreator: role ini memiliki hak untuk melakukan perubahan database seperti create, alter atau drop database.
	6. public: setiap logins yang dibuat di level sql server, by default pasti mendapat public role. Setiap control dari public bisa diatur oleh role lain dengan DCL.
*/

/*
	Cobalah membuat satu logins dengan spesifikasi sebagai berikut:
	Username: violet, Password: ungu, Role: public
	tetapi dengan User Mapping ke databases: Hospital, GirlFlower, Ecommerce.

	Lalu check "Security > Users" Folder di dalam setiap database Hospital, GirlFlower, Ecommerce.
	Di sana bisa dilihat bahwa ada Database User dengan nama violet.
	
	violet pada Server Logins berbeda dengan violet pada Database Users, walaupun mereka memiliki username yang sama.
	Itu dikarenakan violet yang Database Users dibuat secara otomatis dari wizard di dalam logins.

	Cobalah login dengan violet dan coba akses Hospital, GirlFlower dan Ecommerce.
	Lalu coba akses database-database yang lainnya. Di sini bisa jelas apa kegunaan dari Database Users.
	Selain ketiga database di atas, seluruh database di larang untuk diakses.

	Cobalah mengakses database GirlFlower, lalu check Tablesnya. Ya memang terlihat kosong, karena
	user Violet belum mendapatkan akses ke setiap tablenya.
	Masuk kembali sebagai velvet, lalu pergi ke GirlFlower > Security > Users > violet
	lalu click kanan di violet > Properties > Securables. Di sini kita bisa menambahkan otoritasnya untuk setiap table.

	Cobalah membuat database user langsung pada database yang bersangkutan tanpa lewat logins dengan menggunakan user velvet.
*/
USE Atlas;

CREATE USER alex FOR LOGIN tan
GO
ALTER USER alex WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER alex 
GO

/*Role dbo_owner akan membuat user dapat langsung mengakses seluruh database.*/
/*
	Satu logins hanya memiliki 1 database user di setiap database.
	Dalam hal ini tan tidak bisa lagi memiliki database user lain di dalam atlas, tetapi bisa di database lain.
*/

/*Gunakan database Bioskop untuk memulai experiment DCL*/
USE Bioskop;
/*Buatlah seorang database user untuk logins tan dengan username: jessica*/

/*DCL (Data Control Language): SQL yang digunakan untuk melakukan pengaturan keamanan.*/

/*GRANT: digunakan DBA untuk menambah atau memberikan permission ke database user.*/

/*Kita memberi ijin jessica untuk melakukan operasi SELECT pada table dbo.Bioskop*/
GRANT SELECT
ON dbo.Bioskop
TO jessica;

--Kasih beberapa sekaligus
GRANT SELECT, INSERT, UPDATE, DELETE
ON dbo.[Location]
TO jessica;

--All isinya: SELECT, INSERT, UPDATE, DELETE and REFERENCES. Tapi All sudah deprecated dan mungkin hanya berfungsi di sql versi tertentu saja.
GRANT ALL
ON dbo.Theater
TO jessica;

--Untuk seluruh users
GRANT SELECT
ON dbo.Ticket
TO public;

/*REVOKE: mencabut atau menghapus GRANT atau DENY yang sudah diberikan pada user.*/
REVOKE SELECT
ON dbo.[Location]
FROM jessica;

REVOKE DELETE
ON dbo.[Location]
FROM jessica;

/*DENY: digunakan DBA untuk melarang user tertentu untuk melakukan penggunaan terhadap database.*/
DENY UPDATE
ON dbo.[Location]
TO jessica;
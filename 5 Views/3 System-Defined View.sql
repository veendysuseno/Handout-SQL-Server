/*
	System-Defined View adalah view yang diciptakan oleh sql server system di setiap database untuk alasan dan tujuan tertentu.
	
	Ada 2 macam views di dalam system-defined view di dalam sql server:
	1. Information Schema: Standard Catalog metadata yang digunakan untuk melihat informasi "fisik" dari database, seperti tablenya, 
		column, constrain, dan view.
	2. sys Catalog View: metadata catalog yang dibuat oleh sybase pertamakali pada saat pembuatan sql server. Kebanyakan dari Information Schema
		juga di dapat dari sini.
*/

USE Northwind;

/*Melihat semua informasi column yang ada.*/
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;
SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE;

/*DMV (Dynamic Management Views): view yang mengembalikan informasi server state yang bisa digunakan untuk mengawasi kondisi database dan server.*/

/*
	Arti namespacing dari DMV yang sudah di-registered:

	1. db: database related information
	2. exe: query execution-related information
	3. io: I/O statistic
	4. os: SQL server operating system
	5. tran: Transaction Related Info
*/
SELECT wait_type, wait_time_ms  
FROM sys.dm_os_wait_stats;  

SELECT session_id, login_time, [program_name]
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;
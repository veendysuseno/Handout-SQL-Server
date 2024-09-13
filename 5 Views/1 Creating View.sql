USE University;

/* 
	View adalah table virtual yang dihasilkan dari sebuah query yang diberi nama dan di simpan dalam catalog view, 
	yang nantinya table value hasil querynya bisa digunakan nanti oleh query lain.
	
	Beberapa sifat-sifat view:
	1. 1 view cuma terdiri dari satu query.
	2. Saat ingin membuat view, tidak boleh ada statement lain di dalam query.
	3. View digunakan untuk kebutuhan re-usable query.
	4. Di database, view tidak menyimpan hasil, tapi hanya menyimpan querynya saja.

*/

CREATE VIEW dbo.CombinationSubjectTopic AS(
	SELECT sub.[Name], sub.Major, sub.[Description] AS [Subject Description], subTop.Topic, subTop.[Description] AS [Topic Description] 
	FROM dbo.[Subject] AS sub
	JOIN dbo.SubjectTopic AS subTop ON sub.[Name] = subTop.SubjectName
	AND sub.Major = subTop.Major
);

SELECT *
FROM dbo.CombinationSubjectTopic;

--Kita bisa mengubah view dengan cara alter view
ALTER VIEW dbo.CombinationSubjectTopic AS(
	SELECT sub.[Name], sub.Major, sub.[Description] AS [Subject Description], subTop.Topic
	FROM dbo.[Subject] AS sub
	JOIN dbo.SubjectTopic AS subTop ON sub.[Name] = subTop.SubjectName
	AND sub.Major = subTop.Major
);

--Kita bisa menghapus view dengan cara command DROP VIEW lalu nama viewnya.
DROP VIEW dbo.CombinationSubjectTopic;

/*
Seperti pada derived tables, subqueries, CTE, inline function, View tidak bisa dibuat
dengan statement ORDER BY tanpa ketentuan TOP atau OFFSET atau FOR XML.

CREATE VIEW dbo.OrderedSubjectTopic AS(
	SELECT sub.[Name], sub.Major, sub.[Description] AS [Subject Description], subTop.Topic
	FROM dbo.[Subject] AS sub
	JOIN dbo.SubjectTopic AS subTop ON sub.[Name] = subTop.SubjectName
	AND sub.Major = subTop.Major
	ORDER BY sub.[Name]
);
*/

CREATE VIEW dbo.TopTwoSubjectTopic AS(
	SELECT TOP 2 sub.[Name], sub.Major, sub.[Description] AS [Subject Description], subTop.Topic
	FROM dbo.[Subject] AS sub
	JOIN dbo.SubjectTopic AS subTop ON sub.[Name] = subTop.SubjectName
	AND sub.Major = subTop.Major
	ORDER BY sub.[Name]
);
USE Northwind;

/*Perhatikan database Northwind, di sana sudah tersedia banyak view yang sudah dibuatkan sebelumnya*/

--Bisa dilihat view ini adalah kombinasi dari table product dan categorynya, dimana productnya masih di-produksi.
SELECT *
FROM dbo.[Alphabetical list of products];

--Bisa dilihat view ini digunakan untuk menginformasikan nilai bersih penjualan setiap produk beserta kategorinya di tahun 1997.
SELECT *
FROM dbo.[Product Sales for 1997];

--Lalu view di bawah ini adalah view yang menggunakan view yang ada di atas sebelumnya.
SELECT *
FROM dbo.[Category Sales for 1997];

WITH ProductSummary([ID], [Product Name], [Category], Supplier) AS
(
	SELECT ext_prod.ProductID, ext_prod.ProductName, ext_prod.CategoryName, sup.CompanyName
	FROM dbo.[Alphabetical list of products] AS ext_prod
	JOIN dbo.Suppliers AS sup ON ext_prod.SupplierID = sup.SupplierID
),
OrderSummary([Order Date], [Extended Price], ProductID) AS
(
	SELECT ord.OrderDate, ord_ext.ExtendedPrice, ord_ext.ProductID
	FROM [Order Details Extended] AS ord_ext
	JOIN dbo.Orders AS ord ON ord_ext.OrderID = ord.OrderID
)
SELECT ordSum.[Order Date], prodSum.[Product Name], prodSum.Category, prodSum.Supplier, ordSum.[Extended Price]
FROM ProductSummary AS prodSum 
JOIN OrderSummary AS ordSum ON prodSum.ID = ordSum.ProductID;
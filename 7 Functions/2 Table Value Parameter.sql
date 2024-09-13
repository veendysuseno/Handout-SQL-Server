USE Ecommerce;

/*
	Table-valued parameters adalah parameter di dalam user-defined function yang menggunakan 
	tipe data user-defined table type.

	Table-valued parameter harus ditandai dengan READONLY parameters untuk bisa berfungsi.
	Di dalam body fungsi, kita tidak bisa melakukan INSERT, UPDATE atau DELETE untuk parameter tersebut.
*/

/*Buatlah terlebih dahulu user-defined function yang akan digunakan.*/
CREATE TYPE CartTableType AS TABLE (
	Quantity INT NOT NULL,
	ProductCode VARCHAR(20) NOT NULL
);

/*Buatlah function yang menggunakan table-valued parameter seperti di bawah ini:*/
CREATE FUNCTION dbo.HitungTotalCart(@ShipmentName AS VARCHAR(20), @CartTable AS CartTableType READONLY)
RETURNS MONEY AS
BEGIN
	DECLARE @selectedShipCost AS MONEY;
	DECLARE @totalItemCost AS MONEY;
	DECLARE @totalCost AS MONEY;

	SELECT @selectedShipCost = ship.Cost
	FROM dbo.Shipment AS ship
	WHERE ship.[Name] = @ShipmentName;

	WITH QuantityPrice AS(
		SELECT (cart.Quantity * prod.Price) AS Total
		FROM @CartTable AS cart
		JOIN dbo.Product AS prod ON cart.ProductCode = prod.Code
	)
	SELECT @totalItemCost = SUM(Total)
	FROM QuantityPrice;

	SET @totalCost = @selectedShipCost + @totalItemCost
	RETURN @totalCost;
END

/*INSERT data ke dalam satu variable dengan Data Type Table*/
DECLARE @CartTable AS CartTableType
	INSERT INTO @CartTable
		VALUES (2, 'P11'), (2, 'P12');

/*Call fungsi HitungTotalCart*/
SELECT dbo.HitungTotalCart('JNE', @CartTable);
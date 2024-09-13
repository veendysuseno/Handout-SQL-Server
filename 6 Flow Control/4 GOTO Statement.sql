/*Statement GOTO digunakan agar eksekusi sebuah line bisa jump ke statement lain-lain yang diberi nama.*/

DECLARE @pressedButton INT = 2;
IF @pressedButton = 1 GOTO DrinkOne;
IF @pressedButton = 2 GOTO DrinkTwo;
IF @pressedButton = 3 GOTO DrinkThree;
IF @pressedButton = 4 GOTO DrinkFour;

DrinkOne:
	PRINT 'Coca-cola';
	GOTO ExtraOne;

DrinkTwo:
	PRINT 'Sprite';
	GOTO ExtraOne;

DrinkThree:
	PRINT 'Es Jelly';
	GOTO ExtraTwo;

DrinkFour:
	PRINT 'Fanta';
	GOTO ExtraOne;

ExtraOne:
	PRINT 'Sedotan';

ExtraTwo:
	PRINT 'Sendok';

/*
	Notice kalau sendok masih dijalankan, itulah kelemahan dari GOTO, karena seluruh proses setelahnya masih akan dijalankan.
	Seluruh statement tetap akan dijalankan seperti selayaknya seluruh code dijalan-kan baris-perbaris.

	Sendok masih di jalankan , sedangkan Es Jelly dan Fanta di skip karena statementnya GO TO ExtraOne, yaitu sedotan, tetapi karena
	Sendok berada setelah sedotan, maka akan tetap di jalankan.

	Trivia: GOTO ini persis seperti GOTO pada programming language seperti java, C# dan C++
*/
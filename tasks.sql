USE module_5_matskiv;
GO

/*Запити з використанням під-запитів*/


SELECT * FROM supplies ORDER BY productid;
/*1.	Отримати номери виробів, для яких всі деталі постачає постачальник 3*/
SELECT p.productid
FROM products AS p 
WHERE NOT EXISTS (SELECT * FROM supplies WHERE supplierid<>3 AND productid=p.productid);
GO

/*2.	Отримати номера і прізвища постачальників, які постачають деталі для якого-небудь виробу з деталлю 1 в кількості більшій, ніж середній об’єм поставок деталі 1 для цього виробу*/
SELECT sr.supplierid,sr.name
FROM suppliers AS sr JOIN supplies AS sp
ON sr.supplierid=sp.supplierid
WHERE sp.detailid=1 AND sp.quantity>(SELECT AVG(quantity) FROM supplies WHERE detailid=1 AND productid=sp.productid);
GO

/*3.	Отримати повний список деталей для всіх виробів, які виготовляються в Лондоні*/
SELECT DISTINCT details.*
FROM supplies JOIN details
ON supplies.detailid=details.detailid
WHERE productid IN(SELECT productid
				   FROM products
				   WHERE city LIKE 'London');
GO

/*4.	Показати номери і назви постачальників, що постачають принаймні одну червону деталь*/
SELECT supplierid,[name]
FROM suppliers
WHERE supplierid IN (
	SELECT DISTINCT supplierid
	FROM supplies JOIN details
	ON supplies.detailid=details.detailid
	WHERE details.color='red'
);
GO

/*5.	Показати номери деталей, які використовуються принаймні в одному виробі, який поставляється постачальником 2*/
SELECT DISTINCT detailid
FROM supplies
WHERE supplierid=2;
GO

/*6.	Отримати номери виробів, для яких середній об’єм поставки деталей  більший за найбільший об’єм поставки будь-якої деталі для виробу 1*/
SELECT productid
FROM supplies
GROUP BY productid
HAVING AVG(quantity)>(SELECT MAX(quantity) FROM supplies WHERE productid=1); 
GO

/*7.	Вибрати вироби, що ніколи не постачались (під-запит)*/
SELECT *
FROM products
WHERE productid NOT IN(SELECT DISTINCT productid FROM supplies);
GO


/*UNION, UNION ALL , EXCEPT, INTERSECT*/

/*8.	Вибрати постачальників з Лондона або Парижу*/
SELECT * FROM suppliers
WHERE city LIKE 'Paris'
UNION 
SELECT * FROM suppliers
WHERE city LIKE 'London';
GO

/*9.	Вибрати всі міста, де є постачальники  і/або деталі (два запити – перший повертає міста з дублікатами, другий без дублікатів) . Міста у кожному запиті  відсортувати в алфавітному порядку */
SELECT city FROM suppliers
UNION 
SELECT city FROM details
ORDER BY city;
GO

SELECT city FROM suppliers
UNION ALL
SELECT city FROM details
ORDER BY city;
GO

/*10.	Вибрати всіх постачальників за вийнятком тих, що постачають деталі з Лондона */
SELECT * FROM suppliers
EXCEPT 
SELECT * FROM suppliers
WHERE supplierid IN (SELECT DISTINCT supplierid 
					 FROM supplies JOIN details
					 ON supplies.detailid=details.detailid
					 WHERE details.city LIKE 'London');
GO

/*11.	Знайти різницю між множиною продуктів, які знаходяться в Лондоні та Парижі  і множиною продуктів, які знаходяться в Парижі та Римі*/
(SELECT * FROM products
WHERE city LIKE 'London'
UNION
SELECT * FROM products
WHERE city LIKE 'Paris')
EXCEPT
(SELECT * FROM products
WHERE city LIKE 'Paris'
UNION
SELECT * FROM products
WHERE city LIKE 'Roma');
GO

/*12.	Вибрати поставки, що зробив постачальник з Лондона, а також поставки зелених деталей за виключенням поставлених виробів з Парижу (код постачальника, код деталі, код виробу)*/
SELECT supplierid,detailid,productid
FROM supplies 
WHERE supplierid IN(SELECT supplierid FROM suppliers
					WHERE city LIKE 'London')
UNION
SELECT supplierid,detailid,productid
FROM supplies
WHERE detailid IN(SELECT detailid FROM details
				  WHERE color LIKE 'green')
EXCEPT 
SELECT supplierid,detailid,productid
FROM supplies 
WHERE productid IN(SELECT productid FROM products
				   WHERE city LIKE 'Paris');
GO


/*Запити використовуючи CTE  або Hierarchical queries*/

/*13.	Написати довільний запит з двома СТЕ  (в одному є звертання до іншого) */
/*Поставки в яких постачальник і виріб із одного міста та к-сть поставки більша середньої к-сті поставок поточного виробу*/
;WITH avg_quantity(productid,avgQ) AS
(SELECT productid,AVG(quantity)
FROM supplies
GROUP BY productid),

coolQ AS
(SELECT *
FROM supplies
WHERE quantity>(SELECT avgQ FROM avg_quantity WHERE productid=supplies.productid))

SELECT main.supplierid,sup.name AS sup_name,main.productid,pr.name AS pr_name,sup.city,main.detailid,det.name AS det_name, det.city AS det_city
FROM coolQ AS main
JOIN details AS det ON det.detailid=main.detailid
JOIN suppliers AS sup ON sup.supplierid=main.supplierid
JOIN products AS pr ON pr.productid=main.productid
WHERE sup.city=pr.city;
GO

/*14. Обчислити за допомогою рекурсивної CTE факторіал від 10  та вивести у форматі таблиці з колонками Position та Value */
;WITH factorial (pos, val) AS 
(SELECT 1,1 
UNION ALL 
SELECT pos + 1, (pos + 1) * val
FROM factorial
WHERE pos < 10)

SELECT pos,val
FROM factorial;
GO

/*15.	Обчислити за допомогою рекурсивної CTE перші 20 елементів ряду Фібоначчі та вивести у форматі таблиці з колонками Position та Value  */
;WITH fib (pos, prev,val) AS 
(SELECT 1,0,1
UNION ALL 
SELECT pos+1, val,val+prev
FROM fib
WHERE pos < 20)

SELECT pos,val
FROM fib;
GO

/*16.	Розділити вхідний період 2013-11-25 до 2014-03-05 на періоди по календарним місяцям за допомогою рекурсивної CTE та вивести у форматі таблиці з колонками StartDate та EndDate  */
DECLARE @startdate DATE='2013/11/25'    
DECLARE @enddate DATE='2014/03/05'

;WITH cte([date]) AS
(SELECT @startdate
UNION ALL
SELECT DATEADD(d,1,[date])
FROM cte
WHERE [date]<@enddate)

SELECT [date] AS StartDate,CASE
						   WHEN MONTH([date]) <> MONTH(@enddate) THEN EOMONTH([date])
						   ELSE @enddate
						   END AS EndDate 
FROM cte
WHERE DAY([date]) = 1 OR [date] = @startdate
OPTION (MAXRECURSION 0);
GO

/*17.	Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday*/
DECLARE @start DATE = DATEADD(d, 1, EOMONTH(GETDATE(), -1))
DECLARE @end DATE = EOMONTH(@start)

;WITH cte([date],[dayNum]) AS
(SELECT @start, DATEPART(WEEKDAY,@start)
UNION ALL
SELECT DATEADD(d,1,[date]),DATEPART(WEEKDAY,DATEADD(d,1,[date]))
FROM cte
WHERE [date]<@end)

SELECT [1] AS Monday,[2] AS Tuesday,[3] AS Wednesday,[4] AS Thursday,[5] AS Friday,[6] AS Saturday,[7] AS Sunday
FROM (SELECT DATEPART(WEEK, [date]) AS weekNum, DAY([date]) AS [date],[dayNum]
	  FROM cte) AS Dates
PIVOT(
  MIN([date]) FOR [dayNum] 
  IN ([1],[2],[3],[4],[5],[6],[7])
) AS [pivot]
GO

/*18.	Написати запит  який повертає регіони першого рівня (результат нижче)*/
;WITH cte (region_id, place_id, name, [PlaceLevel]) AS
(SELECT region_id,id, name, 0 
FROM [geography]
WHERE region_id IS NULL
UNION ALL 
SELECT  g.region_id,g.id, g.name, [PlaceLevel]+1
FROM [geography] g
JOIN cte 
ON g.region_id = cte.place_id)

SELECT * 
FROM cte
WHERE [PlaceLevel] = 1;
GO

/*19.	Написати запит який повертає під-дерево для конкретного регіону  (наприклад, Івано-Франківськ) */
DECLARE @region VARCHAR(20) ='Ivano-Frankivsk' 

;WITH cte (region_id, id, name, [level]) AS
(
      SELECT region_id, id, name, -1
      FROM [geography]
      WHERE name=@region
      UNION ALL 
      SELECT g.region_id, g.id, g.name, [level]+1
      FROM [geography] g
      JOIN cte 
	  ON g.region_id = cte.id
)
SELECT * 
FROM cte
WHERE [level]>=0
ORDER BY [level];
GO  

/*20.	Написати запит котрий вертає повне дерево  від root ('Ukraine') і додаткову колонку, яка вказує на рівень в ієрархії*/
;WITH cte (region_id, place_id, name, [PlaceLevel]) AS
(SELECT region_id,id, name, 0 
FROM [geography]
WHERE region_id IS NULL
UNION ALL 
SELECT  g.region_id,g.id, g.name, [PlaceLevel]+1
FROM [geography] g
JOIN cte 
ON g.region_id = cte.place_id)

SELECT * 
FROM cte;
GO  

/*21.	Написати запит який повертає дерево для регіону Lviv */
DECLARE @region VARCHAR(20) ='Lviv' 

;WITH cte (region_id, id, name, [level]) AS
(
      SELECT region_id, id, name, 1
      FROM [geography]
      WHERE name=@region
      UNION ALL 
      SELECT g.region_id, g.id, g.name, [level]+1
      FROM [geography] g
      JOIN cte 
	  ON g.region_id = cte.id
)
SELECT * 
FROM cte
ORDER BY [level];
GO  

/*22.	Написати запит який повертає дерево зі шляхами для регіону Lviv*/
DECLARE @region VARCHAR(20) ='Lviv' 

;WITH cte ([name],id,[level],[path]) AS
(
      SELECT [name], id, 1, CAST(CONCAT('/',[name]) AS VARCHAR)
      FROM [geography]
      WHERE [name] = @region
      UNION ALL 
      SELECT g.[name],g.id,[level]+1,CAST(CONCAT([path],'/',g.[name]) AS VARCHAR)
      FROM [geography] g
      JOIN cte 
	  ON g.region_id = cte.id
)
SELECT [name],[level] AS id,[path] 
FROM cte;
GO  

/*23.	Написати запит, який повертає дерево  зі шляхами і довжиною шляхів для регіону Lviv*/
DECLARE @region VARCHAR(20) ='Lviv' 

;WITH cte ([name],center,id,[level],[path]) AS
(
      SELECT [name],[name], id, 0, CAST(CONCAT('/',[name]) AS VARCHAR)
      FROM [geography]
      WHERE [name] = @region
      UNION ALL 
      SELECT g.[name],cte.center,g.id,[level]+1,CAST(CONCAT([path],'/',g.[name]) AS VARCHAR)
      FROM [geography] g
      JOIN cte 
	  ON g.region_id = cte.id
)
SELECT [name] AS Region,center,[level] AS pathlen,[path] 
FROM cte
WHERE [level]>0;
GO

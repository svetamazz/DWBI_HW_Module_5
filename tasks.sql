USE module_5_matskiv;
GO

/*������ � ������������� ��-������*/


SELECT * FROM supplies ORDER BY productid;
/*1.	�������� ������ ������, ��� ���� �� ����� ������� ������������ 3*/
SELECT p.productid
FROM products AS p 
WHERE NOT EXISTS (SELECT * FROM supplies WHERE supplierid<>3 AND productid=p.productid);
GO

/*2.	�������� ������ � ������� �������������, �� ���������� ����� ��� �����-������ ������ � ������� 1 � ������� ������, �� ������� �ᒺ� �������� ����� 1 ��� ����� ������*/
SELECT sr.supplierid,sr.name
FROM suppliers AS sr JOIN supplies AS sp
ON sr.supplierid=sp.supplierid
WHERE sp.detailid=1 AND sp.quantity>(SELECT AVG(quantity) FROM supplies WHERE detailid=1 AND productid=sp.productid);
GO

/*3.	�������� ������ ������ ������� ��� ��� ������, �� �������������� � ������*/
SELECT DISTINCT details.*
FROM supplies JOIN details
ON supplies.detailid=details.detailid
WHERE productid IN(SELECT productid
				   FROM products
				   WHERE city LIKE 'London');
GO

/*4.	�������� ������ � ����� �������������, �� ���������� �������� ���� ������� ������*/
SELECT supplierid,[name]
FROM suppliers
WHERE supplierid IN (
	SELECT DISTINCT supplierid
	FROM supplies JOIN details
	ON supplies.detailid=details.detailid
	WHERE details.color='red'
);
GO

/*5.	�������� ������ �������, �� ���������������� �������� � ������ �����, ���� ������������� �������������� 2*/
SELECT DISTINCT detailid
FROM supplies
WHERE supplierid=2;
GO

/*6.	�������� ������ ������, ��� ���� ������� �ᒺ� �������� �������  ������ �� ��������� �ᒺ� �������� ����-��� ����� ��� ������ 1*/
SELECT productid
FROM supplies
GROUP BY productid
HAVING AVG(quantity)>(SELECT MAX(quantity) FROM supplies WHERE productid=1); 
GO

/*7.	������� ������, �� ����� �� ����������� (��-�����)*/
SELECT *
FROM products
WHERE productid NOT IN(SELECT DISTINCT productid FROM supplies);
GO


/*UNION, UNION ALL , EXCEPT, INTERSECT*/

/*8.	������� ������������� � ������� ��� ������*/
SELECT * FROM suppliers
WHERE city LIKE 'Paris'
UNION 
SELECT * FROM suppliers
WHERE city LIKE 'London';
GO

/*9.	������� �� ����, �� � �������������  �/��� ����� (��� ������ � ������ ������� ���� � ����������, ������ ��� ��������) . ̳��� � ������� �����  ����������� � ���������� ������� */
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

/*10.	������� ��� ������������� �� ��������� ���, �� ���������� ����� � ������� */
SELECT * FROM suppliers
EXCEPT 
SELECT * FROM suppliers
WHERE supplierid IN (SELECT DISTINCT supplierid 
					 FROM supplies JOIN details
					 ON supplies.detailid=details.detailid
					 WHERE details.city LIKE 'London');
GO

/*11.	������ ������ �� �������� ��������, �� ����������� � ������ �� �����  � �������� ��������, �� ����������� � ����� �� ���*/
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

/*12.	������� ��������, �� ������ ������������ � �������, � ����� �������� ������� ������� �� ����������� ����������� ������ � ������ (��� �������������, ��� �����, ��� ������)*/
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


/*������ �������������� CTE  ��� Hierarchical queries*/

/*13.	�������� �������� ����� � ����� ���  (� ������ � ��������� �� ������) */
/*�������� � ���� ������������ � ���� �� ������ ���� �� �-��� �������� ����� �������� �-�� �������� ��������� ������*/
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

/*14. ��������� �� ��������� ���������� CTE �������� �� 10  �� ������� � ������ ������� � ��������� Position �� Value */
;WITH factorial (pos, val) AS 
(SELECT 1,1 
UNION ALL 
SELECT pos + 1, (pos + 1) * val
FROM factorial
WHERE pos < 10)

SELECT pos,val
FROM factorial;
GO

/*15.	��������� �� ��������� ���������� CTE ����� 20 �������� ���� Գ������� �� ������� � ������ ������� � ��������� Position �� Value  */
;WITH fib (pos, prev,val) AS 
(SELECT 1,0,1
UNION ALL 
SELECT pos+1, val,val+prev
FROM fib
WHERE pos < 20)

SELECT pos,val
FROM fib;
GO

/*16.	�������� ������� ����� 2013-11-25 �� 2014-03-05 �� ������ �� ����������� ������ �� ��������� ���������� CTE �� ������� � ������ ������� � ��������� StartDate �� EndDate  */
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

/*17.	����������� �������� ��������� ����� �� ��������� ���������� CTE �� ������� �� ����� � ������ ������� � ��������� Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday*/
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

/*18.	�������� �����  ���� ������� ������ ������� ���� (��������� �����)*/
  
GO

/*19.	�������� ����� ���� ������� ��-������ ��� ����������� ������  (���������, �����-���������). ��������� �� ��������� ��������� ����� (������� ������ ���������� ������)*/

GO  

/*20.	�������� ����� ������ ����� ����� ������  �� root ('Ukraine') � ��������� �������, ��� ����� �� ����� � ��������*/

GO  

/*21.	�������� ����� ���� ������� ������ ��� ������ Lviv */

GO  

/*22.	�������� ����� ���� ������� ������ � ������� ��� ������ Lviv*/

GO  

/*23.	�������� �����, ���� ������� ������  � ������� � �������� ������ ��� ������ Lviv*/

GO

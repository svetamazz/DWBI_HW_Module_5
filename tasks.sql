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

GO
/*9.	������� �� ����, �� � �������������  �/��� ����� (��� ������ � ������ ������� ���� � ����������, ������ ��� ��������) . ̳��� � ������� �����  ����������� � ���������� ������� */

GO
/*10.	������� ��� ������������� �� ��������� ���, �� ���������� ����� � ������� */

GO
/*11.	������ ������ �� �������� ��������, �� ����������� � ������ �� �����  � �������� ��������, �� ����������� � ����� �� ���*/

GO
/*12.	������� ��������, �� ������ ������������ � �������, � ����� �������� ������� ������� �� ����������� ����������� ������ � ������ (��� �������������, ��� �����, ��� ������)*/

GO


/*������ �������������� CTE  ��� Hierarchical queries*/

/*13.	�������� �������� ����� � ����� ���  (� ������ � ��������� �� ������) */

GO
/*14. ��������� �� ��������� ���������� CTE �������� �� 10  �� ������� � ������ ������� � ��������� Position �� Value */

GO
/*15.	��������� �� ��������� ���������� CTE ����� 20 �������� ���� Գ������� �� ������� � ������ ������� � ��������� Position �� Value  */

GO
/*16.	�������� ������� ����� 2013-11-25 �� 2014-03-05 �� ������ �� ����������� ������ �� ��������� ���������� CTE �� ������� � ������ ������� � ��������� StartDate �� EndDate  */

GO
/*17.	����������� �������� ��������� ����� �� ��������� ���������� CTE �� ������� �� ����� � ������ ������� � ��������� Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday*/

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
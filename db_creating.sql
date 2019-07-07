USE MASTER;
GO
DROP DATABASE IF EXISTS module_5_matskiv
GO
CREATE DATABASE module_5_matskiv
GO

USE module_5_matskiv;
GO

CREATE TABLE suppliers(
supplierid INT NOT NULL IDENTITY PRIMARY KEY,
[name] VARCHAR(20),
rating INT,
city VARCHAR(20)
);
GO

CREATE TABLE details(
detailid INT NOT NULL IDENTITY PRIMARY KEY,
[name] VARCHAR(20),
color VARCHAR(20),
[weight] INT,
city VARCHAR(20)
);
GO

CREATE TABLE products(
productid INT NOT NULL IDENTITY PRIMARY KEY,
[name] VARCHAR(20),
city VARCHAR(20)
);
GO

CREATE TABLE supplies(
supplierid INT,
detailid INT,
productid INT,
quantity INT
);
GO

INSERT INTO suppliers VALUES
('Smith',20,'London'),
('Jonth',10,'Paris'),
('Blackie',10,'Paris'),
('Clarck',20,'London'),
('Adams',30,'Athens');
GO

INSERT INTO details VALUES
('Screw','Red',	12,'London'),
('Bolt','Green',17,'Paris'),
('Male-screw','Blue',17,'Roma'),
('Male-screw','Red',14,'London'),
('Whell','Blue',12,'Paris'),
('Bloom','Red',19,'London');
GO

INSERT INTO products VALUES
('HDD','Paris'),
('Perforator','Roma'),
('Reader','Athens'),
('Printer','Athens'),
('FDD','London'),
('Terminal','Oslo'),
('Ribbon','London');

GO

INSERT INTO supplies VALUES
(1,1,1,200),
(1,1,4,700),
(2,3,1,400),
(2,3,2,200),
(2,3,3,200),
(2,3,4,500),
(2,3,5,600),
(2,3,6,400),
(2,3,7,800),
(2,5,2,100),
(3,3,1,200),
(3,4,2,500),
(4,6,3,300),
(4,6,7,300),
(5,2,2,200),
(5,2,4,100),
(5,5,5,500),
(5,5,7,100),
(5,6,2,200),
(5,1,4,100),
(5,3,4,200),
(5,4,4,800),
(5,5,4,400),
(5,6,4,500);
GO

/*geography table*/
create table [geography]
(id int not null primary key, name varchar(20), region_id int);

ALTER TABLE [geography]
       ADD CONSTRAINT R_GB
              FOREIGN KEY (region_id)
                             REFERENCES [geography]  (id);


insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);

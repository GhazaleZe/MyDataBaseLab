use AdventureWorks2012
go

CREATE TABLE Production.ProductLogs(
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25),
	[MakeFlag] [dbo].[Flag] ,
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15),
	[SafetyStockLevel] [smallint] ,
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) ,
	[SizeUnitMeasureCode] [nchar](3) ,
	[WeightUnitMeasureCode] [nchar](3) ,
	[Weight] [decimal](8, 2) ,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) ,
	[Class] [nchar](2) ,
	[Style] [nchar](2) ,
	[ProductSubcategoryID] [int] ,
	[ProductModelID] [int] ,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] ,
	[DiscontinuedDate] [datetime] ,
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime] ,
	[Action] varchar(10)
	);
CREATE TABLE Production.ProductLogsCopy(
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25),
	[MakeFlag] [dbo].[Flag] ,
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15),
	[SafetyStockLevel] [smallint] ,
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) ,
	[SizeUnitMeasureCode] [nchar](3) ,
	[WeightUnitMeasureCode] [nchar](3) ,
	[Weight] [decimal](8, 2) ,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) ,
	[Class] [nchar](2) ,
	[Style] [nchar](2) ,
	[ProductSubcategoryID] [int] ,
	[ProductModelID] [int] ,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] ,
	[DiscontinuedDate] [datetime] ,
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime] ,
	[Action] varchar(10)
	);
select * from Production.Product
select * from Production.ProductLogs
drop table Production.ProductLogs
delete from Production.ProductLogsCopy
--question1**************************************************************
create trigger ProductTrigger 
ON  Production.Product
after insert
AS
begin
insert into Production.ProductLogs(ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,[Action])
select ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, [Weight], DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,'INSERT' from inserted
end

create trigger ProductTrigger1 
ON  Production.Product
after delete
AS
begin
insert into Production.ProductLogs(ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,[Action])
select ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, [Weight], DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,'DELETE' from deleted
end

create trigger ProductTrigger2
ON  Production.Product
after UPDATE
AS
begin
insert into Production.ProductLogs(ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,[Action])
select ProductID, [Name], ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, [Weight], DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate,'UPDATE' from inserted
end


INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate) 
values ('Yechizi', '12345Gh', 0, 0, NULL, 4000, 520,10000, 10000, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL,NULL, NULL, '2001-04-30 00:00:00.000', NULL, NULL, '694215b7-08f7-4c0d-acb1-d734bab4c0c8', '2014-02-08 10:01:36.827')
delete from Production.Product where ProductNumber= '12345Gh'


INSERT INTO Production.Product (Name, ProductNumber, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate) 
values ('YechiziDige', '123478Gh', 0, 0, NULL, 4000, 20,10000, 10000, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL,NULL, NULL, '2001-04-30 00:00:00.000', NULL, NULL, '694215b7-08f7-4c0d-acb1-d734bab4c0c8', '2016-02-09 10:01:36.827')
delete from Production.Product where ProductNumber= '123478Gh'
Update Production.Product set MakeFlag=1 where ProductNumber='123478Gh'

--question2********************************************************************************

insert into Production.ProductLogsCopy select * from Production.ProductLogs

select * from Production.ProductLogsCopy

UPDATE Production.ProductLogsCopy
set Color='Red' where ProductID=1003 and [Action]='INSERT'
UPDATE Production.ProductLogsCopy
set Color='YELLOW' where ProductID=1004 and [Action]='UPDATE'

--question3***************************************************************************

CREATE TABLE Production.ProductLogsChanged(
	[ProductID] [int] ,
	[Name] [dbo].[Name] ,
	[ProductNumber] [nvarchar](25),
	[MakeFlag] [dbo].[Flag] ,
	[FinishedGoodsFlag] [dbo].[Flag] ,
	[Color] [nvarchar](15),
	[SafetyStockLevel] [smallint] ,
	[ReorderPoint] [smallint] ,
	[StandardCost] [money] ,
	[ListPrice] [money] ,
	[Size] [nvarchar](5) ,
	[SizeUnitMeasureCode] [nchar](3) ,
	[WeightUnitMeasureCode] [nchar](3) ,
	[Weight] [decimal](8, 2) ,
	[DaysToManufacture] [int] ,
	[ProductLine] [nchar](2) ,
	[Class] [nchar](2) ,
	[Style] [nchar](2) ,
	[ProductSubcategoryID] [int] ,
	[ProductModelID] [int] ,
	[SellStartDate] [datetime] ,
	[SellEndDate] [datetime] ,
	[DiscontinuedDate] [datetime] ,
	[rowguid] [uniqueidentifier],
	[ModifiedDate] [datetime] ,
	[Action] varchar(10)
	);

select * from Production.ProductLogsChanged

CREATE PROCEDURE Changed
AS
BEGIN
WITH t as (select * from Production.ProductLogs except select * from Production.ProductLogsCopy)
insert into Production.ProductLogsChanged select * from t
END

EXECUTE Changed
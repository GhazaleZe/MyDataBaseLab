use AdventureWorks2012
Go
--q1*********************************************************************************
select * from Production.Product --ProductID,Name
select * from Sales.SalesTerritory --TerritoryID,Group
select * from Sales.SalesOrderDetail -- SalesOrderID,ProductID,OrderQty
select * from Sales.SalesOrderHeader -- SalesOrderID,TerritoryID

select [Name] , [Europe],[North America] , [Pacific]
from (Select Production.Product.[Name],Sales.SalesTerritory.[Group],Sales.SalesOrderDetail.OrderQty
from Production.Product,Sales.SalesOrderDetail,Sales.SalesOrderHeader,Sales.SalesTerritory
where Production.Product.ProductID=Sales.SalesOrderDetail.ProductID and Sales.SalesTerritory.TerritoryID=Sales.SalesOrderHeader.TerritoryID and Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID)
as mainT
PIVOT
(
COUNT (mainT.OrderQty)
for [Group] in ([Europe],[North America] , [Pacific])
)as PVT

--q2**********************************************************

select [PersonType],[M],[F] from
(select Person.Person.PersonType, HumanResources.Employee.Gender ,Person.Person.BusinessEntityID
from Person.Person join HumanResources.Employee on (Person.BusinessEntityID
= Employee.BusinessEntityID)) as mainT
PIVOT
(
COUNT (BusinessEntityID)
for Gender in ([M],[F])
)as PVT


--q3*******************************************************************************
select [Name] from Production.Product
Where LEN([Name]) <15 and PATINDEX('%e%',[Name]) = LEN([Name])-1

--q4*******************************************************************************
DROP FUNCTION TimeChecker
create function TimeChecker (@tarikh char(10))
Returns varchar(100)
as
begin
declare @ret varchar(100)
declare @pat varchar(10)
declare @mat varchar(10)
declare @pat1 varchar(10)
declare @mat1 varchar(10)
set @pat =RIGHT(@tarikh,2)
set @mat =LEFT (@tarikh,7)
set @pat1 =RIGHT(@mat,2)
set @mat1 =LEFT (@mat,4)
		if 
		(len(@tarikh) != 10 or (len(@pat)!=2 or ISNUMERIC(@pat)=0  ) or (len(@pat1)!=2 or ISNUMERIC(@pat1)=0) or (len(@mat1)!=4 or ISNUMERIC(@mat1)=0))
			set @ret ='Wrong format'
		else
			begin
				if @pat1='01'
					set @ret =@pat+ ' Farvardin mah '+@mat1+'shamsi'
				if @pat1='02'
					set @ret =@pat+ ' Ordibehesht mah '+@mat1+'shamsi'
				if @pat1='03'
					set @ret =@pat+ ' Khordad mah '+@mat1+'shamsi'
				if @pat1='04'
					set @ret =@pat+ ' Tir mah '+@mat1+'shamsi'
				if @pat1='05'
					set @ret =@pat+ ' Mordad mah '+@mat1+'shamsi'
				if @pat1='06'
					set @ret =@pat+ ' Shahrivar mah '+@mat1+'shamsi'
				if @pat1='07'
					set @ret =@pat+ ' Mehr mah '+@mat1+'shamsi'
				if @pat1='08'
					set @ret =@pat+ ' Aban mah '+@mat1+'shamsi'
				if @pat1='09'
					set @ret =@pat+ ' Azar mah '+@mat1+'shamsi'
				if @pat1='10'
					set @ret =@pat+ ' Day mah '+@mat1+'shamsi'
				if @pat1='11'
					set @ret =@pat+ ' Bahman mah '+@mat1+'shamsi'
				if @pat1='12'
					set @ret =@pat+ ' Esfand mah '+@mat1+'shamsi'
			end
			
		RETURN @ret;
end;

Select dbo.TimeChecker ('1399/01/03')
Select dbo.TimeChecker ('1399/11/23')
Select dbo.TimeChecker ('1399/01d/03')
Select dbo.TimeChecker ('13399/01/03')

--q5*************************************************************************************

select * from Production.Product where Production.Product.ProductID='777'--ProductID,Name
select * from Sales.SalesTerritory --TerritoryID,
select * from Sales.SalesOrderDetail  -- SalesOrderID,ProductID,OrderQty
select * from Sales.SalesOrderHeader -- SalesOrderID,TerritoryID,OrderDate



drop function sales.AtLeast_Once
create function Sales.AtLeast_Once(@month int ,@year int,@good varchar(50))
returns Table
as
return(
Select distinct Sales.SalesTerritory.[Name]
from Production.Product INNER JOIN Sales.SalesOrderDetail  
ON (Production.Product.ProductID=Sales.SalesOrderDetail.ProductID)
INNER JOIN Sales.SalesOrderHeader 
ON (Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID)
INNER JOIN Sales.SalesTerritory
on ( Sales.SalesTerritory.TerritoryID=Sales.SalesOrderHeader.TerritoryID )
where
year(Sales.SalesOrderHeader.OrderDate)=@year and month(Sales.SalesOrderHeader.OrderDate) = @month
and Production.Product.[Name]= @good   );

select * 
from Sales.AtLeast_Once(07, 2005,'Mountain-100 Black, 44')






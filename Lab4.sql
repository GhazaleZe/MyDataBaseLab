use AdventureWorks2012
Go
SELECT Sales.SalesOrderHeader.CustomerID,Sales.SalesOrderHeader.SalesOrderID,Sales.SalesOrderHeader.OrderDate,Sales.SalesOrderDetail.LineTotal,
AVG(Sales.SalesOrderDetail.LineTotal)OVER (PARTITION BY Sales.SalesOrderHeader.CustomerID
ORDER BY Sales.SalesOrderHeader.OrderDate, Sales.SalesOrderHeader.SalesOrderID
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM Sales.SalesOrderHeader JOIN Sales.SalesOrderDetail ON
(SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID)

-- q2*****************************

select * from Sales.SalesOrderHeader
select *  from sales.SalesTerritory

select CASE Grouping(Sales.SalesTerritory.[Name])
        when 0 then Sales.SalesTerritory.Name
        when 1  then 'ALL Territories'
        END AS TerritoryName, 
	    Case Grouping(Sales.SalesTerritory.[Group]) 
		When 1 then 'ALL Region'
		When 0 then Sales.SalesTerritory.[Group]
		END AS Region
		, Sum(Sales.SalesOrderHeader.SubTotal) as SalesTotal, Count(Sales.SalesOrderHeader.SalesOrderID) as SalesCount
from Sales.SalesTerritory INNER JOIN Sales.SalesOrderHeader ON (Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID)
GROUP BY ROLLUP(Sales.SalesTerritory.[Group],Sales.SalesTerritory.[Name])
Order by Sales.SalesTerritory.[Group],Sales.SalesTerritory.[Name]

--q3**********************************************************************

select * from Production.Product
select * from Production.ProductCategory
select * from Sales.SalesOrderDetail
select * from Production.ProductSubcategory

select  case GROUPING(Production.ProductSubcategory.[Name])
        when 0 then Production.ProductSubcategory.[Name]
        when 1 then 'ALL SubCat'
        END as SubCat,
        case GROUPING(Production.ProductCategory.Name)
        when 0 then Production.ProductCategory.Name
        when 1 then case GROUPING(Production.ProductSubcategory.Name)
                        when 0 then Production.ProductCategory.Name
                        when 1 then 'ALL Cat'
                        end
        END as Cat,
COUNT(Sales.SalesOrderDetail.OrderQty) as SalesCount,SUM(Sales.SalesOrderDetail.LineTotal) as SalesTotal
from Production.Product,Production.ProductCategory,Sales.SalesOrderDetail,Production.ProductSubcategory
where Production.Product.ProductID=Sales.SalesOrderDetail.ProductID AND Production.ProductCategory.ProductCategoryID=Production.ProductSubcategory.ProductCategoryID
AND Production.Product.ProductSubcategoryID=Production.ProductSubcategory.ProductSubcategoryID
Group by ROLLUP(Production.ProductCategory.[Name],Production.ProductSubcategory.[Name])
ORDER BY SubCat,Cat Desc
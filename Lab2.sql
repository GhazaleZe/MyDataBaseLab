
SELECT * from Sales.SalesOrderHeader;
SELECT * from Sales.SalesTerritory;
SELECT * from Sales.SalesPerson;
SELECT * from SAles.Store;
-- Q1***********************************************

SELECT * from Sales.SalesOrderHeader
WHERE Sales.SalesOrderHeader.TotalDue>100000 AND Sales.SalesOrderHeader.TotalDue<500000 and Sales.SalesOrderHeader.[Status]=5
INTERSECT
SELECT * from Sales.SalesOrderHeader
WHERE Sales.SalesOrderHeader.TerritoryID IN (SELECT Sales.SalesTerritory.TerritoryID
                                            FROM Sales.SalesTerritory
                                            WHERE Sales.SalesTerritory.[Group] ='North America' OR Sales.SalesTerritory.Name='France' );

-- Q2********************************************************


SELECT Sales.SalesOrderHeader.SalesOrderID, Sales.SalesOrderHeader.SalesPersonID,Sales.SalesOrderHeader.TotalDue,
Sales.SalesOrderHeader.ShipDate, Sales.Store.Name as StoreName
FROM Sales.SalesOrderHeader , Sales.SalesTerritory  ,Sales.Customer , Sales.Store
Where Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID AND
Sales.SalesOrderHeader.CustomerID= Sales.Customer.CustomerID AND Sales.Customer.StoreID=Sales.Store.BusinessEntityID;


-- Q3******************************************************************

WITH temp(ProductID, OrderQty, TerritoryID) AS 
    (select ProductID, SUM(OrderQty) as NumberOfSell, TerritoryID
    from sales.SalesOrderDetail INNER JOIN sales.SalesOrderHeader 
    ON (sales.SalesOrderDetail.SalesOrderID = sales.SalesOrderHeader.SalesOrderID)
    GROUP BY ProductID, TerritoryID),
    temp1 (ProductID,MuxNum) AS 
    (select ProductID, max(OrderQty) 
    from temp
    GROUP BY ProductID)    
    SELECT temp.ProductID, TerritoryID
    from temp , temp1
    where temp.OrderQty = temp1.MuxNum and temp.ProductID = temp1.ProductID
    ORDER BY ProductID;

-- Q4*************************************************************************************

WITH NewT( SalesOrderID,OrderDate,Status,CustomerID,TerritoryID,SubTotal,TotalDue)
as (SELECT SalesOrderID,OrderDate,Status,CustomerID,SalesOrderHeader.TerritoryID,SubTotal,TotalDue 
from Sales.SalesOrderHeader INNER JOIN Sales.SalesTerritory ON (Sales.SalesOrderHeader.TerritoryID= Sales.SalesTerritory.TerritoryID)
WHERE Sales.SalesOrderHeader.TotalDue>100000 AND Sales.SalesOrderHeader.TotalDue<500000 and Sales.SalesOrderHeader.[Status]=5 and Sales.SalesTerritory.[Group] ='North America')
SELECT * INTO NAmerica_Sales FROM NewT;

SELECT * FROM NAmerica_Sales;
ALTER TABLE NAmerica_Sales ADD PriceLevel CHAR(4) Check (PriceLevel in ('Mid','High','Low'));


WITH myT( avgDue) as (SELECT AVG(TotalDue) from NAmerica_Sales)

UPDATE NAmerica_Sales
set PriceLevel = (CASE 
                        WHEN TotalDue > avgDue THEN 'High'
                        WHEN TotalDue = avgDue THEN 'Mid'
                        WHEN TotalDue < avgDue THEN 'Low'
                 END)
from NAmerica_Sales,myT;

-- Q5********************************************************************************

SELECT BusinessEntityID ,max(Rate) as MuxRate FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID
ORDER BY BusinessEntityID;

SELECT * FROM HumanResources.EmployeePayHistory
ORDER by Rate;

WITH NEWT1(BusinessEntityID,Rate1) as
        (SELECT BusinessEntityID ,max(Rate) as MuxRate FROM HumanResources.EmployeePayHistory 
        GROUP BY BusinessEntityID),

    avgRate (Rate_avg) as 
        (select AVG(Rate1) from NEWT1),
    
    levelAdd (BusinessEntityID,Rate1, LEVEL) AS
        (select BusinessEntityID,Rate1, CASE 
                            WHEN Rate1 < 29.0000 THEN 3
                            WHEN Rate1 >= 29.0000 and Rate1< 50.0000 THEN 2
                            ELSE 1
                    END as LEVEL
        from NEWT1),

    avgSalaryT(BusinessEntityID, NewSalary,LEVEL) AS
        (select BusinessEntityID, CASE 
                            WHEN Rate1 <= Rate_avg/2 THEN (Rate1*1.2)
                            WHEN Rate1 > Rate_avg/2 and Rate1 <= Rate_avg THEN (Rate1*1.15)
                            WHEN Rate1 > Rate_avg and Rate1 <= Rate_avg+ Rate_avg/2 THEN (Rate1*1.1)
                            ELSE (Rate1*1.05)
                            END, [LEVEL]
    from levelAdd, avgRate)
select * 
from  avgSalaryT
ORDER BY BusinessEntityID;

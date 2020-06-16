use AdventureWorks2012
go


--q1****run me after Query1**************************************************
begin tran
select  [Name] from Sales.Store
where Sales.Store.BusinessEntityID='292'

waitfor delay '00:00:10'

select  Sales.SalesPerson.TerritoryID from Sales.SalesPerson
where Sales.SalesPerson.BusinessEntityID='275'


waitfor delay '00:00:02'

--commit Tran

--q2********************************************************************

--dirty read 2rd 
begin tran
select Sales.SalesPerson.BusinessEntityID,Sales.SalesPerson.SalesQuota  from Sales.SalesPerson
where Sales.SalesPerson.BusinessEntityID='275'

--non reapeatable 2nd 

begin tran
select Sales.SalesTaxRate.SalesTaxRateID,Sales.SalesTaxRate.TaxRate
from Sales.SalesTaxRate
where Sales.SalesTaxRate.SalesTaxRateID='1'

update Sales.SalesTaxRate
set Sales.SalesTaxRate.TaxRate=Sales.SalesTaxRate.TaxRate+1
where Sales.SalesTaxRate.SalesTaxRateID='1'

select Sales.SalesTaxRate.SalesTaxRateID,Sales.SalesTaxRate.TaxRate
from Sales.SalesTaxRate
where Sales.SalesTaxRate.SalesTaxRateID='1'

commit tran
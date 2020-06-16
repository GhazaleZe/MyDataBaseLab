use AdventureWorks2012
go

select * from Sales.Store
select * from Sales.SalesPerson
select * from Sales.SalesTaxRate
--q1********run me first******************************************************
begin tran
update Sales.SalesPerson
set Sales.SalesPerson.TerritoryID='2'
where Sales.SalesPerson.BusinessEntityID='275'

waitfor delay '00:00:20'

update Sales.Store
set [Name]='newghazalename'
where Sales.Store.BusinessEntityID='292'

waitfor delay '00:00:10'

commit tran

--q2*************************************************************************
--dirty read first 
begin tran
select Sales.SalesPerson.BusinessEntityID,Sales.SalesPerson.SalesQuota  from Sales.SalesPerson
where Sales.SalesPerson.BusinessEntityID='275'

waitfor delay '00:00:10'
update Sales.SalesPerson
set Sales.SalesPerson.SalesQuota=888888.10
where Sales.SalesPerson.BusinessEntityID='275'

select Sales.SalesPerson.BusinessEntityID,Sales.SalesPerson.SalesQuota  from Sales.SalesPerson
where Sales.SalesPerson.BusinessEntityID='275'

--non reapeatable read first

begin tran
select Sales.SalesTaxRate.SalesTaxRateID,Sales.SalesTaxRate.TaxRate
from Sales.SalesTaxRate
where Sales.SalesTaxRate.SalesTaxRateID='1'

waitfor delay '00:00:10'

update Sales.SalesTaxRate
set Sales.SalesTaxRate.TaxRate=Sales.SalesTaxRate.TaxRate+1
where Sales.SalesTaxRate.SalesTaxRateID='1'

waitfor delay '00:00:10'

select Sales.SalesTaxRate.SalesTaxRateID,Sales.SalesTaxRate.TaxRate
from Sales.SalesTaxRate
where Sales.SalesTaxRate.SalesTaxRateID='1'

waitfor delay '00:00:10'

update Sales.SalesTaxRate
set Sales.SalesTaxRate.TaxRate=Sales.SalesTaxRate.TaxRate+1
where Sales.SalesTaxRate.SalesTaxRateID='1'

waitfor delay '00:00:10'
select Sales.SalesTaxRate.SalesTaxRateID,Sales.SalesTaxRate.TaxRate
from Sales.SalesTaxRate
where Sales.SalesTaxRate.SalesTaxRateID='1'

commit tran



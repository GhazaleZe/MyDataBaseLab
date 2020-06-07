use AdventureWorks2012
go
--C:\_uni\term6\database\lab\7

sp_configure 'show advanced options', 1;
RECONFIGURE;
Go
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;
GO
exec sp_configure 'Advanced', 1 RECONFIGURE
exec sp_configure 'Ad Hoc Distributed Queries', 1
RECONFIGURE
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'AllowInProcess', 1
EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0',
N'DynamicParameters', 1
GO

EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO

--q1**************************************
exec xp_cmdshell 'bcp AdventureWorks2012.Sales.SalesTerritory out C:\_uni\term6\database\lab\7\q1.txt -T -c -t^|'

CREATE TABLE [Sales].[SalesTerritoryNew](
	[TerritoryID] [int] ,
	[Name] [dbo].[Name],
	[CountryRegionCode] [nvarchar](3) ,
	[Group] [nvarchar](50) ,
	[SalesYTD] [money] ,
	[SalesLastYear] [money],
	[CostYTD] [money] ,
	[CostLastYear] [money] ,
	[rowguid] [uniqueidentifier] ,
	[ModifiedDate] [datetime] 
);
drop table [Sales].[SalesTerritoryNew]
bulk insert [Sales].[SalesTerritoryNew]
from 'C:\_uni\term6\database\lab\7\ST.txt'
with
(
	fieldterminator = '|'
)
select * from [Sales].[SalesTerritoryNew]
--q2**********************************************************************
select TerritoryID,[Name] from Sales.SalesTerritory
exec xp_cmdshell 'bcp "select TerritoryID,[Name]  from AdventureWorks2012.Sales.SalesTerritory" queryout C:\_uni\term6\database\lab\7\q2.txt -T -c -t^|'

--q3************************************************************************
select * from Production.Location

exec xp_cmdshell 'bcp AdventureWorks2012.Production.Location out C:\_uni\term6\database\lab\7\location.dat  -T -c -t,'

--q4*****************************************************************

select * from Sales.Store


exec xp_cmdshell 'bcp "select Name, Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $x in /StoreSurvey return  <AnnualSales>{$x/AnnualSales}</AnnualSales>'') as AnnualSales,Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $y in /StoreSurvey return <YearOpened>{$y/YearOpened}</YearOpened>'') as YearOpened,Demographics.query(''declare default element namespace \"http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey\";for $z in /StoreSurvey return  <NumberEmployees>{$z/NumberEmployees}</NumberEmployees>'') as NumberEmployees from AdventureWorks2012.Sales.Store" queryout C:\_uni\term6\database\lab\7\q4.txt -T -c -q -t^|'


select [Name],
Demographics.query ('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $x in /StoreSurvey
return 
<AnnualSales>
{$x/AnnualSales}
</AnnualSales>') as AnnualSales,
Demographics.query('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $y in /StoreSurvey 
return 
<YearOpened>
{$y/YearOpened}
</YearOpened>') as YearOpened,
Demographics.query('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
for $z in /StoreSurvey
return  
<NumberEmployees>
{$z/NumberEmployees}
</NumberEmployees>')
as NumberEmployees from Sales.Store
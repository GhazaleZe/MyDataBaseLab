
-- Q1**************
create login ghazale
with password ='123'

create server role Role1

grant create any database to Role1

alter server role dbcreator drop member ghazale

alter server role Role1 add member ghazale

use AdventureWorks2012
go

create user gh1 for login ghazale

--Q2************************************
create role Role2
create user gh2 for login ghazale
alter role Role2 add member gh2

alter role db_securityadmin add member Role2

alter role db_datareader add member Role2



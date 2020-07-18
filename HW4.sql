use homework
go
--q2*********************************************************
CREATE FUNCTION Check_NationalCode(
    @Code varchar(10)
)
RETURNS varchar(10)
AS 
BEGIN
	DECLARE @validation varchar(10)
	DECLARE @int_code as int
	DECLARE @r int
	DECLARE @temp int
	DECLARE @count INT;
	DECLARE @result INT;
	set @int_code= CAST(@Code as int)
	if len(@Code)>10 OR len(@Code)<8
		set @validation='Invalid'
	else
	begin
		set @int_code= CAST(@Code as int)
		set @r= @int_code%10
		set @int_code= @int_code/10
		SET @count = 2;  
		Set @result=0
		WHILE (@int_code/10)>0
		BEGIN
			Set @temp= @int_code%10
			Set @int_code= @int_code/10
			set @result=@result+(@temp*@count)
			SET @count = @count + 1;
		END;
		Set @temp= @int_code%10
		set @result=@result+(@temp*@count)
		set @result=@result%11
		if @result>2
			set @result=11-@result
		if @result=@r
			set @validation='VALID'
		if @result<>@r
			set @validation='INVALID'
	end
    RETURN @validation
END;

select dbo.Check_NationalCode('1279862383') 

--q3**********************************************************

create table project_payment (
	 ID  varchar(5),
	 Amount int,
	 [Date] date,
     Project varchar(5)
);

create table  prof_payment (
	 ID  varchar(5),
	 Amount int,
	 [Date] date,
     Prof varchar(20)
);

Create table join_payments_Ranke (
	 ProfID  varchar(5),
	 ProfAmount int,
	 ProfDate date,
     Prof varchar(20),
	 ProjID varchar(5),
	 ProjAmount int,
	 ProjDate date,
     Project varchar(5),
	 Row# int	
);

select * from project_payment
select * from prof_payment

insert into prof_payment values('1',100,'1398-10-01','Ahmady')
insert into prof_payment values('2',150,'1398-10-02','Mohammadi')
insert into prof_payment values('2',200,'1398-10-02','Saeedy')
insert into prof_payment values('3',50,'1398-10-04','Ahmady')
insert into prof_payment values('3',300,'1398-10-04','Mohammadi')
insert into prof_payment values('3',200,'1398-10-04','Saeedy')

insert into project_payment values('1',100,'1398-10-01','A')
insert into project_payment values('2',150,'1398-10-02','B')
insert into project_payment values('2',100,'1398-10-02','C')
insert into project_payment values('2',100,'1398-10-02','D')
insert into project_payment values('3',550,'1398-10-04','F')

Create table prof_project(
	 Prof varchar(20),
	 Project varchar(5),
	 [Date] date,
	 Amount int     
);

select * from prof_project;

create view  [join_payments] as
select  prof_payment.ID as ProfID ,prof_payment.Amount as ProfAmount,prof_payment.[Date] as ProfDate,prof_payment.Prof,
project_payment.ID as ProjID,project_payment.Amount as ProjAmount ,project_payment.[Date] as ProjDate,project_payment.Project
from prof_payment,project_payment
where prof_payment.ID=project_payment.ID

select * from join_payments;

CREATE PROCEDURE Prof_Proj
AS
Begin
	declare @profID1 varchar(5);
	declare @projID1 varchar(5);
	declare @project1 varchar(5);
	declare @profdate1 date;
	declare @projdate1 date;
	declare @profamount1 int;
    declare @projamount1 int;
	declare @counter1 int;
	declare @i1 int;
	--declare @myrank1 int;
	declare @family varchar(20);
	delete from prof_project;
	set @counter1 = (select count(Row#) from join_payments_Ranke) +1
	set @i1=1
	While @i1<@counter1
	begin
		set @profID1 = (select ProfID from join_payments_Ranke where Row#=@i1)
		set @projID1 = (select ProjID from join_payments_Ranke where Row#=@i1)
		set @profdate1 = (select ProfDate from join_payments_Ranke where Row#=@i1)
		set @projdate1 = (select ProjDate from join_payments_Ranke where Row#=@i1)
		set @profamount1 = (select ProfAmount from join_payments_Ranke where Row#=@i1)
		set @projamount1 = (select ProjAmount from join_payments_Ranke where Row#=@i1)
		--set @myrank1 = (select Myrank from join_payments_Ranke where Row#=@i1)
		set @project1 = (select Project from join_payments_Ranke where Row#=@i1)
		set @family = (select Prof from join_payments_Ranke where Row#=@i1)
		if @profID1=@projID1 and @profdate1=@projdate1 and @projamount1=@profamount1
		begin
			insert into prof_project(Prof,Project,Date,Amount) 
			select Prof,Project,ProfDate,ProfAmount
			from join_payments_Ranke
			where Row#=@i1;
			update join_payments_Ranke 
			set ProfAmount=0
			where Row#=@i1 or (ProfID=@profID1 and Prof=@family)
			update join_payments_Ranke 
			set Project='Done'
			where Project=@project1
		end
		if @profamount1>@projamount1 and @project1<>'Done' and @profdate1=@projdate1
		begin
			insert into prof_project(Prof,Project,Date,Amount) 
			select Prof,Project,ProfDate,ProjAmount
			from join_payments_Ranke
			where Row#=@i1;
			update join_payments_Ranke 
			set ProfAmount= ProfAmount-ProjAmount
			where Row#=@i1 or (ProfID=@profID1 and Prof=@family)
			update join_payments_Ranke 
			set Project='Done'
			where Project=@project1
		end
		if @profamount1 < @projamount1 and @project1<>'Done' and @profdate1=@projdate1 and @profamount1>0
		begin
			insert into prof_project(Prof,Project,Date,Amount) 
			select Prof,Project,ProfDate,ProfAmount
			from join_payments_Ranke
			where Row#=@i1;
			update join_payments_Ranke 
			set ProfAmount= 0,ProjAmount=@projamount1-@profamount1
			where Row#=@i1 or (ProfID=@profID1 and Prof=@family)
			update join_payments_Ranke 
			set  ProjAmount=@projamount1-@profamount1
			where ProjDate=@projdate1 and Project=@project1 and ProfID=@profID1
		end
		set @i1=@i1+1
	end
	Create table prof_project_help(
	 Prof varchar(20),
	 Project varchar(5),
	 [Date] date,
	 Amount int, 
	 ProfRank int,
	 ProjectRank int
     );
	 insert into prof_project_help select *,DENSE_RANK() OVER (PARTITION BY Prof,[Date] ORDER BY Project) AS ProfRank,
                                   DENSE_RANK() OVER (PARTITION BY Project,[Date] ORDER BY Prof) AS ProjectRank
                                   from prof_project
	update prof_project
	set Prof=NULL
	from prof_project,prof_project_help
	where prof_project.Prof=prof_project_help.Prof and 
	prof_project.Project=prof_project_help.Project and prof_project.Date=prof_project_help.Date
	and prof_project.Amount=prof_project_help.Amount and prof_project_help.ProfRank>1

	update prof_project
	set Project=NULL
	from prof_project,prof_project_help
	where prof_project.Prof=prof_project_help.Prof and 
	prof_project.Project=prof_project_help.Project and prof_project.Date=prof_project_help.Date
	and prof_project.Amount=prof_project_help.Amount and prof_project_help.ProjectRank>1
	select * from prof_project

	delete from join_payments_Ranke
	insert into join_payments_Ranke
	select *,ROW_NUMBER() OVER(ORDER BY ProfID,ProfDate,ProjID,ProjDate) AS Row#
	from join_payments
	drop table prof_project_help
end

execute Prof_Proj

--q4**********************************************************

select * from Cutomer_relationship;
insert into Cutomer_relationship values('1','2')
insert into Cutomer_relationship values('1','5')
insert into Cutomer_relationship values('2','3')
insert into Cutomer_relationship values('3','6');
insert into Cutomer_relationship values('3','7');
insert into Cutomer_relationship values('3','8');
WITH user_chain (starter,connected)
AS
(
	select first_customer_id,second_customer_id from Cutomer_relationship    
    UNION all
    select  user_chain.starter,Cutomer_relationship.second_customer_id
	from user_chain,Cutomer_relationship
	where user_chain.connected= Cutomer_relationship.first_customer_id
)
-- references expression name
SELECT starter,connected
FROM   user_chain
order by starter;

--q5**************************************************************************

create table history_item_fee(
	id varchar(10),
	fee numeric(12,3),
	[date] date
);

select * from history_item_fee;
select * from item;

CREATE TRIGGER dbo.history
   ON  dbo.item
   AFTER update
AS 
BEGIN
	insert into history_item_fee(id,fee,[date]) 
	select id,fee,GETDATE() from deleted
END;

update Item
set fee=22.600
where id='0002'

--q6***********************************************************************

select 
from imaginary
group by cube(a,b,c,d);

select 
from imaginary
group by GROUPING sets(
	(),
	(a),
	(b),
	(c),
	(d),
	(a,b),
	(a,c),
	(a,d),
	(b,c),
	(b,d),
	(c,d),
	(a,b,c),
	(a,b,d),
	(b,c,d),
	(a,c,d),
	(a,b,c,d)
);

select  
from imaginary
group by ROLLUP(a,b,c,d)
UNION all
select 
from imaginary
group by GROUPING sets(
	(b),
	(c),
	(d),
	(a,c),
	(a,d),
	(b,c),
	(b,d),
	(c,d),
	(a,b,d),
	(b,c,d),
	(a,c,d)
);

--q7*********************************************************

--a
select top 100 dbo.Customer.id, COUNT (dbo.Cutomer_relationship.second_customer_id) as add_num
from Customer,Cutomer_relationship
where dbo.Cutomer_relationship.first_customer_id=dbo.Customer.id
group by dbo.Customer.id
order by add_num DESC

--b

select * from Sale
select * from Province
select * from Branch

select top 3 Branch.id as branch_id ,Province.id as Province_id, Sum(Sale.total_price) as total_sale
from Sale,Branch,City,Province
where Sale.branch_id=Branch.id and Branch.city_id=City.id and City.province_id=Province.id
group by Branch.id,Province.id
order by total_sale DESC

--c

select * from Supplier
select * from Buy
select Buy.supplier_id,item_id,Buy.[date],Buy.total_price,
sum(total_price) OVER (PARTITION by Buy.[date],Buy.supplier_id order by item_id) as buy_su
from Buy,Supplier
where Buy.supplier_id=Supplier.id

--d

select DISTINCT City.name as city_name,Province.name as province_name,
sum(total_price) OVER (PARTITION by City.name ) as city_price,
sum(total_price) OVER (PARTITION by Province.name ) as Province_price
from Sale,Branch,City,Province
where Sale.branch_id=branch_id and Branch.city_id=City.id and City.province_id=Province.id
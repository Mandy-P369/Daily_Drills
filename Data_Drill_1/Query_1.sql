create table Drillone(Employee_name varchar(30),Manager_name varchar(30));
Select column_name,data_type from information_schema.columns where table_name='Drillone';
Select * from Drillone;


--Creating hierarchy columns 
With recursive hier as
(
Select employee_name,manager_name,employee_name as hierarchy from Drillone 
where manager_name is null
union all
Select h.employee_name,h.manager_name,
concat(d.manager_name,'>',h.employee_name) as hierarchy
from Drillone d
inner join
hier h on h.manager_name = d.employee_name
)
Select * from hier;


With recursive my_cte as 
(
Select employee_name,manager_name,employee_name as hierarchy from Drillone 
union all
Select employee_name,manager_name from Drillone 
inner join
my_cte m on m.employee_name=d.manager_name 
)
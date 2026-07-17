create table Drillone(Employee_name varchar(30),Manager_name varchar(30));
Select column_name,data_type from information_schema.columns where table_name='Drillone';
Select * from Drillone;


--Creating hierarchy columns 
WITH RECURSIVE hier AS
(
    SELECT
        d.employee_name,
        d.manager_name,
        d.employee_name::TEXT AS hierarchy
    FROM Drillone d
    WHERE d.manager_name IS NULL
    UNION ALL
    SELECT
        d.employee_name,
        d.manager_name,
        CONCAT(h.hierarchy, ' > ', d.employee_name)
    FROM Drillone d
    INNER JOIN hier h
        ON d.manager_name = h.employee_name
)
SELECT *
FROM hier;

-- Creating direct queries columns ..
Select manager_name,count(employee_name) as direct_reports from Drillone group by manager_name;

-- Combination of first two queries 
With recursive cte as (
Select d.employee_name,d.manager_name,d.employee_name as hierarchy from Drillone d 
union all 
Select c.employee_name,c.manager_name from Drillone d 
inner join 
cte c on c.manager_name = d.manager_name) 
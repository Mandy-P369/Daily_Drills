


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
WITH RECURSIVE hier AS
(
    SELECT
        employee_name,
        manager_name,
        employee_name::TEXT AS hierarchy
    FROM Drillone
    WHERE manager_name IS NULL

    UNION ALL

    SELECT
        d.employee_name,
        d.manager_name,
        CONCAT(h.hierarchy, '>', d.employee_name) AS hierarchy
    FROM Drillone d
    INNER JOIN hier h
        ON d.manager_name = h.employee_name
),

direct AS
(
    SELECT
        manager_name,
        COUNT(employee_name) AS direct_reports
    FROM Drillone
    WHERE manager_name IS NOT NULL
    GROUP BY manager_name
)
hier_direct as (
SELECT
    h.employee_name,
    h.manager_name, 
    h.hierarchy,
    COALESCE(d.direct_reports, 0) AS direct_reports
FROM hier h 
LEFT JOIN direct d
    ON h.employee_name = d.manager_name
ORDER BY h.hierarchy
) 

Select * from hier_direct m 
left join 
hier_direct e on e.hierarchy like concat(m.hierarchy,'> %'); 
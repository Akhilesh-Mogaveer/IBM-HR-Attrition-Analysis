-- 1. Avg salary: employees who left vs stayed
SELECT 
    a.Attrition,
    ROUND(AVG(c.MonthlyIncome)) AS avg_salary
FROM
    compensation c
        JOIN
    attrition_status a ON c.EmployeeNumber = a.EmployeeNumber
GROUP BY a.Attrition;

-- 2. Lowest paid job roles
SELECT 
    j.JobRole, ROUND(AVG(c.MonthlyIncome),2) AS avg_salary
FROM
    compensation c
        JOIN
    job_details j ON c.EmployeeNumber = j.EmployeeNumber
GROUP BY j.JobRole
ORDER BY avg_salary ASC;

-- 3. Salary by department vs attrition
SELECT 
    j.Department,
    a.Attrition,
    ROUND(AVG(c.MonthlyIncome), 2) AS avg_salary
FROM
    compensation c
        JOIN
    job_details j ON c.EmployeeNumber = j.EmployeeNumber
        JOIN
    attrition_status a ON c.EmployeeNumber = a.EmployeeNumber
GROUP BY j.Department , a.Attrition
ORDER BY j.Department , a.Attrition
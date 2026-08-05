-- 1. Attrition by years at company
SELECT 
    t.YearsAtCompany,
    COUNT(*) AS total,
    SUM(CASE
        WHEN a.Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS left_count,
    ROUND(SUM(CASE
                WHEN a.Attrition = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS attrition_rate
FROM
    tenure t
        JOIN
    attrition_status a ON t.EmployeeNumber = a.EmployeeNumber
GROUP BY t.YearsAtCompany
ORDER BY attrition_rate DESC;

-- 2. Attrition by years with current manager
SELECT 
    t.YearsWithCurrManager,
    COUNT(*) AS total,
    SUM(CASE
        WHEN a.Attrition = 'Yes' THEN 1
        ELSE 0
    END) AS left_count,
    ROUND(SUM(CASE
                WHEN a.Attrition = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS attrition_rate
FROM
    tenure t
        JOIN
    attrition_status a ON t.EmployeeNumber = a.EmployeeNumber
GROUP BY t.YearsWithCurrManager
ORDER BY attrition_rate DESC;

-- 3. Rank departments by attrition using window function
SELECT Department, attrition_rate, RANK() OVER (ORDER BY attrition_rate DESC) AS dept_rank
FROM (SELECT  j.Department, ROUND(SUM(CASE WHEN a.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate 
  FROM job_details j
  JOIN attrition_status a ON j.EmployeeNumber = a.EmployeeNumber
  GROUP BY j.Department
) dept_summary;

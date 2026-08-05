-- 1. Attrition rate by department
SELECT 
    j.Department,
    COUNT(*) AS total_employees,
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
    job_details j
        JOIN
    attrition_status a ON j.EmployeeNumber = a.EmployeeNumber
GROUP BY j.Department
ORDER BY attrition_rate DESC;

-- 2. Attrition rate by job role
SELECT 
    j.JobRole,
    COUNT(*) AS total_employees,
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
    job_details j
        JOIN
    attrition_status a ON j.EmployeeNumber = a.EmployeeNumber
GROUP BY j.JobRole
ORDER BY attrition_rate DESC;

-- 3. Attrition rate by gender
SELECT 
  e.Gender,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN a.Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN a.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee e
JOIN attrition_status a ON e.EmployeeNumber = a.EmployeeNumber
GROUP BY e.Gender
ORDER BY attrition_rate DESC;

-- 4. Attrition rate by education field
SELECT 
    e.EducationField,
    COUNT(*) AS total_employees,
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
    employee e
        JOIN
    attrition_status a ON e.EmployeeNumber = a.EmployeeNumber
GROUP BY e.EducationField
ORDER BY attrition_rate DESC;
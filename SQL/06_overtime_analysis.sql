-- 1. Overtime vs attrition
SELECT 
    j.OverTime,
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
GROUP BY j.OverTime
ORDER BY attrition_rate DESC;

-- 2. Work life balance vs attrition
SELECT 
    j.WorkLifeBalance,
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
GROUP BY j.WorkLifeBalance
ORDER BY attrition_rate DESC; 

-- 3. Job satisfaction vs attrition
SELECT 
    j.JobSatisfaction,
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
GROUP BY j.JobSatisfaction
ORDER BY attrition_rate DESC;
-- 1. Tenure bucket cohort analysis
WITH tenure_buckets AS (
  SELECT 
    t.EmployeeNumber,
    a.Attrition,
    CASE 
      WHEN t.YearsAtCompany <= 2 THEN '0-2 years'
      WHEN t.YearsAtCompany <= 5 THEN '3-5 years'
      WHEN t.YearsAtCompany <= 10 THEN '6-10 years'
      ELSE '10+ years'
    END AS tenure_group
  FROM tenure t
  JOIN attrition_status a ON t.EmployeeNumber = a.EmployeeNumber
)
SELECT 
  tenure_group,
  COUNT(*) AS total,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
  ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM tenure_buckets
GROUP BY tenure_group
ORDER BY attrition_rate DESC;


-- 2. High risk employee profile using CTE
WITH employee_profile AS (
  SELECT 
    e.EmployeeNumber,
    e.Age,
    j.Department,
    j.JobRole,
    j.OverTime,
    j.JobSatisfaction,
    c.MonthlyIncome,
    t.YearsAtCompany,
    a.Attrition
  FROM employee e
  JOIN job_details j ON e.EmployeeNumber = j.EmployeeNumber
  JOIN compensation c ON e.EmployeeNumber = c.EmployeeNumber
  JOIN tenure t ON e.EmployeeNumber = t.EmployeeNumber
  JOIN attrition_status a ON e.EmployeeNumber = a.EmployeeNumber
)
SELECT * FROM employee_profile
WHERE Attrition = 'Yes'
  AND OverTime = 'Yes'
  AND JobSatisfaction = 1
  AND MonthlyIncome < 5000
ORDER BY YearsAtCompany ASC;
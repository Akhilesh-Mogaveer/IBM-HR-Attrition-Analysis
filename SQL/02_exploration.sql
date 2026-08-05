-- 1. How many employees left vs stayed?
SELECT 
    Attrition, COUNT(*) AS total
FROM
    attrition_status
GROUP BY Attrition;

-- 2. Overall attrition rate
SELECT 
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_percent
FROM
    attrition_status;
    
-- 3. Total employees per department
SELECT 
    Department, COUNT(*) AS total_employees
FROM
    job_details
GROUP BY Department
ORDER BY total_employees DESC;

-- 4. Age range of employees
SELECT 
    round(AVG(Age),1) as Average_Age
FROM
    employee;

-- 5. Average monthly income overall
SELECT 
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM
    compensation;
CREATE DATABASE HR_ANALYSIS;
use HR_ANALYSIS;
RENAME TABLE `hr-employee-attrition` TO hr_employee_attrition;
select * from hr_employee_attrition;

ALTER TABLE hr_employee_attrition 
CHANGE `ï»¿Age` Age INT;

ALTER TABLE hr_employee_attrition
ADD PRIMARY KEY (EmployeeNumber);

CREATE TABLE employee (
  EmployeeNumber    INT           PRIMARY KEY,
  Age               INT           NOT NULL,
  Gender            VARCHAR(10)   NOT NULL,
  MaritalStatus     VARCHAR(20)   NOT NULL,
  Education         INT           NOT NULL,
  EducationField    VARCHAR(50)   NOT NULL,
  NumCompaniesWorked INT          NOT NULL,
  Over18            VARCHAR(5)    NOT NULL,
  DistanceFromHome  INT           NOT NULL
);

INSERT INTO employee
SELECT 
  EmployeeNumber, Age, Gender, MaritalStatus,
  Education, EducationField, NumCompaniesWorked,
  Over18, DistanceFromHome
FROM hr_employee_attrition;

CREATE TABLE job_details (
  EmployeeNumber          INT         PRIMARY KEY,
  Department              VARCHAR(50) NOT NULL,
  JobRole                 VARCHAR(50) NOT NULL,
  JobLevel                INT         NOT NULL,
  JobInvolvement          INT         NOT NULL,
  JobSatisfaction         INT         NOT NULL,
  OverTime                VARCHAR(5)  NOT NULL,
  BusinessTravel          VARCHAR(30) NOT NULL,
  EnvironmentSatisfaction INT         NOT NULL,
  RelationshipSatisfaction INT        NOT NULL,
  WorkLifeBalance         INT         NOT NULL,
  FOREIGN KEY (EmployeeNumber) REFERENCES hr_employee_attrition(EmployeeNumber)
);

INSERT INTO job_details
SELECT 
  EmployeeNumber, Department, JobRole, JobLevel,
  JobInvolvement, JobSatisfaction, OverTime, BusinessTravel,
  EnvironmentSatisfaction, RelationshipSatisfaction, WorkLifeBalance
FROM hr_employee_attrition;

CREATE TABLE compensation (
  EmployeeNumber    INT           PRIMARY KEY,
  MonthlyIncome     INT           NOT NULL,
  MonthlyRate       INT           NOT NULL,
  DailyRate         INT           NOT NULL,
  HourlyRate        INT           NOT NULL,
  PercentSalaryHike INT           NOT NULL,
  StockOptionLevel  INT           NOT NULL,
  StandardHours     INT           NOT NULL,
  FOREIGN KEY (EmployeeNumber) REFERENCES hr_employee_attrition(EmployeeNumber)
);

INSERT INTO compensation
SELECT 
  EmployeeNumber, MonthlyIncome, MonthlyRate,
  DailyRate, HourlyRate, PercentSalaryHike,
  StockOptionLevel, StandardHours
FROM hr_employee_attrition;

CREATE TABLE tenure (
  EmployeeNumber          INT   PRIMARY KEY,
  TotalWorkingYears       INT   NOT NULL,
  YearsAtCompany          INT   NOT NULL,
  YearsInCurrentRole      INT   NOT NULL,
  YearsSinceLastPromotion INT   NOT NULL,
  YearsWithCurrManager    INT   NOT NULL,
  TrainingTimesLastYear   INT   NOT NULL,
  FOREIGN KEY (EmployeeNumber) REFERENCES hr_employee_attrition(EmployeeNumber)
);

INSERT INTO tenure
SELECT 
  EmployeeNumber, TotalWorkingYears, YearsAtCompany,
  YearsInCurrentRole, YearsSinceLastPromotion,
  YearsWithCurrManager, TrainingTimesLastYear
FROM hr_employee_attrition;


CREATE TABLE attrition_status (
  EmployeeNumber    INT          PRIMARY KEY,
  Attrition         VARCHAR(5)   NOT NULL,
  PerformanceRating INT          NOT NULL,
  EmployeeCount     INT          NOT NULL,
  FOREIGN KEY (EmployeeNumber) REFERENCES hr_employee_attrition(EmployeeNumber)
);

INSERT INTO attrition_status
SELECT 
  EmployeeNumber, Attrition,
  PerformanceRating, EmployeeCount
FROM hr_employee_attrition;

SHOW TABLES;

SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'hr_analysis'
AND REFERENCED_TABLE_NAME IS NOT NULL;
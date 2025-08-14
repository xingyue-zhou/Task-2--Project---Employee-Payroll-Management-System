-- Task 2 - Project: Employee Payroll Management System
-- create database
-- CREATE DATABASE payroll_database;
-- USE payroll_database;

CREATE TABLE employees (
    EMPLOYEE_ID INT PRIMARY KEY,
    NAME TEXT,
    DEPARTMENT TEXT,
    EMAIL TEXT,
    PHONE_NO NUMERIC,
    JOINING_DATE DATE,
    SALARY NUMERIC(10,2),
    BONUS NUMERIC(10,2),
    TAX_PERCENTAGE NUMERIC(5,2)
);

INSERT INTO employees (
    EMPLOYEE_ID, NAME, DEPARTMENT, EMAIL, PHONE_NO, JOINING_DATE, SALARY, BONUS, TAX_PERCENTAGE
) VALUES
(1, 'Alice Johnson', 'HR', 'alice.johnson@example.com', 9123456780, '2022-03-15', 60000, 50000, 12.0),
(2, 'Bob Smith', 'Finance', 'bob.smith@example.com', 9234567890, '2025-07-20', 75000, 7000, 11.0),
(3, 'Charlie Lee', 'IT', 'charlie.lee@example.com', 9345678901, '2023-01-10', 80000, 15000, 11.0),
(4, 'David Kim', 'Marketing', 'david.kim@example.com', 9456789012, '2020-05-01', 68000, 4000, 9.5),
(5, 'Eva Brown', 'Sales', 'eva.brown@example.com', 9567890123, '2019-11-18', 82000, 30000, 13.0),
(6, 'Frank Miller', 'Finance', 'frank.miller@example.com', 9678901234, '2022-09-25', 69000, 4500, 10.5),
(7, 'Grace Wang', 'IT', 'grace.wang@example.com', 9789012345, '2023-06-12', 85000, 20000, 14.0),
(8, 'Helen Zhang', 'HR', 'helen.zhang@example.com', 9890123456, '2025-06-01', 64000, 3000, 9.0),
(9, 'Ian Thomas', 'Sales', 'ian.thomas@example.com', 9901234567, '2020-08-30', 90000, 20000, 12.0),
(10, 'Jenny Liu', 'Marketing', 'jenny.liu@example.com', 9012345678, '2018-04-22', 80000, 6500, 11.0);

-- Payroll Queries:
-- a) Retrieve the list of employees sorted by salary in descending order.
SELECT * FROM employees
ORDER BY SALARY DESC
;

-- b) Find employees with a total compensation (SALARY + BONUS) greater than $100,000.
WITH wage AS(
  SELECT
    EMPLOYEE_ID
    , SALARY + BONUS AS per_wage
  FROM employees
)

SELECT *
FROM employees
WHERE EMPLOYEE_ID IN (SELECT distinct EMPLOYEE_ID FROM wage WHERE per_wage > 100000)
;

-- c) Update the bonus for employees in the ‘Sales’ department by 10%.
SELECT
  EMPLOYEE_ID
  , NAME
  , DEPARTMENT
  , EMAIL
  , PHONE_NO
  , JOINING_DATE
  , SALARY
  , CASE WHEN DEPARTMENT = 'Sales' THEN BONUS*1.1 ELSE BONUS END AS BONUS
  , TAX_PERCENTAGE
FROM employees
;

-- d) Calculate the net salary after deducting tax for all employees.
SELECT
  *
  , round((SALARY + BONUS) * (1- TAX_PERCENTAGE/100),2) AS SALARY_AFTER_TAX
FROM employees
;

-- e) Retrieve the average, minimum, and maximum salary per department.
SELECT
  DEPARTMENT
  , avg(SALARY) AS AVG_SALARY
  , min(SALARY) AS MIN_SALARY
  , max(SALARY) AS MAX_SALARY
FROM employees
GROUP BY DEPARTMENT
;

-- Advanced Queries:
-- a) Retrieve employees who joined in the last 6 months.
SELECT
  *
FROM employees
WHERE JOINING_DATE > DATE_ADD(current_date, INTERVAL -6 MONTH)
;

-- b) Group employees by department and count how many employees each has.
SELECT
  DEPARTMENT
  , count(EMPLOYEE_ID) AS EMPLOYEE_CNT
FROM employees
GROUP BY DEPARTMENT
;

-- c) Find the department with the highest average salary.
WITH avg_salary_depar AS(
  SELECT
    DEPARTMENT
    , RANK() OVER( ORDER BY avg(SALARY) DESC) AS AVG_SALARY_RANK
  FROM employees
  GROUP BY DEPARTMENT
)
SELECT *
FROM employees
WHERE DEPARTMENT = (SELECT DEPARTMENT FROM avg_salary_depar WHERE AVG_SALARY_RANK = 1)
;

-- d) Identify employees who have the same salary as at least one other employee
SELECT e1.*
FROM employees e1
  LEFT JOIN employees e2
  ON e1.SALARY = e2.SALARY
  AND e1.EMPLOYEE_ID <> e2.EMPLOYEE_ID
WHERE e2.EMPLOYEE_ID IS NOT NULL
;

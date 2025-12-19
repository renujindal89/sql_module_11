-- in cte
-- it does not store the output in db
When you want to simplify a complex query by breaking it down.
When you want better readability and easier maintenance.
CTE high_salary exists only within this query execution.
Read-only; you cannot modify data inside the CTE.

-- in temperory table 
When you need to store and reuse data multiple times during a session.
Temporary table temp_high_salary exists until session ends or dropped.
-- means auto delete on disconnect
You can reuse temp_high_salary multiple times.
Can add indexes to temp_high_salary if needed.
You can modify (INSERT, UPDATE, DELETE) temp_high_salary.




create database module11;
use module11;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_id INT,
    salary DECIMAL(10, 2),
    department_id INT,
    performance_score INT,
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);
INSERT INTO employees (id, name, manager_id, salary, department_id, performance_score) VALUES
(1, 'Alice', NULL, 90000.00, 1, 95),
(2, 'Bob', 1, 60000.00, 2, 88),
(3, 'Charlie', 1, 55000.00, 2, 92),
(4, 'Diana', 2, 50000.00, 2, 85),
(5, 'Ethan', 2, 48000.00, 3, 91);
select * from employees;

. CTE to Filter High Performers like  more than 90
WITH tb1 AS (
    SELECT *
    FROM employees
    WHERE performance_score > 90
)
SELECT * FROM tb1 where performance_score=95 ;
-- outcome Shows employees with performance score > 90.

-- using subquery 
SELECT *
FROM (
    SELECT *
    FROM employees
    WHERE performance_score > 90
)tb1 where performance_score=95;

✅ 2. CTE to Calculate Average Salary and List those employees who earn  Above-Average 
WITH cte1 AS (
    SELECT AVG(salary) AS avg_sal
    FROM employees
)
SELECT e.*
FROM employees e, cte1 a
WHERE e.salary > a.avg_sal;
--  Compares each employee’s salary to the average salary.



-- using subquery 
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


✅ 4.
-- -- Lists employees earning more than their department average.
-- CTE for Department-wise Average and Individual Comparison

WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.name, e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;



-- using subquery
SELECT e.name, e.department_id, e.salary, d.avg_salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;

✅ 5. CTE with ROW_NUMBER: Rank by Salary
-- Ranks employees by salary from highest to lowest
WITH salary_ranks AS (
    SELECT id,name,salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank_num
    FROM employees
)
SELECT * FROM salary_ranks where rank_num=2;

-- using subquery 

SELECT *
FROM (
    SELECT id, name, salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank_num
    FROM employees
) AS salary_ranks;



✅ 6. CTE for Running Total of Salaries by ID Order
WITH salary_totals AS (
    SELECT id, name, salary,
           SUM(salary) OVER (order by name ) AS running_total
    FROM employees
)
SELECT * FROM salary_totals;
--  Shows how salaries accumulate as you go through employees by ID.





 Recursive CTE: Employee Reporting Tree
-- showing who reports to whom, and what "level" they are in the org chart — 
-- starting from top-level managers down to junior employees.
-- 1 Finds the top-level employees who don’t report to anyone(mid is null)
--  2. Recursive Member (repeating part)
-- 3Finds employees who report to the employees found in the previous step.
-- At each recursive step,
--  the query finds employees whose manager_id matches the id of employees found in the previous iteration.
-- For Bob (id=2), we look for employees where manager_id = 2.

-- For Charlie (id=3), look for employees where manager_id = 3.
WITH RECURSIVE emp_hierarchy AS (
    SELECT id, name, manager_id, 0 AS level   -- c.id=1
           
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees e
    JOIN emp_hierarchy h ON e.manager_id = h.id        
)
SELECT * FROM emp_hierarchy
ORDER BY level;
select * from employees;


📌 Builds a hierarchy of employees from top-level manager downward.

use module11;
select * from employees;
-- CREATE TEMPORARY TABLE Tells MySQL to create a table that only exists during the current session
CREATE TEMPORARY TABLE temp_high_salary AS
SELECT * FROM employees WHERE salary > 60000;

SELECT * FROM temp_high_salary;
-- temp_high_salary available throughout your session until you drop it or disconnect.

-- (Optional) Drop the temporary table if done

DROP TEMPORARY TABLE temp_high_salary;

-- in sql server 
CREATE # temp_high_salary AS
SELECT * FROM employees WHERE salary > 60000;


-- with cte

WITH high_salary AS (
    SELECT * FROM employees WHERE salary > 60000
)
SELECT * FROM high_salary;
-- high_salary only exists during this query execution.








-- CTEs are useful for improving the readability and maintainability of complex queries, 
-- and for breaking down queries into simpler parts.
WITH cte_name AS (
    SELECT ...
)
SELECT ...
FROM cte_name;

-- multiple cte
WITH cte1 AS (
    SELECT ...
),
cte2 AS (
    SELECT ...
)
SELECT ...
FROM cte2
JOIN cte1 ON ...;

-- Q1 Suppose you have an employees table and want to find employees who earn more than the average salary:

WITH avg_salary AS (
    SELECT AVG(salary) AS avg_sal
    FROM employees
)
SELECT e.*
FROM employees e
JOIN avg_salary a ON e.salary > a.avg_sal;

-- Q2 Get all customers who placed orders worth more than $1000.
WITH big_orders AS (
    SELECT customer_id, SUM(order_total) AS total_spent
    FROM orders
    GROUP BY customer_id
    HAVING SUM(order_total) > 1000
)
SELECT c.customer_name, b.total_spent
FROM customers c
JOIN big_orders b ON c.id = b.customer_id;

-- Q3  List products and how many times each has been ordered, only for active products.
WITH active_products AS (
    SELECT id, name
    FROM products
    WHERE status = 'active'
),
product_orders AS (
    SELECT product_id, COUNT(*) AS order_count
    FROM order_items
    GROUP BY product_id
)
SELECT ap.name, po.order_count
FROM active_products ap
LEFT JOIN product_orders po ON ap.id = po.product_id;

-- Q5 CTE with Ranking (ROW_NUMBER)

Find the most recent order for each customer.
WITH ranked_orders AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM orders
)
SELECT *
FROM ranked_orders
WHERE rn = 1;

-- q6- CTE in an UPDATE Statement

Give a 10% bonus to employees with performance above 90.
WITH high_performers AS (
    SELECT id, salary * 1.10 AS new_salary
    FROM employees
    WHERE performance_score > 90
)
UPDATE employees e
JOIN high_performers hp ON e.id = hp.id
SET e.salary = hp.new_salary;

-- q7 CTE for Running Totals

Calculate a running total of sales per day.
WITH daily_sales AS (
    SELECT order_date, SUM(order_total) AS daily_total
    FROM orders
    GROUP BY order_date
),
running_totals AS (
    SELECT order_date,
           daily_total,
           SUM(daily_total) OVER (ORDER BY order_date) AS running_total
    FROM daily_sales
)
SELECT * FROM running_totals;
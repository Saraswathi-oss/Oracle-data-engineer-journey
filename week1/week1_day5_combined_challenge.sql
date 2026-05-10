-- ================================================
-- Oracle Fusion AI Data Engineer Journey
-- Week 1 - Day 5: Combined SQL Challenge
-- Window Functions + CTEs + Optimization together
-- Author: Saraswathi
-- ================================================

-- Setup: Create departments table
CREATE TABLE departments (
    dept_id   NUMBER,
    dept_name VARCHAR2(50)
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'HR');
INSERT INTO departments VALUES (30, 'Technology');

COMMIT;

-- ================================================
-- Challenge: Combined query using CTEs + Window Functions
-- Show department name, employee salary, rank within dept,
-- dept average salary, difference from average
-- Only show depts where average salary > 80000
-- ================================================

-- Version 1: 4 CTE approach (step by step logic)
-- CTE1: Join employees with department names
-- CTE2: Add DENSE_RANK within each department by salary
-- CTE3: Calculate average salary per department
-- CTE4: Combine rank and average together
-- Final: Add salary difference and filter by avg > 80000

WITH cte1 AS (
    SELECT e.*, d.dept_name 
    FROM employees e  
    JOIN departments d ON e.dept_id = d.dept_id
),
cte2 AS (
    SELECT cte1.*, 
           DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk 
    FROM cte1
),
cte3 AS (
    SELECT dept_id, AVG(salary) AS avg2 
    FROM cte2 
    GROUP BY dept_id
),
cte4 AS (
    SELECT cte2.*, avg2  
    FROM cte3 
    JOIN cte2 ON cte3.dept_id = cte2.dept_id
)
SELECT cte4.*, (salary - avg2) AS diff  
FROM cte4 
WHERE avg2 > 80000;


-- ================================================
-- Version 2: Optimized 2 CTE approach
-- AVG() OVER replaces GROUP BY CTE + JOIN
-- Fewer CTEs, same result, better performance
-- Key learning: Window functions can replace GROUP BY CTEs
-- ================================================

WITH cte1 AS (
    SELECT e.*, d.dept_name 
    FROM employees e  
    JOIN departments d ON e.dept_id = d.dept_id
),
cte2 AS (
    SELECT cte1.*,
           DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rnk,
           AVG(salary)  OVER (PARTITION BY dept_id) AS avg2
    FROM cte1
)
SELECT cte2.*, (salary - avg2) AS diff  
FROM cte2 
WHERE avg2 > 80000;


-- ================================================
-- Deduplication Pattern (Interview Question)
-- Find and delete duplicate rows using ROW_NUMBER
-- ================================================

-- Find duplicates
SELECT emp_id, COUNT(*) 
FROM employees 
GROUP BY emp_id 
HAVING COUNT(*) > 1;

-- Delete duplicates keeping one row per group
-- ROW_NUMBER assigns unique numbers within duplicate groups
-- DELETE keeps rn = 1, removes rn > 1
DELETE FROM (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY emp_id, dept_id, salary 
               ORDER BY emp_id
           ) AS rn
    FROM employees e
) WHERE rn > 1;

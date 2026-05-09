-- ================================================
-- Oracle Fusion AI Engineer Journey
-- Week 1 - Day 3: CTEs (Common Table Expressions)
-- Author: Saraswathi
-- ================================================

-- Setup: Create employees table
CREATE TABLE employees (
    emp_id  NUMBER,
    dept_id NUMBER,
    salary  NUMBER
);

INSERT INTO employees VALUES (1, 10, 90000);
INSERT INTO employees VALUES (2, 10, 90000);
INSERT INTO employees VALUES (3, 10, 75000);
INSERT INTO employees VALUES (4, 20, 85000);
INSERT INTO employees VALUES (5, 20, 85000);
INSERT INTO employees VALUES (6, 20, 70000);
INSERT INTO employees VALUES (7, 30, 95000);
INSERT INTO employees VALUES (8, 30, 80000);

COMMIT;

-- Challenge 1
-- Find departments where average salary is above 80000
-- CTE used instead of subquery for readability
WITH avg_sal AS (
    SELECT dept_id, AVG(salary) AS avgsal
    FROM employees
    GROUP BY dept_id
)
SELECT dept_id, avgsal
FROM avg_sal
WHERE avgsal > 80000;

-- Challenge 2
-- Find employees earning above their department average
-- Chained CTEs: CTE1 calculates dept average, CTE2 joins and filters
-- CTE2 references CTE1 directly like a table
WITH
avg_sal1 AS (
    SELECT dept_id, AVG(salary) AS avgsal
    FROM employees
    GROUP BY dept_id
),
avg_sal2 AS (
    SELECT ev.emp_id, ev.dept_id, ev.salary, avg_sal1.avgsal
    FROM employees ev
    JOIN avg_sal1 ON avg_sal1.dept_id = ev.dept_id
    WHERE ev.salary > avg_sal1.avgsal
)
SELECT * FROM avg_sal2;

-- Challenge 3
-- Find top earner per department, no duplicates even on ties
-- CTE wraps ROW_NUMBER window function
-- ROW_NUMBER guarantees exactly one row per dept regardless of ties
WITH cte1 AS (
    SELECT 
        e.*,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rw_nm
    FROM employees e
)
SELECT emp_id, dept_id, salary
FROM cte1
WHERE rw_nm = 1;

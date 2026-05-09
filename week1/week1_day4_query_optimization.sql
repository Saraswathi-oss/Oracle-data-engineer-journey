-- ================================================
-- Index Concepts Practiced on Day 4
-- ================================================

-- Single column index on dept_id
-- Used for queries filtering by department
CREATE INDEX idx_emp_dept ON employees(dept_id);

-- After index creation EXPLAIN PLAN shows:
-- INDEX RANGE SCAN + TABLE ACCESS BY ROWID
-- Oracle finds rows in index first, fetches by physical address

-- Single column index on emp_id (primary key column)
-- Used for queries filtering by employee id
CREATE INDEX idx_emp ON employees(emp_id);

-- Test query using emp_id index
SELECT * FROM employees WHERE emp_id = 1;

-- Composite index on dept_id + salary
-- Useful when queries filter on both columns together
CREATE INDEX idx_emp_dept_sal ON employees(dept_id, salary);

-- This query uses the composite index efficiently
-- dept_id is the leading column so index kicks in
SELECT emp_id, dept_id, salary 
FROM employees 
WHERE dept_id = 10 AND salary > 80000;

-- This query does NOT use composite index efficiently
-- salary alone cannot use an index where dept_id is leading column
SELECT emp_id, dept_id, salary 
FROM employees 
WHERE salary > 80000;

-- Drop index when no longer needed
DROP INDEX idx_emp_dept;
DROP INDEX idx_emp;
DROP INDEX idx_emp_dept_sal;

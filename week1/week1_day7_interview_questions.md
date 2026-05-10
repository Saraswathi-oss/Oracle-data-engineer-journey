# Week 1 - Day 7: SQL Interview Questions

## Question 1: Find and Delete Duplicates

### Find duplicates
SELECT emp_id, COUNT(*)
FROM employees
GROUP BY emp_id
HAVING COUNT(*) > 1;

### Delete duplicates keeping one row
-- ROW_NUMBER assigns unique numbers within duplicate groups
-- PARTITION BY all columns that define a duplicate
DELETE FROM (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY emp_id, dept_id, salary
               ORDER BY emp_id
           ) AS rn
    FROM employees e
) WHERE rn > 1;

## Question 2: UNION vs UNION ALL
- UNION: removes duplicates, slower
- UNION ALL: keeps all rows including duplicates, faster
- UNION ALL preferred for transaction history, audit logs
- UNION preferred when distinct results needed across datasets

## Question 3: Correlated Subquery
- Runs once per row in outer query
- References outer query column
- Performance killer on large tables
- Fix: replace with CTE or window function

## Question 4: Fact vs Dimension Table
- Dimension: descriptive data — customer name, city, product category
- Fact: measurable transactional data — sales amount, quantity, revenue
- Fact table joins to dimension tables using foreign keys

## Question 5: Orders with No Matching Customer

### Approach 1: LEFT JOIN + IS NULL
SELECT * FROM orders o
LEFT JOIN customer c ON o.cust_id = c.cust_id
WHERE c.cust_id IS NULL;

### Approach 2: MINUS
SELECT * FROM orders
WHERE order_id IN (
    SELECT order_id FROM orders
    MINUS
    SELECT order_id FROM customer
);

## Question 6: DELETE vs TRUNCATE vs DROP
| Command | Rows | Structure | Rollback | Speed |
|---|---|---|---|---|
| DELETE | Filtered | Stays | Yes | Slow |
| TRUNCATE | All | Stays | No | Fast |
| DROP | All | Gone | No | Instant |

- DELETE logs every row — supports rollback
- TRUNCATE deallocates data pages — no row logging
- DROP removes entire table including structure

## Question 7: Window Function vs GROUP BY
- GROUP BY collapses rows into groups — lose individual detail
- Window function keeps all rows intact
- Both give aggregated values but window function preserves row level data

## Question 8: Slow Query Debugging Checklist
1. Run EXPLAIN PLAN — understand what Oracle is doing
2. Check indexes — present and being used
3. Check SELECT columns — avoid SELECT *
4. Check WHERE filters — functions on indexed columns
5. Check data volume — new data loaded recently
6. Check statistics — run DBMS_STATS if stale
7. Check recent code changes

## Question 9: Materialized View
- Regular view: saved SQL, runs every time, no data stored
- Materialized view: stores result physically, refresh on schedule
- Use when heavy query joining large tables runs frequently
- Gives instant response to many users instead of rerunning query

## Question 10: Consecutive Days Challenge
-- PENDING -- attempt before Week 2 starts
-- Hint: Use LAG + date arithmetic + CTEs together

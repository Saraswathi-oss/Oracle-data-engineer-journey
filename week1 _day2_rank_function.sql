-- ================================================
-- Oracle Fusion AI Engineer Journey
-- Week 1 - Day 2: RANK, DENSE_RANK, ROW_NUMBER, LAG, LEAD
-- Author: Saraswathi
-- ================================================

-- Setup: Create sales table
CREATE TABLE sales (
    rep_name VARCHAR2(50),
    region   VARCHAR2(50),
    revenue  NUMBER
);

INSERT INTO sales VALUES ('Priya',   'South', 90000);
INSERT INTO sales VALUES ('Meera',   'South', 90000);
INSERT INTO sales VALUES ('Asha',    'South', 75000);
INSERT INTO sales VALUES ('Ravi',    'North', 85000);
INSERT INTO sales VALUES ('Kiran',   'North', 85000);
INSERT INTO sales VALUES ('Suresh',  'North', 70000);
INSERT INTO sales VALUES ('Divya',   'East',  95000);
INSERT INTO sales VALUES ('Lakshmi', 'East',  80000);
INSERT INTO sales VALUES ('Anand',   'East',  80000);

COMMIT;

-- Challenge 1
-- Rank sales reps within each region by revenue descending
-- ROW_NUMBER: always unique, no tie handling
-- RANK: ties get same rank, next rank skips
-- DENSE_RANK: ties get same rank, no skip
SELECT 
    s.*,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC) AS rw_num,
    RANK()       OVER (PARTITION BY region ORDER BY revenue DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS dn_rnk
FROM sales s;

-- Challenge 2
-- Return top 2 reps per region including all tied reps at rank 2
-- DENSE_RANK used because it does not skip ranks on ties
-- dn_rnk < 3 returns rank 1 and rank 2 including all ties
SELECT rep_name, region, dn_rnk FROM (
    SELECT 
        s.*,
        DENSE_RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS dn_rnk
    FROM sales s
) WHERE dn_rnk < 3;

-- Challenge 3
-- Find exactly one top earner per department, no duplicates even on ties
-- ROW_NUMBER used because it always assigns unique rank
-- Even tied rows get different numbers, guaranteeing one row per dept
SELECT * FROM (
    SELECT 
        s.*,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC) AS rw_num
    FROM sales s
) WHERE rw_num = 1;

-- LAG/LEAD Challenge
-- Show each rep's revenue, previous rep revenue, next rep revenue
-- and difference between current and previous revenue
-- LAG looks at previous row, LEAD looks at next row within partition
-- First row in each region has NULL for prv_sal so diff is also NULL
SELECT rep_name, revenue, prv_sal, lead_sal, (revenue - prv_sal) AS diff FROM (
    SELECT 
        s.*,
        LAG(revenue)  OVER (PARTITION BY region ORDER BY revenue DESC) AS prv_sal,
        LEAD(revenue) OVER (PARTITION BY region ORDER BY revenue DESC) AS lead_sal
    FROM sales s
);



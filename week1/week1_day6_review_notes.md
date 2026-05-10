# Week 1 - Day 6: Review Notes

## SQL Concepts Reviewed

### WHERE vs HAVING
- WHERE filters rows before grouping
- HAVING filters groups after aggregation
- Cannot use aggregate functions in WHERE clause

### JOIN Types
- INNER JOIN: returns only matched rows
- LEFT JOIN: returns all left table rows + matched right rows
- Unmatched right table columns return NULL in LEFT JOIN

### Query Optimization Checklist
1. Run EXPLAIN PLAN first
2. Check indexes on filtered columns
3. Avoid SELECT * — fetch only needed columns
4. Avoid functions on indexed columns in WHERE
5. Check data volume and statistics
6. Check recent code changes

### CTE vs Subquery
- Subquery cannot be reused in same query
- CTE is named, can be referenced multiple times
- CTE is cleaner and easier to debug

### ROW_NUMBER Danger
- Non-deterministic on tied data
- Always add tiebreaker column to ORDER BY
- Example: ORDER BY salary DESC, emp_id ASC

### Composite Index Rule
- Leading column must be in WHERE clause
- Query skipping leading column cannot use index efficiently
- Phone book rule: last name then first name

### DELETE vs TRUNCATE vs DROP
| Command | Rows | Structure | Rollback |
|---|---|---|---|
| DELETE | Filtered | Stays | ✅ Yes |
| TRUNCATE | All | Stays | ❌ No |
| DROP | All | Gone | ❌ No |

### Window Function vs GROUP BY
- GROUP BY collapses rows — lose individual detail
- Window function keeps all rows + adds aggregated value

### Correlated Subquery
- Runs once per row in outer query
- Performance killer on large tables
- Fix: replace with CTE or window function

### Materialized View vs View
- Regular view: no data stored, runs query every time
- Materialized view: stores result, refresh on schedule
- Use when heavy query runs frequently by many users

## FDI Concepts Reviewed

### FDI vs OAC
- FDI: prebuilt pipelines, models, subject areas
- OAC: empty platform, build everything yourself

### FDI Data Flow
Fusion Cloud Apps → FDI Pipelines → ADW → Semantic Model → OAC → Dashboards

### Subject Areas
- Prebuilt logical groupings of facts, dimensions, metrics, hierarchies
- Finance: AP Invoices, GL Journals
- HCM: Payroll, Workforce
- SCM: Purchase Orders, Inventory

### Semantic Model Extensions
- Extend prebuilt subject areas
- Add custom calculations, dimensions, hierarchies
- Never replace prebuilt content — extend on top

### FDI Consultant Approach
1. Gather requirements and filter conditions first
2. Check presentation and logical layer for existing content
3. Use semantic extensions for missing calculations
4. Deliver and validate with business user

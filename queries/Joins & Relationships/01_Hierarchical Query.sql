/*
Question:
Find all employees and their direct/indirect reports up to 3 levels deep, showing the management chain for each employee.

Business Context:
This query helps organizations visualize their management hierarchy up to 3 levels deep,
useful for understanding reporting structures, span of control analysis, and organizational planning.
Commonly used in HR analytics, org chart generation, and management reporting.

Approach:
I started with the employees table, then recursively followed the reporting relationships to capture each employee’s direct and indirect reports up to 3 levels. 
For each employee, I built the management chain showing who reports to whom at each level.
*/

WITH RECURSIVE employees_hierarchy AS (
     -- Anchor query: Start with top-level employees (no manager)
     SELECT e.EmployeeID,
            e.FirstName,
            e.LastName,
            e.ReportsTo,
            1 AS level,  -- Top level is level 1
            CONCAT(e.FirstName, ' ', e.LastName) AS management_chain
     FROM Employees e
     WHERE e.ReportsTo IS NULL  -- Start hierarchy from the top
     
     UNION ALL
     
     -- Recursive query: Get direct reports of current level employees
     SELECT emp.EmployeeID,
            emp.FirstName,
            emp.LastName,
            emp.ReportsTo,
            h.level + 1 AS level,  -- Increment level for each recursion
            -- Build management chain by appending current employee to manager's chain
            CONCAT(h.management_chain, ' --> ', emp.FirstName, ' ', emp.LastName)
     FROM Employees emp
     JOIN employees_hierarchy h
          ON h.EmployeeID = emp.ReportsTo  -- Join on manager-employee relationship
     WHERE h.level < 3  -- Stop recursion at 3 levels deep
)

-- Return all employees in hierarchy up to 3 levels
SELECT EmployeeID,
       FirstName,
       LastName,
       ReportsTo,
       level,
       management_chain
FROM employees_hierarchy
ORDER BY management_chain;  -- Order by chain to show hierarchical grouping

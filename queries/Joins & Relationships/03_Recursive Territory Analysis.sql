/*
Question:
For each region, find the total sales amount and the percentage it contributes to the parent region's total (if applicable).

Business Context:
Helps assess sales performance hierarchically and identify top-performing territories and regions.

Approach:
1. Compute sales per territory.
2. Aggregate territory sales to regions.
3. Calculate grand total sales.
4. Combine territories and regions with their respective % contributions.
5. Order results: regions first, then territories by sales.
*/

WITH TerritorySales AS (
    -- Calculate sales for each territory (child level)
    SELECT 
        t.TerritoryID,
        t.TerritoryDescription,
        t.RegionID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TerritorySales
    FROM Orders o
    JOIN "Order Details" od ON o.OrderID = od.OrderID
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
    JOIN Territories t ON et.TerritoryID = t.TerritoryID
    GROUP BY t.TerritoryID, t.TerritoryDescription, t.RegionID
),
RegionSales AS (
    -- Calculate sales for each region (parent level)
    SELECT 
        r.RegionID,
        r.RegionDescription,
        SUM(ts.TerritorySales) AS RegionSales
    FROM TerritorySales ts
    JOIN Regions r ON ts.RegionID = r.RegionID
    GROUP BY r.RegionID, r.RegionDescription
),
GrandTotal AS (
    -- Calculate overall total across all regions
    SELECT SUM(RegionSales) AS TotalSales FROM RegionSales
),
CombinedResults AS (
    SELECT 
        -- For territories (child regions)
        t.TerritoryDescription AS Region,
        ROUND(t.TerritorySales, 2) AS TotalSales,
        -- Percentage of parent region (if applicable)
        CASE 
            WHEN r.RegionSales > 0 
            THEN ROUND((t.TerritorySales * 100.0 / r.RegionSales), 2)
            ELSE 0 
        END AS PercentOfParentRegion,
        'Territory' AS LevelType,
        r.RegionDescription AS ParentRegion
        
    FROM TerritorySales t
    JOIN RegionSales r ON t.RegionID = r.RegionID
    
    UNION ALL
    
    SELECT 
        -- For regions (parent level)
        r.RegionDescription AS Region,
        ROUND(r.RegionSales, 2) AS TotalSales,
        -- Percentage of grand total (since regions have no parent in this hierarchy)
        ROUND((r.RegionSales * 100.0 / gt.TotalSales), 2) AS PercentOfParentRegion,
        'Region' AS LevelType,
        'All Regions' AS ParentRegion
        
    FROM RegionSales r
    CROSS JOIN GrandTotal gt
)
-- Now we can reference the column aliases in ORDER BY
SELECT *
FROM CombinedResults
ORDER BY 
    CASE WHEN LevelType = 'Region' THEN 1 ELSE 2 END,
    ParentRegion,
    TotalSales DESC;

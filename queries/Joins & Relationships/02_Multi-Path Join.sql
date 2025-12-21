/*
Question:
Find customers who have purchased from more than 5 suppliers.

Business Context:
This analysis helps identify customers with diverse supply chains,
which may indicate sophisticated procurement strategies, risk mitigation practices,
or varied product needs. Useful for sales teams to understand customer buying patterns,
supply chain managers to assess customer dependencies, and strategic planners for
market segmentation.

Approach:
I started with individual order details, linked them to orders and customers, 
then linked products to suppliers. 
I counted how many distinct suppliers each customer purchased from and filtered to customers with more than 5 suppliers.
*/

SELECT c.CustomerID,
       c.CompanyName,
       COUNT(DISTINCT p.SupplierID) AS Suppliers_count
FROM Customers c
JOIN Orders o
     ON o.CustomerID = c.CustomerID
JOIN [Order Details] od
     ON od.OrderID = o.OrderID
JOIN Products p
     ON p.ProductID = od.ProductID
-- Group data by customer
GROUP BY c.CustomerID,
         c.CompanyName
-- Only include customers with significant supplier diversification
HAVING COUNT(DISTINCT p.SupplierID) > 5
-- Show most diversified customers first
ORDER BY Suppliers_count DESC;

/*
Question:
Find products that were shipped via shippers located in the same country as the product's supplier.

Business Impact:
Identifies opportunities for optimizing supply chains by using local shipping partners, 
potentially reducing costs, transit times, and customs complications while supporting domestic logistics networks.

Approch:
- Link products to their suppliers to get origin countries.
- Trace product orders to identify shipping companies used.
- Compare supplier countries with shipping destination countries.
- Filter for matches where both are in the same country.
- Return distinct product-shipper combinations with order details

*/

SELECT DISTINCT
    p.ProductID,
    p.ProductName,
    s.CompanyName AS SupplierName,
    s.Country AS SupplierCountry,
    shp.CompanyName AS ShipperName,
    o.ShipCountry AS ShipperCountry,
    o.OrderID,
    o.OrderDate
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
INNER JOIN `Order Details` od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Shippers shp ON o.ShipVia = shp.ShipperID
WHERE s.Country = o.ShipCountry
ORDER BY p.ProductName, o.OrderDate;

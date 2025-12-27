/*
Question:
Find orders where the shipped date exceeded the required date AND the shipping company is different from the supplier's country.

Business Imapact:
1. Customer Dissatisfaction – Late deliveries frustrate customers and risk lost future sales.
2. Higher Costs – Leads to refunds, expedited shipping fees, and extra support time.
3. Inefficient Shipping – Using non-local carriers causes customs delays and longer transit times.
4. Payment Delays – Late shipments slow down invoicing and cash collection.
5. Brand Damage – Repeated delays hurt reliability, especially with business clients.
*/

SELECT DISTINCT 
       o.OrderID,
       s.CompanyName,
       o.ShippedDate,
       o.RequiredDate
FROM Orders o
JOIN "Order Details" od 
      ON od.OrderID = o.OrderID
JOIN Products p 
     ON p.ProductID = od.ProductID
JOIN Suppliers s 
     ON s.SupplierID = p.SupplierID
WHERE ShippedDate  > RequiredDate
AND o.ShipCountry != s.Country;

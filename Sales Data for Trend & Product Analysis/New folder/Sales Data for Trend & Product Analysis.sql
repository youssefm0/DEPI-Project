SELECT 
    O.OrderID,
    O.OrderDate,
    O.CustomerID,
    C.CustomerName,
    OL.StockItemID,
    SI.StockItemName,
    OL.Quantity,
    OL.UnitPrice,
    OL.TaxRate,
    (OL.Quantity * OL.UnitPrice) AS LineRevenue,
    (OL.Quantity * OL.UnitPrice * OL.TaxRate / 100.0) AS TaxAmount,
    ST.TransactionDate
FROM Sales.Orders O
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
JOIN Sales.Customers C ON O.CustomerID = C.CustomerID
JOIN Warehouse.StockItems SI ON OL.StockItemID = SI.StockItemID
LEFT JOIN Sales.CustomerTransactions ST ON C.CustomerID = ST.CustomerID
WHERE O.OrderDate >= '2015-01-01' AND O.OrderDate < '2015-02-01';

-- # What are the top 10 products by total quantity sold?
SELECT TOP 10 
    SI.StockItemName,
    SUM(OL.Quantity) AS TotalQuantity
FROM Sales.OrderLines OL
JOIN Warehouse.StockItems SI ON OL.StockItemID = SI.StockItemID
GROUP BY SI.StockItemName
ORDER BY TotalQuantity DESC;

-- # Which 10 customers spent the most?
SELECT TOP 10 
    C.CustomerName,
    SUM(OL.Quantity * OL.UnitPrice) AS TotalSpent
FROM Sales.Orders O
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
JOIN Sales.Customers C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerName
ORDER BY TotalSpent DESC;

-- # How many orders were made in January 2015?
SELECT 
COUNT(*) AS OrdersInJan2015
FROM Sales.Orders
WHERE OrderDate >= '2015-01-01' AND OrderDate < '2015-02-01';

-- # What is the average order value?
SELECT AVG(OrderTotal.Total) AS AverageOrderValue
FROM (
    SELECT 
        O.OrderID,
        SUM(OL.Quantity * OL.UnitPrice) AS Total
    FROM Sales.Orders O
    JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
    GROUP BY O.OrderID
) AS OrderTotal;

-- # Show total sales per day in January 2015
SELECT 
    CAST(O.OrderDate AS DATE) AS OrderDay,
    SUM(OL.Quantity * OL.UnitPrice) AS TotalSales
FROM Sales.Orders O
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
WHERE O.OrderDate >= '2015-01-01' AND O.OrderDate < '2015-02-01'
GROUP BY CAST(O.OrderDate AS DATE)
ORDER BY OrderDay;

-- # How many different customers ordered in January 2015?
SELECT 
COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM Sales.Orders
WHERE OrderDate >= '2015-01-01' AND OrderDate < '2015-02-01';

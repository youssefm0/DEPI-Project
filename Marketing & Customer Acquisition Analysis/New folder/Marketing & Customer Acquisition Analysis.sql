SELECT 
    C.CustomerID,
    C.CustomerName,
    C.BillToCustomerID,
    C.CustomerCategoryID,
    CC.CustomerCategoryName,
    C.BuyingGroupID,
    C.AccountOpenedDate,
    O.OrderID,
    O.OrderDate,
    OL.Quantity,
    OL.UnitPrice,
    (OL.Quantity * OL.UnitPrice) AS Revenue

FROM Sales.Customers C
LEFT JOIN Sales.CustomerCategories CC ON C.CustomerCategoryID = CC.CustomerCategoryID
LEFT JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
LEFT JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
WHERE C.AccountOpenedDate IS NOT NULL;

-- #Who are the top 10 customers by total revenue?
SELECT TOP 10
    C.CustomerID,
    C.CustomerName,
    SUM(C.)
FROM Sales.Customers C
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalRevenue DESC;

-- #Who are the top 10 customers by total quantity purchased?
SELECT TOP 10 
    C.CustomerID,
    C.CustomerName,
    SUM(OL.Quantity) AS TotalQuantity
FROM Sales.Customers C
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalQuantity DESC;

-- #Who are the top 10 customers by number of orders?
SELECT TOP 10 
    C.CustomerID,
    C.CustomerName,
    COUNT(O.OrderID) AS NumberOfOrders
FROM Sales.Customers C
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY NumberOfOrders DESC;

-- #Which customer categories generate the most revenue?
SELECT 
    CC.CustomerCategoryName,
    SUM(OL.Quantity * OL.UnitPrice) AS TotalRevenue
FROM Sales.Customers C
JOIN Sales.CustomerCategories CC ON C.CustomerCategoryID = CC.CustomerCategoryID
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY CC.CustomerCategoryName
ORDER BY TotalRevenue DESC;

-- #How many new customers were acquired each year?
SELECT 
    YEAR(C.AccountOpenedDate) AS Year,
    COUNT(*) AS NewCustomers
FROM Sales.Customers C
WHERE C.AccountOpenedDate IS NOT NULL
GROUP BY YEAR(C.AccountOpenedDate)
ORDER BY Year;

-- #Which buying groups generate the most revenue?
SELECT 
    BG.BuyingGroupName,
    SUM(OL.Quantity * OL.UnitPrice) AS TotalRevenue
FROM Sales.Customers C
JOIN Sales.BuyingGroups BG ON C.BuyingGroupID = BG.BuyingGroupID
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY BG.BuyingGroupName
ORDER BY TotalRevenue DESC;

-- #Top 10 orders by revenue
SELECT TOP 10
    O.OrderID,
    O.OrderDate,
    C.CustomerName,
    SUM(OL.Quantity * OL.UnitPrice) AS OrderRevenue
FROM Sales.Orders O
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
JOIN Sales.Customers C ON O.CustomerID = C.CustomerID
GROUP BY O.OrderID, O.OrderDate, C.CustomerName
ORDER BY OrderRevenue DESC;

-- #Average order value per customer
SELECT 
    C.CustomerID,
    C.CustomerName,
    AVG(OL.Quantity * OL.UnitPrice) AS AvgOrderValue
FROM Sales.Customers C
JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY AvgOrderValue DESC;

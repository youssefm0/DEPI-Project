SELECT TOP 2000
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

ORDER BY NEWID() --To Get Random Orders

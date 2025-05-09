SELECT 
    S.SupplierID,
    S.SupplierName,
    SI.StockItemID,
    SI.StockItemName,
    SI.Brand,
    SI.LeadTimeDays,
    SI.UnitPackageID,
    PT.PackageTypeName,

    COUNT(DISTINCT PO.PurchaseOrderID) AS NumOrders,
    SUM(POL.OrderedOuters) AS TotalOrderedOuters,
    AVG(POL.ExpectedUnitPricePerOuter) AS AvgUnitPrice,
    SUM(POL.OrderedOuters * POL.ExpectedUnitPricePerOuter) AS TotalCost,
    AVG(WSI.QuantityOnHand) AS AvgQuantityOnHand

FROM Purchasing.PurchaseOrders PO
JOIN Purchasing.PurchaseOrderLines POL ON PO.PurchaseOrderID = POL.PurchaseOrderID
JOIN Purchasing.Suppliers S ON PO.SupplierID = S.SupplierID
JOIN Warehouse.StockItems SI ON POL.StockItemID = SI.StockItemID
JOIN Warehouse.StockItemHoldings WSI ON SI.StockItemID = WSI.StockItemID
JOIN Warehouse.PackageTypes PT ON POL.PackageTypeID = PT.PackageTypeID

GROUP BY 
    S.SupplierID, S.SupplierName,
    SI.StockItemID, SI.StockItemName,
    SI.Brand, SI.LeadTimeDays,
    SI.UnitPackageID, PT.PackageTypeName

ORDER BY TotalCost DESC;

-- #Who are the top 10 suppliers by total order cost?
SELECT TOP 10 
    S.SupplierID,
    S.SupplierName,
    SUM(POL.OrderedOuters * POL.ExpectedUnitPricePerOuter) AS TotalOrderCost
FROM Purchasing.PurchaseOrders PO
JOIN Purchasing.PurchaseOrderLines POL ON PO.PurchaseOrderID = POL.PurchaseOrderID
JOIN Purchasing.Suppliers S ON PO.SupplierID = S.SupplierID
GROUP BY S.SupplierID, S.SupplierName
ORDER BY TotalOrderCost DESC;

-- #What are the top 10 most ordered stock items?
SELECT TOP 10 
    SI.StockItemID,
    SI.StockItemName,
    SUM(POL.OrderedOuters) AS TotalOrdered
FROM Purchasing.PurchaseOrderLines POL
JOIN Warehouse.StockItems SI ON POL.StockItemID = SI.StockItemID
GROUP BY SI.StockItemID, SI.StockItemName
ORDER BY TotalOrdered DESC;

-- #Which employees are responsible for the highest number of purchase orders?
SELECT TOP 10 
    PO.ContactPersonID,
    P.FullName,
    COUNT(*) AS NumOrders
FROM Purchasing.PurchaseOrders PO
JOIN Application.People P ON PO.ContactPersonID = P.PersonID
GROUP BY PO.ContactPersonID, P.FullName
ORDER BY NumOrders DESC;

-- #Which stock items have the highest quantity on hand?
SELECT TOP 10 
    SI.StockItemID,
    SI.StockItemName,
    WSI.QuantityOnHand
FROM Warehouse.StockItemHoldings WSI
JOIN Warehouse.StockItems SI ON WSI.StockItemID = SI.StockItemID
ORDER BY WSI.QuantityOnHand DESC;

-- #What is the average lead time per supplier?
SELECT 
    S.SupplierID,
    S.SupplierName,
    AVG(SI.LeadTimeDays) AS AvgLeadTime
FROM Purchasing.Suppliers S
JOIN Warehouse.StockItems SI ON S.SupplierID = SI.SupplierID
GROUP BY S.SupplierID, S.SupplierName
ORDER BY AvgLeadTime DESC;

-- #Which package types are used the most in purchase orders?
SELECT TOP 10 
    PT.PackageTypeName,
    COUNT(*) AS UsageCount
FROM Purchasing.PurchaseOrderLines POL
JOIN Warehouse.PackageTypes PT ON POL.PackageTypeID = PT.PackageTypeID
GROUP BY PT.PackageTypeName
ORDER BY UsageCount DESC;

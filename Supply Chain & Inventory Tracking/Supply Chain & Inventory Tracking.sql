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

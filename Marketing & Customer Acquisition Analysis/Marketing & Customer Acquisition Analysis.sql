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

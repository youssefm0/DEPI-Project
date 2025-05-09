SELECT 
    PersonID,
    FullName,
    PreferredName,
    LogonName,
    EmailAddress,
    PhoneNumber,
    IsEmployee,
    IsSalesperson,
    IsSystemUser,
    IsPermittedToLogon,
    ValidFrom AS EmploymentStartedWhen,
    ValidTo AS EmploymentEndedWhen,

    -- If ValidTo is '9999...', the row is still current. Use GETDATE() to calculate DaysWorked until today.
    DATEDIFF(
        DAY, 
        ValidFrom, 
        IIF(ValidTo = '9999-12-31 23:59:59.9999999', GETDATE(), ValidTo)
    ) AS DaysWorked,

    -- Tag to know if this row is current or from the history
    IIF(ValidTo = '9999-12-31 23:59:59.9999999', 'Current', 'History') AS VersionSource

FROM Application.People
FOR SYSTEM_TIME ALL
WHERE IsEmployee = 1;

-- #How many current employees are there?
SELECT COUNT(*) AS CurrentEmployees
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo = '9999-12-31 23:59:59.9999999';

-- #What is the average tenure (in days) for current employees?
SELECT 
    AVG(DATEDIFF(DAY, ValidFrom, GETDATE())) AS AvgDaysWorked
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo = '9999-12-31 23:59:59.9999999';

-- #List top 10 longest-serving current employees
SELECT TOP 10
    PersonID,
    FullName,
    DATEDIFF(DAY, ValidFrom, GETDATE()) AS DaysWorked
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo = '9999-12-31 23:59:59.9999999'
ORDER BY DaysWorked DESC;

-- #How many employees left the company each year?
SELECT 
    YEAR(ValidTo) AS YearLeft,
    COUNT(*) AS EmployeesLeft
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo <> '9999-12-31 23:59:59.9999999'
GROUP BY YEAR(ValidTo)
ORDER BY YearLeft;

-- #How many employees were hired each year?
SELECT 
    YEAR(ValidFrom) AS YearHired,
    COUNT(*) AS EmployeesHired
FROM Application.People
WHERE IsEmployee = 1
GROUP BY YEAR(ValidFrom)
ORDER BY YearHired;

-- #Current vs Historical employee counts
SELECT 
    IIF(ValidTo = '9999-12-31 23:59:59.9999999', 'Current', 'History') AS VersionSource,
    COUNT(*) AS CountEmployees
FROM Application.People
WHERE IsEmployee = 1
GROUP BY IIF(ValidTo = '9999-12-31 23:59:59.9999999', 'Current', 'History');

-- #How many are permitted to log on among current employees?
SELECT 
    COUNT(*) AS PermittedToLogon
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo = '9999-12-31 23:59:59.9999999'
  AND IsPermittedToLogon = 1;

-- #How many current employees are also salespersons?
SELECT 
    COUNT(*) AS SalespersonEmployees
FROM Application.People
WHERE IsEmployee = 1
  AND ValidTo = '9999-12-31 23:59:59.9999999'
  AND IsSalesperson = 1;

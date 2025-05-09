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
WHERE IsEmployee = 1

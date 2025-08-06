/* This is example how to query datetime of data changes, if audit routine wasn't set*/

    USE [AdventureWorksDW2017]
    GO

    UPDATE dbo.FactFinance
    SET Date=getdate() , Amount=Amount+1
    WHERE FinanceKey=1
    GO

    WITH main as(   
        SELECT 
    '000'+CAST(FPLC.FILE_id AS NVARCHAR)+':'+CONVERT( VARCHAR(MAX),CAST(FPLC.page_id AS VARBINARY),2 ) page_Id,   FPLC.SLOT_id,
        FinanceKey,  Date, Amount
        FROM dbo.FactFinance (NOLOCK)   
        CROSS APPLY sys.fn_PhysLocCracker(%%physloc%%) AS FPLC
        WHERE FinanceKey=1   )  ,
            tlog as ( 
        SELECT page_id, l2.[Begin Time],L2.[End Time],
        l1.AllocUnitName l1_uname, l2.[Transaction Name] l2_tname,
        l1.[Transaction ID],        l2.[Transaction SID] SNAME

        FROM main
    JOIN
    sys.fn_dblog(NULL,NULL) l1 on main.page_id=[Page ID]
    and slot_id=main.slot_id

    LEFT JOIN sys.fn_dblog(NULL,NULL) l2 
    ON l2.[Transaction ID]=l1.[Transaction ID]  
        )

    SELECT PAGE_id,[Transaction ID], min([Begin Time]),min([End Time]),
    min(l1_uname),min(l2_tname),min(SUSER_SNAME(SNAME))
    FROM tlog
    GROUP BY [Transaction ID],PAGE_id


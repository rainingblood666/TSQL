/* This is example how to query datetime of data changes using SQL Server transactlog, if audit routine wasn't set*/

    USE [AdventureWorksDW2017]
    GO

    UPDATE dbo.FactFinance
    SET Date=getdate() , Amount=Amount+1
    WHERE FinanceKey=1
    GO

    WITH main as(   
        SELECT 
        replace(replace(sys.fn_PhysLocFormatter (%%physloc%%),')','')
        ,'(','') page,
        FinanceKey,  Date, Amount
        FROM dbo.FactFinance (NOLOCK)   
        WHERE FinanceKey=1   )  ,
            tlog as ( 
        SELECT page, l2.[Begin Time],L2.[End Time],
        l1.AllocUnitName l1_uname, l2.[Transaction Name] l2_tname,
        l1.[Transaction ID]
        FROM main
    JOIN
    sys.fn_dblog(NULL,NULL) l1 on PATINDEX('%'+main.page+'%',
    l1.[Lock Information] )>0
    LEFT JOIN sys.fn_dblog(NULL,NULL) l2 
    ON l2.[Transaction ID]=l1.[Transaction ID]  
        )
    SELECT PAGE,[Transaction ID], min([Begin Time]),min([End Time]),
    min(l1_uname),min(l2_tname)
    FROM tlog
    GROUP BY [Transaction ID],page

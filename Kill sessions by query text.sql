DECLARE @kill varchar(8000); SET @kill = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'
FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE database_id = db_id('db_MyDB') and session_id <> @@SPID 
    and text like '%proc_get_orders%'
EXEC(@kill);
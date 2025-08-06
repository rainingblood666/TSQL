    DECLARE @ts_now bigint = (SELECT cpu_ticks/(cpu_ticks/ms_ticks)FROM sys.dm_os_sys_info); 

    SELECT TOP(190) SQLProcessUtilization AS [SQL Server Process CPU Utilization], 
                   SystemIdle AS [System Idle Process], 
                   100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization], 
                   DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS [Event Time] 
    FROM ( 
          SELECT record.value('(./Record/@id)[1]', 'int') AS record_id, 
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') 
                AS [SystemIdle], 
                record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 
                'int') 
                AS [SQLProcessUtilization], [timestamp] 
          FROM ( 
                SELECT [timestamp], convert(xml, record) AS [record] 
                FROM sys.dm_os_ring_buffers 
                WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' 
                AND record LIKE '%<SystemHealth>%') AS x 
          ) AS y 
    ORDER BY /*[SQLProcessUtilization */ [timestamp] DESC;




	SELECT TOP(10)
	st.text
creation_time
, last_execution_time
, (total_worker_time+0.0)/1000 AS total_worker_time
, (total_worker_time+0.0)/(execution_count*1000) AS [AvgCPUTime] , execution_count
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(sql_handle) st
WHERE total_worker_time > 0
ORDER BY total_worker_time DESC

===============================


SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS Hyperthread_Ratio,
cpu_count/hyperthread_ratio AS Physical_CPU_Count,
--physical_memory_in_bytes/1048576 AS Physical_Memory_in_MB,
sqlserver_start_time, affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info
    
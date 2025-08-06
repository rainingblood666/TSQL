select cp.plan_handle 
from sys.dm_exec_cached_plans cp CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st where OBJECT_NAME(st.objectid, st.dbid) = 'proc_dom_rpt_Update'



DBCC FREEPROCCACHE (0x050043008218F327E03E36551402000001000000000000000000000000000000000000000000000000000000);
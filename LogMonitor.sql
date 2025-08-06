DECLARE @command varchar(2000) 

SELECT @command = 'USE ? 
  DECLARE @db_file_information table(db_nm__ varchar(50), lsize float,lsp_used float, status bit)
  INSERT INTO @db_file_information exec("DBCC SQLPERF(LOGSPACE)")
  SELECT db_nm, current_logsize, 
         max_logsize ,lsp_used ,
      "USE "+db_nm+" DBCC SHRINKFILE("+lf_name+","+ case when max_logsize>10 then cast(max_logsize as varchar) ELSE "9000" END +")"
      FROM @db_file_information 
      CROSS JOIN (SELECT DB_NAME() db_nm,    
                         CAST(( SUM(CONVERT(BIGINT, mf.size)) * 8 ) / 1024 / 1024 * .25 AS INT) as Max_Logsize  , 
                         CAST(( SUM(CONVERT(BIGINT, lf.size)) * 8 ) / 1024 / 1024 AS INT) current_logsize, 
                         MIN(lf.name)  lf_name
                         FROM   SYS.MASTER_FILES AS mf
                         CROSS JOIN
                         SYS.MASTER_FILES  AS lf
                         WHERE     mf.database_id = DB_ID()
                         AND       lf.database_id = DB_ID()    
                         AND mf.type_desc = "ROWS"
                         AND lf.type_desc = "LOG")t
                         WHERE (current_logsize>max_logsize and current_logsize>10)
                         AND db_nm=db_nm__      ' 
EXEC sp_MSforeachdb @command 


declare @db_file_information table(db_nm__ varchar(50), lsize float,lsp_used float, status bit)
  insert into @db_file_information exec("DBCC SQLPERF(LOGSPACE)")
SELECT db_nm, current_logsize, max_logsize ,db_nm__ 
FROM @db_file_information,(SELECT DB_NAME() db_nm,    
             CAST(( SUM(CONVERT(BIGINT, mf.size)) * 8 ) / 1024 / 1024 * .27 AS INT) as Max_Logsize  , 
             CAST(( SUM(CONVERT(BIGINT, lf.size)) * 8 ) / 1024 / 1024 AS INT) current_logsize  

   select *   FROM   
   
         sys.master_files AS mf

                CROSS JOIN
                sys.master_files AS lf
                WHERE     mf.database_id = DB_ID()
                AND       lf.database_id = DB_ID()    
                AND       db_nm__ = 'aa"  
                AND mf.type_desc = "ROWS"
                AND lf.type_desc = "LOG")t
                WHERE current_logsize>max_logsize 

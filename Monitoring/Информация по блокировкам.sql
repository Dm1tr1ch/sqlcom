-- Показать цепочку блокировок
SELECT DB_NAME(pr1.dbid) AS 'DB'
	,pr1.spid AS 'ID жертвы'	
	,RTRIM(pr1.loginame) AS 'Login жертвы'	
	,pr1.waittime/1000 as 'Время ожидания жертвы, sec'	
	,pr2.spid AS 'ID виновника'
	,RTRIM(pr2.loginame) AS 'Login виновника'
	,pr1.program_name AS 'программа жертвы'
	,pr2.program_name AS 'программа виновника'
	,txt.[text] AS 'Запрос виновника'
	,pr1_txt.[text] AS 'Запрос жертвы'
	,pr1.login_time
	,pr1.last_batch INTO #blocking_info
FROM   MASTER.dbo.sysprocesses pr1(NOLOCK)
JOIN MASTER.dbo.sysprocesses pr2(NOLOCK)
	ON  (pr2.spid = pr1.blocked) 
OUTER APPLY sys.[dm_exec_sql_text](pr2.[sql_handle]) AS txt
OUTER APPLY sys.[dm_exec_sql_text](pr1.[sql_handle]) AS pr1_txt
WHERE  pr1.blocked <> 0

SELECT * FROM #blocking_info

-- Подробности виновников блокировок
SELECT spid,loginame,lastwaittype,DB_NAME(er.[dbid]) as [DB_NAME],[status],cmd,[program_name],cpu,physical_io,login_time,last_batch,[text] FROM sys.sysprocesses er
left join sys.dm_exec_query_stats qs on er.sql_handle=qs.sql_handle
outer apply sys.dm_exec_sql_text((er.sql_handle)) st
WHERE spid IN (SELECT DISTINCT [ID виновника] FROM #blocking_info)

DROP TABLE #blocking_info

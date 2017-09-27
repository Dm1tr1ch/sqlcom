-- Изначально нагрузка снимается за 3 минуты, поменять можно тут WAITFOR DELAY '00:03:00'
	SELECT s.[spid]
		  ,s.[loginame]
		  ,s.[open_tran]
		  ,s.[blocked]
		  ,s.[waittime]
		  ,s.[cpu]
		  ,s.[physical_io]
		  ,s.[memusage]
		   INTO #sysprocesses2
	FROM   sys.[sysprocesses] s
	WHERE spid > 49

	WAITFOR DELAY '00:03:00' 

	SELECT txt.[text]
		  ,s.[spid]
		  ,s.[loginame]
		  ,s.[hostname]
		  ,DB_NAME(s.[dbid]) [db_name]
		  ,MAX(s.lastwaittype) [last_waittime]
		  ,SUM(s.[waittime] -ts.[waittime]) [waittime]
		  ,SUM(s.[cpu] -ts.[cpu]) [cpu]
		  ,SUM(s.[physical_io] -ts.[physical_io]) [physical_io]
		  ,s.[program_name]
	FROM   sys.[sysprocesses] s
		   JOIN #sysprocesses2 ts
				ON  s.[spid] = ts.[spid]
				AND s.[loginame] = ts.[loginame]
		   OUTER APPLY sys.[dm_exec_sql_text](s.[sql_handle]) AS txt
	WHERE  s.[cpu] -ts.[cpu] 
		   + s.[physical_io] -ts.[physical_io] 
		   > 10
		   OR  (s.[waittime] -ts.[waittime]) > 30
	GROUP BY
		   txt.[text]
		  ,s.[spid]
		  ,s.[loginame]
		  ,s.[hostname]
		  ,DB_NAME(s.[dbid])
		  ,s.[program_name]
	ORDER BY
		   [physical_io] DESC
		   
	DROP TABLE #sysprocesses2
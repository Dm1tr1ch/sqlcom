-- Изначально нагрузка снимается за 3 минуты, поменять можно тут WAITFOR DELAY '00:03:00'

	SELECT [sql_handle], SUM(execution_count) as execution_count, SUM(total_worker_time) as total_worker_time, SUM(total_logical_reads) as total_logical_reads, SUM(total_logical_writes) as total_logical_writes
			   INTO #sysprocesses
	FROM sys.dm_exec_query_stats
	WHERE last_execution_time > DATEADD(mi,-20,GETDATE())
	GROUP BY [sql_handle]

		WAITFOR DELAY '00:03:00'

	SELECT [sql_handle], SUM(execution_count) as execution_count, SUM(total_worker_time) as total_worker_time, SUM(total_logical_reads) as total_logical_reads, SUM(total_logical_writes) as total_logical_writes
	INTO #sysprocesses1
	FROM sys.dm_exec_query_stats
	WHERE last_execution_time > DATEADD(mi,-20,GETDATE())
	GROUP BY [sql_handle]


		SELECT TOP 1000 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
		((CASE qs.statement_end_offset
		WHEN -1 THEN DATALENGTH(qt.TEXT)
		ELSE qs.statement_end_offset
		END - qs.statement_start_offset)/2)+1),
		qt.TEXT,
		ss1.execution_count - ss.execution_count as difference_execution_count,
		ss1.total_worker_time - ss.total_worker_time as difference_total_worker_time,
		ss1.total_logical_reads - ss.total_logical_reads as difference_total_logical_reads,
		ss1.total_logical_writes - ss.total_logical_writes as difference_total_logical_writes,	
		qs.execution_count,
		qs.total_worker_time,
		qs.total_logical_reads,
		qs.total_logical_writes,
		qs.total_elapsed_time/1000 total_elapsed_time_ms,
		qs.last_elapsed_time/1000 last_elapsed_time_ms,
		qs.max_elapsed_time/1000 max_elapsed_time_ms,
		qs.min_elapsed_time/1000 min_elapsed_time_ms,
		qs.max_worker_time,
		qs.min_worker_time,	
		qs.last_worker_time,
		qs.last_logical_reads,
		qs.last_logical_writes,
		qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
		qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
		qs.last_execution_time,
		CAST(qp.query_plan as XML)
		,DB_NAME(qt.dbid)	
		,qt.[objectid] -- по данному id можно вычислить что за объект SELECT name FROM sys.objects WHERE [object_id] = 238623893

	FROM sys.dm_exec_query_stats qs
	INNER JOIN #sysprocesses1 ss1 ON ss1.sql_handle = qs.sql_handle
	INNER JOIN #sysprocesses ss ON ss.sql_handle = qs.sql_handle AND ss1.execution_count > ss.execution_count
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
	ORDER BY ((ss1.total_logical_reads - ss.total_logical_reads) + (ss1.total_logical_writes - ss.total_logical_writes)) / (ss1.execution_count - ss.execution_count) DESC
	--ORDER BY difference_total_worker_time DESC -- CPU time
			   
	DROP TABLE #sysprocesses	
	DROP TABLE #sysprocesses1
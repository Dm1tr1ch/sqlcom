-- SQL Server позволяет получать некоторую информацию о запросах из кэша. Если обновление кэша запросов происходит слишком часто
-- или запросы просто не кэшируются, то в результате этой выборки они отражены не будут

-- Изначально скрипт регистрирует все запросы, которые выполнялись более 1 раза или за последние сутки по количеству 
-- чтений+записи/количество выполнений

-- Вы можете легко поменять параметры сортировки убрав комментарии у одного из полей ORDER BY и добавив комментарий к прошлому ORDER BY

-- Так же вы можете убрать ограчения на количество выполнений и глубину анализа закомментировав условие WHERE

SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
	((CASE qs.statement_end_offset
	WHEN -1 THEN DATALENGTH(qt.TEXT)
	ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2)+1),
	qs.total_elapsed_time/1000 total_elapsed_time_ms,
	qs.last_elapsed_time/1000 last_elapsed_time_ms,
	qs.max_elapsed_time/1000 max_elapsed_time_ms,
	qs.min_elapsed_time/1000 max_elapsed_time_ms,
	qs.max_worker_time,
	qs.min_worker_time,
	qs.last_worker_time,
	qs.total_worker_time,
	qs.execution_count,
	qs.total_logical_reads, qs.last_logical_reads,
	qs.total_logical_writes, qs.last_logical_writes,
	qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
	qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
	qs.last_execution_time,
	CAST(qp.query_plan as XML),	
	qt.[objectid] -- по данному id можно вычислить что за объект SELECT name FROM sys.objects WHERE [object_id] = 238623893
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE (qs.execution_count > 1 OR last_execution_time > GETDATE() -1)
ORDER BY (qs.total_logical_reads + qs.total_logical_writes) / qs.execution_count DESC -- по-умолчанию
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time
-- ORDER BY total_elapsed_time_ms DESC -- Общее время выполнения

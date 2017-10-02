-- Первый вариант
	SELECT session_id, 
	  SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
	  SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
	FROM sys.dm_db_task_space_usage 
	GROUP BY session_id
	ORDER BY SUM(internal_objects_alloc_page_count) + SUM(internal_objects_dealloc_page_count) DESC
	
-- Второй вариант
	SELECT TOP 10 session_id, database_id, user_objects_alloc_page_count + internal_objects_alloc_page_count / 129 AS tempdb_usage_MB
	FROM sys.dm_db_session_space_usage
	ORDER BY user_objects_alloc_page_count + internal_objects_alloc_page_count DESC;
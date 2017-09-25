-- Использование памяти по БД
	WITH AggregateBufferPoolUsage
	AS
	(SELECT DB_NAME(database_id) AS [Database Name],
	CAST(COUNT(*) * 8/1024.0 AS DECIMAL (10,2))  AS [CachedSize]
	FROM sys.dm_os_buffer_descriptors WITH (NOLOCK)
	WHERE database_id > 4 -- system databases
	AND database_id <> 32767 -- ResourceDB
	GROUP BY DB_NAME(database_id))
	SELECT ROW_NUMBER() OVER(ORDER BY CachedSize DESC) AS [Buffer Pool Rank], [Database Name], CachedSize AS [Cached Size (MB)],
		   CAST(CachedSize / SUM(CachedSize) OVER() * 100.0 AS DECIMAL(5,2)) AS [Buffer Pool Percent]
	FROM AggregateBufferPoolUsage
	ORDER BY [Buffer Pool Rank] OPTION (RECOMPILE);
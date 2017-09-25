-- Задержки файловой системы для файлов БД (за всё время)/использование диска
	SELECT DB_NAME(dm_io_virtual_file_stats.database_id) AS [Database Name], dm_io_virtual_file_stats.file_id,f.name,f.physical_name, io_stall_read_ms, num_of_reads,
	CAST(io_stall_read_ms/(1.0 + num_of_reads) AS NUMERIC(10,1)) AS [avg_read_stall_ms],io_stall_write_ms, 
	num_of_writes,CAST(io_stall_write_ms/(1.0+num_of_writes) AS NUMERIC(10,1)) AS [avg_write_stall_ms],
	io_stall_read_ms + io_stall_write_ms AS [io_stalls], num_of_reads + num_of_writes AS [total_io],
	CAST((io_stall_read_ms + io_stall_write_ms)/(1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) 
	AS [avg_io_stall_ms]
	FROM sys.dm_io_virtual_file_stats(null,null) INNER JOIN sys.master_files as f ON dm_io_virtual_file_stats.database_id = f.database_id AND dm_io_virtual_file_stats.file_id = f.file_id
	ORDER BY io_stalls DESC,avg_io_stall_ms DESC;
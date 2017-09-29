 -- Изначально нагрузка снимается за 1 минуту, поменять можно тут WAITFOR DELAY '00:01:00'
	DECLARE @counter int = 0
	WHILE @counter < 5
	BEGIN
	DECLARE @batch_counter_start bigint = (SELECT cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'Batch Requests/sec')

	WAITFOR DELAY '00:01:00'

	DECLARE @batch_counter_end bigint = (SELECT cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'Batch Requests/sec')

	SELECT @batch_counter_end - @batch_counter_start as [Батчей за минуту]

	SET @counter = @counter + 1

	END 
-- Вместо DBCC OPENTRAN()/Открытые транзакции
	SELECT DB_NAME(dt.database_id),
	CASE dt.database_transaction_state
		WHEN 1  THEN 'Not initialized'
		WHEN 3  THEN  'initialized, but not producing log records'
		WHEN 4  THEN  'Producing log records'
		WHEN 5  THEN  'Prepared'
		WHEN 10  THEN  'Committed'
		WHEN 11  THEN  'Rolled back'
		WHEN 12  THEN  'Commit in process' END
		,at.name
	,st.session_id
	,es.[host_name]
	,es.[program_name]
	,ec.connect_time
	,es.login_time
	,es.last_request_start_time
	,es.last_request_end_time
	,es.cpu_time
	,es.logical_reads
	,es.reads
	,es.writes
	,est.[text]
	FROM sys.dm_tran_database_transactions dt 
	FULL JOIN sys.dm_tran_session_transactions st ON dt.transaction_id = st.transaction_id
	FULL JOIN sys.dm_tran_active_transactions at ON dt.transaction_id = at.transaction_id
	FULL JOIN sys.dm_exec_connections ec ON ec.session_id = st.session_id
	FULL JOIN sys.dm_exec_sessions es ON es.session_id = st.session_id
	outer apply sys.dm_exec_sql_text((ec.most_recent_sql_handle)) est
	WHERE st.session_id IS NOT NULL
	
-- Открытые транзакции для таблиц в памяти
	SELECT xtp_transaction_id ,
	transaction_id ,
	session_id ,
	begin_tsn ,
	end_tsn ,
	state_desc
	FROM sys.dm_db_xtp_transactions
	WHERE transaction_id > 0;
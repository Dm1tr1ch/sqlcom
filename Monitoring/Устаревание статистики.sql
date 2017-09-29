-- После SQL Server 2008 R2
SELECT
    sch.name  AS 'Schema',
    so.name as 'Table',
    ss.name AS 'Statistic'
	FROM sys.stats ss
	JOIN sys.objects so ON ss.object_id = so.object_id
	JOIN sys.schemas sch ON so.schema_id = sch.schema_id
	OUTER APPLY sys.dm_db_stats_properties(so.object_id, ss.stats_id) AS sp
	WHERE so.TYPE = 'U'
	AND sp.modification_counter >  CASE WHEN (sp.rows < 25000)
			THEN (sqrt((sp.rows) * 1000))
		WHEN ((sp.rows) > 25000 AND (sp.rows) <= 10000000)
			THEN ((sp.rows) * 0.10 + 500)
		WHEN ((sp.rows) > 10000000 AND (sp.rows) <= 100000000)
			THEN ((sp.rows) * 0.03 + 500)
		WHEN ((sp.rows) > 100000000)
			THEN ((sp.rows) * 0.01 + 500) END
	AND sp.last_updated < getdate() - 1 -- как давно последний раз обновлялась статистика
	ORDER BY sp.last_updated
	DESC
	
-- До SQL Server 2008 R2	
	select DISTINCT SCHEMA_NAME(uid) as gerg, -- Обязательно указать DISTINCT, чтобы убрать дубликаты
		object_name (i.id)as objectname,		
		i.name as indexname
		from sysindexes i INNER JOIN dbo.sysobjects o ON i.id = o.id
		LEFT JOIN sysindexes si ON si.id = i.id AND si.rows > 0 -- добавлено для анализа статистики столбцов
		where i.rowmodctr > 
		CASE WHEN (si.rows < 25000)
			THEN (sqrt((i.rows) * 1000))
		WHEN ((si.rows) > 25000 AND (si.rows) <= 10000000)
			THEN ((si.rows) * 0.10 + 500)
		WHEN ((si.rows) > 10000000 AND (si.rows) <= 100000000)
			THEN ((si.rows) * 0.03 + 500)
		WHEN ((si.rows) > 100000000)
			THEN ((si.rows) * 0.01 + 500)
		END
		AND i.name not like 'sys%'
		AND object_name(i.id) not like 'sys%'
		AND STATS_DATE(i.id, i.indid) < GetDATE()-1
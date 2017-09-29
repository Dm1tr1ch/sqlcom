SELECT  t.name AS [TableName]
	  , fi.page_count AS [Pages]
	  , fi.record_count AS [Rows]
	  , CAST(fi.avg_record_size_in_bytes AS int) AS [AverageRecordBytes]
	  , CAST(fi.avg_fragmentation_in_percent AS int) AS [AverageFragmentationPercent]
	  , SUM(iop.leaf_insert_count) AS [Inserts]
	  , SUM(iop.leaf_delete_count) AS [Deletes]
	  , SUM(iop.leaf_update_count) AS [Updates]
	  , SUM(iop.row_lock_count) AS [RowLocks]
	  , SUM(iop.page_lock_count) AS [PageLocks]
FROM    sys.dm_db_index_operational_stats(DB_ID(),NULL,NULL,NULL) AS iop
JOIN    sys.indexes AS i
ON      ((iop.index_id = i.index_id) AND (iop.object_id = i.object_id))
JOIN    sys.tables AS t
ON      i.object_id = t.object_id
AND     i.type_desc IN ('CLUSTERED', 'HEAP')
JOIN    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') AS fi
ON      fi.object_id=CAST(t.object_id AS int)
AND     fi.index_id=CAST(i.index_id AS int)
AND     fi.index_id < 2
GROUP BY t.name, fi.page_count, fi.record_count
	  , fi.avg_record_size_in_bytes, fi.avg_fragmentation_in_percent
ORDER BY [TableName]
-- Последние backup
	select
	  database_name,
	  MAX(backup_finish_date) as Last_backup_start_date,
	  max(backup_finish_date) as Last_backup_finish_date,
			case when [type]= 'D' then '1_Full Backup'
				 when [type] = 'I' then '2_Diff Backup'
				 when [type] = 'L' then '3_Log Backup'
				 end as [Backup TYPE],
	  count (1) as 'Count of backups',
	  (SELECT bm1.physical_device_name FROM msdb..backupmediafamily as bm1 WHERE bm1.media_set_id = MAX(bs.media_set_id)) as [path],
	  (SELECT CAST(bs2.backup_size/1024/1024 as int) FROM msdb..backupset as bs2 WHERE bs2.backup_set_id = MAX(bs.backup_set_id)) as [size]
	from msdb..backupset bs
	group by database_name,[type]
	order by database_name,[Backup TYPE] --desc --, Last_backup_finish_date
	go 
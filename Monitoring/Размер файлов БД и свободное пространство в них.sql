-- Используется функция sp_msForEachDB, чтобы собрать информацию о каждой БД

IF OBJECT_ID(N'Tempdb..#size',N'U') IS NOT NULL
DROP TABLE #size

CREATE TABLE #size (dbName nvarchar(512),type_desc  nvarchar(120) NULL,fname sysname NULL,fgname sysname NULL, fphysical_name nvarchar(520) NULL, sizeMb decimal(10,2) NULL,freeSizeMb decimal(10,2) NULL)
GO
sp_msForEachDB @command1= 'USE [?]; 
	
	INSERT INTO #size
	select 
		DB_NAME() as dbName,
		f.type_desc as [Type]
		,f.name as [FileName]
		,fg.name as [FileGroup]
		,f.physical_name as [Path]
		,f.size / 128.0 as [CurrentSizeMB]
		,f.size / 128.0 - convert(int,fileproperty(f.name,''SpaceUsed'')) / 
			128.0 as [FreeSpaceMb]

	from 
		sys.database_files f with (nolock) left outer join 
			sys.filegroups fg with (nolock) on
				f.data_space_id = fg.data_space_id
'
SELECT * FROM #size

IF OBJECT_ID(N'Tempdb..#size',N'U') IS NOT NULL
DROP TABLE #size
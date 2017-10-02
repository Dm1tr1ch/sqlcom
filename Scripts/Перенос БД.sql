-- Посмотреть расположение файлов
	SELECT * FROM sys.master_files

-- Общая схема перемещения в рамках того же инстанса
	1. Выполняем скрипты перемещения
		ALTER DATABASE msdb
		MODIFY FILE (name = 'MSDBDATA', filename = 'D:\System\MSDBDATA.mdf')

		ALTER DATABASE msdb
		MODIFY FILE (name = 'MSDBLOG', filename = 'E:\System\MSDBLOG.ldf')

		ALTER DATABASE model
		MODIFY FILE (name = 'modeldev', filename = 'D:\System\model.mdf')

		ALTER DATABASE model
		MODIFY FILE (name = 'modellog', filename = 'E:\System\modellog.ldf')

		ALTER DATABASE tempdb
		MODIFY FILE (name = 'tempdev', filename = 'D:\System\tempdb.mdf')

		ALTER DATABASE tempdb
		MODIFY FILE (name = 'templog', filename = 'E:\System\templog.ldf')
	2. Выключаем инстанс
	3. Меняем через Configuration Management Tools параметры запуска (указываем куда переместили master)
		-dD:\System\master.mdf;
		-eC:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\LOG\ERRORLOG;-lE:\System\mastlog.ldf		
	4. Запускаем и проверяем работу
	5. Resource БД не переносится

-- MSDB/Restore msdb
	- При переносе только msdb достаточно заменить файлы и сервер будет верно их воспринимать, то есть в самой БД не хранится информация о расположении файлов, только в master
	1. Создаём резервную копию
	2. На сервере назначения выключается SQL Agent(постоянно соединяться с msdb)
	3. Убиваем оставшиеся коннекты к msdb руками
	4. Восстанавливаем базу
	
-- Восстановление master/Restore master
	1. Запускаем экземпляр в single-user моде
		net start mssqlserver /m
	2. Подключаемся к SQL Server через текущий контекс пользователя (можно иначе)
		sqlcmd -e
	3. Восстаналиваем БД master (Обратите внимание что после такого восстановления вся информация о подключеннёх БД будет )
		RESTORE DATABASE master FROM DISK = 'Z:\SQLServerBackups\AdventureWorks2012.bak' WITH REPLACE
	4. Останавливаем сервис и запускаем в обычном режиме
		net stop mssqlserver
		net start mssqlserver

-- Перенос обычных баз
	- Detach/Attach
	- Если другой сервер, то надо ещё сопоставить пользователей 
	
-- Перенос БД в AlwaysOn
	- На Secondary исключить БД из AlwaysON (БД перейдёт в состояние Recovery)
	- Установить новое месторасположение для файлов ALTER DATABASE [DBName] MODIFY FILE (NAME = DBName_log2 ,FILENAME ='L:\LOGS\DBName_log2.ldf')
	- Остановить SQL Server
	- Физически перенести файлы
	- Запуститься SQL Server
	- Подключить БД к AlwaysON
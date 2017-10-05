-- Установка
	-- Требования
		- Минимум 3250 оперативной памяти, лучше 4 Гб
		- 4 Гб места на диске

	-- Linux
		https://docs.microsoft.com/en-us/sql/linux/
	-- Ubuntu
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-ubuntu
	-- Red Hat
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-red-hat
	
	-- Пакетов (sqlcmd и odbc)
		1. С помощью pscp копируем в любую дирректорию файлы mssql-tools (https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools#ubuntu)
		2. Запускаем "установку"
			sudo yum localinstall mssql-tools.rpm
			sudo yum localinstall msodbcsql.rpm
		3. Далее выполняем 
			https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat
			
	-- SQL Server Agent
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-sql-agent#RHEL
		yum info mssql-server-agent
		sudo yum install mssql-server-agent
		
	-- Именованный экземпляр
		Рекомендуют использовать контейнер

-- Запуск/остановка SQL Server
	sudo systemctl stop mssql-server
	sudo systemctl start mssql-server
	
-- Обновление
	sudo yum update mssql-server

-- Uninstall / удаление
	sudo yum remove mssql-server
	
	-- Возможно придётся чистить руками остатки
		sudo rm -rf /var/opt/mssql/	

-- По-умолчанию БД размещены
	/var/opt/mssql/data	
			
-- Получить информацию о SQL Server
	systemctl status mssql-server -- активность службы
	yum info mssql-server -- версию
	ps -ef | grep -v grep | grep sql -- Посмотреть запущенные процессы sql	
	systemctl | grep sql -- Посмотреть запущенные "службы" sql / статус

-- Конфиг	
	/opt/mssql/bin/mssql-conf list -- Посмотреть все параметры конфига
		-- Возможные опции
			set
			unset
			traceflag
			set-sa-password
			set-collation
			validate
			list
			setup
			start-service
			stop-service
			enable-service
			disable-service		
		
	-- Изменить COLLATION
		1. Перед запуском надо отключить все пользовательские БД, иначе не работает
		sudo /opt/mssql/bin/mssql-conf set-collation
			
-- sqlcmd
	запускать с параметром -W, чтобы было более менее удобно читать вывод	
	
-- Мониторинг
	top (https://www.mssqltips.com/sqlservertip/4683/linux-administration-for-sql-server-dbas-checking-cpu-usage/)
	iostat –d 4 (https://www.mssqltips.com/sqlservertip/4867/linux-administration-for-sql-server-dbas-checking-disk-io/)
		-x
	iotop
	netstat –i -- Информация по пакетам сети
	netstat -ltu -- Информация по открытым портам 
	
	-- Мониторинг SQL Server на Linux
		https://blogs.msdn.microsoft.com/sqlcat/2017/07/03/how-the-sqlcat-customer-lab-is-monitoring-sql-on-linux/
	
	-- PssDiag for Linux
		https://blogs.msdn.microsoft.com/sqlcat/2017/08/11/collecting-performance-data-with-pssdiag-for-sql-server-on-linux/

-- Дополнительная литература
	https://www.mssqltips.com/sql-server-tip-category/226/sql-server-on-linux/	
	
	-- Top 10 Linux Commands for SQL Server DBAs
		https://www.mssqltips.com/sqlservertip/4816/top-10-linux-commands-for-sql-server-dbas/
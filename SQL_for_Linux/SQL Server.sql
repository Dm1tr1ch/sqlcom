-- ���������
	-- ����������
		- ������� 3250 ����������� ������, ����� 4 ��
		- 4 �� ����� �� �����

	-- Linux
		https://docs.microsoft.com/en-us/sql/linux/
	-- Ubuntu
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-ubuntu
	-- Red Hat
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-red-hat
	
	-- ������� (sqlcmd � odbc)
		1. � ������� pscp �������� � ����� ����������� ����� mssql-tools (https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools#ubuntu)
		2. ��������� "���������"
			sudo yum localinstall mssql-tools.rpm
			sudo yum localinstall msodbcsql.rpm
		3. ����� ��������� 
			https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat
			
	-- SQL Server Agent
		https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-sql-agent#RHEL
		yum info mssql-server-agent
		sudo yum install mssql-server-agent
		
	-- ����������� ���������
		����������� ������������ ���������

-- ������/��������� SQL Server
	sudo systemctl stop mssql-server
	sudo systemctl start mssql-server
	
-- ����������
	sudo yum update mssql-server

-- Uninstall / ��������
	sudo yum remove mssql-server
	
	-- �������� ������� ������� ������ �������
		sudo rm -rf /var/opt/mssql/	

-- ��-��������� �� ���������
	/var/opt/mssql/data	
			
-- �������� ���������� � SQL Server
	systemctl status mssql-server -- ���������� ������
	yum info mssql-server -- ������
	ps -ef | grep -v grep | grep sql -- ���������� ���������� �������� sql	
	systemctl | grep sql -- ���������� ���������� "������" sql / ������

-- ������	
	/opt/mssql/bin/mssql-conf list -- ���������� ��� ��������� �������
		-- ��������� �����
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
		
	-- �������� COLLATION
		1. ����� �������� ���� ��������� ��� ���������������� ��, ����� �� ��������
		sudo /opt/mssql/bin/mssql-conf set-collation
			
-- sqlcmd
	��������� � ���������� -W, ����� ���� ����� ����� ������ ������ �����	
	
-- ����������
	top (https://www.mssqltips.com/sqlservertip/4683/linux-administration-for-sql-server-dbas-checking-cpu-usage/)
	iostat �d 4 (https://www.mssqltips.com/sqlservertip/4867/linux-administration-for-sql-server-dbas-checking-disk-io/)
		-x
	iotop
	netstat �i -- ���������� �� ������� ����
	netstat -ltu -- ���������� �� �������� ������ 
	
	-- ���������� SQL Server �� Linux
		https://blogs.msdn.microsoft.com/sqlcat/2017/07/03/how-the-sqlcat-customer-lab-is-monitoring-sql-on-linux/
	
	-- PssDiag for Linux
		https://blogs.msdn.microsoft.com/sqlcat/2017/08/11/collecting-performance-data-with-pssdiag-for-sql-server-on-linux/

-- �������������� ����������
	https://www.mssqltips.com/sql-server-tip-category/226/sql-server-on-linux/	
	
	-- Top 10 Linux Commands for SQL Server DBAs
		https://www.mssqltips.com/sqlservertip/4816/top-10-linux-commands-for-sql-server-dbas/ 
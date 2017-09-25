/*
Если вам необходимо произвести поиск по ErrorLog с помощью T-SQL, то можно воспользоваться следующим решением.

P.S. Обратите внимание, что данный способ может выполняться значительное время и, возможно, вы быстрее разберётесь без подобных ухищрений.*/

-- Создаём таблицу для ErrorLog
CREATE TABLE #error_log (d datetime,p nvarchar(50),t nvarchar(max))

-- Вставляем в таблицу данные из ErrorLog
INSERT INTO #error_log
EXEC sp_readerrorlog

-- Выполняем фильтрацию (исключение "шума")
SELECT * FROM #error_log WHERE t not like '%Login failed for user%' and t not like '%Error: 18456%'

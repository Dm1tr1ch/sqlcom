-- Тестирование достаточности памяти/экспресс тестирование памяти
	WITH    RingBuffer
          AS (SELECT    CAST(dorb.record AS XML) AS xRecord,
                        dorb.TIMESTAMP
              FROM      sys.dm_os_ring_buffers AS dorb
              WHERE     dorb.ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR'
             )
    SELECT  xr.value('(ResourceMonitor/Notification)[1]', 'varchar(75)') AS RmNotification,
            xr.value('(ResourceMonitor/IndicatorsProcess)[1]', 'tinyint') AS IndicatorsProcess,
            xr.value('(ResourceMonitor/IndicatorsSystem)[1]', 'tinyint') AS IndicatorsSystem,
            DATEADD(ss,
                    (-1 * ((dosi.cpu_ticks / CONVERT (FLOAT, (dosi.cpu_ticks / dosi.ms_ticks)))
                           - rb.TIMESTAMP) / 1000), GETDATE()) AS RmDateTime,
            xr.value('(MemoryNode/TargetMemory)[1]', 'bigint') AS TargetMemory,
            xr.value('(MemoryNode/ReserveMemory)[1]', 'bigint') AS ReserveMemory,
            xr.value('(MemoryNode/CommittedMemory)[1]', 'bigint')/1024 AS CommitedMemory,
            xr.value('(MemoryNode/SharedMemory)[1]', 'bigint') AS SharedMemory,
            xr.value('(MemoryNode/PagesMemory)[1]', 'bigint') AS PagesMemory,
            xr.value('(MemoryRecord/MemoryUtilization)[1]', 'bigint') AS MemoryUtilization,
            xr.value('(MemoryRecord/TotalPhysicalMemory)[1]', 'bigint') AS TotalPhysicalMemory,
            xr.value('(MemoryRecord/AvailablePhysicalMemory)[1]', 'bigint') AS AvailablePhysicalMemory,
            xr.value('(MemoryRecord/TotalPageFile)[1]', 'bigint') AS TotalPageFile,
            xr.value('(MemoryRecord/AvailablePageFile)[1]', 'bigint') AS AvailablePageFile,
            xr.value('(MemoryRecord/TotalVirtualAddressSpace)[1]', 'bigint') AS TotalVirtualAddressSpace,
            xr.value('(MemoryRecord/AvailableVirtualAddressSpace)[1]',
                     'bigint') AS AvailableVirtualAddressSpace,
            xr.value('(MemoryRecord/AvailableExtendedVirtualAddressSpace)[1]',
                     'bigint') AS AvailableExtendedVirtualAddressSpace
    FROM    RingBuffer AS rb
            CROSS APPLY rb.xRecord.nodes('Record') record (xr)
            CROSS JOIN sys.dm_os_sys_info AS dosi
    ORDER BY RmDateTime DESC;
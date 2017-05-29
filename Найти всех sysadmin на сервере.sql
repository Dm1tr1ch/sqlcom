SELECT spp .name AS [Name],
   sps.type_desc,
   sps.is_disabled,
   sps.create_date,
   sps.modify_date,
   sps.default_database_name
FROM sys.server_principals sps
INNER JOIN sys.server_role_members srm ON sps.principal_id = srm.role_principal_id
INNER JOIN sys.server_principals spp ON spp.principal_id = srm.member_principal_id
WHERE sps.type = 'R'
AND sps.name = N'sysadmin'

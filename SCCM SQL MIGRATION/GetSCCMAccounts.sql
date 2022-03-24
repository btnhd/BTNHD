;WITH Logins AS (
SELECT prn.name PrincipalName
 ,prn.default_database_name
 ,rol.name RoleName
 FROM sys.server_principals prn
 LEFT OUTER JOIN sys.server_role_members mem
 ON prn.principal_id = mem.member_principal_id
 LEFT OUTER JOIN sys.server_principals rol
 ON mem.role_principal_id = rol.principal_id
 WHERE prn.is_disabled = 0
 AND prn.type IN ('U','G')
 AND prn.name NOT LIKE @@SERVERNAME+N'%'
)
SELECT N'USE [master];' AS CommandsToKeepAndRun
UNION ALL
 -- Logins
SELECT N'IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = N'''+PrincipalName+N''')
CREATE LOGIN ['+PrincipalName+N'] FROM WINDOWS WITH DEFAULT_DATABASE = ['+ISNULL(default_database_name,N'master')+N'];
'
 FROM Logins
UNION ALL
 -- Server Roles
SELECT N'IF (
SELECT ISNULL(rol.name,N''NULL'')
 FROM sys.server_principals prn
 LEFT OUTER JOIN sys.server_role_members mem
 ON prn.principal_id = mem.member_principal_id
 LEFT OUTER JOIN sys.server_principals rol
 ON mem.role_principal_id = rol.principal_id
 WHERE prn.name = N'''+PrincipalName+N'''
) != N'''+RoleName+N'''
ALTER SERVER ROLE '+RoleName+N' ADD MEMBER ['+PrincipalName+N'];
'
 FROM Logins
 WHERE RoleName IS NOT NULL
UNION ALL
 -- Server Permissions Extended:
SELECT CASE prm.class
 WHEN 100 THEN prm.state_desc+' '+prm.permission_name+' TO ['+pal.name+'];' COLLATE SQL_Latin1_General_CP1_CI_AS
 WHEN 105 THEN prm.state_desc+' '+prm.permission_name+' ON ENDPOINT :: ['+(SELECT name FROM sys.endpoints WHERE endpoint_id = prm.major_id)+'] TO ['+pal.name+'];' COLLATE SQL_Latin1_General_CP1_CI_AS
 END
 FROM sys.server_permissions prm
 INNER JOIN sys.server_principals pal
 ON prm.grantee_principal_id = pal.principal_id
 AND pal.is_disabled = 0
 AND pal.name NOT LIKE @@SERVERNAME+N'%'
 AND pal.type IN ('U','G')
UNION ALL
SELECT N'GO';
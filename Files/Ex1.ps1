
# Import the sqlserver module
Import-Module SqlServer
$server = New-Object Microsoft.SqlServer.Management.Smo.Server "localhost"

# Recreate login 'sqltom'
Invoke-Sqlcmd -ServerInstance "localhost" -Query @"
IF EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'sqltom')
    DROP LOGIN sqltom;
CREATE LOGIN sqltom WITH PASSWORD = 'myS3cret', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
"@ -TrustServerCertificate

# Recreate login 'olle' and disable it
Invoke-Sqlcmd -ServerInstance "localhost" -Query @"
IF EXISTS (SELECT 1 FROM sys.sql_logins WHERE name = 'olle')
    DROP LOGIN olle;
CREATE LOGIN olle WITH PASSWORD = 'myS3cret', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
ALTER LOGIN olle DISABLE;
"@ -TrustServerCertificate

# Switch to Windows Authentication mode
$server.Settings.LoginMode = [Microsoft.SqlServer.Management.SMO.ServerLoginMode]::Integrated
$server.Alter()

# Stop SQL Server service
Stop-Service -Name 'MSSQLSERVER' -Force

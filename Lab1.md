
# SQL Server Introductory Exercises

### Exercise 1: Version, Edition, and Instance Management (40 min)

**Step 1: Identify Version and Edition Using Object Explorer (GUI)**
- Open **SQL Server Management Studio (SSMS)**.
- Connect to your default instance (`North`).
- Right-click on your instance name in Object Explorer and select **Properties**.
- Note down the **Product version** and **Edition** from the General page.

**Step 2: Identify Version and Edition Using T-SQL**
- Open a new query window in SSMS.
- Run these queries:
```sql
SELECT @@VERSION AS SQLVersion;
SELECT SERVERPROPERTY('Edition') AS Edition;
```
- Verify if results match the information obtained via Object Explorer.

**Step 3: Identify Version and Edition Using sqlcmd**
- Open Command Prompt.
- Connect to the instance using sqlcmd:
```shell
sqlcmd -S North
```
- Execute these commands:
```sql
SELECT @@VERSION;
GO
SELECT SERVERPROPERTY('Edition');
GO
```
- Compare the results again.

**Step 4: Manage SQL Server Instances Using Configuration Manager**
- Open **SQL Server Configuration Manager**.
- Locate your two SQL Server instances (`North` and `North\A`).
- Stop and start the named instance (`North\A`).

**Step 5: Start/Stop Services Using Command Line**
- Open **Command Prompt**.
- First, type:
```shell
net start
```
- This will list all currently running services.
- Try to stop and start the SQL Server services:
```shell
net stop MSSQLSERVER
net start MSSQLSERVER
net stop MSSQL$A
net start MSSQL$A
```
- Try doing this **without admin rights** and observe what happens.
- Then try again using **Run as administrator**.
- Reflect on why admin access is required for managing services.

- In SSMS, reconnect to both instances to ensure they are running and accessible.
- Discuss the importance of properly managing instances (isolation, security, and resources).

### Exercise 2: SQL Server Memory Configuration (20 min)
- Connect to the default instance (`North`) using SSMS.
- Execute these queries to view current memory configuration:
```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'min server memory';
EXEC sp_configure 'max server memory';
```
- Change the max memory temporarily:
```sql
EXEC sp_configure 'max server memory', 2048; -- 2 GB
RECONFIGURE;
```
- Reset to default:
```sql
EXEC sp_configure 'max server memory', 2147483647; -- Default unlimited
RECONFIGURE;
```
- Discuss why controlling memory allocation is important for SQL Server performance and stability.

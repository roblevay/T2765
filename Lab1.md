
# SQL Server Introductory Exercises

### Exercise 1: Identify Version and Edition (20 min)

**Step 1: Using Object Explorer (GUI)**
- Open **SQL Server Management Studio (SSMS)**.
- Connect to your default instance (`North`).
- Right-click on your instance name in Object Explorer and select **Properties**.
- Note down the **Product version** and **Edition** from the General page.

**Step 2: Using T-SQL queries**
- Open a new query window in SSMS.
- Run these queries:
```sql
SELECT @@VERSION AS SQLVersion;
SELECT SERVERPROPERTY('Edition') AS Edition;
```
- Verify if results match the information obtained via Object Explorer.

**Step 3: Using sqlcmd (command-line)**
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
- Repeat step 1-3 with the name instance North\A

### Exercise 2: Manage SQL Server Instances (20 min)
- Open **SQL Server Configuration Manager**.
- Locate your two SQL Server instances (`North` and `North\A`).
- Stop and start the named instance (`North\A`).
- In SSMS, reconnect to both instances to ensure they are running and accessible.
- Discuss the importance of properly managing instances (isolation, security, and resources).

### Exercise 3: SQL Server Memory Configuration (20 min)
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

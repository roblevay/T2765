
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

### Exercise 2: Manage SQL Server Instances and Services (20 min)

**Step 1: Use SQL Server Configuration Manager**
- Open **SQL Server Configuration Manager**.
- Locate your two SQL Server instances (`North` and `North\A`).
- Stop and start the named instance (`North\A`).

**Step 2: Start/Stop Services Using Command Line**
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
- Reconnect to both instances in SSMS to confirm they are up and running.
- Discuss isolation, security, and resource management for multiple instances.


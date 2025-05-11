# 🗄️ Lab 4: Managing Database Storage

---
Lab 4: Managing database storage
Ex 1. Create a database
Create a database named CRM on the default instance with below specifications:
• Database files in the C:\DbFiles\MSSQLSERVER folder.
• One mdf file, size 50 MB
• One file named CRM_ HistoryData.ndf, size 100MB, in a filegroup named History.
• One transaction log file, size 20 MB.
• The files should have a filegrowth of 20MB and max size of 20 GB.
Ex 2. Move tempdb
Move the tempdb files to the “C:\DbFiles\MSSQLSERVER folder”. There is no GUI in SSMS for this. Use an “ALTER DATABASE … MODIFY FILE ” command for each file that tempdb uses. Do a “SELECT * FROM tempdb.sys.database_files” to see what files tempdb has. Restart SQL Server to verify that the new files are created where you specified. Delete the old tempdb files.
If you want assistance with managing tempdb, check out https://sqlblog.karaszi.com/managing-tempdb/.
If you're not careful, then your SQL server might refuse to start and we are in for some existing troubleshooting. Feel free to skip this exercise of you feel nervous.
Ex 3. Detach and attach a database
Detach the CRM database you created in above exercise 1 from the default instance. Copy the database files to the C:\DbFiles\A folder. Make sure that the service account for the A instance is owner of those files and has full permissions of those files. Attach the database onto the A-instance. Re-attach the database based on the original files to the default instance.
Lab 4 answer suggestions
Ex 3. Detach and attach a database 8
Copyright Tibor Karaszi Konsulting and Cornerstone Group AB
Lab 4 answer suggestions
Ex 1. Create a database
CREATE DATABASE CRM
ON PRIMARY
( NAME = 'CRM', FILENAME = N'C:\DbFiles\MsSqlServer\CRM.mdf'
, SIZE = 50MB, FILEGROWTH = 20MB, MAXSIZE = 20GB),
FILEGROUP History
( NAME = 'CRM_HistoryData', FILENAME = N'C:\DbFiles\MsSqlServer\CRM_HistoryData.ndf'
, SIZE = 100MB, FILEGROWTH = 20MB, MAXSIZE = 20GB)
LOG ON
( NAME = 'CRM_log', FILENAME = N'C:\DbFiles\MsSqlServer\CRM_log.ldf'
, SIZE = 20MB, FILEGROWTH = 20MB, MAXSIZE = 20GB)
Lab 4 answer suggestions
Ex 3. Detach and attach a database 9
Copyright Tibor Karaszi Konsulting and Cornerstone Group AB
Ex 2. Move tempdb
First check your current tempdb current and template structure:
--Current
SELECT
'tempdb' AS db_name_
,file_id
,name
,physical_name
,size * 8/1024 AS size_MB
,type_desc
,CASE WHEN is_percent_growth = 1 THEN CAST(growth AS varchar(3)) + ' %' ELSE CAST(growth * 8/1024 AS varchar(10)) + ' MB' END AS growth
,max_size * 8/1024 AS max_size_MB
FROM tempdb.sys.database_files
ORDER BY type, file_id
--Template
SELECT
DB_NAME(database_id) AS db_name_
,file_id
,name
,physical_name
,size * 8/1024 AS size_MB
,type_desc
,CASE WHEN is_percent_growth = 1 THEN CAST(growth AS varchar(3)) + ' %' ELSE CAST(growth * 8/1024 AS varchar(10)) + ' MB' END AS growth
,max_size * 8/1024 AS max_size_MB
FROM master.sys.master_files
WHERE DB_NAME(database_id) = 'tempdb'
ORDER BY db_name_, type, file_id
Below is an example where we change startup folder an instance having 4 data files. Adjust below to match your installation, if needed.
ALTER DATABASE tempdb
MODIFY FILE (NAME = tempdev, SIZE = 8MB, FILEGROWTH = 64MB, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb.mdf')
ALTER DATABASE tempdb
MODIFY FILE (NAME = temp2, SIZE=8MB, FILEGROWTH = 64MB, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb_mssql_2.ndf')
ALTER DATABASE tempdb
MODIFY FILE (NAME = temp3, SIZE=8MB, FILEGROWTH = 64MB, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb_mssql_3.ndf')
ALTER DATABASE tempdb
MODIFY FILE (NAME = temp4, SIZE=8MB, FILEGROWTH = 64MB, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb_mssql_4.ndf')
ALTER DATABASE tempdb
MODIFY FILE (NAME = templog, SIZE=8MB, FILEGROWTH = 64MB, FILENAME = 'C:\DbFiles\MsSqlServer\templog.ldf')
Restart SQL Server to verify that the new files are created where you specified. Delete the old tempdb files.
Lab 4 answer suggestions
Ex 3. Detach and attach a database 10
Copyright Tibor Karaszi Konsulting and Cornerstone Group AB
Ex 3. Detach and attach a database
Logon to the default instance and execute:
EXEC sp_detach_db 'CRM'
Copy the database files to the C:\DbFiles\A folder. Set full permissions as well as ownership on the files to the MSSQL$A account. You can use below from a command prompt:
icacls C:\DbFiles\a\CRM.mdf /setowner MSSQL$A
icacls C:\DbFiles\a\CRM.mdf /grant MSSQL$A:F
icacls C:\DbFiles\a\CRM_HistoryData.ndf /setowner MSSQL$A
icacls C:\DbFiles\a\CRM_HistoryData.ndf /grant MSSQL$A:F
icacls C:\DbFiles\a\CRM_log.ldf /setowner MSSQL$A
icacls C:\DbFiles\a\CRM_log.ldf /grant MSSQL$A:F
Now login to the A instance and execute below:
CREATE DATABASE CRM ON
(FILENAME = N'C:\DbFiles\a\CRM.mdf' )
,(FILENAME = N'C:\DbFiles\a\CRM_HistoryData.ndf' )
,(FILENAME = N'C:\DbFiles\a\CRM_log.ldf' )
FOR ATTACH
And re-attach the CRM database on the default instance:
CREATE DATABASE CRM ON
(FILENAME = N'C:\DbFiles\MsSqlServer\CRM.mdf' )
,(FILENAME = N'C:\DbFiles\MsSqlServer\CRM_HistoryData.ndf' )
,(FILENAME = N'C:\DbFiles\MsSqlServer\CRM_log.ldf' )
FOR ATTACH


# 🧪 1. SQL Server – Restore from Backup  (Step-by-Step)

## 🎯 Objective

1. Create a folder `C:\Dest` for storing restored databases.
2. Back up the `AdventureWorksDW` database to `C:\sqlbackups`.
3. Restore the backup with a new name `AWDWCopyFromBackup` into `C:\Dest`.
4. Export `AdventureWorks` to a BACPAC file.
5. Import the BACPAC as a new database `AwDWCopyFromBacPac` into `C:\Dest`.

---

## 📁 Step 1 – Create the Destination Folder

In Windows:

1. Open **File Explorer**.
2. Navigate to `C:\`.
3. Create a folder named `Dest`.

Or use PowerShell:

```powershell
New-Item -ItemType Directory -Path "C:\Dest"
```

---

## 💾 Step 2 – Back Up the AdventureWorks Database

In SQL Server Management Studio (SSMS):

```sql
BACKUP DATABASE AdventureWorksDW
TO DISK = 'C:\sqlbackups\AdventureWorksDW.bak'
WITH FORMAT, INIT, COMPRESSION;
```

- `C:\sqlbackups` must exist.
- Use Windows/File Explorer to create it if needed.

---

## ♻️ Step 3 – Restore the Database with a New Name

```sql
RESTORE DATABASE AWDWCopyFromBackup
FROM DISK = 'C:\sqlbackups\AdventureWorksDW.bak'
WITH 
    MOVE 'AdventureWorksDW_Data' TO 'C:\Dest\AWDWCopyFromBackup.mdf',
    MOVE 'AdventureWorksDW_Log' TO 'C:\Dest\AWDWCopyFromBackup.ldf',
    REPLACE;
```

> ℹ️ Replace `'AdventureWorksDW_Data'` and `'AdventureWorksDW_Log'` with the logical file names in your backup if different.
> You can get them using:
```sql
RESTORE FILELISTONLY FROM DISK = 'C:\sqlbackups\AdventureWorksDW.bak';
```

# 🧪 2. SQL Server – Restore from BACPAC  (Step-by-Step)
---

## 📦 Step 1 – Export AdventureWorks to BACPAC

1. In SSMS, right-click the `AdventureWorksDW` database.
2. Choose **Tasks > Export Data-tier Application**.
3. Select **Export to a BACPAC file**.
4. Save it to `C:\Dest\AdventureWorksDW.bacpac`.

---

## 📥 Step 2 – Import the BACPAC to a New Database

1. In SSMS, right-click **Databases** > **Import Data-tier Application**.
2. Choose the file `C:\Dest\AdventureWorksDW.bacpac`.
3. Name the new database: `AwDWCopyFromBacPac`.
4. Set the destination Data file path and Log file path to `C:\Dest`.
5. Finish the wizard.

---

## ✅ Summary

You now have two copies of `AdventureWorksDW`:
- `AWDWCopyFromBackup` restored from a `.bak` file
- `AwDWCopyFromBacPac` imported from a `.bacpac` file

This shows two different ways to move or duplicate databases in SQL Server.


# 🧪 1. SQL Server – Managing Database Storage

## Step 1 – Create a Database

**Check for the existence of the database CRM on the default instance. If it exists, drop the database**

### Instructions

Create a database named **CRM** on the default instance with the following specifications:

- Database files in the `C:\DbFiles\MSSQLSERVER` folder
- One `.mdf` file, size 50 MB
- One `.ndf` file named `CRM_HistoryData.ndf`, size 100 MB, in a filegroup named `History`
- One transaction log file, size 20 MB
- All files should have a filegrowth of 20 MB and a max size of 20 GB

---

### Answer Suggestion

```sql
CREATE DATABASE CRM
ON PRIMARY
( NAME = 'CRM', FILENAME = N'C:\DbFiles\MsSqlServer\CRM.mdf',
  SIZE = 50MB, FILEGROWTH = 20MB, MAXSIZE = 20GB),
FILEGROUP History
( NAME = 'CRM_HistoryData', FILENAME = N'C:\DbFiles\MsSqlServer\CRM_HistoryData.ndf',
  SIZE = 100MB, FILEGROWTH = 20MB, MAXSIZE = 20GB)
LOG ON
( NAME = 'CRM_log', FILENAME = N'C:\DbFiles\MsSqlServer\CRM_log.ldf',
  SIZE = 20MB, FILEGROWTH = 20MB, MAXSIZE = 20GB);
```

---

## Step 2 – Move `tempdb`

Skapa en ny datafil i tempdb:

```sql
USE master;
GO
ALTER DATABASE tempdb 
ADD FILE (
    NAME = temp3, 
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\tempdb_mssql_3.ndf', 
    SIZE = 64MB, 
    FILEGROWTH = 64MB
);
USE master;
GO
ALTER DATABASE tempdb 
ADD FILE (
    NAME = temp4, 
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\tempdb_mssql_4.ndf', 
    SIZE = 64MB, 
    FILEGROWTH = 64MB
);


GO
```

### Instructions

Move the `tempdb` files to the `C:\DbFiles\MSSQLSERVER` folder.

> ⚠️ There is no GUI in SSMS for this. Use `ALTER DATABASE ... MODIFY FILE` for each file.  
> Run `SELECT * FROM tempdb.sys.database_files` to inspect current files.

Restart SQL Server to verify the files are created in the new location. Delete the old files.

🔗 [Managing tempdb – Karaszi](https://sqlblog.karaszi.com/managing-tempdb/)

---

### Answer Suggestion

```sql
-- Check current files
SELECT name, physical_name FROM tempdb.sys.database_files;

-- Template from master
SELECT name, physical_name FROM master.sys.master_files WHERE DB_NAME(database_id) = 'tempdb';

-- Move files (example with 4 data files and 1 log)
ALTER DATABASE tempdb MODIFY FILE (NAME = tempdev, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = temp3, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb_mssql_3.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = temp4, FILENAME = 'C:\DbFiles\MsSqlServer\tempdb_mssql_4.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = templog, FILENAME = 'C:\DbFiles\MsSqlServer\templog.ldf');

```
Run the command


```sql
-- Check current files
SELECT name, physical_name FROM tempdb.sys.database_files;
```

The paths are changed. Check in the file system. The files have not been created.

Restart SQL Server. Verify the files are created in the new location. Delete the old files.
---

## Step 3 – Detach and Attach a Database

### Instructions

1. Detach the `CRM` database from the default instance.
2. Copy the database files to `C:\DbFiles\X`.
3. Ensure the  service account has full ownership and permissions.
4. Attach the database on the `X` instance.
5. Re-attach the original copy on the default instance.

---

### Answer Suggestion

**Create the folder C:\DbFiles\X**

**Give the user student full permission to this folder**

**Detach from default instance:**

**Copy the CRM files to the C:\DbFiles\X folder**
```sql
EXEC sp_detach_db 'CRM';
```

**Attach on A-instance:**
```sql
CREATE DATABASE CRM ON
(FILENAME = N'C:\DbFiles\X\CRM.mdf'),
(FILENAME = N'C:\DbFiles\X\CRM_HistoryData.ndf'),
(FILENAME = N'C:\DbFiles\X\CRM_log.ldf')
FOR ATTACH;
```

**Re-attach on default instance:**
```sql
CREATE DATABASE CRM ON
(FILENAME = N'C:\DbFiles\MsSqlServer\CRM.mdf'),
(FILENAME = N'C:\DbFiles\MsSqlServer\CRM_HistoryData.ndf'),
(FILENAME = N'C:\DbFiles\MsSqlServer\CRM_log.ldf')
FOR ATTACH;
```

---



# 🧪 2. SQL Server – Restore from Backup  (Step-by-Step)

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

# 🧪 3. SQL Server – Restore from BACPAC  (Step-by-Step)
---

## 📦 Step 1 – Export AdventureWorksLT to BACPAC

1. In SSMS, right-click the `AdventureWorksLT` database.
2. Choose **Tasks > Export Data-tier Application**.
3. Select **Export to a BACPAC file**.
4. Save it to `C:\Dest\AdventureWorksLT.bacpac`.

---

## 📥 Step 2 – Import the BACPAC to a New Database

1. In SSMS, right-click **Databases** > **Import Data-tier Application**.
2. Choose the file `C:\Dest\AdventureWorksLT.bacpac`.
3. Name the new database: `AwLTCopyFromBacPac`.
4. Set the destination Data file path and Log file path to `C:\Dest`.
5. Finish the wizard.

---

## ✅ Summary

You now have two copies of `AdventureWorksDW` and AdventureWorksLT:
- `AWDWCopyFromBackup` restored from a `.bak` file
- `AwLTCopyFromBacPac` imported from a `.bacpac` file

This shows two different ways to move or duplicate databases in SQL Server.


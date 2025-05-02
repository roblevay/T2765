# Exercise 1: SQL Server Index Fragmentation & Statistics Exercise

## 🏁 Step 1: Create a test database and table

```sql
CREATE DATABASE FragmentationDemo;
GO

USE FragmentationDemo;
GO

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    City NVARCHAR(100)
);
GO
```

---

## 📈 Step 2: Insert data and create an index

-- Create a non-clustered index
CREATE NONCLUSTERED INDEX IX_Customers_City ON Customers(City);
GO
```

```sql
-- Insert 10,000 rows
INSERT INTO Customers (FirstName, LastName, City)
SELECT
    LEFT(NEWID(), 8),
    LEFT(NEWID(), 8),
    CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'Stockholm' ELSE 'Gothenburg' END
FROM sys.all_objects a
CROSS JOIN sys.all_objects b
WHERE a.object_id < 100 AND b.object_id < 100;  -- approx 10,000 rows



---

## 🌀 Step 3: Fragment the index

```sql
-- Delete about half the rows randomly
DELETE FROM Customers
WHERE CustomerID % 2 = 0;

-- Insert more rows to cause page splits
INSERT INTO Customers (FirstName, LastName, City)
SELECT
    LEFT(NEWID(), 8),
    LEFT(NEWID(), 8),
    'Malmö'
FROM sys.all_objects
WHERE object_id < 100;
GO
```

---

## 🔍 Step 4: Check fragmentation

```sql
SELECT 
    dbschemas.name AS SchemaName,
    dbtables.name AS TableName,
    dbindexes.name AS IndexName,
    indexstats.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID('FragmentationDemo'), NULL, NULL, NULL, 'SAMPLED') AS indexstats
JOIN sys.tables dbtables ON dbtables.object_id = indexstats.object_id
JOIN sys.schemas dbschemas ON dbtables.schema_id = dbschemas.schema_id
JOIN sys.indexes AS dbindexes ON dbindexes.object_id = indexstats.object_id AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.index_id > 0;
```

---

## 🛠️ Step 5: Update statistics

### Option A – Use system stored procedure
```sql
EXEC sp_updatestats;
```

### Option B – Manually update a specific table or index
```sql
UPDATE STATISTICS Customers;
-- or
UPDATE STATISTICS Customers IX_Customers_City;
```

---

## 🧹 Bonus: Reorganize or Rebuild index

```sql
-- Reorganize (lightweight)
ALTER INDEX IX_Customers_City ON Customers REORGANIZE;

-- Rebuild (heavier)
ALTER INDEX IX_Customers_City ON Customers REBUILD;
```

---

## ✅ Done!

You now know how to:
- Create fragmentation
- Detect it with DMVs
- Update statistics
- Rebuild or reorganize indexes

# 🛠️ Exercise 2: SQL Server Maintenance Plans – Step-by-Step Exercise

## 🎯 Objective

Create three separate maintenance plans in SQL Server using SQL Server Management Studio (SSMS) to:

1. Back up all user databases.
2. Perform database maintenance (index rebuild/reorganize and update statistics).
3. Clean up old backup files and maintenance history.

---

## 🧩 Prerequisites

- SQL Server Agent must be running.
- SSMS installed and connected to an instance.
- Sufficient permissions to create maintenance plans (typically sysadmin).

---

## 🔹 Plan 1: Back Up All User Databases

### Step-by-Step:

1. Open **SSMS** and connect to your SQL Server instance.
2. Expand **Management** > Right-click **Maintenance Plans** > Choose **New Maintenance Plan**.
3. Name the plan: `UserDatabaseBackup`. Wait for some time for the toolbox Maintenance Plan Tasks to appear.
4. In the toolbox (on the left), drag **Back Up Database Task** into the designer.
5. Double-click the task to configure:
   - **Backup type**: Full
   - **Databases**: All user databases
   - **Backup to**: Choose location (e.g. `C:\SQLBackups`)
   - Enable backup compression if supported
   - Optional: Create a sub-directory for each database
6. Click **OK**.
7. Click on the Add Subplan icon 
   - Name: `NightlyBackup`
   - Add a Schedule
   - Frequency: Daily
   - Time: e.g. 2:00 AM
8. Save the plan (Ctrl+S or File > Save).

---

## 🔹 Plan 2: Index and Statistics Maintenance

### Step-by-Step:

1. Right-click **Maintenance Plans** > **New Maintenance Plan**.
2. Name the plan: `IndexAndStatsMaintenance`.
3. Add **Rebuild Index Task**:
   - Databases: All user databases
   - Tables: All tables
4. Add **Update Statistics Task**:
   - Databases: All user databases
   - Scan type: Full scan 
5. Schedule the plan:
   - Frequency: Weekly
   - Time: e.g. Sunday at 3:00 AM
6. Save the plan.

---

## 🔹 Plan 3: Cleanup Old Backups and History

### Step-by-Step:

1. Create a new maintenance plan: `CleanupTasks`.
2. Add **Maintenance Cleanup Task**:
   - Delete: Backup files
   - Folder: Same as used in the backup plan (`C:\SQLBackups`)
   - File extension: `.bak`
   - File age: Delete files older than 7 days
3. Add another **Maintenance Cleanup Task**:
   - Delete: Maintenance Plan history
   - File age: Older than 30 days
4. Schedule:
   - Frequency: Weekly
   - Time: e.g. Sunday at 4:00 AM
5. Save the plan.

---

## ✅ Summary

This set of exercises helps automate key SQL Server maintenance:

- **Plan 1** ensures all databases are backed up nightly.
- **Plan 2** keeps indexes and stats optimized weekly.
- **Plan 3** prevents disk space and history buildup.

All can be created without writing T-SQL using the Maintenance Plan Wizard or Designer in SSMS.

If time permits, verify that the Sql Server Agent service is running and execute each of the plans by right-clicking and verifying that they run correctly.



# 🔧 Exercise 3: Using Ola Hallengren’s SQL Server Maintenance Solution

## 🎯 Objective

Set up Ola Hallengren’s widely used maintenance scripts to:

- Back up all user databases
- Perform index maintenance (rebuild if > 30% fragmentation, reorganize if 10–30%)
- Update statistics

---

## 📥 Step 1 – Download the Scripts

1. Go to the official website (right-click to open in new tab):  
   👉 <a href="https://ola.hallengren.com" target="_blank">https://ola.hallengren.com</a>

2. Click  “MaintenanceSolution.sql” under Getting Started

3. Open **SQL Server Management Studio (SSMS)** and run the downloaded script against the **master** database.

   This will create:
   - Stored procedures (e.g., `dbo.DatabaseBackup`, `dbo.IndexOptimize`)
   - Support tables (e.g., `dbo.CommandLog`)
  

---

## 🧪 Step 2 – Run Backup for All User Databases

To back up all user databases to a folder (e.g., `C:\SQLBackups`):

```sql
EXEC dbo.DatabaseBackup
  @Databases = 'USER_DATABASES',
  @Directory = 'C:\SQLBackups',
  @BackupType = 'FULL',
  @Compress = 'Y',
  @CheckSum = 'Y',
  @LogToTable='Y';
```

You can schedule this using a SQL Agent job that runs nightly.

---

## 🔧 Step 3 – Index Maintenance

To rebuild/reorganize indexes based on fragmentation:

```sql
EXEC dbo.IndexOptimize
  @Databases = 'USER_DATABASES',
  @FragmentationLow = NULL,
  @FragmentationMedium = 'INDEX_REORGANIZE',
  @FragmentationHigh = 'INDEX_REBUILD_ONLINE',
  @FragmentationLevel1 = 10,
  @FragmentationLevel2 = 30,
  @UpdateStatistics = 'ALL',
  @LogToTable='Y';
```

- Reorganize if fragmentation is **10–30%**
- Rebuild if **>30%**
- Also updates statistics for all indexes

Schedule this weekly or as needed using SQL Agent.

---

## 🗂️ Optional: Command Log Table

You can review what actions were taken by querying:

```sql
SELECT * FROM dbo.CommandLog ORDER BY StartTime DESC;
```

---

## ✅ Summary

With minimal setup, Ola Hallengren’s solution gives you:

- Reliable backups with checksums and compression
- Smart index and stats maintenance based on actual fragmentation
- Logging of all maintenance actions

Perfect for both small environments and enterprise-scale SQL Servers.



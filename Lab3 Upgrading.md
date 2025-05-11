
# 🧪 SQL Server – Copying and Restoring Databases

## 🎯 Objective

Learn two different methods to copy a database from one SQL Server instance (`North`) to another (`North\A`):

- Using the **Copy Database Wizard (Detach and Attach)**  
- Doing a **manual backup/restore**, handling logins, fixing orphaned users, and updating compatibility level.

---

## 🧩 Prerequisites

- You need sysadmin rights on both `North` and `North\A`.
- SQL Server Agent must be **running** on both servers.
- The database to be copied must be **offline-able** (for the wizard method).
- The database `AdventureWorks` should already exist on `North`.

---

## 🧷 Method 1 – Copy Database Wizard (Detach and Attach)

### 🔐 Step 1 – Set SQL Server Agent Credentials on `North\A`

1. Open **SQL Server Configuration Manager** on `North\A`.
2. Go to **SQL Server Services**.
3. Right-click **SQL Server Agent (NORTH\A)** > **Properties**.
4. In the **Log On** tab:
   - Select **This account**
   - Enter:
     - **User**: `Student`
     - **Password**: `myS3cret`
5. Click **OK** and restart the SQL Server Agent service.

---

### 🛠️ Step 2 – Create a Sample Database on `North`

Run on the `North` instance:

```sql
CREATE DATABASE MoveDb;
GO

USE MoveDb;
CREATE TABLE TestData (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100)
);
INSERT INTO TestData VALUES (1, 'Gamma'), (2, 'Delta');
````

---

### 🧙 Step 3 – Use the Copy Database Wizard (Detach and Attach)

1. In SSMS, connect to `North`.
2. Right-click the server > **Tasks** > **Copy Database**.
3. Click **Next** on the welcome screen.
4. Select `North` as the Source Server and click **Next**
5. Select `North\A` as the destination server and click **Next**
6. Choose **Use Detach and Attach method** → click **Next**.
7. Select to copy the database: `MoveDb` → click **Next**.
8. Set destination file paths if needed → click **Next**.
9. In Configure the Package → click **Next**.
10. Schedule the package to run immediately and click **Next**
11. Click **Finish** The database will be copied

---

### ✅ Step 4 – Confirm the Migration

On `North\A`, verify:

```sql
SELECT * FROM MoveDb.dbo.TestData;
```

---

### 📝 Notes (Detach and Attach)

* This method **takes the source database offline** during the transfer.
* It is **fast** for large databases but requires **downtime**.
* Make sure file paths are valid and accessible between the two servers.

---

## 🧷 Method 2 – Manual Backup and Restore

### 🔐 Step 1 – Create Login and User on `North`

On `North`:

```sql
CREATE LOGIN Liza WITH PASSWORD = 'myS3cret';
GO
USE AdventureWorks;
CREATE USER Liza FOR LOGIN Liza;
```

---

### 💾 Step 2 – Backup and Restore AdventureWorks

1. On `North`, back up the database:

```sql
BACKUP DATABASE AdventureWorks
TO DISK = 'C:\DbFiles\AdventureWorks.bak';
```

2. On `North\A`, restore the database with different physical file names:

```sql
RESTORE DATABASE AdventureWorks
FROM DISK = 'C:\DbFiles\AdventureWorks.bak'
WITH MOVE 'AdventureWorks_Data' TO 'C:\DbFiles\AdventureWorks_A_Data.mdf',
     MOVE 'AdventureWorks_Log' TO 'C:\DbFiles\AdventureWorks_A_Log.ldf',
     REPLACE;
```

3. Optionally update statistics:

```sql
USE AdventureWorks;
EXEC sp_updatestats;
```

---

### 🧩 Step 3 – Fix Orphaned User

On `North\A`:

```sql
USE AdventureWorks;
EXEC sp_change_users_login 'Report';
```

Then fix the orphaned user:

```sql
ALTER USER Liza WITH LOGIN = Liza;
```

If needed, recreate the login with the original SID using `sp_help_revlogin` from the source.

---

### ⚙️ Step 4 – Raise Compatibility Level

Check current level:

```sql
SELECT compatibility_level
FROM sys.databases
WHERE name = 'AdventureWorks';
```

Raise it (example for SQL Server 2019):

```sql
ALTER DATABASE AdventureWorks
SET COMPATIBILITY_LEVEL = 150;
```

---

### ✅ Final Checks

* Confirm login `Liza` works on `North\A`.
* Validate that compatibility level is updated.
* Verify restored data in `AdventureWorks`.

---

### 📝 Notes (Manual Method)

* Use **different file names** to avoid collisions on same machine.
* `sp_updatestats` is often used after restores, even if not technically required.
* Raising compatibility level can affect performance and query behavior.

---

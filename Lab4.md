
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
TO DISK = 'C:\sqlbackups\AdventureWorks.bak'
WITH FORMAT, INIT, COMPRESSION;
```

- `C:\sqlbackups` must exist.
- Use Windows/File Explorer to create it if needed.

---

## ♻️ Step 3 – Restore the Database with a New Name

```sql
RESTORE DATABASE AWCopyFromBackup
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


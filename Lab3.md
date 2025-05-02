
# 🔧 SQL Server – Move Database Using Detach and Attach

## 🎯 Objective

Manually move a database from server `North` to server `North\A` using the **Detach and Attach** method.

---

## 🧩 Prerequisites

- You must have file access on both `North` and `North\A`.
- You need sysadmin privileges on both SQL Server instances.
- SQL Server Agent not required for this method.

---

## 🛠️ Step 1 – Create a Test Database on `North`

1. Connect to `North` using SSMS.
2. Run the following SQL:

```sql
CREATE DATABASE MoveDb;
GO

USE MoveDb;
CREATE TABLE TestData (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100)
);
INSERT INTO TestData VALUES (1, 'Gamma'), (2, 'Delta');
```

---

## ⛔ Step 2 – Detach the Database from `North`

1. In SSMS, right-click the `MoveDb` database > **Tasks** > **Detach**.
2. In the dialog:
   - Check the box to drop connections.
   - Click **OK** to detach.
3. Locate the `.mdf` and `.ldf` files (usually in `C:\Program Files\Microsoft SQL Server\...\Data\`).

---

## 📁 Step 3 – Copy Database Files to `North\A`

1. Manually copy the `.mdf` and `.ldf` files to the `Data` folder on `North\A`:
   - e.g. `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\`

Use a shared folder, USB drive, or direct file transfer depending on your setup.

---

## 🔗 Step 4 – Attach the Database on `North\A`

1. Connect to `North\A` using SSMS.
2. Right-click **Databases** > **Attach**.
3. Click **Add** and select the copied `.mdf` file.
4. Confirm both `.mdf` and `.ldf` are listed.
5. Click **OK** to attach.

---

## ✅ Step 5 – Verify the Migration

1. In `North\A`, open the new `MoveDb` database.
2. Run:

```sql
SELECT * FROM MoveDb.dbo.TestData;
```

You should see the rows `Gamma` and `Delta`.

---

## 🧼 Optional Cleanup

To remove the test database from both servers:

```sql
DROP DATABASE MoveDb;
```

Delete the copied files manually from disk if no longer needed.

---

## 📝 Notes

- The source database is **offline** after detach – clients cannot connect until it is re-attached.
- Moving the files instead of copying them makes this a **one-way operation** unless you have a backup.
- Always ensure you have full access rights to the data files.

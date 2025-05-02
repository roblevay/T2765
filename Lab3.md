
# 🧪 SQL Server Copy Database Wizard – Using Detach and Attach Method

## 🎯 Objective

Use the **Copy Database Wizard** to copy a database from server `North` to server `North\A` using the **Detach and Attach** method .

---

## 🧩 Prerequisites

- You need sysadmin rights on both `North` and `North\A`.
- SQL Server Agent must be **running** on both servers.
- The database to be copied must be **offline-able** during the operation.

---

## 🔐 Step 1 – Set SQL Server Agent Credentials on `North\A`

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

## 🛠️ Step 2 – Create a Sample Database on `North`

Connect to `North` and run:

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

## 🧙 Step 3 – Use the Copy Database Wizard (Detach and Attach)

1. In SSMS, connect to `North`.
2. Right-click the server > **Tasks** > **Copy Database**.
3. Click **Next** on the welcome screen.
4. Select North as the Source Server and click **Next**
5. Select North\A as the destination server and click **Next**
6. Choose **Use Detach and Attach method** → click **Next**.
7. Select to copy the database: `MoveDb` → click **Next**.
8. Set destination file paths if needed → click **Next**.
9. In Configure the Package → click **Next**.
10. Schedule the package to run immediately and click **Next**
11. Click 

---

## ✅ Step 4 – Confirm the Migration

On `North\A`, verify:

```sql
SELECT * FROM MoveDb.dbo.TestData;
```

Ensure you see the copied data (`Gamma`, `Delta`).

---

## 📝 Notes

- The **Detach and Attach** method takes the source database offline during the transfer.
- It is faster than SMO for large databases but **requires downtime**.
- Make sure file paths are valid and accessible between the two servers.


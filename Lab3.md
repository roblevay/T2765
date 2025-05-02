
# 🧪 SQL Server Copy Database Wizard – Offline Transfer

## 🎯 Objective

Copy a database from server `North` to `North\A` using the **Copy Database Wizard**, selecting the option to **take the source database offline during the transfer**.

---

## 🔐 Step 1 – Update SQL Server Agent Account on `North\A`

1. Open **SQL Server Configuration Manager** on `North\A`.
2. Go to **SQL Server Services**.
3. Right-click on **SQL Server Agent (NORTH\A)** > **Properties**.
4. In the **Log On** tab:
   - Choose **This account**
   - Enter:
     - **User**: `Student`
     - **Password**: `myS3cret`
5. Click **OK**, then restart the SQL Server Agent.

---

## 🛠️ Step 2 – Create a Database on `North`

1. Connect to `North` using SSMS.
2. Run:

```sql
CREATE DATABASE MoveDb;
GO

USE MoveDb;
CREATE TABLE TestData (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100)
);
INSERT INTO TestData VALUES (1, 'Alpha'), (2, 'Beta');
```

---

## 🧙 Step 3 – Use the Copy Database Wizard with Offline Option

1. In SSMS, connect to `North`.
2. Right-click the server name > **Tasks** > **Copy Database**.
3. Click **Next** on the welcome page.
4. Choose **Use the detach and attach method** → click **Next**.
5. Enter destination server: `North\A`
6. Authenticate as needed → click **Next**.
7. Select to copy `MoveDb` → click **Next**.
8. Choose **Take source database offline** during transfer → click **Next**.
9. Adjust file paths if needed → click **Next**.
10. Choose to run immediately or schedule → click **Next**.
11. Confirm settings and click **Finish**.

---

## ✅ Step 4 – Verify on `North\A`

1. Connect to `North\A`.
2. Expand **Databases** and confirm `MoveDb` exists.
3. Check the `TestData` table content.

---

## 🧼 Optional Cleanup

```sql
DROP DATABASE MoveDb;  -- Run on both servers if needed
```

---

## 📝 Summary

This version of the wizard **takes the source database offline** during the transfer, which:

- Minimizes data inconsistencies
- Requires downtime during the operation

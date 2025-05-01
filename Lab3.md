
# 🧪 SQL Server Upgrade Simulation (No Old Instance Needed)

## 📝 Objective
Simulate a SQL Server upgrade using the Data Migration Assistant (DMA) — without needing an older SQL Server instance.

---

## Step 1 – Create a Test Database

Open SQL Server Management Studio and run the following script:

```sql
CREATE DATABASE OldDb;
GO
USE OldDb
GO

CREATE TABLE Test (
    ID INT PRIMARY KEY,
    Msg NVARCHAR(100)
);

INSERT INTO Test VALUES (1, 'Hello'), (2, 'World');

CREATE PROCEDURE LegacyProc AS
BEGIN
    RAISERROR('This is deprecated', 10, 1);  -- Intentionally deprecated syntax
END;
```

---

## Step 2 – Set a Legacy Compatibility Level

Still in SSMS, simulate an old environment by downgrading the compatibility level:

```sql
ALTER DATABASE OldDb SET COMPATIBILITY_LEVEL = 110;  -- SQL Server 2012
```

---

## Step 3 – Run Data Migration Assistant (DMA)

1. Launch DMA.
2. Click **"+ New"**, choose **Assessment**.
3. Connect to your local SQL Server instance.
4. Select **"OldDb"**.
5. Choose **Target: SQL Server 2022**.
6. Run the assessment.

---

## Step 4 – Analyze the Results

- What issues does DMA report?
- Are there **breaking changes** or **deprecated features**?
- Would anything block a real upgrade?

Take screenshots or notes if used in a classroom setting.

---

## Step 5 – (Optional) Upgrade Compatibility Level

To simulate post-upgrade behavior:

```sql
ALTER DATABASE OldDb SET COMPATIBILITY_LEVEL = 160;  -- SQL Server 2022
```

You may also enable **Query Store** to track performance differences (optional):

```sql
ALTER DATABASE OldDb SET QUERY_STORE = ON;
```

---

## ✅ Summary

This exercise gives hands-on experience with:
- Using DMA to assess upgrade readiness
- Simulating older database behavior
- Identifying and fixing upgrade blockers

All without requiring an actual older SQL Server instance.

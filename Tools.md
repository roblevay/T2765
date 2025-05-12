# SQL Server Diagnostic Tools – Hands-on Exercise

## Objective
Learn how to download, install, and run three powerful diagnostic tools for SQL Server:

- Glenn Berry’s Diagnostic Scripts  
- `sp_Blitz` by Brent Ozar  
- `sp_DBInfo` by Tibor Karaszi

---

## 1. Glenn Berry's Diagnostic Queries

### 🔽 Download
Go to:  
[https://glennsqlperformance.com/resources/](https://glennsqlperformance.com/resources/)

Download the latest script matching your SQL Server version (e.g., SQL Server 2022 Diagnostic Information Queries).

### ▶️ Usage
1. Open the `.sql` file in SSMS.
2. Run the whole script or selected queries.
3. Review results in SSMS grid.

### 📌 Useful Queries to Start With

- **Top Waits**
  ```sql
  SELECT wait_type, wait_time_ms, percent_total_waits
  FROM sys.dm_os_wait_stats
  ORDER BY wait_time_ms DESC;
  ```
  > Identifies what your server is *waiting* on the most – a key to performance tuning.

- **Missing Indexes**
  ```sql
  SELECT *
  FROM sys.dm_db_missing_index_details;
  ```
  > Shows potentially helpful indexes that SQL Server wishes existed.

- **Expensive Queries**
  ```sql
  SELECT TOP 10 total_worker_time, execution_count, query_hash
  FROM sys.dm_exec_query_stats
  ORDER BY total_worker_time DESC;
  ```
  > Finds CPU-heavy queries – great for optimization targets.

---

## 2. `sp_Blitz` – Health Check by Brent Ozar

### 🔽 Download
Visit:  
[https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit) (open in a new window)

Click on sp_blitz.sql. The file will open

### 📦 Install
1. Click Copy raw file
2. Paste it in SSMS.
3. Run it in the `master` database.

### ▶️ Usage
```sql
EXEC sp_Blitz;
```

### 🧾 Output Overview

- **Priority**: Severity of issue (1 is critical up to 255 which is not critical at all)
- **Finding**: The issue found (e.g. “Backups Not Performed Recently”)
- **Database Name**: Which DB is affected (if applicable)
- **Details**: Text explanation and a link to learn more

> Helps you quickly spot configuration problems, security risks, and maintenance issues.

---

## 3. `sp_DBInfo` – Database Space Info by Tibor Karaszi

### 🔽 Download
Go to:  
[https://karaszi.com/spdbinfo-database-space-usage-information](https://karaszi.com/spdbinfo-database-space-usage-information) (open in a new window)

Click sp_dbinfo.sql 

### 📦 Install
1. Copy the script and paste it in SSMS
2. Run it in the database where you want the procedure (commonly `master`).

### ▶️ Usage
```sql
EXEC sp_DBInfo;
```

### 🧾 Output
Shows space usage at file and object level:

- DB name, file sizes, free space
- Space used per filegroup and per object (e.g. table)
- Warnings for possible cleanup

> Very useful for tracking growth or troubleshooting large tables.


## 4. `sp_tableinfoo` – Table Info

### 🔽 Download
Go to:  
https://karaszi.com/sptableinfo-list-tables-and-space-usage (open in a new window)

Click sp_tableinfo.sql 

### 📦 Install
1. Copy the script and paste it in SSMS
2. Run it in the database where you want the procedure (commonly `master`).

### ▶️ Usage
```sql
EXEC sp_tableinfo;
```

### 🧾 Output

The procedure returns a row for each table in current database (unless table spread over several filegroups, using several indexes or partitions; if so then several rows are returned). It returns schema name, table name, number of rows, size in both MB and pages and file group.

---

Självklart, här är en motsvarande sektion för `sp_indexinfo` i samma stil:

---

## 5. `sp_indexinfo` – Index Info

### 🔽 Download

Go to:
[https://karaszi.com/sp\_indexinfo-list-indexes-and-their-attributes](https://karaszi.com/sp_indexinfo-list-indexes-and-their-attributes) (open in a new window)

Click `sp_indexinfo.sql`

### 📦 Install

1. Copy the script and paste it in SSMS
2. Run it in the database where you want the procedure (commonly `master`)

### ▶️ Usage

```sql
EXEC sp_indexinfo;
```

### 🧾 Output

The procedure lists all indexes in the current database, with detailed attributes:
table name, index name, type, uniqueness, number of rows, size in MB, fragmentation, included columns, and more.
Superb for index reviews and cleanup decisions.

---

Vill du ha motsvarande för `sp_indexanalyse` också?


## ✅ Summary
These tools are safe, free, and widely used in the SQL Server community.  
They help you analyze, audit, and understand your servers in minutes.

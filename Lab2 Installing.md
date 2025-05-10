# 🛠️ SQL Server Installation & Validation

# Exercise 1. Before the Installation

You will use the SQL Server installation program to view hardware and software requirements, use the configuration checker and also see what is already installed on the machine:

- Run `setup.exe`. It is likely found on the `D:` or `F`drive (an attached ISO), or possibly in a folder named something like `C:\SqlInstall`.
- Use the **Planning** page to view *Hardware and Software Requirements*.
- Use the **Tools** page to run the *System Configuration Checker*.
- Also on the Tools page, check what is installed using the *Installed SQL Server features discovery report*.

---

# Exercise 2. Install a Named Instance (Developer Edition)

You will install a new instance of the database engine. We suggest that you install only the database engine, to keep it quick and simple.  
(If there is something specific you want to explore during these days, feel free to include it.)

You can choose settings as you like, but for reference:

- Instance name: `X`
- Database engine only – no subcomponents
- Default folders
- Default service accounts (Virtual Service Accounts)
- Set database engine and Agent service to start manually
- Any collation (choose a non-default if you want to test)
- If using "Mixed Mode" authentication:
  - Password for `sa`: `myS3cret`
- Add yourself as an admin login

---

# Exercise 3. Check the Installation

- Verify that your instance is running – start it if needed.
- Log in using SSMS or Azure Data Studio.
- Use **SQL Server Configuration Manager** to configure the instance to also listen on TCP/IP.
- You can stop the instance if you want to save system resources – or keep it running for experiments.

---

# Exercise 4. SQLIOSIM Disk I/O Integrity Test Exercise

### Objective:
Run the SQLIOSIM tool with a custom configuration to verify disk I/O integrity.

### Step 1: Prepare the Environment

- Open a terminal with **Administrator rights** (right-click CMD or PowerShell > *Run as administrator*).

### Step 2: Locate SQLIOSIM

- Navigate to the SQL Server Binn directory:
```cmd
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
```
- Confirm that `SQLIOSim.exe` exists.

### Step 3: Start SQLIOSIM with Custom Config

```cmd
sqliosim.exe
```

- Set the cycle duration to 30 and test cycles to 2.
- Use one data file with size 256 MB and max size 512 MB.
- Click OK → Simulator → Start
- Optional: rerun with different parameters

### Step 4: Review the Results

- Green = OK, Yellow = warnings (often fine on VMs), Red = serious issues

### Step 5: Reflect and Discuss

- What did your test validate?
- Any warnings/errors?
- Is your environment suitable for SQL Server?

---

# Exercise 5. DiskSpd Basic Test – Read Performance

## Goal
Test read performance with 4 KB block size, 100% random reads, 8 threads, for 60 seconds.

## Step 1 – Create a test file

```cmd
fsutil file createnew C:\test\testfile.dat 1073741824
```

## Step 2 – Run DiskSpd

```cmd
diskspd -b4K -d60 -o8 -t8 -r -W0 -L C:\test\testfile.dat
```

## Understanding the Output

Focus on:
- IOPS, MB/s throughput
- Latency stats
- CPU usage

### Latency Percentiles

| %-ile  | Read (ms) |
|--------|-----------|
| 50th   | ~0.35     |
| 95th   | ~0.59     |
| max    | ~20.60    |

---

## 🔍 What's “good”?

| Storage           | IOPS   | MB/s   | Latency   |
|-------------------|--------|--------|-----------|
| HDD               | 75–150 | ~100   | 5–15 ms   |
| SATA SSD          | 10K+   | ~500   | <0.5 ms   |
| Azure Premium P30 | ~5K    | ~200   | ~0.5–1 ms |

---

# Exercise 3. DiskSpd Basic Test – Write Performance

## Goal
Test write performance with 64 KB blocks, 100% sequential writes,  4 threads, 30 seconds.

## Step 1 – Create test file

```cmd
fsutil file createnew C:\test\writetest.dat 1073741824
```

## Step 2 – Run DiskSpd

```cmd
diskspd -b64K -d30 -o4 -t4 -w100 -si -W0 -L C:\test\writetest.dat
```

## Output Interpretation

- IOPS / Throughput
- Avg, min, max latency
- CPU bottlenecks

### Latency Table (Write)

| %-ile  | Write (ms) |
|--------|------------|
| 50th   | ~0.47      |
| 95th   | ~0.88      |
| max    | ~20.22     |

---

## 🔍 What's “good”?

| Storage           | IOPS   | MB/s   | Latency   |
|-------------------|--------|--------|-----------|
| HDD               | 100–200| ~100   | 5–15 ms   |
| SATA SSD          | 5K–20K | ~500   | <0.5 ms   |
| Azure Premium P30 | ~2K–5K | ~200   | ~0.5–1 ms |

Write performance depends heavily on cache behavior and flush policy.

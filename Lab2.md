
# Exercise 1. SQLIOSIM Disk I/O Integrity Test Exercise

### Objective:
Run the SQLIOSIM tool with a custom configuration to verify disk I/O integrity.

---

### Step 1: Prepare the Environment

- Open a terminal with **Administrator rights** (right-click CMD or PowerShell > *Run as administrator*).


---

### Step 2: Locate SQLIOSIM

- Navigate to the SQL Server Binn directory:
```cmd
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
```
- Confirm that `SQLIOSim.exe` exists.

---

### Step 3: Start SQLIOSIM with Custom Config

- Launch `SQLIOSim.exe` from the `Binn` directory by executing sqliosim.exe

```
sqliosim.exe
```

### Step 4: Run the Simulation

- Set the cycle duration to 30 and test cycles to 2. Use only one data file with size 256 MB and Maxsize 512 MB Fill out the other variables to your liking.
- Click OK
- From the Simulator menu, click Start
- The test will run using your custom parameters.
- If time permits, rerun with different parameters. Many cycles and large files can take a long time!

---

### Step 5: Review the Results


- Green = OK, Yellow = warnings (tolerable on VMs), Red = serious problems.

---

### Step 6: Reflect and Discuss

- What did your custom config test?
- Were there any warnings or errors?
- Could your environment safely run SQL Server based on this test?


# Exercise 2. DiskSpd Basic Test – Read Performance


## Goal
Test read performance with 4 KB block size, 100% random reads, 8 threads, for 60 seconds.

---

## Step 1 – Create a test file

- If not exists, create a folder called c:\test
- Open a terminal with **Administrator rights** (right-click CMD or PowerShell > *Run as administrator*).
 
```cmd
fsutil file createnew C:\test\testfile.dat 1073741824
```
Creates a 1 GB file (1,073,741,824 bytes).

---

## Step 2 – Run DiskSpd

```cmd
diskspd -b4K -d60 -o8 -t8 -r -W0 -L C:\test\testfile.dat
```

### Flag explanation:
- `-b4K` → Block size: 4 KB
- `-d60` → Duration: 60 seconds
- `-o8` → Outstanding I/Os per thread: 8
- `-t8` → Number of threads: 8
- `-r` → Random I/O
- `-W0` → Disable write cache
- `-L` → Enable latency statistics
- `C:\test\testfile.dat` → File used for the test

---

## Understanding the Output

After the test, DiskSpd outputs detailed metrics. Key sections to focus on:

### 1. **Total I/O Performance**
- **IOPS (I/O per second)**: Total number of operations completed per second.
- **MB/s (Throughput)**: How much data was read per second.
- **Latency**: Response time of I/O operations. Lower is better.

### 2. **Latency Statistics**
- **Average Latency**: Mean time per I/O operation (in ms or µs).
- **Minimum and Maximum Latency**: Useful for spotting spikes or stalls.
- **Standard Deviation**: High stddev = inconsistent performance.

### 3. **CPU Usage**
- Breakdown of how much CPU each thread used.
- Helps determine if the bottleneck is CPU or disk.

---

## Summary

This test gives a snapshot of your system's random read performance under load. Useful for checking:
- Disk throughput and consistency
- Suitability for workloads like SQL Server OLTP
- Impact of disk type (e.g., SSD vs HDD vs network storage)

- 
# Exercise 3. DiskSpd Basic Test – Write Performance

## Goal
Test write performance with 64 KB block size, 100% sequential writes, 4 threads, for 30 seconds.

---

## Step 1 – Create a test file

```cmd
fsutil file createnew C:\test\writetest.dat 1073741824
```
Creates a 1 GB file (1,073,741,824 bytes).

---

## Step 2 – Run DiskSpd

```cmd
diskspd -b64K -d30 -o4 -t4 -w100 -s -W0 -L C:\test\writetest.dat
```

### Flag explanation:
- `-b64K` → Block size: 64 KB
- `-d30` → Duration: 30 seconds
- `-o4` → Outstanding I/Os per thread: 4
- `-t4` → Number of threads: 4
- `-w100` → 100% write workload
- `-s` → Sequential I/O
- `-W0` → Disable write cache
- `-L` → Enable latency statistics
- `C:\test\writetest.dat` → File used for the test

---

## Understanding the Output

After the test, DiskSpd provides performance data. Key parts to examine:

### 1. **Total I/O Performance**
- **IOPS (I/O per second)**: Number of write operations per second.
- **MB/s (Throughput)**: Amount of data written per second.
- **Latency**: Time taken per write – crucial for sustained throughput.

### 2. **Latency Statistics**
- **Average, min, max latency**: Show how fast or slow individual writes were.
- **Standard Deviation**: High values might indicate performance instability.

### 3. **CPU Utilization**
- Indicates whether your bottleneck is the disk subsystem or the CPU.

---

## Summary

This test helps evaluate:
- Raw write performance of your storage
- Suitability for sequential write-heavy workloads (e.g., backups, logging)
- Effects of disabling write cache

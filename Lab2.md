
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

---

## 📊 Understanding the Latency Percentile Table

DiskSpd provides a detailed latency distribution table like this:

```
  %-ile |  Read (ms) | Write (ms) | Total (ms)
----------------------------------------------
    min |      0.005 |        N/A |      0.005
   25th |      0.288 |        N/A |      0.288
   50th |      0.350 |        N/A |      0.350
   75th |      0.425 |        N/A |      0.425
   90th |      0.513 |        N/A |      0.513
   95th |      0.589 |        N/A |      0.589
   99th |      0.962 |        N/A |      0.962
3-nines |      1.415 |        N/A |      1.415
4-nines |      5.528 |        N/A |      5.528
5-nines |     11.052 |        N/A |     11.052
6-nines |     18.650 |        N/A |     18.650
7-nines |     20.596 |        N/A |     20.596
8-nines |     20.606 |        N/A |     20.606
9-nines |     20.606 |        N/A |     20.606
    max |     20.606 |        N/A |     20.606
```

### What does this mean?

- **min**: The fastest I/O operation.
- **50th (median)**: Half of all operations were faster than this.
- **90th/95th/99th**: 90%, 95%, and 99% of all operations were faster. The rest were slower.
- **3-nines to 9-nines**: Extremely rare slow operations. "5-nines" means 99.999% were faster than that time.

### How to interpret it?

- **Median < 1 ms** = Excellent
- **95th/99th > 2-5 ms** = May indicate spikes or storage hiccups
- **Very high max** = Occasional blocking or caching delays

---

## 🔍 What are “good” values?

| Storage Type         | IOPS (4K) | MB/s (64K) | Avg Latency       |
|----------------------|-----------|------------|-------------------|
| HDD (7200 rpm)       | 75–150    | 80–120     | 5–15 ms           |
| SATA SSD             | 10K–100K  | 300–550    | 0.1–0.5 ms        |
| NVMe SSD             | 200K+     | 1–3 GB/s   | <0.1 ms           |
| Azure Premium (P30)  | ~5K       | ~200 MB/s  | 0.5–1 ms          |

Values vary by workload, but this gives a rough guideline.

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
diskspd -b64K -d30 -o4 -t4 -w100 -si -W0 -L C:\test\writetest.dat
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

---

## 📊 Understanding the Latency Percentile Table

DiskSpd provides a detailed latency distribution table like this:

```
  %-ile |  Read (ms) | Write (ms) | Total (ms)
----------------------------------------------
    min |        N/A |      0.012 |      0.012
   25th |        N/A |      0.350 |      0.350
   50th |        N/A |      0.475 |      0.475
   75th |        N/A |      0.612 |      0.612
   90th |        N/A |      0.775 |      0.775
   95th |        N/A |      0.888 |      0.888
   99th |        N/A |      1.312 |      1.312
3-nines |        N/A |      2.025 |      2.025
4-nines |        N/A |      5.620 |      5.620
5-nines |        N/A |     10.810 |     10.810
6-nines |        N/A |     18.000 |     18.000
7-nines |        N/A |     20.200 |     20.200
8-nines |        N/A |     20.220 |     20.220
9-nines |        N/A |     20.220 |     20.220
    max |        N/A |     20.220 |     20.220
```

### What does this mean?

- **min**: Fastest write operation.
- **50th (median)**: Half of all write operations were faster than this.
- **95th/99th**: Show how much latency increases for the slowest few operations.
- **Nines (3-9)**: Extreme outliers — may show disk stalls or flush delays.

### How to interpret it?

- **Median write latency < 1 ms** = Great
- **95th/99th > 5 ms** = Not ideal; spikes might cause performance issues
- **Max > 20 ms** = Indicates caching or queueing delays

---

## 🔍 What are “good” values?

| Storage Type         | IOPS (64K seq writes) | MB/s       | Avg Latency       |
|----------------------|------------------------|------------|-------------------|
| HDD (7200 rpm)       | 100–200                | 80–150     | 5–15 ms           |
| SATA SSD             | 5K–20K                 | 300–500    | 0.1–0.5 ms        |
| NVMe SSD             | 50K+                   | 1–3 GB/s   | <0.1 ms           |
| Azure Premium (P30)  | ~2K–5K                 | ~200 MB/s  | 0.5–1 ms          |

Write performance depends heavily on cache behavior and flush policy.

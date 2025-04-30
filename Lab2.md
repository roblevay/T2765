
# SQL Server I/O Testing Exercises

### Exercise 1: Test Disk I/O Correctness with SQLIOSIM (15–20 min)

**Step 1: Download and Launch SQLIOSIM**
- Download SQLIOSIM utility from Microsoft:
  https://aka.ms/sqliosim-download
- Extract the files and launch `SQLIOSim.exe`.

**Step 2: Configure and Run Test**
- Select the drive where SQL Server data files are (or will be) stored.
- Use default settings for a basic test, or customize the number of threads, duration, and file size.
- Start the simulation.

**Step 3: Review and Interpret Results**
- After the test completes, examine the result pane:
  - **Green text**: Normal output
  - **Yellow warnings**: Usually benign but worth reviewing
  - **Red text**: Serious disk I/O errors — must be investigated
- A typical healthy result contains no red errors and very few (if any) warnings.

**Step 4: Discussion**
- On a physical machine, SQLIOSIM should show no red errors.
- On a virtual machine (VM), occasional warnings may appear, often related to disk latency or write caching.
- If red errors appear consistently on a VM:  
  → Consider disk controller configuration, underlying storage performance, or virtualization platform settings.

---

### Exercise 2: Test Disk I/O Performance with DISKSPD (15–20 min)

**Step 1: Prepare Command Prompt as Administrator**
- Open Command Prompt as administrator.

**Step 2: Run a Performance Test**
- Execute:
```shell
diskspd -c1G -b8K -r -t2 -o4 -d30 -h c:\diskspd-testfile.dat
```
- This runs a 30-second read test using 8KB blocks, simulating SQL Server workloads.

**Step 3: Review Output**
- Look at these key metrics in the output:
  - **IOPS** (I/O operations per second)
  - **Throughput** (MB/s)
  - **Latency** (average response time in ms)
- For a VM, decent results might be:
  - ~500–2000 IOPS
  - ~10–50 MB/s
  - Latency below 5 ms
- Very high latency or very low throughput could signal poor storage performance.

**Step 4: Clean Up**
```shell
del c:\diskspd-testfile.dat
```

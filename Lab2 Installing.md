# 🛠️ SQL Server Installation & Validation

# Exercise 1. Before the Installation

You will use the SQL Server installation program to view hardware and software requirements, use the configuration checker and also see what is already installed on the machine:

- Run `setup.exe`. It is likely found on the `D:` or `F: `drive (an attached ISO), or possibly in a folder named something like `C:\SqlInstall` or `F:\SQL\Install`
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

- In file explorer, Navigate to the SQL Server Binn directory:
C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Binn"

- Confirm that `SQLIOSim.exe` exists.

### Step 3: Start SQLIOSIM with Custom Config

Right-click the file 

sqliosim.exe

and select **Run as Admininstrator**

- Set the cycle duration to 30 and test cycles to 2.
- Click OK → Simulator → Start
- Optional: rerun with different parameters
- The simulation will take less than 10 minutes

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

Download the file diskspd.exe to the c:\temp directory

## Step 1 – Create a test file
From a command prompt:

```cmd
fsutil file createnew C:\temp\testfile.dat 1073741824
```

## Step 2 – Run DiskSpd

```cmd
c:\temp\diskspd -b64K -d30 -o4 -t4 -w100 -si -W0 -L C:\testfile.dat
```

---

### 📌 Parametrar i detalj

* **`-b64K`**
  Blockstorlek: varje I/O-operation använder block om 64 KB.
  (Standard är 64 KB, men du kan ändra beroende på vad du vill simulera, t.ex. 8K för databasliknande mönster.)

* **`-d30`**
  Testets varaktighet: körs i 30 sekunder.

* **`-o4`**
  Queue depth / Outstanding I/O: upp till 4 I/O-operationer hålls "ute" samtidigt per tråd.
  (Detta simulerar flera samtidiga begäran, ungefär som ett system med köer mot disken.)

* **`-t4`**
  Antal trådar per målfil: här 4 trådar.
  I praktiken betyder det att testet parallelliseras för att belasta disken mer realistiskt.

* **`-w100`**
  Skriv-andel (%). 100 = rent skrivtest.
  (0 skulle vara rent lästest, 50 en mix av läs/skriv.)

* **`-si`**
  Disable software caching: inaktiverar *software caching* i operativsystemet.
  Gör testet mer "rått" och hårdvarunära.

* **`-W0`**
  Write-through mode: `0` = stäng av skrivcache (dvs skriver direkt till disk, utan att buffras i cache).
  Detta ger en mer konservativ bild av verklig skrivprestanda.

* **`-L`**
  Logga latens för varje I/O och skriv till konsolen.
  Bra för analys av variation i responstider, inte bara total MB/s.

* **`C:\temp\writetest.dat`**
  Målfilen som testet körs mot. DiskSpd skapar och använder denna fil under körning.
  (Bra att välja en mapp på den disk du vill mäta.)

---

### 📝 Sammanfattning

Kommando kör ett **30 sekunder långt, 100 % skrivtest** mot `C:\temp\writetest.dat` med:

* blockstorlek 64 KB,
* 4 trådar,
* 4 outstanding I/O per tråd (totalt upp till 16 samtidiga I/O),
* utan OS-cache och med write-through (för mer realistiska värden),
* och loggar latens.

---


Wait for some time for the program to finish.

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

# Exercise 6. DiskSpd Basic Test – Write Performance

## Goal
Test write performance with 64 KB blocks, 100% sequential writes,  4 threads, 30 seconds.

## Step 1 – Create test file

```cmd
fsutil file createnew C:\temp\writetest.dat 1073741824
```

## Step 2 – Run DiskSpd

```cmd
c:\temp\diskspd -b64K -d30 -o4 -t4 -w100 -si -W0 -L C:\temp\writetest.dat
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


# Exercise 7 : CrystalDiskMark

- Download **CrystalDiskMark9_0_1.exe** from **https://github.com/roblevay/T1987**
- Install the application using default settings
- In the **Admin** program, seleect dick **c:** amd click **All**. Wait for about 5 minutes for the program to run.
- Repeat the procedure awith disk **d:** and compare the results

Here is an explanation of the values on the left. You will get values for **Read MB/s** and **Write MB/s** in each box.

- **SEQ1M Q8T1**  
  Sequential read/write with **1 MB block size**, queue depth 8, 1 thread.  
  → Good for measuring **maximum transfer speed** under parallel load.

- **SEQ1M Q1T1**  
  Sequential read/write with **1 MB block size**, queue depth 1, 1 thread.  
  → Represents **single-threaded sequential performance**, closer to everyday file copy scenarios.

- **RND4K Q32T1**  
  Random read/write with **4 KB block size**, queue depth 32, 1 thread.  
  → Simulates **many outstanding small I/Os**, similar to a server or heavy multitasking.

- **RND4K Q1T1**  
  Random read/write with **4 KB block size**, queue depth 1, 1 thread.  
  → Shows **single-queue random access performance**, typical for databases or OS background operations.


## Example CrystalDiskMark Results

[![CrystalDiskMark Benchmark](f45fbed0-b0d3-42ed-8dad-006ebb507754.png)](https://github.com/roblevay/T1987/blob/main/images/CrystalDiskMark.png)

### Interpretation

- **SEQ1M Q8T1: 213.7 MB/s Read / 172.6 MB/s Write**  
  High sequential performance, showing the disk can transfer large files at ~200 MB/s.  
  → This is typical for a SATA HDD or a lower-end SSD.

- **SEQ1M Q1T1: 215.0 MB/s Read / 171.1 MB/s Write**  
  Single-threaded sequential speed is almost the same as multi-queue, which is expected.  
  → Everyday tasks like copying files will run at ~200 MB/s.

- **RND4K Q32T1: 17.8 MB/s Read / 14.8 MB/s Write**  
  Random small-block performance with a deep queue.  
  → Much lower than sequential, which is normal. Shows how the disk handles many small operations at once.

- **RND4K Q1T1: 17.6 MB/s Read / 3.9 MB/s Write**  
  Random small-block performance with a single queue.  
  → Write speed here is the weakest (3–4 MB/s). This is the limiting factor for workloads like databases or lots of small file updates.

### Overall Assessment
- The drive performs well for **sequential transfers** (~200 MB/s), which means copying and moving large files is reasonably fast.  
- **Random writes at Q1T1 are slow**, which is common for mechanical hard drives or entry-level SSDs without DRAM cache.  
- For general use (Windows, Office, browsing, media), this performance is acceptable.  
- For heavy multitasking or database workloads, performance would feel much slower compared to a modern NVMe SSD.



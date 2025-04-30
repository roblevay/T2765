
# SQLIOSIM Disk I/O Integrity Test Exercise

### Objective:
Run the SQLIOSIM tool to verify disk I/O integrity in the environment where SQL Server is installed.

### Step 1: Locate SQLIOSIM

- Open a terminal with **Administrator rights** (right-click CMD or PowerShell > *Run as administrator*).
- Navigate to SQL Server’s Binn directory. For example:

```powershell
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
```

- Confirm that `SQLIOSim.exe` exists in this directory.

### Step 2: Prepare the Log File Path

- Before running the simulation, make sure the log file location is valid.
- If needed, create a directory like `C:\Temp`:
```powershell
mkdir C:\Temp
```

- When SQLIOSIM opens, set the log file path (top-right corner of the UI) to:
```
C:\Temp\SQLIOSim.log
```

### Step 3: Run the Simulation

- In the SQLIOSIM interface, select the drive where SQL Server data is or will be stored.
- Use the default test settings.
- Click **Start Simulation**.

### Step 4: Review the Results

- Green = normal.
- Yellow = warnings (review, often tolerable on VMs).
- Red = serious disk I/O errors – investigate.

### Step 5: Discuss

- Why is disk I/O integrity important for SQL Server?
- What kinds of problems might these tests help detect?

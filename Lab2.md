
# SQLIOSIM Disk I/O Integrity Test Exercise

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

- Set the cycle duration to 30 and test cycles to 4. Fill out the other variables to your liking.
- Clik OK
- From the Simulator menu, click Start
- The test will run using your custom parameters.

---

### Step 5: Review the Results

- Open the log file in Notepad:
```powershell
notepad C:\SQLIOSim.log
```
- Green = OK, Yellow = warnings (tolerable on VMs), Red = serious problems.

---

### Step 6: Reflect and Discuss

- What did your custom config test?
- Were there any warnings or errors?
- Could your environment safely run SQL Server based on this test?


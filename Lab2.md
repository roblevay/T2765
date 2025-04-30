
# SQLIOSIM Disk I/O Integrity Test Exercise

### Objective:
Run the SQLIOSIM tool with a custom configuration to verify disk I/O integrity.

---

### Step 1: Prepare the Environment

- Open a terminal with **Administrator rights** (right-click CMD or PowerShell > *Run as administrator*).
- Create a working folder on the C: drive:
```powershell
mkdir C:\sqliosim
```
- Copy the provided configuration file `sqliosim.cfg` into this directory.

---

### Step 2: Locate SQLIOSIM

- Navigate to the SQL Server Binn directory:
```powershell
cd "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Binn"
```
- Confirm that `SQLIOSim.exe` exists.

---

### Step 3: Start SQLIOSIM with Custom Config

- Launch `SQLIOSim.exe` from the `Binn` directory.
- In the SQLIOSIM window:
  - Go to **File > Load configuration file…**
  - Select the config file you copied earlier:
    ```
    C:\sqliosim\sqliosim.cfg
    ```
  - In the main interface, ensure the **Log file path** is set to:
    ```
    C:\sqliosim\SQLIOSim.log
    ```

---

### Step 4: Run the Simulation

- Click **Start Simulation**.
- The test will run using your custom parameters.

---

### Step 5: Review the Results

- Open the log file in Notepad:
```powershell
notepad C:\sqliosim\SQLIOSim.log
```
- Green = OK, Yellow = warnings (tolerable on VMs), Red = serious problems.

---

### Step 6: Reflect and Discuss

- What did your custom config test?
- Were there any warnings or errors?
- Could your environment safely run SQL Server based on this test?


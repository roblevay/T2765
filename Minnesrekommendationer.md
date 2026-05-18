Det finns ingen exakt procentsats som alltid gäller, men det finns ganska etablerade rekommendationer för **max server memory** i SQL Server.

Grundprincipen är:

> SQL Server ska få så mycket minne som möjligt — men Windows och andra tjänster måste ha tillräckligt kvar.

# Det viktigaste

Du bör nästan alltid sätta:

```sql
max server memory
```

Man bör normalt **inte** låta SQL Server använda “allt”.

---

# Praktisk tumregel

## Dedikerad SQL Server

| Totalt RAM | Rekommenderat till OS |
| ---------- | --------------------- |
| 8 GB       | 2–3 GB                |
| 16 GB      | 4 GB                  |
| 32 GB      | 4–6 GB                |
| 64 GB      | 6–8 GB                |
| 128 GB     | 10–16 GB              |
| 256 GB+    | 16–24 GB              |

Resten kan SQL Server få.

---

# Exempel

## Server med 64 GB RAM

Vanligt:

* Windows + backup + antivirus:

  * 6–8 GB

SQL Server:

```text id="qkl0ng"
56 GB
```

Alltså:

```sql
EXEC sp_configure 'max server memory', 57344;
RECONFIGURE;
```

(56 × 1024 MB)

---

# Rekommenderad procent

## Dedikerad SQL Server

Typiskt:

| Servertyp     | SQL Server får |
| ------------- | -------------- |
| Små servrar   | 70–80 %        |
| Medel         | 80–90 %        |
| Stora servrar | 90–95 %        |

Ju större server desto mindre procent behöver OS.

---

# Min server memory

## Normalt

De flesta lämnar:

```text id="lyyvy5"
min server memory = 0
```

Det är helt OK.

---

# När använder man min server memory?

Främst:

* flera SQL-instanser
* virtuella miljöer
* resurskontroll
* specialfall

Inte särskilt vanligt i vanliga installationer.

---

# Viktigt att förstå

## max server memory styr INTE allt

Inställningen gäller främst:

* buffer pool
* databascache

Men SQL Server kan fortfarande använda extra minne för:

* linked servers
* CLR
* backups
* columnstore
* SSIS
* antivirus-interaktion
* tredjepartsverktyg

Så lämna alltid marginal.

---

# Vanliga misstag

## 1. Ingen maxgräns alls

SQL Server äter då ofta upp nästan allt RAM.

Resultat:

* Windows börjar swappa
* servern blir seg
* RDP fryser
* backup strular

Mycket vanligt.

---

## 2. För lite minne till OS

Exempel:

```text id="9vhb8m"
64 GB server
63 GB till SQL
```

Då finns nästan inget kvar till:

* filcache
* antivirus
* drivrutiner
* backup-program

---

## 3. För låg max memory

Ger:

* onödiga läsningar från disk
* sämre cache hit ratio
* lägre prestanda

---

# Microsofts officiella syn

Microsoft ger ingen exakt formel längre.

De säger i princip:

* lämna tillräckligt för OS
* övervaka systemet
* justera efter workload

---

# Min praktiska rekommendation

## Modern dedikerad SQL Server

### 32 GB server

```text id="qgxz0n"
SQL: 26–28 GB
```

---

### 64 GB server

```text id="67iz31"
SQL: 54–58 GB
```

---

### 128 GB server

```text id="lz5hgd"
SQL: 112–120 GB
```

---

# Så kontrollerar du nuvarande inställning

```sql
EXEC sp_configure 'max server memory';
```

---

# Så ändrar du

```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'max server memory', 57344;
RECONFIGURE;
```

---

# Kontrollera faktisk användning

```sql
SELECT 
    physical_memory_in_use_kb / 1024 AS SQL_MB
FROM sys.dm_os_process_memory;
```

---

# På virtuella servrar

Var extra försiktig om:

* flera VM:ar delar host
* dynamiskt minne används
* VMware ballooning finns

Då bör man lämna större marginaler.

---

# På samma server som annat

Om samma server kör:

* IIS
* SSIS
* Power BI
* AI-modeller
* Docker
* backup-agent

…måste mer RAM reserveras för OS/applikationer.

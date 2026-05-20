# Att tänka på vid uppgradering av SSIS från SQL Server 2019 till 2022

SSIS fungerar generellt ganska smärtfritt mellan 2019 och 2022, men det finns några viktiga områden som ofta ställer till problem.

---

# 1. Versionskompatibilitet i Visual Studio / SSDT

## Det viktigaste först

SSIS-paket utvecklas normalt i:

* Visual Studio
* SSIS Extension (SSDT)

För SQL Server 2022 behöver du normalt:

| Komponent      | Rekommendation    |
| -------------- | ----------------- |
| Visual Studio  | 2019 eller 2022   |
| SSIS Extension | senaste versionen |

---

# Viktigt

Gamla SSDT-versioner kan:

* inte deploya korrekt
* sakna stöd för nya targets
* ge märkliga valideringsfel

---

# 2. TargetServerVersion

I projektet:

```text
Project → Properties → TargetServerVersion
```

Måste ändras till:

```text
SQL Server 2022
```

Annars kan deployment eller validation bete sig konstigt.

---

# 3. Integration Services Catalog (SSISDB)

## Vanligt misstag

Man uppgraderar SQL Server men:

* återställer gammal SSISDB
* utan att uppgradera katalogen

---

# Kontrollera därför

Efter uppgradering:

```sql
SELECT * FROM catalog.catalog_properties
```

---

# Rekommendation

Ofta bäst att:

1. skapa ny SSISDB i 2022
2. deploya om projekten

istället för att bara återställa gammal katalog.

---

# 4. .NET-versioner

Många äldre SSIS-lösningar använder:

* Script Tasks
* Script Components
* custom assemblies

Där kan problem uppstå.

---

# Kontrollera särskilt

## Script Tasks

Gamla:

* VSTA-versioner
* assemblies
* GAC-referenser

kan behöva byggas om.

---

# 5. OLE DB-drivrutiner

MYCKET vanligt problem.

Efter uppgradering saknas ofta:

* gamla OLE DB providers
* Oracle-drivrutiner
* Excel-drivrutiner
* Access Database Engine

---

# Kontrollera

## Exempel:

```text
Microsoft.ACE.OLEDB.12.0
SQLNCLI11
```

SQL Native Client är deprecated.

---

# Rekommendation

Migrera helst till:

```text
MSOLEDBSQL
```

(Microsoft OLE DB Driver for SQL Server)

---

# 6. 32-bit vs 64-bit

Klassisk SSIS-fälla.

## Problem uppstår ofta med:

* Excel
* Access
* äldre ODBC/OLEDB

---

# Kontrollera

I SQL Agent-jobb:

* Use 32-bit runtime?

I Visual Studio:

* Run64BitRuntime

---

# 7. Deprecated komponenter

Vissa äldre komponenter är:

* deprecated
* borttagna
* problematiska

Exempel:

* Data Mining
* gamla Hadoop connectors
* gamla Azure Feature Pack-versioner

---

# 8. SSIS Scale Out

Om du använder Scale Out:

* måste workers uppgraderas
* certifikat kan behöva återskapas

---

# 9. SQL Agent-jobb

Kontrollera efter uppgradering:

* proxies
* credentials
* subsystem
* package paths

Vanligt att jobb “fungerar manuellt men inte via Agent”.

---

# 10. ProtectionLevel

Vanligt problem efter migrering.

Exempel:

```text
EncryptSensitiveWithUserKey
```

kan skapa problem mellan:

* servrar
* användare
* deployment pipelines

---

# Rekommendation

Ofta bättre:

```text
DontSaveSensitive
```

och använda:

* environments
* parameters
* secrets

---

# 11. CLR och custom DLL:er

Kontrollera:

* tredjepartsbibliotek
* custom tasks
* custom connectors

Gamla binärer kan:

* sakna stöd
* kräva recompilation

---

# 12. Azure-anslutningar

Gamla Azure Feature Packs:

* bör uppdateras
* kan ge auth-problem

Speciellt med:

* MFA
* modern auth
* TLS 1.2+

---

# 13. Performance

SSIS 2022 är normalt inte dramatiskt snabbare än 2019.

Men:

* nyare drivers
* bättre TLS
* nyare OLEDB
* modernare SQL connectivity

kan förbättra stabilitet.

---

# 14. Testa detta extra noga

## Vanliga problemområden

| Område              | Risk  |
| ------------------- | ----- |
| Excel-import/export | Hög   |
| Oracle-drivers      | Hög   |
| Script Tasks        | Medel |
| SQL Agent           | Hög   |
| 32-bit runtime      | Hög   |
| Custom DLL          | Hög   |
| SSISDB restore      | Medel |

---

# Min rekommenderade uppgraderingsstrategi

## Bäst praxis

### 1.

Installera SQL Server 2022 + SSIS separat.

### 2.

Installera senaste:

* Visual Studio
* SSIS Extension

### 3.

Öppna projektet och:

* ändra TargetServerVersion

### 4.

Bygg om projektet.

### 5.

Deploya till NY SSISDB.

### 6.

Testa:

* manuellt
* via SQL Agent
* alla externa connectors

---


De flesta problem vid SSIS-uppgraderingar handlar egentligen inte om SSIS självt utan om:

* drivrutiner
* 32/64-bit
* Excel
* Script Tasks
* credentials
* SQL Agent

Själva paketen fungerar ofta förvånansvärt bra mellan 2019 och 2022.


# Från 2019 till 2025

Till **SQL Server 2025** är SSIS-uppgraderingen mer känslig än 2019→2022.

Viktigast att kontrollera:

| Område                             | Att tänka på                                                                                                                                                     |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **32-bit runtime**                 | Deprecated i SQL Server 2025. SSMS 21 och SSIS Projects 2022 stöder 64-bit only framåt. Extra viktigt för Excel/Access/äldre ODBC/OLE DB. ([Microsoft Learn][1]) |
| **Legacy SSIS Service**            | Deprecated. Undvik Package Store/msdb-modellen; använd helst **SSISDB Catalog**. ([Microsoft Learn][1])                                                          |
| **Oracle/Attunity CDC**            | CDC-komponenter för Oracle by Attunity är borttagna från SQL Server 2025 SSIS. ([Microsoft Learn][1])                                                            |
| **Microsoft Connector for Oracle** | Borttagen från SQL Server 2025 SSIS. Kontrollera Oracle-flöden extra noga. ([Microsoft Learn][1])                                                                |
| **Hadoop-komponenter**             | Hadoop Hive/Pig/File System Tasks är flyttade ut/borta från SSIS 2025. ([Microsoft Learn][1])                                                                    |
| **SSISDB**                         | Efter uppgradering kan SSISDB behöva uppgraderas via **Integration Services Catalogs → SSISDB → Database Upgrade** i SSMS. ([Microsoft Learn][2])                |
| **Upgrade path**                   | SQL Server 2025 stöder uppgradering från bl.a. SQL Server 2019 och 2022. ([Microsoft Learn][3])                                                                  |

Min korta rekommendation:

**Migrera hellre än inplace-uppgradera** SSIS till 2025.

Gör så här:

1. Installera ny SQL Server 2025 med SSIS.
2. Skapa/uppgradera SSISDB.
3. Installera senaste Visual Studio/SSIS Projects-extension.
4. Ändra `TargetServerVersion` i projekten.
5. Bygg om och deploya om.
6. Testa alla paket som använder:

   * Excel/Access
   * Oracle
   * CDC
   * Hadoop
   * Script Tasks
   * 32-bit drivers
   * SQL Agent jobs

Den största praktiska risken vid 2025 är alltså inte vanliga SQL Server-flöden, utan **gamla connectors och 32-bit-beroenden**.

[1]: https://learn.microsoft.com/en-us/sql/integration-services/what-s-new-in-integration-services-in-sql-server-2025?view=sql-server-ver17&utm_source=chatgpt.com "What's New in SQL Server 2025 Integration Services"
[2]: https://learn.microsoft.com/en-us/sql/integration-services/catalog/ssis-catalog?view=sql-server-ver17&utm_source=chatgpt.com "SSIS Catalog - SQL Server Integration Services (SSIS)"
[3]: https://learn.microsoft.com/en-us/sql/database-engine/install-windows/supported-version-and-edition-upgrades-2025?view=sql-server-ver17&utm_source=chatgpt.com "Supported version and edition upgrades (SQL Server 2025)"

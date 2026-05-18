Här är en översikt över de viktigaste skillnaderna mellan **SQL Server Standard** och **SQL Server Enterprise** (gäller i huvudsak SQL Server 2019/2022).

# Kort sammanfattning

| Funktion            | Standard                 | Enterprise                       |
| ------------------- | ------------------------ | -------------------------------- |
| Målgrupp            | Mindre/medelstora system | Stora verksamhetskritiska system |
| Max CPU/RAM         | Begränsad                | Nästan obegränsad                |
| HA/DR               | Grundläggande            | Fullt stöd                       |
| Prestandafunktioner | Begränsade               | Fullt stöd                       |
| Online-operationer  | Delvis                   | Fullt stöd                       |
| Partitionering      | Begränsad nytta          | Full funktionalitet              |
| Pris                | Mycket billigare         | Betydligt dyrare                 |

---

# 1. Hårdvarubegränsningar

## SQL Server Standard

Begränsad till:

* mindre av:

  * 4 sockets
  * 24 kärnor

Max minne för Database Engine:

* ca 128 GB buffer pool
* begränsningar för vissa komponenter

---

## SQL Server Enterprise

* OS-begränsningar gäller
* hundratals kärnor möjligt
* TB-tals RAM möjligt

Enterprise skalar alltså mycket bättre.

---

# 2. Always On / High Availability

## Standard

Begränsat stöd:

* Basic Availability Groups
* endast:

  * 2 noder
  * 1 databas per AG
  * ingen read-only secondary

---

## Enterprise

Full Always On:

* flera repliker
* flera databaser
* read scale-out
* automatisk failover
* distributed AGs

Stor skillnad för kritiska system.

---

# 3. Online index operations

## Standard

Mycket begränsat:

* index rebuild offline i många fall

Det innebär blockeringar.

---

## Enterprise

Stöd för:

* ONLINE index rebuild
* ONLINE schema changes
* resumable operations

Väldigt viktigt i 24/7-system.

---

# 4. Partitionering

## Standard

Kan läsa partitionerade tabeller men saknar många optimeringar.

---

## Enterprise

Full partitionering:

* partition switching
* sliding window
* avancerad hantering

Vanligt i DW/BI-system.

---

# 5. Compression

## Standard

Numera stöd för:

* row compression
* page compression

(Tidigare Enterprise-only.)

---

## Enterprise

Fullt stöd + bättre parallellism och skalning.

---

# 6. Columnstore

## Standard

Stöd finns idag.

Men:

* mindre skalning
* färre avancerade scenarier

---

## Enterprise

Optimerat för stora datalager och analytics.

---

# 7. In-Memory OLTP

## Standard

Begränsat:

* max storlek på memory-optimized data

---

## Enterprise

Full kapacitet.

---

# 8. Resource Governor

## Standard

Ej tillgänglig.

---

## Enterprise

Ja.

Kan:

* begränsa CPU
* styra workloads
* prioritera användare/appar

Viktigt i konsoliderade miljöer.

---

# 9. Transparent Data Encryption (TDE)

## Standard

JA i moderna versioner (2019+).

Tidigare Enterprise-only.

---

## Enterprise

Fullt stöd.

---

# 10. Backup Compression

## Standard

JA.

---

## Enterprise

JA + bättre skalning.

---

# 11. Parallelism och Query Optimizer

## Standard

Mer begränsad.

---

## Enterprise

Mer avancerad parallellism:

* bättre optimizer
* intelligent query processing
* högre skalning

---

# 12. Virtualisering

## Standard

Licens per VM.

---

## Enterprise

Med Software Assurance:

* obegränsat antal SQL-VM:ar på hosten

Stor ekonomisk skillnad i VMware/Hyper-V-miljöer.

---

# 13. Security

## Standard

Bra grundsäkerhet.

---

## Enterprise

Avancerade funktioner:

* extensible key management
* avancerad auditing
* bättre integration med HSM

---

# 14. Pris

## Standard

Betydligt billigare.

Vanligt för:

* interna system
* mindre affärssystem
* utbildning
* webbapplikationer

---

## Enterprise

Mycket dyrt.

Används för:

* banker
* stora ERP-system
* hög belastning
* mission critical

---

# Typiska användningsområden

## Standard räcker ofta för:

* de flesta företagsappar
* utbildning
* webbappar
* mindre ERP
* interna system

---

## Enterprise behövs ofta för:

* 24/7-system
* mycket stora databaser
* avancerad HA
* tung BI/analytics
* stora OLTP-system

---

# De viktigaste Enterprise-funktionerna i praktiken

De som brukar avgöra:

| Funktion                 | Vanlig anledning      |
| ------------------------ | --------------------- |
| Online index rebuild     | Slippa driftstopp     |
| Full Always On           | Hög tillgänglighet    |
| Resource Governor        | Workload-kontroll     |
| Obegränsad skalning      | Mycket hög belastning |
| Avancerad partitionering | Stora tabeller        |
| VM-rättigheter           | Många SQL-VM:ar       |

---

# Min praktiska erfarenhet

Många företag köper Enterprise “för säkerhets skull” trots att:

* CPU-belastningen är låg
* databaserna är små
* inga Enterprise-funktioner används

Standard räcker långt idag.

Men:

* behöver man ONLINE maintenance
* eller avancerad Always On

…då blir Enterprise snabbt svårt att undvika.

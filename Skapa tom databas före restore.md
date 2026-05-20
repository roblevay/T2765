Ja — det finns faktiskt flera situationer där det kan vara nyttigt eller till och med rekommenderat.
Men i många normala fall är det onödigt.

Det här är ett bra exempel på en SQL Server-sak där:

> “Det beror på varför man gör restore.”

---

# Normalfallet

Vanlig restore:

```sql
RESTORE DATABASE Sales
FROM DISK = 'C:\Backup\Sales.bak';
```

kräver inte att databasen finns.

SQL Server:

* skapar databasen
* skapar MDF/LDF
* återställer metadata

automatiskt.

---

# Så varför skapa tom databas först?

Det finns flera skäl.

---

# 1. Kontrollera filplaceringar

Detta är mycket vanligt.

Om man först skapar databasen:

```sql
CREATE DATABASE Sales
ON (
    NAME = Sales,
    FILENAME = 'F:\Data\Sales.mdf'
)
LOG ON (
    NAME = Sales_log,
    FILENAME = 'G:\Log\Sales.ldf'
);
```

kan man sedan restore:a över den:

```sql
RESTORE DATABASE Sales
FROM DISK = 'C:\Backup\Sales.bak'
WITH REPLACE;
```

---

# Varför?

För att få:

✅ rätt disksystem
✅ rätt storage-layout
✅ rätt filplacering
✅ kontroll på logg/data-separation

---

# MEN…

Det finns en viktig detalj:

## Restore använder normalt backupens filmetadata

Så om man inte använder `WITH MOVE` kan SQL Server ändå försöka återställa till originalvägarna från backupen.

Därför gör man oftast hellre:

```sql
RESTORE DATABASE Sales
FROM DISK = 'C:\Backup\Sales.bak'
WITH
    MOVE 'Sales' TO 'F:\Data\Sales.mdf',
    MOVE 'Sales_log' TO 'G:\Log\Sales.ldf';
```

Det är renare.

---

# 2. Säkerställa att rätt filgrupper finns

I avancerade miljöer kan man:

* skapa storage först
* skapa filegroups
* skapa speciallayout

innan restore.

Men detta är ganska avancerat.

---

# 3. Förbereda permissions och settings

En tom databas kan användas för att:

* sätta owner
* sätta containment
* sätta FILESTREAM
* sätta collation
* skapa kataloger

innan restore.

---

# 4. För att “reservera” databasenamnet

I vissa deployment-scenarier vill man:

* skapa DB först
* konfigurera rättigheter
* sätta policies
* sedan restore:a över

---

# 5. Historiskt/workarounds

Förr gjorde vissa DBA:er detta för att:

* undvika restore-problem
* kontrollera filgrowth
* styra autogrowth
* hantera mount points

Men moderna `WITH MOVE` gör detta mindre viktigt.

---

# 6. Availability Groups / specialfall

I vissa HA-scenarier kan man:

* skapa DB först
* sedan seed:a eller restore:a

Men inte som normal restore-rutin.

---

# Viktig detalj: vad händer egentligen?

När du restore:ar med:

```sql
WITH REPLACE
```

skriver SQL Server över:

* metadata
* systemtabeller
* allocation maps
* data pages

i databasen.

Den tomma databasen försvinner i praktiken.

---

# Så den tomma databasen “används” inte direkt

Det är viktigt att förstå.

SQL Server:

> fyller inte på den tomma databasen.

Restore ersätter den nästan helt.

---

# En klassisk missuppfattning

Många tror:

> “Jag skapar databasen för att reservera storlek.”

Men restore kommer ändå använda backupens metadata och filstruktur om man inte styr med `MOVE`.

---

# När är det mest meningsfullt idag?

Främst:

## När man vill styra filplaceringar

eller:

## När backupen kommer från annan server med andra disksökvägar

---

# Exempel

Backup kommer från:

```text
D:\MSSQL\Data\
```

men nya servern har:

```text
F:\SQLData\
G:\SQLLog\
```

Då gör man nästan alltid:

```sql
RESTORE FILELISTONLY
FROM DISK = 'C:\Backup\Sales.bak';
```

och sedan:

```sql
RESTORE DATABASE Sales
FROM DISK = 'C:\Backup\Sales.bak'
WITH
    MOVE 'Sales' TO 'F:\SQLData\Sales.mdf',
    MOVE 'Sales_log' TO 'G:\SQLLog\Sales_log.ldf';
```

---

# Min praktiska rekommendation

I moderna SQL Server-miljöer:

## Skapa normalt INTE tom databas först

utan använd:

✅ `RESTORE FILELISTONLY`
✅ `WITH MOVE`
✅ rätt filplaceringar direkt

Det är renare och tydligare.

---

# Men…

Att skapa DB först är inte “fel”.

Det kan vara användbart:

* pedagogiskt
* för storagekontroll
* i avancerade deployment-scenarier
* i vissa HA-lösningar

---

# Sammanfattning

## Oftast:

Onödigt.

## Ibland:

Praktiskt för filplacering och konfiguration.

## Viktigt att förstå:

Restore ersätter nästan hela den tomma databasen ändå.

## Modern best practice:

Använd hellre:

```sql
RESTORE FILELISTONLY
```

och:

```sql
WITH MOVE
```

för att styra återställningen.

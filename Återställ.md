Först tar du reda på de logiska filnamnen i backupen:

```sql
RESTORE FILELISTONLY
FROM DISK = 'D:\Backup\MinDatabas.bak';
```

Då får du namn ungefär som:

```text
MinDatabas
MinDatabas_log
```

Sedan återställer du till rätt katalog:

```sql
RESTORE DATABASE MinDatabas
FROM DISK = 'D:\Backup\MinDatabas.bak'
WITH
    MOVE 'MinDatabas'     TO 'D:\SQLData\MinDatabas.mdf',
    MOVE 'MinDatabas_log' TO 'E:\SQLLog\MinDatabas_log.ldf',
    REPLACE,
    STATS = 5;
```

Det viktiga är:

```sql
MOVE 'logiskt_filnamn' TO 'fysisk_sökväg'
```


```sql
SELECT 
    SERVERPROPERTY('InstanceDefaultDataPath') AS DataPath,
    SERVERPROPERTY('InstanceDefaultLogPath')  AS LogPath;
```

Då kan du använda de katalogerna i `WITH MOVE`.

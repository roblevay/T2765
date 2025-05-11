@echo off
REM Skapa nödvändiga kataloger för T2765-övningarna

REM Skapa katalogen för demodatabaser
if not exist "C:\DemoDatabases\Course_DemoDatabases" (
    mkdir "C:\DemoDatabases\Course_DemoDatabases"
    echo Skapade: C:\DemoDatabases\Course_DemoDatabases
) else (
    echo Katalogen finns redan: C:\DemoDatabases\Course_DemoDatabases
)

REM Skapa katalogen för databasfiler
if not exist "C:\DbFiles\MSSQLSERVER" (
    mkdir "C:\DbFiles\MSSQLSERVER"
    echo Skapade: C:\DbFiles\MSSQLSERVER
) else (
    echo Katalogen finns redan: C:\DbFiles\MSSQLSERVER
)

REM Skapa katalogen för databasfiler på A
if not exist "C:\DbFiles\a\" (
    mkdir "C:\DbFiles\a\"
    echo Skapade: C:\DbFiles\a\
) else (
    echo Katalogen finns redan: C:\DbFiles\a\
)

REM Skapa katalogen för test
if not exist "C:\Test" (
    mkdir "C:\Test"
    echo Skapade: C:\Test
) else (
    echo Katalogen finns redan: C:\Test
)

REM Skapa katalogen för sqlbackups
if not exist "C:\sqlbackups" (
    mkdir "C:\sqlbackups"
    echo Skapade: C:\sqlbackups
) else (
    echo Katalogen finns redan: C:\sqlbackups
)


pause

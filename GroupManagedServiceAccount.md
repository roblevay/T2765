# Kort handledning – skapa ett gMSA för SQL Server

## Förutsättningar

* Active Directory
* Windows Server 2012+
* SQL-servern är medlem i domänen
* Domänadmin-rättigheter

---

# 1. Skapa KDS Root Key

Körs EN gång i domänen på en Domain Controller.

```powershell
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
```

---

# 2. Skapa gMSA-kontot

Exempel där SQL-servern heter `SQL01`.

```powershell
New-ADServiceAccount `
 -Name gmsa-sql `
 -DNSHostName sql01.contoso.local `
 -PrincipalsAllowedToRetrieveManagedPassword SQL01$
```

---

# 3. Installera gMSA på SQL-servern

Kör på SQL-servern:

```powershell
Install-ADServiceAccount gmsa-sql
```

---

# 4. Verifiera

```powershell
Test-ADServiceAccount gmsa-sql
```

Resultat:

```text
True
```

---

# 5. Använd kontot i SQL Server

Öppna:

```text
SQL Server Configuration Manager
```

Gå till:

* SQL Server Services
* Properties
* Log On

Ange konto:

```text
CONTOSO\gmsa-sql$
```

Lämna lösenord tomt.

---

# 6. Starta om tjänsten

Starta om:

* SQL Server
* SQL Server Agent

Klart 😊

---

# Viktigt

* Använd alltid **SQL Server Configuration Manager**
* Ändra inte via `services.msc`
* Glöm inte `$` i kontonamnet

---

# Rekommenderat upplägg

| Tjänst            | Konto       |
| ----------------- | ----------- |
| SQL Server Engine | gmsa-sql$   |
| SQL Server Agent  | gmsa-agent$ |

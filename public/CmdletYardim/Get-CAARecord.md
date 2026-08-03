---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-CAARecord.md
schema: 2.0.0
---

# Get-CAARecord

## SYNOPSIS
DNS CAA (Certification Authority Authorization) kaydini getirir, hangi sertifika otoritelerinin yetkili oldugunu ve raporlamanin etkin olup olmadigini kontrol eder.

## SYNTAX

```
Get-CAARecord [-Name] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Domain'in CAA DNS kaydini Cloudflare DNS over HTTPS uzerinden getirir ve domain adi, CAA durumu ile oneri bilgisini dondurur.

-Server parametresi neden yok: PowerShell'in Resolve-DnsName komutu CAA kayit tipini desteklemez. Bu nedenle fonksiyon sorguyu Cloudflare'in DNS over HTTPS resolver'i uzerinden yapar ve alternatif DNS sunucusu belirtilemez. Split DNS ortamlarinda bu ayrimi bilmekte fayda vardir.

Fonksiyon yalnizca kaydin varligina bakmaz; IODEF iletisim adresinin tanimli olup olmadigini da kontrol eder. IODEF, yetkisiz bir sertifika talebi oldugunda size bildirim gitmesini saglar.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CAARecord binsec.nl | fl *

Name        : binsec.nl
CAARecord   : CAA record found, allowed CAs: comodoca.com, digicert.com; cansignhttpexchanges=yes, issue "letsencrypt.org", issue "sectigo.com", letsencrypt.org, pki.goog; cansi
              gnhttpexchanges=yes, ssl.com, comodoca.com, digicert.com; cansignhttpexchanges=yes, letsencrypt.org, pki.goog; cansignhttpexchanges=yes, ssl.com.
CAAAdvisory : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.
```

Belirtilen domain icin DNS CAA kaydini kontrol eder.

### Example 2
```powershell
PS C:\> Get-CAARecord binsec.nl, itsecuritymatters.nl | fl *

Name        : binsec.nl
CAARecord   : CAA record found, allowed CAs: comodoca.com, digicert.com; cansignhttpexchanges=yes, issue "letsencrypt.org", issue "sectigo.com", letsencrypt.org, pki.goog; cansi
              gnhttpexchanges=yes, ssl.com, comodoca.com, digicert.com; cansignhttpexchanges=yes, letsencrypt.org, pki.goog; cansignhttpexchanges=yes, ssl.com.
CAAAdvisory : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.

Name        : itsecuritymatters.nl
CAARecord   : No CAA record found.
CAAAdvisory : No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for itsecuritymatters.nl.
```

Iki domain icin DNS CAA kaydini kontrol eder.

## PARAMETERS

### -Name
CAA kaydinin cozumlenecegi domain adini belirtir.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Zorunlu: Evet
Position: 0
Varsayilan deger: Yok
Pipeline girisi: Evet (ByPropertyName, ByValue)
Joker karakter: Hayir
```

### CommonParameters
Bu cmdlet ortak parametreleri destekler: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction ve -WarningVariable. Ayrintili bilgi icin: [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-CAARecord, PowerShell Gallery'de yayinlanan 'DomainHealthChecker' modulunun parcasidir](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)

---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-DMARCRecord.md
schema: 2.0.0
---

# Get-DMARCRecord

## SYNOPSIS
Bir domain'in DMARC kaydini getirir ve degerlendirir.

## SYNTAX

```
Get-DMARCRecord [-Name] <String[]> [[-Server] <String>] 
 [<CommonParameters>]
```

## DESCRIPTION
Get-DMARCRecord, bir veya birden fazla domain icin _dmarc TXT kaydini sorgular, DMARC politikasini ve alt alan adi politikasini (p= ve sp=) degerlendirir ve her domain icin Name, DmarcRecord, DmarcAdvisory alanlarini iceren bir nesne dondurur.

Politika seviyeleri: p=reject en guclu seviyedir (basarisiz mesajlar reddedilir), p=quarantine ara seviyedir (spam klasorune duser), p=none yalnizca raporlama yapar ve hicbir mesaji engellemez. Onerilen yaklasim kademeli gecistir: p=none ile baslayip rua raporlarini izleyin, mesru gonderici kaynaklarini duzeltin, ardindan p=quarantine ve en sonunda p=reject seviyesine cikin.

Windows'ta Resolve-DnsName, Linux/macOS'ta dig kullanir.

## EXAMPLES

### Example 1
```
PS C:\> Get-DMARCRecord -Name binsec.nl

Name      DmarcRecord                 DmarcAdvisory
----      -----------                 -------------
binsec.nl v=DMARC1; p=reject; pct=100 Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
```

Bu ornek, belirtilen domain'in DMARC kaydini cozumler.

### Example 2
```
PS C:\> Get-DMARCRecord -Name binsec.nl -Server 10.0.0.1

Name      DmarcRecord                 DmarcAdvisory
----      -----------                 -------------
binsec.nl v=DMARC1; p=none; pct=100   Domain has a valid DMARC record but the DMARC (subdomain) policy does not prevent abuse of your domain by phishers and spammers.
```

Bu ornek, DMARC kaydini 10.0.0.1 DNS sunucusu uzerinden cozumler.

## PARAMETERS

### -Name
DMARC kaydinin cozumlenecegi domain adini belirtir.

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

### -Server
Sorgularin yonlendirilecegi DNS sunucusu. Split DNS ortamlarinda kullanilir.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Zorunlu: Hayir
Position: 1
Varsayilan deger: Yok
Pipeline girisi: Hayir
Joker karakter: Hayir
```

### CommonParameters
Bu cmdlet ortak parametreleri destekler: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction ve -WarningVariable. Ayrintili bilgi icin: [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-DMARCRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker)
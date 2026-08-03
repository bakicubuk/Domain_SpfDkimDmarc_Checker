---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim//Get-BIMIecord.md
schema: 2.0.0
---

<!-- Bu dosya orijinal yardim dokumaninin Turkce cevirisidir.
     Basliklar ve yaml anahtarlari platyPS gereksinimi nedeniyle Ingilizce birakilmistir.
     Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/ -->

# Get-BimiRecord

## SYNOPSIS
Bir veya birden fazla domain icin BIMI (Brand Indicators for Message Identification) kaydini cozumler ve dogrular.

## SYNTAX

```
Get-BimiRecord [-Name] <String[]> [[-Selector] <String>] [[-Server] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-BimiRecord, domain'in BIMI TXT kaydini sorgular (istege bagli olarak belirtilen selector ile), kayit icerigini degerlendirir, DMARC politikasinin BIMI ile uyumlu olup olmadigini dogrular (p=quarantine veya p=reject ve pct=100 gerekir) ve a= etiketiyle isaret edilen VMC sertifikasini gecerli HTTPS adresi ve son kullanma tarihi acisindan inceler. Donen alanlar: Name, BimiRecord, BimiAdvisory.

DIKKAT: Kayit bulunamadiginda BimiRecord alani bos kalmaz, aciklayici bir metin yazilir. Ciktiyi programatik olarak isleyecekseniz bosluk kontrolu yerine v=BIMI1 onekini arayin.

Windows'ta Resolve-DnsName, Linux/macOS'ta dig kullanir (dnsutils paketi gerekir).

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-BIMIrecord binsec.nl | fl *

Name         : binsec.nl
BimiRecord   : We couldn't find a BIMI record associated with your domain.
BimiAdvisory : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
```

Belirtilen domain icin BIMI kaydini sorgular. Cikti uzun oldugundan Format-List (fl) ile okumak daha rahattir.

### Example 2
```powershell
PS C:\> Get-BIMIRecord binsec.nl, dmarcadvisor.com

Name             BimiRecord                                                                                                                                BimiAdvisory
----             ----------                                                                                                                                ------------
binsec.nl        We couldn't find a BIMI record associated with your domain.                                                                               DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
dmarcadvisor.com v=BIMI1; l=https://bimi.eu.dmarcmanager.app/eu-2o4fmqie/default/logo.svg; a=https://bimi.eu.dmarcmanager.app/eu-2o4fmqie/default/cert.pem DMARC policy is set to p=reject, which is the best policy for BIMI to function. 'a=' (VMC) tag contains a valid HTTPS URL.
```

Iki domain icin BIMI kaydini sorgular.

### Example 3
```powershell
PS C:\> Get-BIMIRecord bimigroup.org -server 1.1.1.1

Name          BimiRecord                                       BimiAdvisory
----          ----------                                       ------------
bimigroup.org v=BIMI1; l=https://bimigroup.org/bimi-sq.svg; a= DMARC policy is set to p=reject, which is the best policy for BIMI to function. 'a=' (VMC) tag does not contain a valid HTTPS URL, it should start with 'https://'. It's recommended to use a valid HTTPS URL for VMC to prevent that scammers misuse your logo.
```

Alternatif bir DNS sunucusu uzerinden BIMI kaydini sorgular.

## PARAMETERS

### -Name
BIMI kaydinin cozumlenecegi domain adini belirtir.

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

### -Selector
Sorgulanacak BIMI selector'unu belirtir.

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

### -Server
Sorgularin yonlendirilecegi DNS sunucusu. Split DNS ortamlarinda kullanilir.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Zorunlu: Hayir
Position: 2
Varsayilan deger: Yok
Pipeline girisi: Hayir
Joker karakter: Hayir
```

### -ProgressAction

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Zorunlu: Hayir
Konum: Adlandirilmis
Varsayilan deger: Yok
Pipeline girisi: Hayir
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

[Get-BIMIRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)
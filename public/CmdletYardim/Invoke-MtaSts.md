---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Invoke-MtaSts.md
schema: 2.0.0
---

# Invoke-MtaSts

## SYNOPSIS
Bir domain'in MTA-STS DNS kaydini ve politika dosyasini dogrular, MX sunucularinin TLS destegini raporlar.

## SYNTAX

```
Invoke-MtaSts [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-MtaSts iki parcayi birlikte kontrol eder: _mta-sts TXT DNS kaydini (bicimini, v=STSv1 surumunu ve id alanini dogrular) ve https://mta-sts.<domain>/.well-known/mta-sts.txt adresindeki politika dosyasini (surum, mod, max_age ve listelenen mx girdilerini degerlendirir).

Ardindan politika dosyasindaki MX girdilerini gercek MX DNS kayitlariyla karsilastirir ve MX sunucularinin STARTTLS destekleyip desteklemedigini test eder. Donen alanlar: Name, mtaRecord, mtaAdvisory.

Windows'ta Resolve-DnsName, Linux/macOS'ta dig kullanir.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-MtaSts microsoft.com

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

Bu ornek, belirtilen domain icin MTA-STS TXT kaydini ve gecerli MTA-STS politikasini kontrol eder.

### Example 2
```powershell
PS C:\>  Invoke-MtaSts binsec.nl, microsoft.com

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
binsec.nl                                  The MTA-STS DNS record doesn't exist.
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

Bu ornek, iki domain icin MTA-STS TXT kaydini ve politikasini kontrol eder.

### Example 3
```powershell
PS C:\> Invoke-MtaSts microsoft.com -Server 1.1.1.1

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

Bu ornek, kontrolu farkli bir DNS sunucusu uzerinden yapar. Split DNS ortamlarinda kullanilir.

## PARAMETERS

### -Name
MTA-STS kaydinin cozumlenecegi domain adini belirtir.

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

[Invoke-MtaSts, PowerShell Gallery'de yayinlanan 'DomainHealthChecker' modulunun parcasidir](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)
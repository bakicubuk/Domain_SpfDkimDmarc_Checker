---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-SPFRecord.md
schema: 2.0.0
---

# Get-SPFRecord

## SYNOPSIS
Bir veya birden fazla domain icin SPF (Sender Policy Framework) kaydini getirir ve degerlendirir.

## SYNTAX

```
Get-SPFRecord [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get-SPFRecord, domain'in v=spf1 ile baslayan SPF TXT kaydini bulur, redirect yonlendirmelerini takip eder, ic ice gecmis DNS lookup'larini sayar (RFC 7208'in 10 lookup sinirini denetler), kayit ve token uzunluklarini kontrol eder ve SPF qualifier'ini degerlendirerek uygulanabilir oneriler uretir. Donen nesnenin alanlari: Name, SPFRecord, SPFRecordLength, SPFRecordDnsLookupCount, SPFAdvisory.

DIKKAT: SPFRecordDnsLookupCount sayisal degil, "7/10 (OK)" biciminde METIN doner. Uc varyanti vardir: 8 ve alti icin (OK), 9 ve uzeri icin (Ok, but watch your DNS Lookups!), tam 10 icin (Ok, but maximum DNS Lookups reached!). Sayi 10'u astiginda da "watch" mesaji geldigi icin metindeki "Ok" ifadesine guvenmeyin; soldaki sayiyi ayristirin.

Capraz platform: Windows'ta Resolve-DnsName, Linux/macOS'ta dig kullanir. Ozel DNS cozumlemesi icin istege bagli -Server parametresini kabul eder.

## EXAMPLES

### Example 1
```
PS C:\> get-spfrecord binsec.nl

Name                    : binsec.nl
SPFRecord               : v=spf1 -all
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
SPFAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
```

Bu ornek, belirtilen domain'in SPF kaydini cozumler.

### Example 2
```
PS C:\> Get-SPFRecord -Name binsec.nl -Server 10.0.0.1

Name                    : binsec.nl
SPFRecord               : v=spf1 -all
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
SPFAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
```

Bu ornek, SPF kaydini 10.0.0.1 DNS sunucusu uzerinden cozumler.

## PARAMETERS

### -Name
SPF kaydinin cozumlenecegi domain adini belirtir.

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

[Get-SPFRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)
---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-DNSSec.md
schema: 2.0.0
---

# Get-DNSSec

## SYNOPSIS
Bir veya birden fazla domain'in DNSSEC ile imzalanip imzalanmadigini belirler.

## SYNTAX

```
Get-DNSSec [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get-DNSSec, belirtilen domain'ler icin DNSKEY kayitlarini sorgular ve RFC 4034'e gore DNSSEC yapilandirmasini (flags ve protokol alanlarini) degerlendirir. Donen alanlar: Name, DNSSEC, DnsSecAdvisory.

Neden onemli: SPF, DKIM ve DMARC kayitlarinin hepsi DNS uzerinden okunur. DNS cevabi manipule edilebiliyorsa bu kayitlarin hicbirinin guvencesi kalmaz. DNSSEC, cevabin gercekten yetkili sunucudan geldigini ve yolda degistirilmedigini garantiler.

Windows'ta Resolve-DnsName, Linux/macOS'ta dig kullanir (dnsutils paketi gerekir).

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DNSSec -Name binsec.nl
```

Bu ornek, belirtilen domain icin DNSSEC kayitlarini cozumler.

## PARAMETERS

### -Name
DNSSEC varliginin test edilecegi domain adini belirtir.

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

[DNSSEC'e giris (Cloudflare)](https://www.cloudflare.com/dns/dnssec/how-dnssec-works/)

[Get-DNSSec is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)

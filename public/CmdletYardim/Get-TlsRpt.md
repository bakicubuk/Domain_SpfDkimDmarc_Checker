---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-TlsRpt.md
schema: 2.0.0
---

# Get-TlsRpt

## SYNOPSIS
Bir veya birden fazla domain icin TLS-RPT kayitlarini getirir ve dogrular.

## SYNTAX

```
Get-TlsRpt [-Name] <String[]> [[-Server] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-TlsRpt, domain'in TLS-RPT DNS kaydini sorgular ve kaydin icerigiyle birlikte gecerli bir TLS-RPT politikasinin bulunup bulunmadigini belirten bir oneri metni dondurur. Alternatif DNS sunucusu uzerinden sorgulamayi destekler.

Neden onemli: TLS-RPT, MTA-STS'in tamamlayicisidir. Karsi taraftaki mail sunucusu size mesaj gonderirken TLS baglantisinda sorun yasarsa, bunu rua alaninda belirttiginiz adrese raporlar. MTA-STS'i enforce moduna almadan once TLS-RPT ile bir sure gozlem yapmak, teslimat kaybi yasamamak acisindan kritiktir. Kayit varsa ancak rua alani tanimli degilse modul bunu ayrica uyarir.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-TlsRpt microsoft.com

Name          TlsRptRecord                                           TlsRptAdvisory
----          ------------                                           --------------
microsoft.com v=TLSRPTv1;rua=https://tlsrpt.azurewebsites.net/report TLS-RPT Record found. The 'rua' field is configured.
```

Belirtilen domain icin TLS-RPT DNS kaydini sorgular.

### Example 2
```powershell
PS C:\> {{ command }}
```

<exlplaination>

## PARAMETERS

### -Name
TLS-RPT kayitlari cozumlenecek bir veya birden fazla domain adi girin.

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

[Get-TlsRpt is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)
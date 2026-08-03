---
external help file: DomainHealthChecker-Yardim.xml
Module Name: DomainHealthChecker
online version: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Invoke-SpfDkimDmarc.md
schema: 2.0.0
---

# Invoke-SpfDkimDmarc

## SYNOPSIS
SPF, DKIM, DMARC, MTA-STS, BIMI, DNSSEC, TLS-RPT ve CAA kayitlarini tek komutta kontrol eder.

## SYNTAX

### domain
```
Invoke-SpfDkimDmarc [-Name] <String[]> [[-DkimSelector] <String>] [[-Server] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### file
```
Invoke-SpfDkimDmarc [-File] <FileInfo> [[-DkimSelector] <String>] [[-Server] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-SpfDkimDmarc, DomainHealthChecker modulunun ana fonksiyonudur. Bir veya birden fazla domain icin tum kayit kontrollerini tek cagrida calistirir ve birlesik bir nesne dondurur.

Kayitlari tek tek kontrol etmek isterseniz Get-SPFRecord, Get-DKIMRecord, Get-DMARCRecord gibi cmdlet'leri ayri ayri kullanabilirsiniz.

TOPLU TARAMADA DIKKAT: Cmdlet her calistirildiginda PowerShell Gallery'ye karsi otomatik guncelleme kontrolu yapar. Tek domain icin sorun degildir, ancak 50 domainlik bir listede gereksiz gecikme ve dis ag trafigi anlamina gelir. Toplu taramalarda -SkipUpdateCheck kullanin.

Alias: isdd (ayrica Show-SpfDkimDmarc).

## EXAMPLES

### Example 1
```
PS C:\> Invoke-spfDkimDmarc binsec.nl

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : dkim
DkimAdvisory    : We couldn't find a DKIM record associated with your domain.
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
```

Bu ornek, tek bir domain icin tum kayit kontrollerini calistirir.

### Example 2
```
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.com -IncludeDNSSEC

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : dkim
DkimAdvisory    : We couldn't find a DKIM record associated with your domain.
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
DnsSec          : Domain is DNSSEC signed.
DnsSecAdvisory  : Great! DNSSEC is enabled on your domain.

Name                    : ing.nl
SpfRecord               : v=spf1 ip4:80.248.34.0/24 ip4:195.248.87.0/24 ip4:85.112.22.247 ip4:74.63.141.251 ip4:83.149.86.160/27 ip4:83.149.121.128/26 ip4:80.79.192.34/31 ip4:78
                          .31.119.9 ip4:91.220.136.168 ip4:46.31.52.0/23 ip4:46.19.168.0/23 ip4:192.254.112.185 ip4:91.209.197.6 ip4:91.209.197.7 ip4:62.112.237.21 ip4:62.112.23
                          7.23 ip6:2a00:1558:2801:4::2:1 ip6:2a00:1558:2801:4::3:1 include:_spf.ing.net include:_spf.ing.nl -all
SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. An SPF-record is configured and the
                           policy is sufficiently strict.
SPFRecordLength         : 404
SPFRecordDnsLookupCount : 4/10 (OK)
DmarcRecord             : v=DMARC1;p=reject;rua=mailto:ejdvezzq@ag.eu.dmarcadvisor.com
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelectorsDetected   : s1, s2, selector1, selector2
DkimSelector-1          : s1
DkimRecord-1            : k=rsa; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApnjC0Fafq6RS+zmVjT6Q9mPL1dVGdB7YKK95qSvqUUtBedJj9FRJjJAlmCWo+b9ud1zjeilSbFATquehhMJTbmBKbZV55
                          c87h9kTiYEgcgin73v6jX8BZH31V3kjhZhoihkYxw1dSd+kkpg8sRSjCCUTFpZPuBFeYS+lMb2FJA4lt6Z5jXZZRYJ/Z9E8+LIrg/sI7vNvMJ4tcOB2DWR2H2jwB1BRaL/KAzWfOU6tiXlSUXz8ySgE
                          pK73QYN5eI5LF9cXI8gGRKhgPsyAMk46D/PzChfM887V/OBENl5WXfdNLIhchx7+3fPr5m4Lp7N30qpptkUt4DWL8Q0pcZrsOQIDAQAB
DkimAdvisory-1          : DKIM-record found for selector s1.
DkimSelector-2          : s2
DkimRecord-2            : k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCw15owzRl7WtvB+FXW9/0v2Ejq6JLxCLQVkb0bAkNOdTsyjrcyO2Y9LbJY8hl+vbiyRAwcOL6mRMdp8/9pUG5igkvbgU15X5sN9
                          t2X35vw/PTzniXb2pgRwXky74NLECe69+vgK48hhfTyt1s2IlQgmszsSH/pGPo8HFF4AzXVlwIDAQAB
DkimAdvisory-2          : DKIM-record found for selector s2.
DkimSelector-3          : selector1
DkimRecord-3            : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx1X7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCpdtMaXjmYVG9
                          zvSx74HUBb223TqMve8K1qBU/sW2I3ZijuP/37HacBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;
DkimAdvisory-3          : DKIM-record found for selector selector1.
DkimSelector-4          : selector2
DkimRecord-4            : v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvDSp8D/42mawgWJauHcYFf77NZzt/lOiPITC4+dtX3YM20gVHpazEmWdcef2WkgNSLiEpVkJxqqx8K8QufV1jPxft
                          dg1uUP9lb1wIW2LdxDURdTPKcFPQIitjyxoKFzfZvo3zNVC967lAXYHwBOpUwWLFrD7SJzqCZHZUOHrlSwehxnBVFa2YEd2qLAUSJ3TG6O9jdrCicRpvyl6CL/S+lp0uRypdmnk0adAujCXKLqTmy62
                          3JguQDwyS09wjBU4M/jVIpTxvjkd4HdWv02fEMrAFLMxJH+SBkr83oXE7vUxUuqjK6hVXupecszeFOkP6B0qDv2lddsJywTuUHjqmQIDAQAB;
DkimAdvisory-4          : DKIM-record found for selector selector2.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : v=spf1 -all
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
TlsRptRecord            : v=spf1 -all
TlsRptAdvisory          : TLS-RPT Record found, but the 'rua' field is not configured. Consider adding a 'rua' field to receive reports.
```

Bu ornek, iki domain icin kontrolleri calistirir. Ikinci domain'de birden fazla DKIM kaydi vardir; modul hepsini tespit etmeye calisir.

### Example 3
```
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.com -IncludeDNSSEC -DkimSelector selector2 -server 1.1.1.1

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : selector2
DkimAdvisory    : No DKIM-record found for selector selector2._domainkey.binsec.nl
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
DnsSec          : Domain is DNSSEC signed.
DnsSecAdvisory  : Great! DNSSEC is enabled on your domain.

Name            : microsoft.com
SpfRecord       : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:spf-a.ho
                  tmail.com include:_spf1-meo.microsoft.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 184
DmarcRecord     : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPkb8bu8RGWeJGk3hJrouZXIdZ+HTp/azRp8IUOHp5wKvPUAi/54PwuLscUjRk4Rh3hjIkMpKRfJJXPxWb
                  rT7eMLric7f/S0h+qF4aqIiQqHFCDAYfMnN6V3Wbke2U5EGm0H/cAUYkaf2AtuHJ/rdY/EXaldAm00PgT9QQMez66QIDAQAB;
DkimSelector    : selector2
DkimAdvisory    : DKIM-record found.
MtaRecord       : v=STSv1; id=20190225000000Z;
MtaAdvisory     : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
DnsSec          : No DNSKEY records found.
DnsSecAdvisory  : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
```

Bu ornek, belirtilen DKIM selector'u ve 1.1.1.1 DNS sunucusu kullanilarak iki domain icin kontrolleri calistirir.

### Example 3
```
Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domains.txt -server 1.1.1.1 -DkimSelector zendesk1

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.

Name            : itsecuritymatters.nl
SpfRecord       : v=spf1 include:spf.protection.outlook.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 46
DmarcRecord     : v=DMARC1; p=reject; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.

Name            : microsoft.com
SpfRecord       : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:spf-a.ho
                  tmail.com include:_spf1-meo.microsoft.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 184
DmarcRecord     : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       : v=STSv1; id=20190225000000Z;
MtaAdvisory     : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

Bu ornek, 'domains.txt' dosyasinda listelenen domainler icin kontrolleri calistirir. Belirtilen DKIM selector'u ve 1.1.1.1 DNS sunucusu kullanilir.

NOT: Bu ornekte kullanilan -IncludeDNSSEC parametresi 2.1 surumunde kaldirilmistir; DNSSEC artik varsayilan olarak sorgulanir.

## PARAMETERS

### -DkimSelector
Ozel bir DKIM selector adi belirtir. Verilmezse yaygin selector listesi denenir.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Zorunlu: Hayir
Position: 3
Varsayilan deger: Yok
Pipeline girisi: Hayir
Joker karakter: Hayir
```

### -File
Birden fazla domain'i bir dosyadan okur. Dosyada her satirda bir domain bulunmalidir.

```yaml
Type: FileInfo
Parameter Sets: file
Aliases: Path

Zorunlu: Evet
Position: 2
Varsayilan deger: Yok
Pipeline girisi: Evet (ByPropertyName, ByValue)
Joker karakter: Hayir
```

### -Name
Kayitlarin cozumlenecegi domain adlarini belirtir.

```yaml
Type: String[]
Parameter Sets: domain
Aliases:

Zorunlu: Evet
Position: 1
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
Position: 4
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

### System.String
### System.IO.FileInfo
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Invoke-SpfDkimDmarc is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[GitHub proje sayfasi](hhttps://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/)
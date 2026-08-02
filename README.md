# DomainHealthChecker — Türkçe Doküman

`DomainHealthChecker`, DomainHealthChecker PowerShell modülü içindeki ana fonksiyondur. Bir veya birden fazla domain için SPF, DKIM, BIMI ve DMARC kayıtlarını kontrol eder. Modülü kurduktan sonra bu fonksiyonla tüm kayıtları tek seferde denetleyebilir; ya da `Get-SPFRecord`, `Get-DKIMRecord`, `Get-DNSSec`, `Get-BIMIRecord`, `Get-DMARCRecord` gibi cmdlet'lerle tek tek sorgulayabilirsiniz.

## Sistem Gereksinimleri

Windows tarafında PowerShell 5.1 veya üzeri; Linux ve macOS tarafında PowerShell Core gerekir.

## Kurulum

### PowerShell Gallery (önerilen)

Modül PowerShell Gallery üzerinde yayınlanıyor. Doğrudan şu komutla kurabilirsiniz:

```powershell
Install-Module DomainHealthChecker
```

PowerShell Gallery modülün en güncel sürümünü otomatik olarak indirir ve kurar.

### Manuel Kurulum

Modülü GitHub'daki *Releases* sekmesinden indirebilirsiniz. ZIP dosyasını indirip açtıktan sonra şu komutla import edin:

```powershell
Import-Module -Name .\DomainHealthChecker.psm1
```

Alternatif olarak depoyu klonlayıp import edebilirsiniz:

## Kullanılabilir Cmdlet'ler

Modülü kurduktan sonra aşağıdaki komutlar kullanımınıza açılır:

| Cmdlet | Alias | Açıklama |
| --- | --- | --- |
| `DomainHealthChecker` | `isdd` | Bir veya birden fazla domain için SPF, DKIM ve DMARC kayıtlarını kontrol eder. Sonuçları `Export-Csv` gibi komutlarla dosyaya aktarabilirsiniz. |
| `Get-SPFRecord` | `gspf` | Tek bir domain için SPF kaydını kontrol eder. Kaydın karakter uzunluğunu ve DNS lookup sayısını da hesaplar. |
| `Get-DKIMRecord` | `gdkim` | Tek bir domain için DKIM kaydını kontrol eder. |
| `Get-DMARCRecord` | `gdmarc` | Tek bir domain için DMARC kaydını kontrol eder. |
| `Get-DNSSec` | `gdnssec` | Domain'in DNSSEC ile korunup korunmadığını kontrol eder. |
| `Invoke-MtaSts` | `gmts` | MTA-STS kaydının varlığını ve geçerli bir MTA-STS politikasının bulunup bulunmadığını kontrol eder. |
| `Get-BIMIRecord` | `gbimi` | BIMI kaydının varlığını ve DMARC politikasının BIMI'nin gereksinimlerine uygun yapılandırılıp yapılandırılmadığını kontrol eder. |
| `Get-CAARecord` | `gcaa` | CAA kaydının varlığını kontrol eder. IODEF'in tanımlı olup olmadığını da denetler. |
| `Get-TlsRpt` | `gtlstps` | TLS-RPT'nin uygulanıp uygulanmadığını kontrol eder. |

## Split DNS Ortamları

Split DNS kullanan bir ortamdaysanız `-Server` parametresiyle alternatif bir DNS sunucusu belirtebilirsiniz.

Bu parametre `Get-CAARecord` fonksiyonunda bulunmaz. Nedeni, PowerShell'in `Resolve-DnsName` komutunun CAA kayıt tipini desteklememesidir; bu fonksiyon sorgusunu Cloudflare'in DNS over HTTPS resolver'ı üzerinden yapar.

## Kullanım Örnekleri

### Örnek 1 — Tek domain

```powershell
DomainHealthChecker bakicubuk.com
```

Belirtilen domain için SPF, DMARC, DKIM, MTA-STS, BIMI, DNSSEC, TLS-RPT ve CAA yapılandırmasını kontrol eder.

Çıktıda her kayıt için iki alan gelir: kaydın ham içeriği (`SpfRecord`, `DmarcRecord`, ...) ve o kayda dair değerlendirme (`SpfAdvisory`, `DmarcAdvisory`, ...). SPF için ayrıca `SPFRecordLength` ve `SPFRecordDnsLookupCount` alanları da bulunur.

### Örnek 2 — Birden fazla domain

```powershell
DomainHealthChecker bakicubuk.com, microsoft.com
```

Virgülle ayırarak birden fazla domain verebilirsiniz. Her domain için ayrı bir sonuç nesnesi döner.

### Örnek 3 — Özel selector ve DNS sunucusu

```powershell
DomainHealthChecker bakicubuk.com, ornek.com -DkimSelector selector1 -Server 1.1.1.1
```

DKIM sorgusunu `selector1` üzerinden, tüm DNS sorgularını ise `1.1.1.1` sunucusu üzerinden yapar.

### Örnek 4 — Dosyadan toplu tarama

```powershell
DomainHealthChecker -File $env:USERPROFILE\Desktop\domains.txt -Server 1.1.1.1
```

`domains.txt` dosyasının içeriğini okur ve listedeki her domain için tüm kontrolleri sırayla çalıştırır.

`domains.txt` dosyasının içeriği şu şekilde olmalıdır — her satırda bir domain:

```
bakicubuk.com
ornek.com
test.com
```

## Çıktı Alanlarını Yorumlarken

Modülün ürettiği bazı alanlar ilk bakışta yanıltıcı olabilir:

**`SPFRecordDnsLookupCount`** sayısal bir değer değil, metindir. `0/10 (OK)` biçiminde gelir; soldaki sayı gerçek lookup sayısı, sağdaki 10 ise RFC 7208 sınırıdır. Sayı 9'a ulaştığında `(Ok, but watch your DNS Lookups!)`, tam 10 olduğunda `(Ok, but maximum DNS Lookups reached!)` uyarısı eklenir.

**Kayıt bulunamadığında alanlar boş kalmaz.** Modül açıklayıcı bir metin döndürür — örneğin `No DKIM-record found.` ya da `We couldn't find a BIMI record associated with your domain.` Bu çıktıyı programatik olarak işleyecekseniz boşluk kontrolü yerine geçerli kayıt önekini (`v=STSv1`, `v=TLSRPTv1`, `v=BIMI1`) aramanız gerekir.

**Birden fazla DKIM selector bulunduğunda** çıktı yapısı değişir: düz `DkimRecord` alanı yerine `DkimSelectorsDetected` alanı dolar ve her selector için `DkimSelector-1`, `DkimRecord-1`, `DkimAdvisory-1` şeklinde numaralı alanlar üretilir.

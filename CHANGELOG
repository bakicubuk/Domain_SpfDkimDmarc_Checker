# DEĞİŞİKLİK GÜNLÜĞÜ

> Bu dosya, DomainHealthChecker modülünün orijinal `CHANGELOG` dosyasının Türkçe çevirisidir.
> Yalnızca okuma amaçlıdır. Güncel ve resmi sürüm notları için depo kökündeki `CHANGELOG`
> dosyasına ya da <Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/CHANGELOG> adresine bakın.
>
> **Not:** Orijinal dosya depo sahibi tarafından yönetilmektedir, ona commit atılmamalıdır.

Biçim [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) standardını temel alır.

---

## [2.2] — 29.07.2026

**Eklenenler**
- TLS-RPT DNS kaydını kontrol eden `Get-TlsRpt` fonksiyonu eklendi (#55)
- DNS CAA kaydını kontrol eden `Get-CAARecord` fonksiyonu eklendi (#61)

**Güncellenenler**
- `Get-DKIMRecord` fonksiyonu, birden fazla selector'ü aynı anda kontrol edebilecek şekilde güncellendi (#57)

**Düzeltilenler**
- `Get-DKIMRecord` içinde CNAME üzerinden gelen DKIM kaydının Windows'ta kırpılması sorunu giderildi

**Değişenler**
- `Get-DKIMRecord` fonksiyonundaki varsayılan `DkimSelectors` listesi genişletildi
- README ve yardım dokümanları güncellendi

## [2.1] — 28.01.2026

**Eklenenler**
- Modül çağrılırken PowerShell Gallery'ye karşı yapılan güncelleme kontrolünü atlamak için `-SkipUpdateCheck` parametresi eklendi
- `Get-BIMIRecord` kontrolü eklendi; bir veya birden fazla domain için BIMI (Brand Indicators for Message Identification) kayıtlarını çözümler ve doğrular

**Değişenler**
- `Update-ModuleVersion` fonksiyonunun adı, işlevini daha iyi yansıtması için `Update-DomainHealthChecker` olarak değiştirildi
- README ve yardım dokümanları güncellendi

**Kaldırılanlar**
- `-IncludeDNSSEC` parametresi kaldırıldı; DNSSEC artık varsayılan olarak sorgulanıyor

## [2.0] — 07.01.2026

**Eklenenler**
- PowerShell Core ile macOS ve Linux için çapraz platform desteği eklendi (#39)
- İşletim sistemi tespiti için `Get-OsPlatform.ps1` eklendi
- `dig` DNS aracının kurulu olup olmadığını kontrol eden `Test-DnsUtilsInstalled.ps1` eklendi
- Otomatik sürüm güncellemesi için `Update-ModuleDomainHealthChecker.ps1` eklendi

**Değişenler**
- README ve yardım dokümanları güncellendi

## [1.8.0] — 28.05.2025

**Eklenenler**
- SPF DNS lookup sayısı kontrolü eklendi (#16)

**Düzeltilenler**
- Boşluk içeren dosya yollarının desteklenmemesi sorunu giderildi (#50)

## [1.7.1] — 18.12.2024

**Düzeltilenler**
- SPF kaydı bulunmadığında oluşan hata giderildi (#48)

## [1.7] — 09.11.2024

**Eklenenler**
- Yeni `Get-MTASTS` fonksiyonu (#41)
- `-Name` parametresi için birden fazla değer desteği (#43)

**Güncellenenler**
- Varsayılan DKIM selector listesi

**Düzeltilenler**
- `Invoke-SpfDkimDmarc` içinde `DkimSelector` parametresinin çalışmaması (#37)
- SPF uzunluk hesabındaki yazım hatası (#38, #42)
- SPF kontrolünün hatalı sonuç vermesi (#44)
- SPF uzunluk hesabı (#45)

**Değişenler**
- README ve yardım dokümanları güncellendi (#40)

## [1.6] — 25.04.2023

**Eklenenler**
- DNSKEY kayıtları bulunabiliyorsa `-IncludeDNSSEC` parametresi eklendi (#27 talebi üzerine)
- SPF kaydının 255 karakteri aşıp aşmadığını denetleyen kontrol eklendi (#33)

**Düzeltilenler**
- Özel `DkimSelector` ve `Server` parametrelerine ilişkin düzeltmeler (#30)
- 255 karakteri aşan SPF kayıtlarında `Get-SPFRecord.ps1` hatası (#31)
- `Invoke-SpfDkimDmarc` fonksiyonunun `-Server` parametresini kullanmaması (#32)

## [1.5.2] — 30.02.2022

**Düzeltilenler**
- Kaynak olarak dosya kullanıldığında son satırın iki kez işlenmesi (#24)
- `Get-DMARCRecord` fonksiyonunun hatalı sonuç döndürebilmesi (#19)

## [1.5.1] — 30.05.2022

**Düzeltilenler**
- DKIM CNAME düzeltmesi (#20)

## [1.5] — 13.08.2021

**Eklenenler**
- SPF artık `redirect` yönlendirmelerini takip ediyor
- Yeni dışa aktarılan fonksiyonlar: `Get-SPFRecord`, `Get-DKIMRecord`, `Get-DMARCRecord`
- Alias tanımları eklendi: `gspf`, `gdkim`, `gdmarc`

**Değişenler**
- Her fonksiyon kendi PowerShell script dosyasına taşındı

**Kaldırılanlar**
- `Show-SpfDkimDmarc` cmdlet'i kaldırıldı; yerine `Invoke-SpfDkimDmarc` kullanılmalı

## [1.4.2] — 13.07.2021

**Eklenenler**
- Varsayılan DKIM kontrolüne daha yaygın kullanılan selector'ler eklendi

**Kaldırılanlar**
- Koda gömülü sabit DNS sunucusu kaldırıldı; artık elle belirtilmesi gerekiyor

## [1.4.1] — 07.07.2021

**Düzeltilenler**
- Boş SPF kaydında oluşan hata mesajı

## [1.4] — 06.07.2021

**Eklenenler**
- PowerShell 5.1 desteği
- Özel DKIM selector'leri için `DkimSelector` parametresi
- Script'e manifest dosyası eklendi

**Değişenler**
- Çok sayıda `if/elseif` bloğu `switch` yapısıyla değiştirildi
- Script, uygun fiil/isim yapısına sahip (`Invoke-SpfDkimDmarc`) bir modüle dönüştürüldü

**Düzeltilenler**
- SPF içindeki çalışmayan `if/elseif` bloğu

## [1.3.1] — 03.07.2021

**Düzeltilenler**
- Konsol çıktısı hatası

## [1.3] — 02.07.2021

**Eklenenler**
- `nslookup` kullanımı `Resolve-DnsName` ile değiştirildi

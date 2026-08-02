
# 'DomainHealthChecker' modulu icin manifest dosyasi
#
# Olusturan  : Baki CUBUK
#
# Olusturulma: 29.07.2026
#

@{

# Bu manifest ile iliskili script modulu ya da binary modul dosyasi.
RootModule = 'DomainHealthChecker.psm1'

# Modulun surum numarasi.
ModuleVersion = '2.2.0'

# Desteklenen PowerShell surumleri (Desktop = Windows PowerShell 5.1, Core = PowerShell 7.x)
CompatiblePSEditions = @('Desktop','Core', 'Windows', 'Linux', 'macOS')

# Modulu benzersiz sekilde tanimlayan kimlik (GUID)
GUID = '9f882a16-ebe1-4e3d-8573-7e014c129d1f'

# Modulun yazari
Author = 'Baki CUBUK'

# Sirket ya da uretici bilgisi
CompanyName = ''

# Modulun telif hakki bildirimi
Copyright = '(c) Baki CUBUK. All rights reserved.'

# Modulun sundugu islevlerin aciklamasi
Description = 'PowerShell module for checking SPF, DKIM, DMARC, BIMI, MTA-STS, TLS-RPT and CAA records for one or multiple domains. This module supports Windows, Linux, and macOS platforms with PowerShell Core.'

# Bu modulun ihtiyac duydugu en dusuk Windows PowerShell surumu
PowerShellVersion = '5.1'

# Bu modulun calismasi icin gereken PowerShell host adi
# PowerShellHostName = ''

# Bu modulun calismasi icin gereken en dusuk PowerShell host surumu
# PowerShellHostVersion = ''

# Gereken en dusuk Microsoft .NET Framework surumu. Bu onkosul yalnizca PowerShell Desktop surumu icin gecerlidir.
# DotNetFrameworkVersion = ''

# Gereken en dusuk ortak dil calisma zamani (CLR) surumu. Bu onkosul yalnizca PowerShell Desktop surumu icin gecerlidir.
# CLRVersion = ''

# Bu modulun ihtiyac duydugu islemci mimarisi (None, X86, Amd64)
# ProcessorArchitecture = ''

# Bu modul import edilmeden once genel ortama yuklenmesi gereken moduller
# RequiredModules = @()

# Bu modul import edilmeden once yuklenmesi gereken assembly dosyalari
# RequiredAssemblies = @()

# Modul import edilmeden once cagiran ortamda calistirilacak script (.ps1) dosyalari
# ScriptsToProcess = @()

# Modul import edilirken yuklenecek tip tanim (.ps1xml) dosyalari
# TypesToProcess = @()

# Modul import edilirken yuklenecek bicimlendirme (.ps1xml) dosyalari
# FormatsToProcess = @()

# RootModule icinde belirtilen modulun ic modulu (nested module) olarak import edilecek moduller
# NestedModules = @()

# Modulun disa aktardigi fonksiyonlar. En iyi performans icin joker karakter kullanmayin ve
# satiri silmeyin; disa aktarilacak fonksiyon yoksa bos dizi birakin.
FunctionsToExport = 'Invoke-SpfDkimDmarc', 'Get-SPFRecord', 'Get-DKIMRecord', 
               'Get-DMARCRecord', 'Get-DNSSEC', 'Invoke-MtaSts', 'Get-BimiRecord','Get-TlsRpt', 'Get-CAARecord', 'Update-ModuleDomainHealthChecker'

# Modulun disa aktardigi cmdlet'ler. En iyi performans icin joker karakter kullanmayin ve
# satiri silmeyin; disa aktarilacak cmdlet yoksa bos dizi birakin.
CmdletsToExport = '*'

# Modulun disa aktardigi degiskenler
VariablesToExport = '*'

# Modulun disa aktardigi alias'lar. En iyi performans icin joker karakter kullanmayin ve
# satiri silmeyin; disa aktarilacak alias yoksa bos dizi birakin.
AliasesToExport = 'isdd', 'isdd', 'gspf', 'gdkim', 'gdmarc', 'gdnssec', 'gmts', 'gbimi','gtlstps', 'gcaa'

# Modulun disa aktardigi DSC kaynaklari
# DscResourcesToExport = @()

# Bu modulle birlikte paketlenen tum moduller
# ModuleList = @()

# Bu modulle birlikte paketlenen tum dosyalar
# DIKKAT: Burada listelenen dosyalar depoda yoksa Test-ModuleManifest hata verir.
FileList = 'CHANGELOG', 'DomainHealthChecker.psd1', 'DomainHealthChecker.psm1', 
               'LICENSE', 'README.md'

# RootModule icinde belirtilen module aktarilacak ozel veriler. Ayrica modul hakkinda ek
# bilgi tasiyan bir PSData hashtable'i da icerebilir.
PrivateData = @{

    PSData = @{

        # Modul icin tanimlanan etiketler. Cevrimici galerilerde bulunabilirligi artirir.
        Tags = 'Email','Emailsecurity','Security','SPF','DKIM','DMARC','DNSSEC','MTA-STS','TLS-RPT','BIMI','CAA','DomainHealth','DomainHealthChecker'

        # Modulun lisansina ait adres
        LicenseUri = 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/LICENSE'

        # Projenin ana web adresi
        ProjectUri = 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/'

        # Modulu temsil eden ikonun adresi
        IconUri = 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/main/logo/Invoke-SpfDkimDmarc.png'

        # Modulun surum notlari
        ReleaseNotes = 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/CHANGELOG'

        # Modulun on surum (prerelease) etiketi
        # Prerelease = ''

        # Kurulum veya guncelleme icin kullanicinin lisansi acikca kabul etmesi gerekip gerekmedigi
        # RequireLicenseAcceptance = $false

        # Bu modulun bagimli oldugu harici moduller
        # ExternalModuleDependencies = @()

    } # PSData hashtable sonu

 } # PrivateData hashtable sonu

# Modulun yardim bilgilerine ait adres
HelpInfoURI = 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletHelp/Invoke-SpfDkimDmarc.md'

# Modulden disa aktarilan komutlar icin varsayilan onek. Import-Module -Prefix ile degistirilebilir.
# DefaultCommandPrefix = ''

}


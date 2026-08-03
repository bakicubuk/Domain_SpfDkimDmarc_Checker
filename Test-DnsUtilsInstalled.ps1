# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#
.SYNOPSIS
Linux sisteminde DNS araclarinin (dig) kurulu olup olmadigini kontrol eder.

.DESCRIPTION
'dnsutils' paketi, DNS sorgulari icin gerekli olan 'dig' komut satiri aracini saglar.
Bu fonksiyon 'dig' komutunun sistemde bulunup bulunmadigini kontrol eder ve eksikse
kullaniciya 'dnsutils' paketini kurmayi onerir.

.EXAMPLE
PS /home/user> Test-DnsUtilsInstalled
[-] dnsutils is NOT installed
[?] The 'dnsutils' package is required for DNS lookups. Do you want to install it now? (y/N): Y
[*] Updating package list...
[*] Installing dnsutils...
[+] Installation complete.
[+] Installation finished.
#>

# Private (ic kullanim) fonksiyonlari yukle
Import-Module $PSScriptRoot\Get-OsPlatform.ps1 -Force -DisableNameChecking

function Test-DnsUtilsInstalled {
    [cmdletbinding()]
    param()

    begin {

        try {
            $OsPlatform = (Get-OsPlatform).Platform
        }
        catch {
            Write-Verbose "Failed to determine OS platform, defaulting to Windows"
            $OsPlatform = "Windows"
        }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"

    } Process {

        if ($OsPlatform -eq "Linux") {
            Write-Verbose "Checking if 'dnsutils' package is installed."
            if (dpkg -l dnsutils 2>$null) {
                Write-verbose "dnsutils is installed"
            }
            else {
                Write-Host "[!] Bu modulu Linux uzerinde kullanmak icin, 'dig' komutunu saglayan 'dnsutils' paketi kurulu olmalidir."
                Write-Verbose "[*] Checking if 'dnsutils' package is installed."
                Write-Host "[-] dnsutils kurulu DEGIL"
                Write-verbose "'dnsutils' package is not installed."
                Write-Verbose "Prompting user to install 'dnsutils' package."
                $answer = Read-Host "[?] The 'dnsutils' package is required for DNS lookups. Do you want to install it now? (y/N)"

                switch ($answer) {
                    { $_.ToLower() -eq 'y' } {
                        Write-Verbose "User chose to install 'dnsutils'."
                        Write-Host "[*] Paket listesi guncelleniyor..."
                        sudo apt update

                        Write-Host "[*] dnsutils kuruluyor..."
                        sudo apt install -y dnsutils

                        Write-Host "[+] Kurulum tamamlandi."
                        if (dpkg -l dnsutils 2>$null) {
                            Write-Host "[+] Kurulum bitti."
                        }
                        else {
                            Write-Host "[-] dnsutils kurulu DEGIL. Script'i tekrar calistirin ya da 'sudo apt install dnsutils' ile elle kurun."
                            return
                        }
                    }
                    { $_.ToLower() -eq 'n' } {
                        Write-Verbose "User chose not to install 'dnsutils'."
                        Write-Host "[*] Kurulum kullanici tarafindan iptal edildi."
                        return
                    }
                    Default {
                        Write-Verbose "No valid input from user. Assuming 'No'."
                        Write-Host "[*] Kurulum kullanici tarafindan iptal edildi."
                        return
                    }
                }
            }
        }
        elseif ($OsPlatform -eq "macOS") {
            # macOS'ta 'dig' varsayilan olarak gelse de, komutun gercekten kullanilabilir
            # oldugundan emin olmak icin yine de kontrol ediyoruz.
            Write-Verbose "Checking if the 'dig' command is available."
            if (Get-Command dig -ErrorAction SilentlyContinue) {
                Write-Verbose "dig is installed."
            }
            else {
                Write-Host "[!] Bu modulu macOS uzerinde kullanmak icin, 'dig' komutunu saglayan 'bind' paketi kurulu olmalidir."
                Write-Verbose "[-] dig kurulu DEGIL"
                Write-Host "[-] dig kurulu DEGIL"
                Write-Verbose "Prompting user to install 'bind' package using 'Homebrew."
                $answer = Read-Host "[?] The 'bind' package is required for DNS lookups. Do you want to install it now using Homebrew? (y/N)"

                switch ($answer) {
                    { $_.ToLower() -eq 'y' } {
                        Write-Verbose "User chose to install 'bind' package."
                        
                        # Homebrew kurulu mu kontrol et
                        Write-Verbose "Checking if Homebrew is installed."
                        if (-not (Get-Command brew -ErrorAction SilentlyContinue)) {
                            Write-Verbose "Homebrew is NOT installed."
                            Write-Host "[-] Homebrew kurulu degil. Once Homebrew'i kurun ya da 'bind' paketini elle kurun. Cikiliyor..."
                            return
                        }
                        else {

                            # dig'i kur (BIND paketinin parcasidir)
                            Write-Verbose "Homebrew is installed. Proceeding to install 'bind' package."
                            brew install bind
                            Write-Verbose "dig has been installed."
                            if (Get-Command dig -ErrorAction SilentlyContinue) {
                                Write-Verbose "dig is installed successfully."
                            }
                            else {
                                Write-Host "[-] dig kurulu DEGIL. Script'i tekrar calistirin ya da 'brew install bind' ile elle kurun."
                                return
                            }
                        }
                    }
                    { $_.ToLower() -eq 'n' } {
                        Write-Verbose "User chose not to install 'bind'."
                        Write-Host "[*] Kurulum kullanici tarafindan iptal edildi."
                        return
                    }
                    Default {
                        Write-Verbose "User chose not to install 'bind' package."
                        Write-Host "[*] Kurulum kullanici tarafindan iptal edildi."
                        return
                    }
                }
            }
        } 
    } End {
        Write-Verbose "Finished $($MyInvocation.MyCommand)"
    }
} 

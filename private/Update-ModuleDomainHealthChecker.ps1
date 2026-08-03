# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#
.SYNOPSIS
Kurulu DomainHealthChecker modulunun surumunu kontrol eder ve daha yeni bir surum varsa gunceller.

.DESCRIPTION
Bu fonksiyon, PowerShell Gallery uzerinde DomainHealthChecker modulunun daha yeni
bir surumu olup olmadigini kontrol eder.
.EXAMPLE
Update-ModuleDomainHealthChecker
#>

function Update-ModuleDomainHealthChecker {
    [CmdletBinding()]
    param()

    begin {
        # Kurulu DomainHealthChecker modulunun mevcut surumunu kontrol et
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        try {
            Write-Verbose "Checking the current installed module version..."
            $CurrentInstalledModuleVersion = (Get-Module -Name DomainHealthChecker).Version.ToString()
            $CurrentVersionOnPowerShellGallery = (Find-Module -Name DomainHealthChecker).Version.ToString()
            Write-Verbose "Current installed version: $CurrentInstalledModuleVersion"
            Write-Verbose "Latest version on PowerShell Gallery: $CurrentVersionOnPowerShellGallery"
        }
        catch {
            Write-Verbose "Error occurred while checking module version: $_"
            Write-Error "[-] Failed to check the module version. Ensure you have an active internet connection and access to the PowerShell Gallery."
        }

    } process {
        if ($CurrentInstalledModuleVersion -lt $CurrentVersionOnPowerShellGallery) {
            Write-Host "[*] DomainHealthChecker modulunun daha yeni bir surumu mevcut. Kurulu surumunuz $CurrentInstalledModuleVersion, en son surum olan $CurrentVersionOnPowerShellGallery surumune guncellemenizi oneririz." -ForegroundColor Yellow
            
            # Modulu guncellemek icin kullanicidan onay iste
            Write-Verbose "Prompting user for module update confirmation."

            $answer = Read-Host "[?] Do you want to update the DomainHealthChecker module now? (y/N)"
            switch ($answer) {
                { $_.ToLower() -eq 'y' } {
                    Write-Verbose "User chose to update 'DomainHealthChecker'."
                    Write-Host "[+] DomainHealthChecker modulu guncelleniyor..."
                    try {
                        Update-Module -Name DomainHealthChecker -Force -ErrorAction Stop
                        Write-Host "[+] Modul $CurrentVersionOnPowerShellGallery surumune basariyla guncellendi." -ForegroundColor Green
                    }
                    catch {
                        Write-Verbose "Error occurred during module update: $_. Trying alternative update method."
                        Install-Module -Name DomainHealthChecker -Force -AllowClobber -ErrorAction Stop
                        
                    } finally {
                        Write-Verbose "Error occurred while updating module: $_"
                        Write-Error "[-] Failed to update the DomainHealthChecker module. Please try updating it manually."
                    }
                }
                { $_.ToLower() -eq 'n' } {
                    Write-Verbose "User chose not to update 'DomainHealthChecker'."
                    Write-Host "[*] Modul guncellemesi atlandi. Daha sonra Update-ModuleDomainHealthChecker komutuyla guncelleyebilirsiniz." -ForegroundColor Yellow
                }
                Default {
                    Write-Verbose "User input not recognized, assuming 'No'."
                    Write-Host "[*] Modul guncellemesi atlandi. Daha sonra 'Update-Module -Name DomainHealthChecker -Force' komutuyla guncelleyebilirsiniz."
                }
            }
        }
    } end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}


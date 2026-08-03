# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#
.SYNOPSIS
Calisilan isletim sistemi platformunu tespit eder (macOS, Windows veya Linux).

.DESCRIPTION
Bu fonksiyon, script'in uzerinde calistigi isletim sistemini belirler ve macOS,
Windows ya da Linux oldugunu dondurur. DomainHealthChecker modulunun capraz
platform destegi icin kullanilir.

.EXAMPLE
Get-OsPlatform
#>

function Get-OsPlatform {
    [cmdletbinding()]
    param()

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $osPlatformObject = New-Object System.Collections.Generic.List[System.Object]
    }

    Process {
        # PowerShell 5.1 mi yoksa PowerShell 7 mi kullaniliyor kontrol et
        if ($PSVersionTable.PSVersion.Major -eq 5 -and $PSVersionTable.PSVersion.Minor -eq 1) {
            # PowerShell 5.1 yalnizca Windows uzerinde desteklenir
            Write-Verbose "PowerShell 5.1 detected."
            Write-Verbose "Platform is Windows."
            $OsPlatform = "Windows"
        }
        elseif ($PSVersionTable.PSVersion.Major -ge 7) {
            Write-Verbose "PowerShell 7 or later is detected."
            # PowerShell 7 ve sonrasi
            if ($IsWindows) {
                Write-Verbose "Platform is Windows"
                $OsPlatform = "Windows"
            }
            elseif ($IsmacOS) {
                Write-Verbose "Platform is macOS"
                $OsPlatform = "macOS"
            }
            elseif ($IsLinux) {
                Write-Verbose "Platform is Linux"
                $OsPlatform = "Linux"
            }
            else {
                Write-Verbose "Unknown platform. Fallback to Windows"
                $OsPlatform = "Windows"
            }
        }

    } End {
        $OsPlatformReturnValues = New-Object psobject
        $OsPlatformReturnValues | Add-Member NoteProperty "Platform" $OsPlatform
        $osPlatformObject.Add($OsPlatformReturnValues)
        $OsPlatformReturnValues
    }
}
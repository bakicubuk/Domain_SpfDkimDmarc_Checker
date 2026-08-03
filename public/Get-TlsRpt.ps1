# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

# Private (ic kullanim) fonksiyonlari yukle
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-TlsRpt {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "TLS-RPT kayitlari cozumlenecek bir veya birden fazla domain adi girin.")]
        [string[]]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "Sorgularin yonlendirilecegi DNS sunucusu.")]
        [string]$Server
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        # Isletim sistemi platformunu belirle
        try {
            Write-Verbose "Determining OS platform"
            $OsPlatform = (Get-OsPlatform).Platform
        }
        catch {
            Write-Verbose "Failed to determine OS platform, defaulting to Windows"
            $OsPlatform = "Windows"
        }

        # Linux veya macOS: dnsutils paketinin kurulu olup olmadigini kontrol et
        if ($OsPlatform -eq "Linux" -or $OsPlatform -eq "macOS") {
            Test-DnsUtilsInstalled
        }
        
        if ($PSBoundParameters.ContainsKey('Server')) {
            $SplatParameters = @{
                'Server'      = $Server
                'ErrorAction' = 'SilentlyContinue'
            }
        }
        Else {
            $SplatParameters = @{
                'ErrorAction' = 'SilentlyContinue'
            }
        }

        $TlsRptObject = New-Object System.Collections.Generic.List[System.Object]
    }
    Process {

        foreach ($domain in $Name) {

            # Bir onceki dongudan kalan degerlerin degiskenlerde kalmadigindan emin ol
            $TlsRptRecord = $null
            $TlsRptAdvisory = $null

            Write-Verbose "Processing TLSRPT record for domain: $domain"
            if ($OsPlatform -eq "Windows") {
                $TlsRptRecord = Resolve-DnsName -Type TXT -Name "_smtp._tls.$domain" @SplatParameters | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                Write-Verbose "TLSRPT record for domain $($domain): $TlsRptRecord"
            }
            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                $TlsRptRecord = $(dig TXT "_smtp._tls.$domain" +short | Out-String).Trim()
                Write-Verbose "TLSRPT record for domain $($domain): $TlsRptRecord"
            }
            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                $TlsRptRecord = $(dig TXT "_smtp._tls.$domain" +short $PSBoundParameters.Server | Out-String).Trim()
                Write-Verbose "TLSRPT record for domain $($domain) using server $($PSBoundParameters.Server): $TlsRptRecord"
            }

            if ($null -eq $TlsRptRecord -or $TlsRptRecord -eq "") {
                Write-Verbose "No TLS-RPT Record found for domain $($domain)"
                $TlsRptRecord = "No TLS-RPT Record found."
                $TlsRptAdvisory = "No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports."
            }
            else {
                $ruaMatch = [regex]::Match($tlsRptRecord, 'rua=([^;]+)')
                if ($ruaMatch.Success) {
                    $TlsRptAdvisory = "TLS-RPT Record found. The 'rua' field is configured."
                }
                else {
                    $TlsRptAdvisory = "TLS-RPT Record found, but the 'rua' field is not configured. Consider adding a 'rua' field to receive reports."
                }
            }

            $TlsRptReturnValues = New-Object psobject
            $TlsRptReturnValues | Add-Member NoteProperty "Name" $domain
            $TlsRptReturnValues | Add-Member NoteProperty "TlsRptRecord" $TlsRptRecord
            $TlsRptReturnValues | Add-Member NoteProperty "TlsRptAdvisory" $TlsRptAdvisory
            $TlsRptObject.Add($TlsRptReturnValues)
            $TlsRptReturnValues
        }

    } End {}

}
Set-Alias gtlstps -Value Get-TlsRpt
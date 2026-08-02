<#
HelpInfoURI 'Https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker'
#>

# Public (disa acik) fonksiyonlari yukle
# DIKKAT: Test-Path kontrolu nedeniyle 'public' klasoru yoksa hicbir hata
# uretilmez, fonksiyonlar sessizce yuklenmez. Import sonrasi Get-Command ile
# 10 fonksiyonun geldigini mutlaka dogrulayin.
$PublicFolder = Join-Path -Path $PSScriptRoot -ChildPath 'public'
if (Test-Path -Path $PublicFolder) {
    Get-ChildItem -Path $PublicFolder -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }
}

# Private (ic kullanim) fonksiyonlari yukle
$PrivateFolder = Join-Path -Path $PSScriptRoot -ChildPath 'private'
if (Test-Path -Path $PrivateFolder) {
    Get-ChildItem -Path $PrivateFolder -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }
}

function Invoke-SpfDkimDmarc {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory, ParameterSetName = 'domain',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "SPF, DKIM ve DMARC kaydinin sorgulanacagi domain adini belirtir.",
            Position = 1)]
        [string[]]$Name,

        [Parameter(
            Mandatory, ParameterSetName = 'file',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Bir dosyadaki birden fazla domain icin SPF, DKIM ve DMARC kayitlarini gosterir.",
            Position = 2)]
        [Alias('Path')]
        [System.IO.FileInfo]$File,

        [Parameter(Mandatory = $False,
            HelpMessage = "Ozel bir DKIM selector adi belirtir.",
            Position = 3)]
        [string]$DkimSelector,

        [Parameter(Mandatory = $false,
            HelpMessage = "Sorgularin yonlendirilecegi DNS sunucusu.",
            Position = 4)]
        [string]$Server,

        [Parameter(Mandatory = $false,
            HelpMessage = "Modul guncelleme kontrolunu atlar.",
            Position = 5)]
        [switch]$SkipUpdateCheck
    )

    begin {

        # Modul icin guncelleme olup olmadigini kontrol et
        # NOT: Toplu taramalarda -SkipUpdateCheck ile bu adim atlanmalidir,
        # aksi halde her domain icin PowerShell Gallery'ye istek gider.
        if (!$SkipUpdateCheck) {
            try {
                Update-ModuleDomainHealthChecker -Verbose:$False
            }
            catch {
                Write-Verbose "No update check could be performed: $_"
            }
        }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $InvokeObject = New-Object System.Collections.Generic.List[System.Object]        
    } process {

        $Splat = @{}
        $DKIMSplat = @{}

        switch -Regex ($True) { 
            { $Server -and !$DkimSelector } {
                $Splat += @{ 
                    'Server' = $Server
                } 
            } 
            { $DkimSelector -and !$Server } {
                $DKIMSplat += @{
                    'DkimSelector' = $DkimSelector
                } 
            } 
            { $DkimSelector -and $Server } { 
                $DKIMSplat += @{
                    'DkimSelector' = $DkimSelector
                }
                $Splat += @{ 
                    'Server' = $Server
                }
            }
        }

        # 'File' parametresi kullanildiginda: dosyadaki her satiri domain olarak isle
        if ($PSBoundParameters.ContainsKey('File')) {
            Write-Progress -Activity "Querying SPF, DKIM, DMARC, MTA-STS, BIMI, DNSSEC and TLS-RPT records" -Status "Processing domains..." -PercentComplete 0
            foreach ($Name in (Get-Content -Path $File)) {
                $SPF = Get-SPFRecord -Name $Name @Splat
                $DKIM = Get-DKIMRecord -Name $Name @Splat @DKIMSplat
                $DMARC = Get-DMARCRecord -Name $Name @Splat
                $MTASTS = Invoke-MtaSTS -Name $Name @Splat
                $BIMI = Get-BimiRecord -Name $Name @Splat
                $DNSSEC = Get-DNSSec -Name $Name @Splat
                $TlsRPT = Get-TlsRpt -Name $Name @Splat
                # Get-CAARecord, Resolve-DnsName CAA tipini desteklemedigi icin
                # Cloudflare DNS over HTTPS kullanir; bu nedenle -Server parametresi almaz.
                $CAA = Get-CAARecord -Name $Name

                $InvokeReturnValues = New-Object psobject
                $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
                $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
                $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" $SPF.SPFRecordDnsLookupCount  # "7/10 (OK)" gibi METIN doner, sayi degil
                $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
                $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory

                if ($DKIM.DkimSelectorsDetected -is [string] -and -not [string]::IsNullOrEmpty($DKIM.DkimSelectorsDetected)) {
                    write-verbose "Invoke-SpfDkimDmarc: Detected multiple DKIM selectors for domain $($SPF.Name): $($DKIM.DkimSelectorsDetected)"
                    $DkimSelectors = $DKIM.DkimSelectorsDetected -split ', '
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelectorsDetected" $DKIM.DkimSelectorsDetected
                    for ($i = 0; $i -lt $DkimSelectors.Count; $i++) {
                        $index = $i + 1
                        $InvokeReturnValues | Add-Member NoteProperty "DkimSelector-$index" $DkimSelectors[$i]
                        $InvokeReturnValues | Add-Member NoteProperty "DkimRecord-$index" $DKIM."DkimRecord-$index"
                        $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory-$index" "DKIM-record found for selector $($DkimSelectors[$i])."
                    }
                }
                elseif ($DKIM.DkimSelector -is [string] -and -not [string]::IsNullOrEmpty($DKIM.DkimSelector)) {
                    Write-verbose "Invoke-SpfDkimDmarc: Detected DKIM selector for domain $($SPF.Name): $($DKIM.DkimSelector)"
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
                    $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" $DKIM.DkimRecord
                    $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
                }
                else {
                    Write-verbose "Invoke-SpfDkimDmarc: No DKIM selector detected for domain $($SPF.Name)."
                    $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" $null
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $null
                    $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
                }

                $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
                $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "BimiRecord" "$($BIMI.BimiRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "BimiAdvisory" $BIMI.BimiAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "TlsRptRecord" $TlsRPT.TlsRptRecord
                $InvokeReturnValues | Add-Member NoteProperty "TlsRptAdvisory" $TlsRPT.TlsRptAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "CaaRecord" $CAA.CaaRecord
                $InvokeReturnValues | Add-Member NoteProperty "CaaAdvisory" $CAA.CaaAdvisory
                $InvokeObject.Add($InvokeReturnValues)
                $InvokeReturnValues
            }
        }

        # 'Name' parametresi kullanildiginda: parametreyle verilen domainleri isle
        if ($PSBoundParameters.ContainsKey('Name')) {
            Write-Progress -Activity "Querying SPF, DKIM, DMARC, MTA-STS, BIMI, DNSSEC and TLS-RPT records" -Status "Processing domains..." -PercentComplete 0
            foreach ($domain in $Name) {
                $SPF = Get-SPFRecord -Name $domain @Splat
                $DKIM = Get-DKIMRecord -Name $domain @Splat @DKIMSplat
                $DMARC = Get-DMARCRecord -Name $domain @Splat
                $MTASTS = Invoke-MtaSTS -Name $domain @Splat
                $DNSSEC = Get-DNSSec -Name $domain @Splat
                $BIMI = Get-BimiRecord -Name $domain @Splat
                $TlsRPT = Get-TlsRpt -Name $domain @Splat
                $CAA = Get-CAARecord -Name $domain

                $InvokeReturnValues = New-Object psobject
                $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
                $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
                $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" $SPF.SPFRecordDnsLookupCount  # "7/10 (OK)" gibi METIN doner, sayi degil
                $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
                $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory

                if ($DKIM.DkimSelectorsDetected -is [string] -and -not [string]::IsNullOrEmpty($DKIM.DkimSelectorsDetected)) {
                    write-verbose "Invoke-SpfDkimDmarc: Detected multiple DKIM selectors for domain $($SPF.Name): $($DKIM.DkimSelectorsDetected)"
                    $DkimSelectors = $DKIM.DkimSelectorsDetected -split ', '
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelectorsDetected" $DKIM.DkimSelectorsDetected
                    for ($i = 0; $i -lt $DkimSelectors.Count; $i++) {
                        $index = $i + 1
                        $InvokeReturnValues | Add-Member NoteProperty "DkimSelector-$index" $DkimSelectors[$i]
                        $InvokeReturnValues | Add-Member NoteProperty "DkimRecord-$index" $DKIM."DkimRecord-$index"
                        $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory-$index" "DKIM-record found for selector $($DkimSelectors[$i])."
                    }
                }
                elseif ($DKIM.DkimSelector -is [string] -and -not [string]::IsNullOrEmpty($DKIM.DkimSelector)) {
                    Write-verbose "Invoke-SpfDkimDmarc: Detected DKIM selector for domain $($SPF.Name): $($DKIM.DkimSelector)"
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
                    $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" $DKIM.DkimRecord
                    $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
                }
                else {
                    Write-verbose "Invoke-SpfDkimDmarc: No DKIM selector detected for domain $($SPF.Name)."
                    $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" $null
                    $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $null
                    $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
                }

                $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
                $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "BimiRecord" "$($BIMI.BimiRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "BimiAdvisory" $BIMI.BimiAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "TlsRptRecord" $TlsRPT.TlsRptRecord
                $InvokeReturnValues | Add-Member NoteProperty "TlsRptAdvisory" $TlsRPT.TlsRptAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "CaaRecord" $CAA.CaaRecord
                $InvokeReturnValues | Add-Member NoteProperty "CaaAdvisory" $CAA.CaaAdvisory
                $InvokeObject.Add($InvokeReturnValues)
                $InvokeReturnValues
            }
        }
    }
    end {
  
    }
}

Set-Alias Show-SpfDkimDmarc -Value Invoke-SpfDkimDmarc
Set-Alias isdd -Value Invoke-SpfDkimDmarc
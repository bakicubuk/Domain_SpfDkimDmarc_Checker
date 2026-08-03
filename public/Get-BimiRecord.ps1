# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#>
HelpInfoURI 'https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-BIMIRecord.md'
#>

function Get-BimiRecord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "BIMI kaydinin sorgulanacagi domain adini belirtir.")]
        [string[]]$Name,

        [Parameter(Mandatory = $false,
            Helpmessage = "Sorgulanacak BIMI selector adini belirtir.")]
        [string]$Selector,

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

        $BimiObject = New-Object System.Collections.Generic.List[System.Object]

    } process {
        foreach ($domain in $Name) {
            Write-Verbose "Resolving BIMI record for domain: $domain"

            if ($PSBoundParameters.ContainsKey('Selector')) {
                Write-Verbose "Using BIMI selector: $($Selector)"

                if ($OsPlatform -eq "Windows") {
                    $bimiRecord = Resolve-DnsName -Type TXT -Name "$($Selector)._bimi.$($domain)" @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                    $bimiRecord = $(dig TXT "$($Selector)._bimi.$($domain)" +short | Out-String).Trim()
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                    $bimiRecord = $(dig TXT "$($Selector)._bimi.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
                }
            }
            else {
                Write-Verbose "Using default BIMI selector."

                if ($OsPlatform -eq "Windows") {
                    $bimiRecord = Resolve-DnsName -Type TXT -Name "default._bimi.$($domain)" @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                    $bimiRecord = $(dig TXT "default._bimi.$($domain)" +short | Out-String).Trim()
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                    $bimiRecord = $(dig TXT "default._bimi.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
                }

                if ($null -eq $bimiRecord -or $bimiRecord -eq "") {
                    Write-Verbose "No BIMI record found for $domain"
                    $BimiAdvisory += "No BIMI record found for domain."
                    $BimiRecord = "We couldn't find a BIMI record associated with your domain."
                }
            }

            if ($null -ne $bimiRecord -and $bimiRecord -ne "") {
                Write-Verbose "BIMI record found for $domain"
                $BimiAdvisory += "BIMI record found."
                $BimiRecord = $bimiRecord
            

                # BIMI'nin calisabilmesi icin DMARC politikasi 'quarantine' ya da 'reject' olmalidir
                # 'quarantine' politikalarinda pct degeri 100'den kucuk OLMAMALIDIR.
                # See: https://datatracker.ietf.org/doc/html/draft-brand-indicators-for-message-identification-12#name-introduction
                try {

                    Write-Verbose "Checking DMARC record for domain: $domain"
                    $DmarcPolicy = Get-DMARCRecord -Name $domain @SplatParameters
                }
                Catch {
                    Write-Verbose "No DMARC record found for domain: $domain"
                    $null = $DmarcPolicy
                } 
            
                if ($null -eq $DmarcPolicy -or $DmarcPolicy -eq "") {
                    Write-Verbose "No DMARC record found for $domain"
                    $BimiAdvisory = "Does not have a DMARC record. To use BIMI, this domain must have a DMARC record with a policy of at least p=quarantine and pct=100."
                }
                else {
                    switch -Regex ($DmarcPolicy) {
                        ('p=none') {
                            $BimiAdvisory = "DMARC policy is set to p=none. BIMI requires a DMARC policy of at least p=quarantine to function."
                        }
                        ('p=quarantine') {
                            $BimiAdvisory = "DMARC policy is set to p=quarantine. While BIMI can function with this policy, it is recommended to use p=reject for better protection."
                        }
                        ('p=reject') {
                            $BimiAdvisory = "DMARC policy is set to p=reject, which is the best policy for BIMI to function."
                        }
                        ('pct=(100|\d{1,2})') {
                            $pctValue = [int]$Matches[1]
                            if ($pctValue -lt 100) {
                                $BimiAdvisory += " DMARC policy pct is set to less than 100%, BIMI requires a DMARC policy with pct=100 to function."
                            }
                        }
                    }

                }

                # BIMI kaydinin 'a=' etiketini icerip icermedigini kontrol et
                # 'a=' etiketi (Verified Mark Certificate / VMC) zorunlu degildir.
                # See: https://datatracker.ietf.org/doc/html/draft-brand-indicators-for-message-identification-12#section-4.3
            
                if ($bimiRecord -match "a=") {
                    Write-Verbose "Validating 'a=' (VMC) tag in BIMI record."
                    $VMC = $bimiRecord.Split("a=")[1].Split(";")[0].Trim()

                    # 'a=' etiketinin gecerli bir HTTPS adresi icerip icermedigini kontrol et
                    if ($VMC -match "^https://") {
                        Write-Verbose "'a=' (VMC) tag contains a valid HTTPS URL."
                        $BimiAdvisory += " 'a=' (VMC) tag contains a valid HTTPS URL."
                        Write-Verbose "Validate date of VMC certificate"
                        
                        # VMC sertifikasini indir
                        # Sertifika zincirinde birden fazla sertifika varsa ayir
                        try {
                            Write-Verbose "Downloading VMC certificate from URL: $VMC"
                            $VmcCertificate = (Invoke-WebRequest -Uri $VMC -UseBasicParsing).Content
                            $certificates = $VmcCertificate -split '(?=-----BEGIN CERTIFICATE-----)' | Where-Object { $_ -match 'BEGIN CERTIFICATE' }
                        }
                        catch {
                            Write-Verbose "Failed to download VMC certificate from URL: $VMC"
                            $BimiAdvisory += " Failed to download VMC certificate from URL: $VMC. Please ensure the URL is correct and accessible."
                            continue
                        }

                        foreach ($pem in $certificates) {
                            Write-Verbose "Processing VMC certificate."
                            $base64 = $pem -replace '-----BEGIN CERTIFICATE-----', '' -replace '-----END CERTIFICATE-----', '' -replace '\\s', ''

                            $certBytes = [System.Convert]::FromBase64String($base64)
                            $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certBytes)
                            Write-Verbose "Loaded certificate: $($cert.Subject)"

                            # Sertifikanin son kullanma tarihini kontrol et (CA sertifikasini atla)
                            $expiration = [datetime]$cert.NotAfter
                            if ($expiration -lt (Get-Date)) {
                                Write-Verbose "VMC certificate is expired, expiration date: $($expiration)"
                                $BimiAdvisory += " VMC certificate is expired, expiration date: $($expiration). Please renew the certificate."
                            }
                            else {
                                Write-Verbose "VMC certificate is valid, expiration date: $($expiration)."
                                $BimiAdvisory += " VMC certificate is valid, expiration date: $($expiration)."
                            }

                            break # zincirdeki yalnizca ilk sertifika degerlendirilir
                        }
                    }
                    else {
                        Write-Verbose "'a=' (VMC) tag does not contain a valid HTTPS URL."
                        $BimiAdvisory += " 'a=' (VMC) tag does not contain a valid HTTPS URL, it should start with 'https://'. It's recommended to use a valid HTTPS URL for VMC to prevent that scammers misuse your logo."
                    }
                }
                else {
                    Write-Verbose "No 'a=' (VMC) tag found in BIMI record."
                    $BimiAdvisory += " No 'a=' (VMC) tag found, it's recommended to include a VMC certificate."
                }
            }            

            $BimiReturnValues = New-Object psobject
            $BimiReturnValues | Add-Member NoteProperty "Name" $domain
            $BimiReturnValues | Add-Member NoteProperty "BimiRecord" $BimiRecord
            $BimiReturnValues | Add-Member NoteProperty "BimiAdvisory" $BimiAdvisory
            $BimiObject.Add($BimiReturnValues)
            $BimiReturnValues
        }
    } end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
Set-Alias -Name gbimi -Value Get-BimiRecord
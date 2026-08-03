# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#>
HelpInfoURI 'https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/blob/main/public/CmdletYardim/Get-CAARecord.md'
#>

# Private (ic kullanim) fonksiyonlari yukle
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-CAARecord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "CAA kaydinin sorgulanacagi domain adini belirtir.")]
        [string[]]$Name
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $CAAObject = New-Object System.Collections.Generic.List[System.Object]

    }
    process {
        foreach ($domain in $Name) {

            Write-Verbose "Resolving CAA-record for $domain"
            Write-Verbose "Resolving CAA-record with https://cloudflare-dns.com/dns-query?name=$domain&type=CAA"
            
            # CAA kaydini cozumlemek icin Cloudflare'in DNS over HTTPS API'sini kullan
            # (Resolve-DnsName CAA kayit tipini desteklemedigi icin bu yontem zorunludur)
            # See: https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/make-api-requests/
            try {
                $ApiResponse = Invoke-RestMethod -Uri "https://cloudflare-dns.com/dns-query?name=$domain&type=CAA" -Headers @{ "accept" = "application/dns-json" }
                $AllowedCas = @()
                $iodefValues = @()
                if ($ApiResponse.Answer) {
                    Write-verbose "CAA record found for $($domain): $($ApiResponse.Answer | ForEach-Object { $_.data })"
                    foreach ($answer in $ApiResponse.Answer) {
                        $CAAValues = Convert-CaaRdata $answer.data
                        Write-verbose "Converted CAA record for $($domain): $($CAAValues.Value)"

                        if ($CAAValues.Tag -in @("issue", "issuewild") -and $CAAValues.Value) {
                            $AllowedCas += $CAAValues.Value
                        }
                        elseif ($CAAValues.Tag -eq "iodef" -and $CAAValues.Value) {
                            $iodefValues += $CAAValues.Value
                        }
                    }

                    if ($AllowedCas.Count -gt 0 -or $iodefValues.Count -gt 0) {
                        $CAARecord = "CAA record found, allowed CAs: $($AllowedCas -join ', ')."
                        if ($iodefValues.Count -gt 0) {
                            $iodef = $iodefValues -join ', '
                            Write-verbose "CAA record found with IODEF contact information: $iodef"
                            $CAAAdvisory = "CAA record found with IODEF contact information: $iodef"
                        }
                        else {
                            Write-verbose "CAA record found but IODEF not configured."
                            $CAAAdvisory = "CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications."
                        }
                    }
                    else {
                        $CAAAdvisory = "No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for $domain."
                    }
                }
                else {
                    $CAARecord = "No CAA record found."
                    $CAAAdvisory = "No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for $domain."
                    Write-Verbose "No CAA record found for $domain."
                }
            }
            catch {
                Write-Verbose "Failed to resolve CAA-record for $domain. Error: $($_.Exception.Message)"
            }

            $CAAReturnValues = New-Object psobject
            $CAAReturnValues | Add-Member NoteProperty "Name" $domain
            $CAAReturnValues | Add-Member NoteProperty "CAARecord" $CAARecord
            $CAAReturnValues | Add-Member NoteProperty "CAAAdvisory" $CAAAdvisory
            $CAAObject.Add($CAAReturnValues)
            $CAAReturnValues

        }
    }
    end {

    }
}
Set-Alias -Name gcaa -Value Get-CAARecord
# Kaynak: https://github.com/bakicubuk/Domain_SpfDkimDmarc_Checker/

<#
.SYNOPSIS
    CAA kaydinin RDATA bolumunu hex bicimden okunabilir bicime cevirir.

.DESCRIPTION
    Bu fonksiyon, DNS sorgularindan hex bicimde donen CAA RDATA verisini alir ve
    okunabilir bicime cevirir; icindeki flags, tag ve value alanlarini ayristirir.

.EXAMPLE
    Convert-CaaRdata -HexData "\# 19 00 05 69 73 73 75 65 64 69 67 69 63 65 72 74 2e 63 6f 6d"
#>
function Convert-CaaRdata {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$HexData
    )

    # Varsa bastaki "\# 19 " onekini (uzunluk bayti) at, yalnizca hex ciftlerini birak
    $hexBytes = ($HexData -replace '^\\#\s*\d+\s*', '') -split '\s+' | Where-Object { $_ }
    $bytes = $hexBytes | ForEach-Object { [Convert]::ToByte($_, 16) }

    $flags = $bytes[0]
    $tagLen = $bytes[1]
    $tag = -join ($bytes[2..(1 + $tagLen)] | ForEach-Object { [char]$_ })
    $value = -join ($bytes[(2 + $tagLen)..($bytes.Length - 1)] | ForEach-Object { [char]$_ })

    [PSCustomObject]@{
        Flags = $flags
        Tag   = $tag
        Value = $value
    }
}
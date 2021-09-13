
param (
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/sALL'
)

Push-Location $PSScriptRoot

if (Get-Package 'Adobe Acrobat *') {exit}

$ScriptBlock = {
    $reader = (Invoke-WebRequest 'https://get.adobe.com/reader/webservices/json/standalone/?language=Hindi' -UseBasicParsing -Headers @{'X-Requested-With' = 'XMLHttpRequest'} | ConvertFrom-Json) | Group-Object {$_.queryName.EndsWith('(64Bit)')} -AsHashTable
    $download_url = ($reader.[Environment]::Is64BitOperatingSystem).download_url
    if ($download_url) {$download_url} else {$reader.Values.download_url}
}

& '..\..\Install-VerifiedProgram.ps1' $ScriptBlock $Arguments

Pop-Location

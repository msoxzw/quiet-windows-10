
param (
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/sALL'
)

Push-Location $PSScriptRoot

if (Get-Package 'Adobe Acrobat *') {exit}

$ScriptBlock = {
    $reader = (Invoke-WebRequest 'https://get.adobe.com/reader/webservices/json/standalone/' -UseBasicParsing -Headers @{'Accept-Language' = (Get-UICulture).Name; 'X-Requested-With' = 'XMLHttpRequest'} | ConvertFrom-Json) | Group-Object {$_.queryName.EndsWith('(64Bit)')} -AsHashTable
    ($reader.[Environment]::Is64BitOperatingSystem).download_url
}

& '..\..\Install-VerifiedProgram.ps1' $ScriptBlock $Arguments

Pop-Location

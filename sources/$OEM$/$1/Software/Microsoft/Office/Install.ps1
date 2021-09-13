
param (
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/configure'
)

Push-Location $PSScriptRoot

$Uri = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
& '..\..\Install-VerifiedProgram.ps1' $Uri $Arguments

Pop-Location

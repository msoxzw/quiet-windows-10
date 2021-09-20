
param (
    [Parameter(Mandatory)]
    [string]$Product,

    [string]$Channel = 'stable',

    [switch]$SystemLevel,

    [Parameter(Position=0, ValueFromRemainingArguments)]
    [string[]]$Arguments = '/silent /enterprise'
)

begin {Push-Location $PSScriptRoot}

$Uri, $App = (Import-PowerShellDataFile 'Products.psd1').$Product['uri', $Channel]

if (Get-Package $App.Name) {return}

$Arguments += '/install "appguid={0}&needsadmin={1}"' -f $App.Guid, $SystemLevel
& '..\Install-VerifiedProgram.ps1' $Uri $Arguments

end {Pop-Location}

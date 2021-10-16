
param (
    [Parameter(Mandatory)]
    [string]$Product,

    [string]$Channel = 'stable',

    [switch]$SystemLevel,

    [int]$RetryInterval = -1,

    [Parameter(Position=0, ValueFromRemainingArguments)]
    [string[]]$Arguments = '/silent /enterprise'
)

begin
{
    Push-Location $PSScriptRoot
    . '..\helpers.ps1'
}

process
{
    $Uri, $App = (Import-PowerShellDataFile 'Products.psd1').$Product['uri', $Channel]

    if (Get-Package $App.Name) {return}

    $Arguments += '/install "appguid={0}&needsadmin={1}"' -f $App.Guid, $SystemLevel
    $ExitCode = Install-VerifiedProgram $Uri $Arguments -RetryInterval $RetryInterval
}

end
{
    Pop-Location
    exit $ExitCode
}

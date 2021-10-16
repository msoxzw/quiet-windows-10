
param (
    [int]$RetryInterval = -1,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/sALL'
)

begin
{
    Push-Location $PSScriptRoot
    . '..\..\helpers.ps1'
}

process
{
    if (Get-Package 'Adobe Acrobat *') {return}

    $ScriptBlock = {
        $reader = (Invoke-WebRequest 'https://get.adobe.com/reader/webservices/json/standalone/' -UseBasicParsing -Headers @{'Accept-Language' = (Get-UICulture).Name; 'X-Requested-With' = 'XMLHttpRequest'} | ConvertFrom-Json) | Group-Object {$_.queryName.EndsWith('(64Bit)')} -AsHashTable
        ($reader.[Environment]::Is64BitOperatingSystem).download_url
    }

    $ExitCode = Install-VerifiedProgram $ScriptBlock $Arguments -RetryInterval $RetryInterval
}

end
{
    Pop-Location
    exit $ExitCode
}

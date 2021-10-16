
param (
    [int]$RetryInterval = -1,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/configure'
)

begin
{
    Push-Location $PSScriptRoot
    . '..\..\helpers.ps1'
}

process
{
    $Uri = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
    $ExitCode = Install-VerifiedProgram $Uri $Arguments -RetryInterval $RetryInterval
}

end
{
    Pop-Location
    exit $ExitCode
}

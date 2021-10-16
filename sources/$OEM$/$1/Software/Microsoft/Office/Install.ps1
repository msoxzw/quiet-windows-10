
param (
    [int]$RetryInterval = -1,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/configure'
)

begin {Push-Location $PSScriptRoot}

process
{
    $Uri = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
    $ExitCode = & '..\..\Install-VerifiedProgram.ps1' $Uri $Arguments -RetryInterval $RetryInterval
}

end {Pop-Location; exit $ExitCode}

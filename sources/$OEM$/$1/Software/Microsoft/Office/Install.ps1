
param (
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/configure'
)

begin {Push-Location $PSScriptRoot}

process
{
    $Uri = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
    $ExitCode = & '..\..\Install-VerifiedProgram.ps1' $Uri $Arguments
}

end {Pop-Location; exit $ExitCode}

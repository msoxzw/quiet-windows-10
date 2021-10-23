
param (
    [Parameter(Mandatory)]
    [string]$Product,

    [string]$Channel = 'release',

    [int]$RetryInterval = -1,

    [Parameter(Position=0, ValueFromRemainingArguments)]
    [string[]]$Arguments = '/S /LaunchedFromStub'
)

begin
{
    Push-Location $PSScriptRoot
    . '..\helpers.ps1'
}

process
{
    $App = (Import-PowerShellDataFile 'Products.psd1').$Product.$Channel

    if (Get-Package "$($App.Name) (*)") {return}

    $ScriptBlock = {
        $os = "win$(if([Environment]::Is64BitOperatingSystem){64})"
        $lang = (Invoke-WebRequest 'https://www.mozilla.org/' -UseBasicParsing -Headers @{'Accept-Language' = (Get-UICulture).Name} -MaximumRedirection 0 -ErrorAction 0).Headers.Location.Trim('/')
        (Invoke-WebRequest "https://download.mozilla.org/?os=$os&lang=$lang&product=$($App.Download)" -UseBasicParsing -Method Head).BaseResponse.ResponseUri
    }

    $ExitCode = Install-VerifiedProgram $ScriptBlock $Arguments -RetryInterval $RetryInterval
    & '.\Setup.ps1'
}

end
{
    Pop-Location
    exit $ExitCode
}

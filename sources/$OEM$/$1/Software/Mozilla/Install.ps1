
param (
    [Parameter(Mandatory)]
    [string]$Product,

    [string]$Channel = 'release',

    [Parameter(Position=0, ValueFromRemainingArguments)]
    [string[]]$Arguments = '/S /LaunchedFromStub'
)

Push-Location $PSScriptRoot

$App = (Import-PowerShellDataFile 'Products.psd1').$Product.$Channel

if (Get-Package "$($App.Name) (*)") {exit}

$ScriptBlock = {
    $os = "win$(if([Environment]::Is64BitOperatingSystem){64})"
    $lang = (Invoke-WebRequest 'https://www.mozilla.org/' -UseBasicParsing -Headers @{'Accept-Language' = (Get-UICulture).Name} -MaximumRedirection 0 -ErrorAction 0).Headers.Location.Trim('/')
    (Invoke-WebRequest "https://download.mozilla.org/?os=$os&lang=$lang&product=$($App.Download)" -UseBasicParsing -Method Head).BaseResponse.ResponseUri
}

& '..\Install-VerifiedProgram.ps1' $ScriptBlock $Arguments -Wait
& '.\setup.ps1'

Pop-Location

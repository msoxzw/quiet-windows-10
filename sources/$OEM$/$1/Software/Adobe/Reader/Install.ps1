
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
        $uri = 'https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/'
        $uri += (Invoke-WebRequest $uri -UseBasicParsing).Links.Where({$_.href.StartsWith('continuous/')}, 'Default', 1).href
        $uri = (Invoke-WebRequest $uri -UseBasicParsing).Links.Where({$_.href.EndsWith('_MUI.msp')}, 'Default', 2).href
        Start-BitsTransfer $uri[[Environment]::Is64BitOperatingSystem] 'patch.msp'

        if ([Environment]::Is64BitOperatingSystem) {
            'https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2100120135/AcroRdrDCx642100120135_MUI.exe'
        }
        else {
            'https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/1500720033/AcroRdrDC1500720033_MUI.exe'
        }
    }

    $Arguments += '/msi PATCH="{0}"' -f (Join-Path $PSScriptRoot 'patch.msp')

    $ExitCode = Install-VerifiedProgram $ScriptBlock $Arguments -RetryInterval $RetryInterval
}

end
{
    Pop-Location
    exit $ExitCode
}

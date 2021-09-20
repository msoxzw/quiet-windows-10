
param (
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments = '/sALL'
)

begin {Push-Location $PSScriptRoot}

process
{
    if (Get-Package 'Adobe Acrobat *') {return}

    $ScriptBlock = {
        $reader = (Invoke-WebRequest 'https://get.adobe.com/reader/webservices/json/standalone/' -UseBasicParsing -Headers @{'Accept-Language' = (Get-UICulture).Name; 'X-Requested-With' = 'XMLHttpRequest'} | ConvertFrom-Json) | Group-Object {$_.queryName.EndsWith('(64Bit)')} -AsHashTable
        ($reader.[Environment]::Is64BitOperatingSystem).download_url
    }

    & '..\..\Install-VerifiedProgram.ps1' $ScriptBlock $Arguments
}

end {Pop-Location}

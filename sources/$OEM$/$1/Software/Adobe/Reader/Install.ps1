Push-Location $PSScriptRoot

if (Get-Package 'Adobe Acrobat *') {exit}
$reader = (Invoke-WebRequest 'https://get.adobe.com/reader/webservices/json/standalone/?language=Hindi' -UseBasicParsing -Headers @{'X-Requested-With' = 'XMLHttpRequest'} | ConvertFrom-Json) | Group-Object {$_.queryName.EndsWith('(64Bit)')} -AsHashTable

$url = ($reader.[Environment]::Is64BitOperatingSystem).download_url
if ($url -eq $null) {$url = $reader.Values.download_url}

if (-not $args) {$args = '/sALL'}
& '..\..\Install-VerifiedProgram.ps1' $url $args

Pop-Location

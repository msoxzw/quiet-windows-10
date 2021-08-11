Push-Location $PSScriptRoot

$subscriptionsURL = 'https://raw.githubusercontent.com/adblockplus/adblockpluscore/master/data/subscriptions.json'
Invoke-WebRequest $subscriptionsURL -OutFile 'subscriptions.json'
$subscriptions = Get-Content '*.json' -Raw | ConvertFrom-Json | ForEach-Object {$_}

$language = (Get-UICulture).TwoLetterISOLanguageName
if ($language -notin $subscriptions.languages) {$language = 'en'}

$registryPath = 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists'
$added = Get-ItemPropertyValue "$registryPath\*" 'Name'
$subscriptions | Where-Object {$_.title -notin $added -and ($null -eq $_.languages -or $language -in $_.languages)} | ForEach-Object {[PSCustomObject]@{'Enabled' = 1; 'Name' = $_.title; 'Url' = $_.url -replace '\.txt$','.tpl'} | Set-ItemProperty (New-Item  $registryPath -Name "{$(New-Guid)}".ToUpper() -Force).PSPath}

Pop-Location

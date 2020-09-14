Push-Location $PSScriptRoot

$Config = '..\Config\Files\LocalAppData', $env:LocalAppData
$Config.ForEach({Copy-Item (Get-ChildItem -Directory) $_ -Force -Filter PSIsContainer -Recurse})
$User_Data = Get-ChildItem -Filter 'User Data' -Recurse -Name -Directory
Get-ChildItem $User_Data -Recurse -Name -File | Select-Object -Unique | ForEach-Object {$chromium = Join-Path 'Chromium\User Data' $_; Join-Path $User_Data $_ -PipelineVariable browser | ForEach-Object {Join-Path $Config $_ | ForEach-Object {-join (Get-Content ($_, $chromium, $browser | Get-Unique) -Raw -ErrorAction 0) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}}}


reg import 'Chromium.reg'
$key = Select-String -Pattern '^\[(.+)\]$' -Path *.reg -List | ForEach-Object {$_.Matches.Groups[1].Value}
$chromium = $key.Where({$_.EndsWith('\Chromium')})
$key.Where({-not $_.EndsWith('\Chromium')}).ForEach({reg copy $chromium $_ /s /f})
Get-Item '*.reg' | ForEach-Object {reg import $_}

Pop-Location

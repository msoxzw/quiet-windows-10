Push-Location $PSScriptRoot

$Config = '..\Config\Files\LocalAppData', $env:LocalAppData
$Config.ForEach({Copy-Item (Get-ChildItem -Directory) $_ -Force -Filter PSIsContainer -Recurse})
$User_Data = Get-ChildItem -Filter 'User Data' -Recurse -Name -Directory
Get-ChildItem 'Chromium\User Data' -Recurse -Name -File | ForEach-Object {$chromium = Join-Path 'Chromium\User Data' $_; $browser = Join-Path $User_Data $_; $browser | ForEach-Object {Join-Path $Config $_ | ForEach-Object {-join (Get-Content ($_, $chromium, $browser | Get-Unique) -Raw -ErrorAction 0) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}}}


$Keys = Select-String -Pattern '(?<=^\[)[^]]+(?=\]$)' -Path '*.reg' -List | Group-Object {$_.Matches.Value.EndsWith('\Chromium')}
$Chromium = $Keys[0].Group.ForEach({reg import $_.Path; $_.Matches.Value})
$Keys[1].Group.ForEach({reg copy $Chromium[0] $_.Matches.Value /s /f; reg import $_.Path})

Pop-Location

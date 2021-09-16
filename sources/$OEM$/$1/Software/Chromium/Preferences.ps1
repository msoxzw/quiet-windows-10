Push-Location $PSScriptRoot

$User_Data = Get-ChildItem -Filter 'User Data' -Recurse -Name -Directory
Get-ChildItem 'Chromium\User Data' -Recurse -Name -File | ForEach-Object {$chromium = Join-Path 'Chromium\User Data' $_; Join-Path $User_Data $_ | ForEach-Object {$browser = Join-Path $env:LocalAppData $_; -join (Get-Content ($browser, $chromium, $_ | Get-Unique) -Raw -ErrorAction 0) -replace '\s*}\s*{', ',' | New-Item $browser -Force}}

[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Edge\SmartScreenEnabled', '', 0)
[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Edge\SmartScreenPuaEnabled', '', 0)

Pop-Location

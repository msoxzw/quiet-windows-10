Push-Location $PSScriptRoot

Resolve-Path '*.reg' | ForEach-Object {reg import $_}

Get-ChildItem -Directory | ForEach-Object {$Config = Join-Path $_ '*'; Get-ItemPropertyValue (Join-Path 'HKCU:', 'HKLM:' "Software\Mozilla\*$_*\*\Main") 'Install Directory' | ForEach-Object {Copy-Item $Config $_ -Force -Recurse}}

Get-Item 'HKCU:\Software\Mozilla\*\Default Browser Agent' | ForEach-Object {$agent = Join-Path ($_.Property[0] -split '\|')[0] 'default-browser-agent'; Get-ChildItem (Join-Path $_.PSParentPath 'Installer') -Name | ForEach-Object {& $agent uninstall $_}}

Pop-Location

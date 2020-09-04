Push-Location $PSScriptRoot

Get-Item '*.reg' | ForEach-Object {reg import $_}

Get-ChildItem -Directory | ForEach-Object {$Config = Join-Path $_ '*'; Get-ItemPropertyValue "HKLM:\Software\Mozilla\*$_*\*\Main" 'Install Directory' | ForEach-Object {Copy-Item $Config $_ -Force -Recurse}}

Pop-Location

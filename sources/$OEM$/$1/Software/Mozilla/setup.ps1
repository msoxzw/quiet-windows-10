Push-Location $PSScriptRoot

Resolve-Path '*.reg' | ForEach-Object {reg import $_}

Get-ChildItem -Directory | ForEach-Object {$Configuration = Join-Path $_ '*'; Get-ItemPropertyValue (Join-Path 'HKCU:', 'HKLM:' "Software\Mozilla\*$_*\*\Main") 'Install Directory' -ErrorAction 0 | ForEach-Object {Copy-Item $Configuration $_ -Force -Recurse}}

(Get-ScheduledTask '*Default Browser Agent*').Actions | ForEach-Object {& $_.Execute uninstall $_.Arguments.Split()[1]}

Pop-Location

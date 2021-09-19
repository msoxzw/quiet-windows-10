@echo off

REM https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_character_encoding
set "command=& {$args | ForEach-Object {(Get-Content -LiteralPath $_ -Raw) -replace "`r`n", "`n" | New-Item $_ -Force}} %*"

PowerShell "%command:"=\"%"

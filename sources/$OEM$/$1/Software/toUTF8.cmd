@echo off

set files=%*
set files=%files:"=\"%

PowerShell "& {$args | ForEach-Object {(Get-Content -LiteralPath $_ -Raw) -replace \"`r`n\",\"`n\" | Set-Content -LiteralPath $_ -NoNewline}}" %files%

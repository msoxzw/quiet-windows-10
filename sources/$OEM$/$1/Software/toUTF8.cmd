@echo off

set "command=& {$args | ForEach-Object {(Get-Content -LiteralPath $_ -Raw) -replace "`r`n", "`n" | Set-Content -LiteralPath $_ -NoNewline}} %*"

PowerShell "%command:"=\"%"

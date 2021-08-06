@echo Start-Process PowerShell '-ExecutionPolicy Bypass -Command "Get-Item "%~dp0*.ps1" | ForEach-Object {& $_ %*}"' -Verb RunAs -Wait | PowerShell -

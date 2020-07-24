@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

set Config=..\Config\Files\LocalAppData\
PowerShell "Get-ChildItem 'User Data' -Recurse -Directory | Resolve-Path -Relative | ForEach-Object {robocopy '.\Chromium\User Data' ('%Config%' + $_) /s; Get-ChildItem $_ -Recurse -File | Resolve-Path -Relative | ForEach-Object {-join  (Get-Content ('%Config%' + $_), $_ -Raw) -replace '\s*}\s*{', ',' | Set-Content ('%Config%' + $_) -NoNewline}}"

robocopy "%Config%" "%LocalAppData%" /s


reg import Chromium.reg
PowerShell "$key = Select-String -Pattern '^\[(.+)\]$' -Path *.reg -List | ForEach-Object {$_.Matches.Groups[1].Value}; $chromium = $key.Where({$_.EndsWith('\Chromium')}); $key.Where({-not $_.EndsWith('\Chromium')}).ForEach({reg copy $chromium $_ /s /f})"
for %%i in (*.reg) do reg import "%%i"

popd

@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

set Config='..\Config\Files\LocalAppData', '%LocalAppData%'
PowerShell "%Config% | ForEach-Object {Copy-Item (Get-ChildItem -Directory) $_ -Force -Filter {PSIsContainer} -Recurse}; Get-ChildItem 'Chromium\User Data' -Recurse -Name -File | ForEach-Object {$chromium = Join-Path 'Chromium\User Data' $_; Get-ChildItem -Filter 'User Data' -Recurse -Name -Directory | Join-Path -ChildPath $_ -PipelineVariable browser | ForEach-Object {Join-Path %Config% $_ | ForEach-Object {-join (Get-Content ($chromium, $browser, $_ | Get-Unique) -Raw -ErrorAction 0) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}}}"


reg import Chromium.reg
PowerShell "$key = Select-String -Pattern '^\[(.+)\]$' -Path *.reg -List | ForEach-Object {$_.Matches.Groups[1].Value}; $chromium = $key.Where({$_.EndsWith('\Chromium')}); $key.Where({-not $_.EndsWith('\Chromium')}).ForEach({reg copy $chromium $_ /s /f})"
for %%i in (*.reg) do reg import "%%i"

popd

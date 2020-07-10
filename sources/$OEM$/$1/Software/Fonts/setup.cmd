@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

set fonts=https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHanNotoCJK.ttc

:download
aria2c --dir="%SystemRoot%\Fonts" %fonts% || goto download

for %%i in (*.reg) do reg import "%%i"
mklink "..\Config\Registry\Internet Explorer Fonts.reg" "%~dp0Internet Explorer.reg"

for /d %%i in (..\Mozilla\*) do mklink "%%i\defaults\pref\fonts.js" "%~dp0Mozilla.js"

PowerShell "'%LocalAppData%', '..\Config\Files\LocalAppData' | Join-Path -ChildPath 'Chromium\User Data\*\Preferences' | ForEach-Object {-join (Get-Content $_, 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}"
PowerShell "Get-Item '%LocalAppData%\*\*\User Data\*\Preferences' | ForEach-Object {-join (Get-Content $_, 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}"

popd

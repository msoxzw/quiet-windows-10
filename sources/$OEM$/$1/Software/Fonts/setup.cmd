@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

set fonts=https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHanNotoCJK.ttc

:download
aria2c --dir="%SystemRoot%\Fonts" %fonts% || (timeout /t 60 & goto download)

for %%i in (*.reg) do reg import "%%i"
mklink "..\Config\Registry\Internet Explorer Fonts.reg" "%~dp0Internet Explorer.reg"

set Chromium=..\Chromium\Chromium\User Data\Default\Preferences
PowerShell "-join (Get-Content '%Chromium%', 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content '%Chromium%' -NoNewline"

for /d %%i in (..\Mozilla\*) do mklink "%%i\defaults\pref\fonts.js" "%~dp0Mozilla.js"

popd

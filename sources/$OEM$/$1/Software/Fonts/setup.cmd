@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

REM Download and install the latest Source Han Super OTC
set fonts=https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHan.ttc

:download
aria2c --dir="%SystemRoot%\Fonts" %fonts% || (timeout /t 60 & goto download)

for %%i in (*.reg) do reg import "%%i"


REM The default fonts for Chinese, Japanese, and Korean (CJK) languages in Internet Explorer are changed to Source Han
mklink "..\Config\Registry\Internet Explorer Fonts.reg" "%~dp0Internet Explorer.reg"

REM The default fonts for Chinese, Japanese, and Korean (CJK) languages in Chromium based browsers are changed to Source Han
PowerShell "'..\Config\Files\LocalAppData', '%LocalAppData%' | Get-ChildItem -Filter 'User Data' -Recurse -Directory | Join-Path -ChildPath '*\Preferences' -Resolve | ForEach-Object {-join (Get-Content $_, 'Chromium.json' -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}"

REM The default fonts for Chinese, Japanese, and Korean (CJK) languages in Mozilla applications are changed to Source Han
PowerShell "Get-ItemPropertyValue 'HKLM:\Software\Mozilla\*\*\Main' 'Install Directory' | ForEach-Object {Copy-Item Mozilla.js ($_ + '\defaults\pref\fonts.js')}"

popd

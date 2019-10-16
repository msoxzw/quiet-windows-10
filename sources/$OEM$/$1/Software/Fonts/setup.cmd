@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

set fonts=https://github.com/adobe-fonts/source-han-super-otc/releases/latest/download/SourceHanNotoCJK.ttc

:download
aria2c --dir="%SystemRoot%\Fonts" %fonts% || goto download

for %%i in (*.reg) do reg import "%%i"

for /f "tokens=3*" %%i in ('reg query "HKLM\Software\Mozilla" /v "Install Directory" /s ^| find "REG_SZ"') do robocopy . "%%k\defaults\pref" fonts.js

popd

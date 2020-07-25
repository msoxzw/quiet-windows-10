@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

for %%i in (*.reg) do reg import "%%i"

PowerShell "Get-ChildItem -Directory -PipelineVariable Config | ForEach-Object {Get-ItemPropertyValue ('HKLM:\Software\Mozilla\*' + $_ + '*\*\Main') 'Install Directory' | ForEach-Object {robocopy $Config $_ /s}}"

popd

@echo off
pushd %~dp0

PowerShell "Start-BitsTransfer 'https://officecdn.microsoft.com/pr/wsus/setup.exe'" && setup.exe /configure

popd

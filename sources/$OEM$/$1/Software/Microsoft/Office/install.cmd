@echo off
pushd %~dp0

bitsadmin /transfer "Office" "https://officecdn.microsoft.com/pr/wsus/setup.exe" "%~dp0setup.exe" && setup /configure

popd

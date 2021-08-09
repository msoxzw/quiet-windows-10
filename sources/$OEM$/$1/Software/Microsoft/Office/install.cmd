@echo off
pushd %~dp0

aria2c "https://officecdn.microsoft.com/pr/wsus/setup.exe"
setup /configure

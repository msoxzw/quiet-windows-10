@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

for /f "tokens=2*" %%i in ('reg query HKLM\Software\7-Zip /v Path') do set zip="%%j7z.exe"
if not exist %zip% exit /b

for %%i in (*.url) do %zip% x -o"%ProgramFiles%\JetBrains\%%~ni" %%~ni-*.exe -x!$PLUGINSDIR -x!bin\Uninstall.exe.nsis

popd

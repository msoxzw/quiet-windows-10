@echo off

if "%~1" == "" (
    set products=https://data.services.jetbrains.com/products?fields=code,name,distributions
    PowerShell "(Invoke-WebRequest '%products%' | ConvertFrom-Json).Where{$_.distributions.windows}.ForEach{Set-Content ('%~dp0' + $_.name + '.cmd') ('@\"%%~dp0setup.cmd\" ' + $_.code)}"
    exit /b
)


if not exist "%~3" aria2c -d %Temp% --on-download-complete "%~dp0setup.cmd" "https://data.services.jetbrains.com/products/download?code=%1&platform=windows" & exit /b


whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)

for /f "tokens=2*" %%i in ('reg query HKLM\Software\7-Zip /v Path') do set zip="%%j7z.exe"
if not exist %zip% exit /b

set InstallDir=%ProgramFiles%\JetBrains

%zip% x -o"%InstallDir%\Temp" %3 -x!$PLUGINSDIR -x!bin\Uninstall.exe.nsis

pushd %InstallDir%

PowerShell "$product=Get-Content 'Temp\product-info.json' | ConvertFrom-Json; Remove-Item $product.name -Recurse; Move-Item 'Temp' $product.name; New-Item '%Public%\Desktop' -Name $product.name -ItemType SymbolicLink -Value (Join-Path $product.name $product.launch[0].launcherPath) -Force"

popd

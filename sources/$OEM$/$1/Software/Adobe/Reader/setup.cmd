@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off
pushd %~dp0

for %%i in (Acro*.msp) do set properties=PATCH="%%~fi"

set properties=%properties% DISABLE_BROWSER_INTEGRATION=YES EULA_ACCEPT=YES ENABLE_OPTIMIZATION=0 ADD_THUMBNAILPREVIEW=0 DISABLEDESKTOPSHORTCUT=1 DISABLE_ARM_SERVICE_INSTALL=1

for %%i in (Acro*.exe) do "%%i" /sALL /msi %properties%

schtasks /delete /tn "Adobe Acrobat Update Task" /f

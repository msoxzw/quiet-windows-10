@whoami /groups | find "S-1-16-8192" && (PowerShell Start-Process cmd '/c \"\"%~f0\" %*\"' -Verb RunAs & exit /b)
@echo off

PowerShell Rename-Computer -NewName Computer

REM Set DNS server addresses with EDNS Client Subnet support and no logging
PowerShell "Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses ('9.9.9.11','149.112.112.11','2620:fe::11','2620:fe::fe:11')"

PowerShell Set-MpPreference -MAPSReporting Disabled -PUAProtection Disabled -SubmitSamplesConsent NeverSend

REM Remove all apps for the local system except Microsoft Store
PowerShell "Get-AppxProvisionedPackage -Online | Where-Object DisplayName Microsoft.WindowsStore -NE | Remove-AppxProvisionedPackage -Online"

REM Remove all Windows capabilities for the local system except language capabilities
PowerShell "Get-WindowsCapability -Online -LimitAccess | Where-Object { $_.Name -notlike 'Language.*' -and $_.State -eq 'Installed'} | Remove-WindowsCapability -Online"


REM Encrypt the existing used space on the system volume
manage-bde -on %SystemDrive% -UsedSpaceOnly

REM Disable the hibernate feature
powercfg /h off

REM Set time zone automatically
sc config tzautoupdate start= demand

REM Change the default time server to pool.ntp.org
REM https://www.ntppool.org/
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"


REM Turn off all startup apps for the system account
for /f "skip=2" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run /v %%i /t REG_BINARY /d 03 /f

REM Download and install apps when any network connection is available
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce /v Install /d "schtasks /create /tn Install /xml \"%SystemDrive%\Software\Install.xml\" /f" /f

REM Configure system and apps for the system account
for %%i in ("%SystemDrive%\Software\Config\Registry\System\*.reg") do reg import "%%i"


reg load HKU\Default "%SystemDrive%\Users\Default\NTUSER.DAT"

REM Turn off all startup apps for a new user account
for /f "skip=2" %%i in ('reg query HKU\Default\Software\Microsoft\Windows\CurrentVersion\Run') do reg add HKU\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run /v %%i /t REG_BINARY /d 03 /f

REM Configure system and apps for a new user account when signing in to the computer for the first time
reg add HKU\Default\Software\Microsoft\Windows\CurrentVersion\RunOnce /v Setup /d "%SystemDrive%\Software\Config\setup.cmd" /f

reg unload HKU\Default


REM Restart computer immediately
shutdown /r /t 0

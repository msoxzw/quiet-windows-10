@echo off
pushd %~dp0

REM Clear desktop for the current user account
del "%USERPROFILE%\Desktop\*.lnk"

explorer

REM Enable MAC randomization on all wireless LAN interfaces
for /f "tokens=2*" %%i in ('netsh wlan show interfaces ^| find "Name"') do netsh wlan set randomization enabled=yes interface="%%j"

REM Set the current time zone to Coordinated Universal Time
:: tzutil /s UTC

REM Set the culture for the current user account to United States
:: PowerShell Set-Culture -CultureInfo en-US

REM Set the home location for the current user account to 0xF4 (hex) (United States)
PowerShell Set-WinHomeLocation -GeoId 0xF4

REM Insert the language English (United States) to the user's language list
PowerShell $LanguageList = Get-WinUserLanguageList; $LanguageList.Insert(0, 'en-US'); Set-WinUserLanguageList -LanguageList $LanguageList -Force


REM Turn off all app permissions for the current user account
for /f "tokens=7* delims=\" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\Capabilities') do reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\%%j" /v Value /d Deny /f

REM Turn off all suggestions for the current user account
for /f %%i in ('reg query HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager ^| find "REG_DWORD"') do reg add HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager /v %%i /t REG_DWORD /d 0 /f

REM Clear Start layout for the current user account
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore /f

REM Clear taskbar for the current user account
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /va /f


REM Configure system and apps for the current user account
setlocal EnableDelayedExpansion
for /d %%i in (Files\*) do robocopy "%%i" "!%%~ni!" /s
endlocal
for %%i in (Registry\*.reg) do reg import "%%i"


Rem Configure Chromium based Browser
set chromium=%LocalAppData%\Chromium\User Data\Default\Preferences
PowerShell "Get-Item '%LocalAppData%\*\*\User Data\Default\Preferences' | ForEach-Object {-join (Get-Content $env:chromium, $_ -Raw) -replace '\s*}\s*{', ',' | Set-Content $_ -NoNewline}"


REM Specify the desktop background without changing any setting
set Wallpaper=%AppData%\Microsoft\Windows\Themes\TranscodedWallpaper

for %%i in (Wallpaper\*) do copy "%%i" "%Wallpaper%"
for %%i in ("%Wallpaper%\..\CachedFiles\*") do copy nul "%%i"

shutdown /l

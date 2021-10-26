#requires -RunAsAdministrator

Push-Location $PSScriptRoot

# Copy regional and language settings to all users and also the system account (logonUI screen)
Start-Process control 'intl.cpl,,/f:"Language.xml"' -Wait
Remove-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize' 'GUIFont.*'

Pop-Location

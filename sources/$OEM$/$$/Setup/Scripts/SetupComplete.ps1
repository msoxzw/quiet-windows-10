Rename-Computer -NewName Computer


# Set DNS server addresses with Anonymized EDNS Client Subnet support and no logging only if any of them are operational.
$DNS = '45.90.28.0','45.90.30.0','2a07:a8c0::', '2a07:a8c1::'
Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses $DNS -Validate

# Configure preferences for Windows Defender
Set-MpPreference -MAPSReporting Disabled -PUAProtection Disabled -SubmitSamplesConsent NeverSend

# Disable Windows Error Reporting
Disable-WindowsErrorReporting

# Remove all apps for the local system except Microsoft Store
Get-AppxProvisionedPackage -Online | Where-Object DisplayName 'Microsoft.WindowsStore' -NE | Remove-AppxProvisionedPackage -Online

# Remove all Windows capabilities for the local system except language capabilities
# Get-WindowsCapability -Online -LimitAccess | Where-Object {$_.Name -notlike 'Language.*' -and $_.State -eq 'Installed'} | Remove-WindowsCapability -Online

# Disable all Windows optional features for the local system
# Get-WindowsOptionalFeature -Online | Where-Object State 'Enabled' -EQ | Disable-WindowsOptionalFeature -Online -Remove -NoRestart

# Encrypt the existing used space on the system volume
Enable-BitLocker $env:SystemDrive -UsedSpaceOnly

# Disable the hibernate feature
powercfg /hibernate off

# Set time zone automatically
Set-Service 'tzautoupdate' -StartupType Manual

# Change the default time server to pool.ntp.org
# https://www.ntppool.org/use.html
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"


# Turn off all startup apps for the system account
(Get-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run').Property.ForEach({[Microsoft.Win32.Registry]::SetValue('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run', $_, [byte[]]3)})

# Download and install apps when any network connection is available
[Microsoft.Win32.Registry]::SetValue('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce', 'Install', 'schtasks /create /tn Install /xml "%SystemDrive%\Software\Install.xml" /f')

# Configure system and apps for the system account
Join-Path $env:SystemDrive 'Software\Config\Registry\System\*.reg' -Resolve | ForEach-Object {reg import $_}


reg load 'HKU\Default' (Join-Path $env:SystemDrive 'Users\Default\NTUSER.DAT')

# Turn off all startup apps for a new user account
(Get-Item 'HKEY_USERS\Default\Software\Microsoft\Windows\CurrentVersion\Run').Property.ForEach({[Microsoft.Win32.Registry]::SetValue('HKEY_USERS\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run', $_, [byte[]]3)})

# Configure system and apps for a new user account when signing in to the computer for the first time
[Microsoft.Win32.Registry]::SetValue('HKEY_USERS\Default\Software\Microsoft\Windows\CurrentVersion\RunOnce', 'Setup', '%SystemDrive%\Software\Config\setup.cmd')

reg unload 'HKU\Default'


Restart-Computer

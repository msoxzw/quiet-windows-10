Rename-Computer -NewName Computer


# Set DNS server addresses with Anonymized EDNS Client Subnet support and no logging only if any of them are operational.
$DNS = '45.90.28.0','45.90.30.0','2a07:a8c0::', '2a07:a8c1::'
Resolve-DnsName example.com -Server $DNS
if ($?) {
    Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses $DNS
}

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
powercfg /h off

# Set time zone automatically
Set-Service 'tzautoupdate' -StartupType Manual

# Change the default time server to pool.ntp.org
# https://www.ntppool.org/use.html
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"


# Turn off all startup apps for the system account
$key = New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run' -Force
(Get-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run').Property.ForEach({$key.SetValue($_, [byte[]]3)})

# Download and install apps when any network connection is available
$key = New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Force
$key.SetValue('Install', 'schtasks /create /tn Install /xml "%SystemDrive%\Software\Install.xml" /f')

# Configure system and apps for the system account
Join-Path $env:SystemDrive 'Software\Config\Registry\System\*.reg' -Resolve | ForEach-Object {reg import $_}


reg load 'HKLM\Default' (Join-Path $env:SystemDrive 'Users\Default\NTUSER.DAT')

# Turn off all startup apps for a new user account
$key = New-Item 'HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run' -Force
(Get-Item 'HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Run').Property.ForEach({$key.SetValue($_, [byte[]]3)})

# Configure system and apps for a new user account when signing in to the computer for the first time
$key = New-Item 'HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\RunOnce' -Force
$key.SetValue('Setup', '%SystemDrive%\Software\Config\setup.cmd')

reg unload 'HKLM\Default'


Restart-Computer

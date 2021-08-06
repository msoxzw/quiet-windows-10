Push-Location $PSScriptRoot

explorer

# Enable MAC randomization on all wireless LAN interfaces
netsh wlan set randomization enabled=yes interface=*

# Set the current time zone to Coordinated Universal Time
# Set-TimeZone -Id 'UTC'

# Set the culture for the current user account to United States
# Set-Culture -CultureInfo en-US

# Set the home location for the current user account to 0xF4 (hex) (United States)
Set-WinHomeLocation -GeoId 0xF4

# Insert the language English (United States) to the user's language list
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Insert(0, 'en-US')
# Set-WinUserLanguageList -LanguageList $LanguageList -Force


# Turn off all app permissions for the current user account
foreach ($Capability in Get-ChildItem 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\Capabilities' -Name) {
    [Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\$Capability", 'Value', 'Deny')
}

# Turn off all suggestions for the current user account
$key = Get-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
$key.Property.ForEach({Set-ItemProperty $key.PSPath $_ 0})

# Clear Start layout for the current user account
Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore' -Recurse

# Clear taskbar for the current user account
Clear-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'

# Configure system and apps for the current user account
Get-ChildItem 'Files' -Directory | ForEach-Object {Copy-Item (Join-Path $_.FullName '*') (Get-Item env:$_).Value -Force -Recurse}
Join-Path 'Registry' '*.reg' -Resolve | ForEach-Object {reg import $_}


# Add Internet Explorer Tracking Protection Lists from known Adblock Plus subscriptions and by language
& '.\Add Tracking Protection Lists.ps1'

# Configure Chromium based browsers
[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce', 'Chromium', 'PowerShell -ExecutionPolicy Bypass -File "%SystemDrive%\Software\Chromium\Preferences.ps1"', [Microsoft.Win32.RegistryValueKind]::ExpandString)

# Configure IrfanView
if ([Environment]::Is64BitOperatingSystem) {
    New-Item (Join-Path $env:AppData 'IrfanView\i_view64.ini') -ItemType HardLink -Value (Join-Path $env:AppData 'IrfanView\i_view32.ini')
}

# Configure madVR
[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\madshi\madVR', 'Settings', [System.IO.File]::ReadAllBytes((Resolve-Path 'settings.bin')))


# Clear desktop for the current user account
Remove-Item (Join-Path $HOME 'Desktop\*.lnk')

# Specify the desktop background without changing any setting
$Wallpaper = Join-Path $env:AppData 'Microsoft\Windows\Themes\TranscodedWallpaper'

Copy-Item (Join-Path 'Wallpaper' '*') $Wallpaper
Clear-Content (Join-Path $Wallpaper '..\CachedFiles\*')

shutdown /l

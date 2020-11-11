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
$LanguageList = Get-WinUserLanguageList
$LanguageList.Insert(0, 'en-US')
Set-WinUserLanguageList -LanguageList $LanguageList -Force


# Turn off all app permissions for the current user account
foreach ($Capability in Get-ChildItem 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\Capabilities' -Name) {
	[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\$Capability", 'Value', 'Deny')
}

# Turn off all suggestions for the current user account
$key = Get-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
$key.Property.ForEach({Set-ItemProperty $key.PSPath $_ 0})

# Clear taskbar for the current user account
Clear-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'

# Configure system and apps for the current user account
Get-ChildItem 'Files' -Directory | ForEach-Object {Copy-Item (Join-Path $_.FullName '*') (Get-Item env:$_).Value -Force -Recurse}
Join-Path 'Registry' '*.reg' -Resolve | ForEach-Object {reg import $_}


# Add Internet Explorer Tracking Protection Lists
(Get-Content 'Internet Explorer.json' -Raw | ConvertFrom-Json) | ForEach-Object {$_ | Set-ItemProperty (New-Item 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists' -Name "{$(New-Guid)}".ToUpper() -Force).PSPath}

# Configure madVR
[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\madshi\madVR', 'Settings', [System.IO.File]::ReadAllBytes((Resolve-Path 'settings.bin')))


# Clear desktop for the current user account
Remove-Item (Join-Path $HOME 'Desktop\*.lnk')

# Turn off activity history
$CDPPath = Join-Path $env:LocalAppdata 'ConnectedDevicesPlatform\CDPGlobalSettings.cdp'
$CDP = Get-Content $CDPPath -Raw | ConvertFrom-Json
$CDP.AfcPrivacySettings.PublishUserActivity = 1
$CDP.AfcPrivacySettings.UploadUserActivity = 1
ConvertTo-Json $CDP | Set-Content $CDPPath -NoNewline

# Specify the desktop background without changing any setting
$Wallpaper = Join-Path $env:AppData 'Microsoft\Windows\Themes\TranscodedWallpaper'

Copy-Item (Join-Path 'Wallpaper' '*') $Wallpaper
Clear-Content (Join-Path $Wallpaper '..\CachedFiles\*')

logoff

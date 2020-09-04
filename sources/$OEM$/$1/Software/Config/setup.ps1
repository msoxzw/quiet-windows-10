Push-Location $PSScriptRoot

explorer

# Enable MAC randomization on all wireless LAN interfaces
netsh wlan set randomization enabled=yes interface=*

# Clear desktop for the current user account
Remove-Item (Join-Path $HOME 'Desktop\*.lnk')

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
foreach ($Capability in Get-ChildItem 'HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\Capabilities') {
	$key = New-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore' -Name $Capability -Force
	$key.SetValue('Value', 'Deny')
}

# Turn off all suggestions for the current user account
$key = Get-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
$key.Property.ForEach({Set-ItemProperty $key.PSPath $_ 0})

# Clear Start layout for the current user account
Remove-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore' -Recurse

# Clear taskbar for the current user account
Clear-Item 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'

# Configure system and apps for the current user account
Get-ChildItem 'Files' -Directory | ForEach-Object {Copy-Item (Join-Path $_ '*') (Get-Item env:$_) -Force -Recurse}
Get-Item 'Registry\*.reg' | ForEach-Object {reg import $_}


# Add Internet Explorer Tracking Protection Lists
(Get-Content 'Internet Explorer.json' -Raw | ConvertFrom-Json) | ForEach-Object {$_ | Set-ItemProperty (New-Item 'HKCU:\Software\Microsoft\Internet Explorer\Safety\PrivacIE\Lists' -Name "{$(New-Guid)}".ToUpper() -Force).PSPath}

# Configure madVR
$key = New-Item 'HKCU:\Software\madshi\madVR' -Force
$key.SetValue('Settings', [System.IO.File]::ReadAllBytes((Get-Item 'settings.bin')))

# Specify the desktop background without changing any setting
$Wallpaper = Join-Path $env:AppData 'Microsoft\Windows\Themes\TranscodedWallpaper'

Copy-Item 'Wallpaper\*' $Wallpaper
Clear-Content (Join-Path $Wallpaper '..\CachedFiles\*')

logoff

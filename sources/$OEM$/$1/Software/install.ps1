Push-Location $PSScriptRoot

# Set DNS server addresses with Anonymized EDNS Client Subnet support and no logging only if any of them are operational.
$DNS = '45.90.28.0','45.90.30.0','2a07:a8c0::', '2a07:a8c1::'
Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses $DNS -Validate

# Install Chocolatey
while ($env:ChocolateyInstall -eq $null) {
    $env:chocolateyUseWindowsCompression = 'true'
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
}

# Install Chocolatey packages
$choco = Join-Path $env:ChocolateyInstall 'choco.exe'
$packages = '7zip adobereader aria2 ccleaner.portable ffmpeg firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent stubby thunderbird'.Split()
do {
	& $choco install $packages -y
} until ($?)


# Associate archive formats with 7-Zip with the system default icon
$DefaultIcon = Get-ItemPropertyValue 'Registry::HKEY_CLASSES_ROOT\CompressedFolder\DefaultIcon' '(Default)'
$OpenCommend = '"{0}" "%1"' -f (Get-ItemPropertyValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' 'DisplayIcon')
$FileTypes = '001 7z arj bz2 bzip2 cpio deb gz gzip lha lzh lzma rar rpm tar taz tbz tbz2 tgz tpz txz xar xz z zip'.Split()
foreach ($FileType in $FileTypes) {
	[Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\.$FileType", "", "7-Zip.$FileType")
	[Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType", "", "$FileType Archive")
	[Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType\DefaultIcon", "", $DefaultIcon)
	[Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType\Shell\Open\Command", "", $OpenCommend)
}


# Configure CCleaner Portable
$CCleaner = Get-Item 'HKCU:\Software\Piriform\CCleaner'
$CCleaner.GetValueNames() | ForEach-Object {'[Options]'} {'{0}={1}' -f $_, $CCleaner.GetValue($_)} | Set-Content (Join-Path $env:ChocolateyInstall 'lib\ccleaner.portable\tools\ccleaner.ini')

# Copy regional and language settings to all users and also the system account (logonUI screen)
control 'intl.cpl,,/f:"Language.xml"'
Clear-Item 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize'


# Set desktop backgroud as the default lock screen image without changing any setting
# Require turning off all suggestions
takeown /f (Join-Path $env:ProgramData 'Microsoft\Windows\SystemData') /a /r /d y
$ScreenPath = Join-Path $env:ProgramData 'Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z'
$WallpaperPath = Join-Path $env:AppData 'Microsoft\Windows\Themes\CachedFiles'
foreach ($image in Get-ChildItem $WallpaperPath 'CachedImage_*') {
    $name = 'LockScreen___{0:d4}_{1:d4}_notdimmed.jpg' -f $image.BaseName.Split('_')[1,2]
    New-Item $ScreenPath -Name $name -ItemType SymbolicLink -Value $image.FullName -Force
}


# Configure Chromium based browsers
& (Join-Path 'Chromium' 'setup.ps1')

# Configure Firefox and Thunderbird with the custom install directory
& (Join-Path 'Mozilla' 'setup.ps1')

# Download and install the latest Source Han Super OTC
# Change the default fonts for Chinese, Japanese, and Korean (CJK) languages to Source Han
# & (Join-Path 'Fonts' 'setup.ps1')


Get-ChildItem 'Tasks' '*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_.FullName -Raw)}

# Set local DNS server addresses only if any of them are operational.
Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses (Resolve-DnsName 'localhost').IPAddress -Validate

Disable-ScheduledTask 'Install'

Pop-Location

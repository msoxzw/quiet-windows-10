Push-Location $PSScriptRoot

# Set DNS server addresses only if any of them are operational.
$DNS = '8.8.8.8','8.8.4.4','2001:4860:4860::8888','2001:4860:4860::8844'
Resolve-DnsName 'example.com' -Server $DNS
if ($?) {
	Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses $DNS
}

# Install Chocolatey
while ($env:ChocolateyInstall -eq $null) {
    $env:chocolateyUseWindowsCompression = 'true'
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
}

# Install Chocolatey packages
$choco = Join-Path $env:ChocolateyInstall 'choco'
$packages = '7zip adobereader aria2 ccleaner.portable ffmpeg firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent thunderbird'.Split()
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
Start-Process control 'intl.cpl,,/f:"Language.xml"' -Wait
Clear-Item 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize'


# Set desktop backgroud as the default lock screen image without changing any settings
# Require turning off all suggestions
takeown /f (Join-Path $env:ProgramData 'Microsoft\Windows\SystemData') /a /r /d y
$ScreenPath = Join-Path $env:ProgramData 'Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z'
$WallpaperPath = Join-Path $env:AppData 'Microsoft\Windows\Themes\CachedFiles'
foreach ($image in Get-ChildItem $WallpaperPath 'CachedImage_*') {
    $name = 'LockScreen___{0}_{1}_notdimmed.jpg' -f $image.BaseName.Split('_')[1, 2].PadLeft(4, '0')
    New-Item $ScreenPath -Name $name -ItemType SymbolicLink -Value $image.FullName -Force
}


# Add Internet Explorer Tracking Protection Lists from known Adblock Plus subscriptions and by language
& (Join-Path 'Config' 'Add Tracking Protection Lists.ps1')

# Configure Chromium based browsers
& (Join-Path 'Chromium' 'Policies.ps1')

# Configure Firefox and Thunderbird with the custom install directory
& (Join-Path 'Mozilla' 'setup.ps1')


Get-ChildItem 'Tasks' '*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_.FullName -Raw) -Force}

Disable-ScheduledTask 'Install'

Pop-Location

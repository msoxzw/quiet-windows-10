Push-Location $PSScriptRoot

# Set DNS server addresses with Anonymized EDNS Client Subnet support and no logging only if any of them are operational.
$DNS = '45.90.28.0','45.90.30.0','2a07:a8c0::', '2a07:a8c1::'
Resolve-DnsName example.com -Server $DNS
if ($?) {
    Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses $DNS
}

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
$OpenCommend = '"{0}" "%1"' -f (Get-ItemPropertyValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' 'DisplayIcon')
$FileTypes = '001 7z arj bz2 bzip2 cpio deb gz gzip lha lzh lzma rar rpm tar taz tbz tbz2 tgz tpz txz xz z zip'
foreach ($FileType in $FileTypes) {
	New-Item "HKLM:\Software\Classes\.$FileType" -Value "7-Zip.$FileType" -Force
	New-Item "HKLM:\Software\Classes\7-Zip.$FileType" -Value "$FileType Archive" -Force
	New-Item "HKLM:\Software\Classes\7-Zip.$FileType\Shell\Open\Command" -Value $OpenCommend -Force
	Copy-Item "HKLM:\Software\Classes\CompressedFolder\DefaultIcon" "HKLM:\Software\Classes\7-Zip.$FileType"
}


# Configure CCleaner Portable
$ccleaner_ini = Join-Path $env:ChocolateyInstall 'lib\ccleaner.portable\tools\ccleaner.ini'
Set-Content $ccleaner_ini '[Options]'
$CCleaner = Get-Item 'HKCU:\Software\Piriform\CCleaner'
$CCleaner.GetValueNames() | ForEach-Object {"$_=$($CCleaner.GetValue($_))"} | Add-Content $ccleaner_ini

# Copy regional and language settings to all users and also the system account (logonUI screen)
control 'intl.cpl,,/f:"Language.xml"'
Clear-Item 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize'


# Set desktop backgroud as the default lock screen image without changing any setting
# Require turning off all suggestions
takeown /f (Join-Path $env:ProgramData 'Microsoft\Windows\SystemData') /a /r /d y
$ScreenPath = Join-Path $env:ProgramData 'Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z'
$WallpaperPath = Join-Path $env:AppData 'Microsoft\Windows\Themes\CachedFiles'
foreach ($image in Get-ChildItem $WallpaperPath -Filter 'CachedImage_*') {
    $name = 'LockScreen___{0:d4}_{1:d4}_notdimmed.jpg' -f $image.Name.Split('_')[1,2]
    New-Item $ScreenPath -Name $name -ItemType SymbolicLink -Value $image -Force
}


# Configure Chromium based browsers
& 'Chromium\setup.ps1'

# Configure Firefox and Thunderbird with the custom install directory
& 'Mozilla\setup.ps1'

# Download and install the latest Source Han Super OTC
# Change the default fonts for Chinese, Japanese, and Korean (CJK) languages to Source Han
# & 'Fonts\setup.ps1'


Get-Item 'Tasks\*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_ -Raw)}

# Set local DNS server addresses only if any of them are operational.
Resolve-DnsName example.com -Server 'localhost'
if ($?) {
    Get-NetAdapter -Physical | Set-DnsClientServerAddress -ServerAddresses (Resolve-DnsName 'localhost').IPAddress
}

Disable-ScheduledTask 'Install'

Pop-Location

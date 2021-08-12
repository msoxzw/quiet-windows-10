Push-Location $PSScriptRoot

$packages = '7zip adobereader aria2 ccleaner.portable firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent thunderbird'

# Install Chocolatey
if ((Get-AuthenticodeSignature "$env:ChocolateyInstall\choco.exe" -ErrorAction 0).Status -ne 0) {
    $file = Join-Path $env:TEMP 'install.ps1'
    do {
        Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing -OutFile $file
    } until ((Get-AuthenticodeSignature $file).Status -eq 0)
    $env:chocolateyUseWindowsCompression = 'true'
    do {
        & $file
    } until ((Get-AuthenticodeSignature "$env:ChocolateyInstall\choco.exe").Status -eq 0)
}

# Install Chocolatey packages
do {
    & "$env:ChocolateyInstall\choco.exe" install $packages.Split() -y
} until ($?)


# Associate archive formats with 7-Zip with the system default icon
$7z = Get-ItemPropertyValue 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\7-Zip' 'DisplayIcon'
if ($7z) {
    $DefaultIcon = Get-ItemPropertyValue 'Registry::HKEY_CLASSES_ROOT\CompressedFolder\DefaultIcon' '(Default)'
    $OpenCommend = '"{0}" "%1"' -f $7z
    $FileTypes = '001 7z arj bz2 bzip2 cpio deb gz gzip lha lzh lzma rar rpm tar taz tbz tbz2 tgz tpz txz xar xz z zip'.Split()
    foreach ($FileType in $FileTypes) {
        [Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\.$FileType", "", "7-Zip.$FileType")
        [Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType", "", "$FileType Archive")
        [Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType\DefaultIcon", "", $DefaultIcon)
        [Microsoft.Win32.Registry]::SetValue("HKEY_CLASSES_ROOT\7-Zip.$FileType\Shell\Open\Command", "", $OpenCommend)
    }
}


# Configure CCleaner Portable
$CCleaner = Get-Item 'HKCU:\Software\Piriform\CCleaner'
$ccleaner_ini = Join-Path $env:ChocolateyInstall 'lib\ccleaner.portable\tools\ccleaner.ini'
New-Item $ccleaner_ini -Force
$CCleaner.GetValueNames() | ForEach-Object {'[Options]'} {'{0}={1}' -f $_, $CCleaner.GetValue($_)} | Set-Content $ccleaner_ini

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
& (Join-Path 'Microsoft' 'Internet Explorer\Add Tracking Protection Lists.ps1')

# Configure Chromium based browsers
& (Join-Path 'Chromium' 'Policies.ps1')

# Configure Firefox and Thunderbird with the custom install directory
& (Join-Path 'Mozilla' 'setup.ps1')


Get-ChildItem 'Tasks' '*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_.FullName -Raw) -Force}

Unregister-ScheduledTask 'Install' -Confirm:$false

Pop-Location

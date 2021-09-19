Push-Location $PSScriptRoot

[System.Collections.Generic.HashSet[string]]$packages = '7zip adobereader aria2 ccleaner.portable firefox git hashcheck irfanviewplugins mpv notepadplusplus qbittorrent thunderbird'.Split()

# Install packages with automatic delta update instead of Chocolatey
$AutoUpdateApps = @{
    'adobereader' = 'Adobe\Reader\Install.ps1'
    'microsoft-edge' = '"Chromium\Install.ps1" -Product edge -SystemLevel'
    'microsoft-edge-insider' = '"Chromium\Install.ps1" -Product edge -Channel beta -SystemLevel'
    'microsoft-edge-insider-dev' = '"Chromium\Install.ps1" -Product edge -Channel dev -SystemLevel'
    'microsoft-edge-insider-canary' = '"Chromium\Install.ps1" -Product edge -Channel canary'
    'firefox' = '"Mozilla\Install.ps1" -Product firefox'
    'firefox-beta' = '"Mozilla\Install.ps1" -Product firefox -Channel beta'
    'firefox-dev' = '"Mozilla\Install.ps1" -Product firefox -Channel aurora'
    'firefox-nightly' = '"Mozilla\Install.ps1" -Product firefox -Channel nightly'
    'googlechrome' = '"Chromium\Install.ps1" -Product chrome -SystemLevel'
    'googlechrome.beta' = '"Chromium\Install.ps1" -Product chrome -Channel beta -SystemLevel'
    'googlechrome.dev' = '"Chromium\Install.ps1" -Product chrome -Channel dev -SystemLevel'
    'googlechrome.canary' = '"Chromium\Install.ps1" -Product chrome -Channel canary'
    'thunderbird' = '"Mozilla\Install.ps1" -Product thunderbird'
    'thunderbird-beta' = '"Mozilla\Install.ps1" -Product thunderbird -Channel beta'
    'thunderbird-nightly' = '"Mozilla\Install.ps1" -Product thunderbird -Channel nightly'
}
$AutoUpdateApps.GetEnumerator() | ForEach-Object {if ($packages.Remove($_.Key)) {Start-Process PowerShell '-File', $_.Value}}

# Install Chocolatey
[uri]$uri = 'https://chocolatey.org/install.ps1'
$file = Join-Path $env:TEMP (Split-Path $uri -Leaf)
while ($true) {
    Start-BitsTransfer $uri $file -Dynamic
    if ($?) {
        'A', 'A' | PowerShell -ExecutionPolicy AllSigned -File $file
        if ($?) {
            $env:ChocolateyInstall = [Environment]::GetEnvironmentVariable('ChocolateyInstall', 'Machine')
            break
        }
    }
    Start-Sleep 600
}

# Install Chocolatey packages
$Signature = Get-AuthenticodeSignature (Join-Path $env:ChocolateyInstall 'choco.exe')
if ($Signature.Status -ne 'Valid') {exit}
while ($true) {
    & $Signature.Path install $packages -y
    if ($?) {break}
    Start-Sleep 600
}


# Associate archive formats with 7-Zip with the system default icon
$7z = (Get-Package '7-Zip *').Metadata['DisplayIcon']
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


# Copy regional and language settings to all users and also the system account (logonUI screen)
Start-Process control 'intl.cpl,,/f:"Language.xml"' -Wait
Remove-ItemProperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\GRE_Initialize' 'GUIFont.*'


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

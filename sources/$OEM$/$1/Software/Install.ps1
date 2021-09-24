#requires -RunAsAdministrator
Push-Location $PSScriptRoot

[System.Collections.Generic.HashSet[string]]$packages = (Get-Content 'Packages.txt' -Raw).Split()

# Install packages with automatic delta update instead of Chocolatey
$AutoUpdateApps = Import-PowerShellDataFile 'AutoUpdateApps.psd1'
$AutoUpdateApps.GetEnumerator() | ForEach-Object {if ($packages.Remove($_.Key)) {& $_.Value}}


# Install Chocolatey
New-Item "FileSystem::$env:ChocolateyInstall" -ItemType Directory -Force
if (-not $?) {$env:ChocolateyInstall = Join-Path $env:ProgramData 'chocolatey'}
[Environment]::SetEnvironmentVariable('ChocolateyInstall', $env:ChocolateyInstall, 'Machine')

$choco = Join-Path $env:ChocolateyInstall 'choco.exe'
$Signature = Get-AuthenticodeSignature $choco
if ($Signature.Status -ne 'Valid') {
    Write-Warning $Signature.StatusMessage
    $uri = 'https://chocolatey.org/api/v2/package/chocolatey'
    $file = Join-Path $env:ChocolateyInstall 'lib\chocolatey\chocolatey.nupkg'
    New-Item $file -Force

    while ($true) {
        Start-BitsTransfer $uri $file -Dynamic
        if ($?) {
            tar -xf $file -C $env:ChocolateyInstall --strip-components=2 'tools/chocolateyInstall'
            if ($?) {
                $Signature = Get-AuthenticodeSignature $choco
                if ($Signature.Status -eq 'Valid') {break}
                Write-Warning $Signature.StatusMessage
            }
        }
        & '.\Sleep.ps1'
    }
}

# Install Chocolatey packages
while ($true) {
    & $Signature.Path install $packages -y
    if ($?) {break}
    & '.\Sleep.ps1'
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


# Add Internet Explorer Tracking Protection Lists from known Adblock Plus subscriptions and by language
& (Join-Path 'Microsoft' 'Internet Explorer\Add Tracking Protection Lists.ps1')

# Configure Chromium based browsers
& (Join-Path 'Chromium' 'Policies.ps1')

Join-Path 'Microsoft' '*.ps1' -Resolve | ForEach-Object {& $_}

Get-ChildItem 'Tasks' '*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_.FullName -Raw) -Force}

Unregister-ScheduledTask 'Install' -Confirm:$false

Pop-Location

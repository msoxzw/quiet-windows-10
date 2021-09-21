#requires -RunAsAdministrator
Push-Location $PSScriptRoot

[System.Collections.Generic.HashSet[string]]$packages = (Get-Content 'Packages.txt' -Raw).Split()

# Install packages with automatic delta update instead of Chocolatey
$AutoUpdateApps = Import-PowerShellDataFile 'AutoUpdateApps.psd1'
$AutoUpdateApps.GetEnumerator() | ForEach-Object {if ($packages.Remove($_.Key)) {& $_.Value}}

$Sleep = [scriptblock]::Create((Get-Content 'Sleep.ps1' -Raw))

# Install Chocolatey
Set-ExecutionPolicy AllSigned Process
[uri]$uri = 'https://chocolatey.org/install.ps1'
$file = Join-Path $env:Temp (Split-Path $uri -Leaf)
while ($true) {
    Invoke-WebRequest $uri -UseBasicParsing -OutFile $file
    if ($?) {
        & $file
        if ($?) {
            $Signature = Get-AuthenticodeSignature (Join-Path $env:ChocolateyInstall 'choco.exe')
            if ($Signature.Status -eq 'Valid') {break}
            else {Remove-Item $env:ChocolateyInstall -Recurse}
        }
    }
    & $Sleep
}

# Install Chocolatey packages
while ($true) {
    & $Signature.Path install $packages -y
    if ($?) {break}
    & $Sleep
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

#requires -RunAsAdministrator

Push-Location $PSScriptRoot

. '.\helpers.ps1'

# Install Chocolatey
New-Item "FileSystem::$env:ChocolateyInstall" -ItemType Directory -Force
if (-not $?) {$env:ChocolateyInstall = Join-Path $env:ProgramData 'chocolatey'}
[Environment]::SetEnvironmentVariable('ChocolateyInstall', $env:ChocolateyInstall, 'Machine')

$choco = Join-Path $env:ChocolateyInstall 'choco.exe'
if (-not (Verify-Signature $choco)) {
    $uri = 'https://chocolatey.org/api/v2/package/chocolatey'
    $file = Join-Path $env:ChocolateyInstall 'lib\chocolatey\chocolatey.nupkg'
    New-Item $file -Force

    while ($true) {
        Start-BitsTransfer $uri $file -Dynamic
        if ($?) {
            tar -xf $file -C $env:ChocolateyInstall --strip-components=2 'tools/chocolateyInstall'
            if ($? -and (Verify-Signature $choco)) {break}
        }
        Retry-After
    }
}

# Install packages
$AutoUpdateApps = Import-PowerShellDataFile 'AutoUpdateApps.psd1'
$packages = -split (Get-Content 'Packages.txt' -Raw) | ForEach-Object {if ($AutoUpdateApps.Contains($_)) {$AutoUpdateApps.$_} else {"& $choco install $_ -y"}} | ForEach-Object {[scriptblock]::Create('$null = {0}; -not $?' -f $_)}
while ($true) {
    $packages = $packages.Where({& $_})
    if (-not $packages) {break}
    Retry-After
}

Join-Path 'Microsoft' '*.ps1' -Resolve | ForEach-Object {& $_}

Get-ChildItem 'Tasks' '*.xml' | ForEach-Object {Register-ScheduledTask $_.BaseName -Xml (Get-Content $_.FullName -Raw) -Force}

Pop-Location

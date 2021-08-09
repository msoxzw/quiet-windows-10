Push-Location $PSScriptRoot

$DiscImage = $args[0]
$DriveLetter = (Read-Host 'Enter the drive letter for installation media')[0]

$Source = (Mount-DiskImage $DiscImage | Get-Volume).DriveLetter + ':'
$Destination = $DriveLetter + ':'

Copy-Item (Join-Path $Source '*') $Destination -Force -Recurse

if (-not $?) {
    Write-Warning 'The disc image is too large to copy so it will be compressed.'
    $Dism = Join-Path $Source 'sources\dism.exe'
    $SourceImage = Join-Path $Source 'sources\install.wim'
    $DestinationImage = Join-Path $Destination 'sources\install.esd'
    Start-Process PowerShell "Get-WindowsImage -ImagePath $SourceImage | ForEach-Object {& $Dism /Export-Image /SourceImageFile:$SourceImage /SourceIndex:`$_.ImageIndex /DestinationImageFile:$DestinationImage /Compress:recovery}" -Verb RunAs -Wait
}

Copy-Item 'sources' $Destination -Force -Recurse

Dismount-DiskImage $DiscImage
Set-Partition -DriveLetter $DriveLetter -IsActive $true

Pop-Location

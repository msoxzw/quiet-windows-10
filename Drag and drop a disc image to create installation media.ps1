#requires -RunAsAdministrator

param (
    [Parameter(Mandatory)]
    [ValidateScript({Get-DiskImage $_})]
    [string]$DiscImage,

    [Parameter(Mandatory, HelpMessage='Enter a drive letter for installation media')]
    [ValidateScript({Get-Volume $_})]
    [char]$DriveLetter
)

$Source = (Mount-DiskImage $DiscImage | Get-Volume).DriveLetter + ':'
$Destination = $DriveLetter + ':'

Copy-Item (Join-Path $Source '*') $Destination -Force -Recurse

if (-not $?) {
    Write-Warning 'The disc image is too large to copy so it will be compressed.'
    $Dism = Join-Path $Source 'sources\dism.exe'
    $SourceImage = Join-Path $Source 'sources\install.wim'
    $DestinationImage = Join-Path $Destination 'sources\install.esd'
    Get-WindowsImage -ImagePath $SourceImage | ForEach-Object {& $Dism /Export-Image /SourceImageFile:$SourceImage /SourceIndex:$($_.ImageIndex) /DestinationImageFile:$DestinationImage /Compress:recovery}
}

Copy-Item (Join-Path $PSScriptRoot 'sources') $Destination -Force -Recurse

Dismount-DiskImage $DiscImage
Set-Partition -DriveLetter $DriveLetter -IsActive $true

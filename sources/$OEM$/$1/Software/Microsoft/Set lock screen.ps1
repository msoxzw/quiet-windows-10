#requires -RunAsAdministrator

# Set desktop backgroud as the default lock screen image without changing any settings
# Require turning off all suggestions
takeown /f (Join-Path $env:ProgramData 'Microsoft\Windows\SystemData') /a /r /d y
$ScreenPath = Join-Path $env:ProgramData 'Microsoft\Windows\SystemData\S-1-5-18\ReadOnly\LockScreen_Z'
$WallpaperPath = Join-Path $env:AppData 'Microsoft\Windows\Themes\CachedFiles'
foreach ($image in Get-ChildItem $WallpaperPath 'CachedImage_*') {
    $name = 'LockScreen___{0}_{1}_notdimmed.jpg' -f $image.BaseName.Split('_')[1, 2].PadLeft(4, '0')
    New-Item $ScreenPath -Name $name -ItemType SymbolicLink -Value $image.FullName -Force
}

#requires -RunAsAdministrator

Push-Location $PSScriptRoot

$Products = Import-PowerShellDataFile 'Products.psd1'
Get-ChildItem -Name -Directory | ForEach-Object {$Configuration = Join-Path $_ '*'; Get-Package $Products.$_.Values.Name.ForEach({"$_ (*)"}) -ErrorAction 0 | ForEach-Object {Copy-Item $Configuration $_.Metadata['InstallLocation'] -Force -Recurse}}

(Get-ScheduledTask '* Default Browser Agent *').Actions | ForEach-Object {& $_.Execute uninstall $_.Arguments.Split()[1]}

Pop-Location

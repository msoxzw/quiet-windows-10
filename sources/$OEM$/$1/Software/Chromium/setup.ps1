Push-Location $PSScriptRoot

$Directories = @{}
$Products = Import-PowerShellDataFile 'Products.psd1'
$Products.Keys | ForEach-Object {$Directories.$_ = $Products.$_.Values.Directory.ForEach({Join-Path $env:LocalAppData $_})}

Get-ChildItem -Name -Directory -PipelineVariable App | Get-ChildItem -Recurse -Name -File | ForEach-Object {$Patch = Join-Path $App $_; Join-Path $Directories.$App $_ | ForEach-Object {-join (Get-Content $_, $Patch -Raw -ErrorAction 0) -replace '\s*}\s*{', ',' | New-Item $_ -Force}}

[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Edge\SmartScreenEnabled', '', 0)
[Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Edge\SmartScreenPuaEnabled', '', 0)

Pop-Location

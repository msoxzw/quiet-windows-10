Push-Location $PSScriptRoot


Get-ChildItem -Directory | ForEach-Object {$Configuration = Join-Path $_ '*'; (Get-Package "Mozilla $_ *").Metadata['InstallLocation'] | ForEach-Object {Copy-Item $Configuration $_ -Force -Recurse}}

(Get-ScheduledTask '*Default Browser Agent*').Actions | ForEach-Object {& $_.Execute uninstall $_.Arguments.Split()[1]}

Pop-Location

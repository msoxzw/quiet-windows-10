Push-Location $PSScriptRoot

if (-not $args) {$args = '/configure'}
& '..\..\Install-VerifiedProgram.ps1' 'https://officecdn.microsoft.com/pr/wsus/setup.exe' $args

Pop-Location

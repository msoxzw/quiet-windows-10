Push-Location $PSScriptRoot

# https://docs.microsoft.com/deployoffice/overview-office-deployment-tool
if (-not $args) {$args = '/configure'}
& '..\..\Install-VerifiedProgram.ps1' 'https://officecdn.microsoft.com/pr/wsus/setup.exe' $args

Pop-Location

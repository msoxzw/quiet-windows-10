Push-Location $PSScriptRoot

. '..\..\Install-VerifiedProgram.ps1'

# https://docs.microsoft.com/deployoffice/overview-office-deployment-tool
$null = Install-VerifiedProgram 'https://officecdn.microsoft.com/pr/wsus/setup.exe' '/configure'

Pop-Location

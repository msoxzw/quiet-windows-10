Push-Location $PSScriptRoot

# https://docs.microsoft.com/deployoffice/overview-office-deployment-tool
& '..\..\Install-VerifiedProgram.ps1' 'https://officecdn.microsoft.com/pr/wsus/setup.exe' '/configure'

Pop-Location

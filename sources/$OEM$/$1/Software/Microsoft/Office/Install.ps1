Push-Location $PSScriptRoot

$Uri = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
$Arguments = if ($args) {$args} else {'/configure'}

& '..\..\Install-VerifiedProgram.ps1' $Uri $Arguments

Pop-Location

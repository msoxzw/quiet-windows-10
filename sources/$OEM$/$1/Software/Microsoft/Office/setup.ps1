Push-Location $PSScriptRoot

$url = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
$file = Split-Path $url -Leaf

do {
    Start-BitsTransfer $url
} until ((Get-AuthenticodeSignature $file).Status -eq 0)
& ".\$file" /configure

Pop-Location

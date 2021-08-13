Push-Location $PSScriptRoot

$url = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
$file = Split-Path $url -Leaf

while ($true) {
    Start-BitsTransfer $url
    if ($?) {
        $Signature = Get-AuthenticodeSignature $file
        if ($Signature.Status -eq 'Valid') {
            & $Signature.Path /configure
            break
        }
    }
}

Pop-Location

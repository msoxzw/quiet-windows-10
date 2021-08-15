Push-Location $PSScriptRoot

$url = 'https://officecdn.microsoft.com/pr/wsus/setup.exe'
$file = Split-Path $url -Leaf

while ($true) {
    Start-BitsTransfer $url
    if ($?) {
        $Signature = Get-AuthenticodeSignature $file
        if ($Signature.Status -eq 'Valid') {
            Start-Process $Signature.Path '/configure' -Verb RunAs
            break
        }
    }
    Start-Sleep 600
}

Pop-Location

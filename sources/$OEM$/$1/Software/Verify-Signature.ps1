
param (
    [Parameter(Mandatory)]
    [string]$Path
)

$Signature = Get-AuthenticodeSignature -LiteralPath $Path
if ($?) {
    if ($Signature.Status -eq 'Valid') {return $true}
    Write-Warning $Signature.StatusMessage
    return $false
}


param (
    [Parameter(Mandatory, Position=0)]
    [uri]$Source,

    [Parameter(Position=1)]
    [string]$Arguments,

    [string]$Destination = (Split-Path $Source -Leaf),

    [switch]$Dynamic,

    [int]$RetryInterval = 600
)

while ($true) {
    Start-BitsTransfer $Source $Destination -Dynamic:$Dynamic
    if ($?) {
        $Signature = Get-AuthenticodeSignature $Destination
        if ($Signature.Status -eq 'Valid') {
            return [System.Diagnostics.Process]::Start(@{FileName = $Signature.Path; Arguments = $Arguments; Verb = 'runas'})
        }
        Write-Warning $Signature.StatusMessage
    }
    $Date = (Get-Date).AddSeconds($RetryInterval)
    for ($i = $RetryInterval; -not $Host.UI.RawUI.KeyAvailable -and $i -gt 0; $i--) {
        Write-Progress "Retry after $Date, press a key to continue ..." 'Waiting' -SecondsRemaining $i
        Start-Sleep 1
    }
}

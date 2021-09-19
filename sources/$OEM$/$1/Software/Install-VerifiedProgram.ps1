[CmdletBinding(DefaultParameterSetName = 'Uri')]
param (
    [Parameter(Mandatory, ParameterSetName = 'Uri', Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Uri,

    [Parameter(Mandatory, ParameterSetName = 'ScriptBlock', Position = 0)]
    [ValidateNotNullOrEmpty()]
    [scriptblock]$ScriptBlock,

    [Parameter(Position=1)]
    [string[]]$Arguments,

    [string]$Destination,

    [switch]$Dynamic,

    [switch]$Wait,

    [int]$RetryInterval = 600
)

while ($true) {
    [uri]$Source = switch ($PSCmdlet.ParameterSetName)
    {
        'Uri' {$Uri}
        'ScriptBlock' {& $ScriptBlock}
    }
    if (-not $Destination) {$Destination = Split-Path $Source -Leaf}
    Start-BitsTransfer $Source $Destination -Dynamic:$Dynamic
    if ($?) {
        $Signature = Get-AuthenticodeSignature $Destination
        if ($Signature.Status -eq 'Valid') {
            Start-Process $Signature.Path $Arguments -Verb 'runas' -Wait:$Wait
            break
        }
        Write-Warning $Signature.StatusMessage
    }
    $Date = (Get-Date).AddSeconds($RetryInterval)
    for ($i = $RetryInterval; -not [Console]::KeyAvailable -and $i -gt 0; --$i) {
        Write-Progress "Retry after $Date, press a key to continue ..." 'Waiting' -SecondsRemaining $i
        Start-Sleep 1
    }
}

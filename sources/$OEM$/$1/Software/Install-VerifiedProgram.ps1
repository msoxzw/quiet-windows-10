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

    [int]$RetryInterval = 600
)

$ExitCode = -1
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
            $ExitCode = (Start-Process $Signature.Path $Arguments -Verb 'runas' -PassThru -Wait).ExitCode
        }
        else {Write-Warning $Signature.StatusMessage}
    }
    if ($ExitCode -eq 0) {return $ExitCode}
    & (Join-Path $PSScriptRoot 'Sleep.ps1') $RetryInterval
}

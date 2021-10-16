function Install-VerifiedProgram
{
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

        [int]$RetryInterval = -1
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
        if ($? -and Verify-Signature $Destination) {
            $ExitCode = (Start-Process $Destination $Arguments -Verb 'runas' -PassThru -Wait).ExitCode
        }
        if ($RetryInterval < 0 -or $ExitCode -eq 0) {return $ExitCode}
        Sleep $RetryInterval
    }
}


function Verify-Signature
{
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
}


function Sleep
{
    param (
        [int]$RetryInterval = 600
    )

    $Date = (Get-Date).AddSeconds($RetryInterval)
    for ($i = $RetryInterval; -not [Console]::KeyAvailable -and $i -gt 0; --$i) {
        Write-Progress "Retry after $Date, press a key to continue ..." 'Waiting' -SecondsRemaining $i
        Start-Sleep 1
    }
}

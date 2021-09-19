param (
    [int]$RetryInterval = 600
)

$Date = (Get-Date).AddSeconds($RetryInterval)
for ($i = $RetryInterval; -not [Console]::KeyAvailable -and $i -gt 0; --$i) {
    Write-Progress "Retry after $Date, press a key to continue ..." 'Waiting' -SecondsRemaining $i
    Start-Sleep 1
}

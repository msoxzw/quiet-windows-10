#requires -RunAsAdministrator

Push-Location $PSScriptRoot

$Keys = Select-String -Pattern '(?<=^\[)[^]]+(?=\]$)' -Path '*.reg' -List | Group-Object {$_.Matches.Value.EndsWith('\Chromium')}
$Chromium = $Keys[0].Group.ForEach({reg import $_.Path; $_.Matches.Value})
$Keys[1].Group.ForEach({reg copy $Chromium[0] $_.Matches.Value /s /f; reg import $_.Path})

Pop-Location

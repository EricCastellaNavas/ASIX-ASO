#requires -Version 7.0

$serveis = @(Get-Service)
$serveisEnExecucio = @($serveis | Where-Object { $_.Status -eq 'Running' })
$serveisNoExecutats = @($serveis | Where-Object { $_.Status -ne 'Running' })

Write-Output '===== ESTAT DELS SERVEIS ====='
Write-Output ''
Write-Output "Total: $($serveis.Count)"
Write-Output "Running: $($serveisEnExecucio.Count)"
Write-Output "Not running: $($serveisNoExecutats.Count)"

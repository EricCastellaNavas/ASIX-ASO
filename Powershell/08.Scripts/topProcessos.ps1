#requires -Version 7.0

$processos = @(Get-Process)

$processos |
    Sort-Object CPU -Descending |
    Select-Object -First 10 Name, Id, CPU |
    Format-Table -AutoSize

Write-Output "Nombre total de processos: $($processos.Count)"

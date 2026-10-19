#requires -Version 7.0

# =====================
# PROCESSOS
# =====================
$processos = @(Get-Process)
Write-Output '===== PROCESSOS ====='
$processos |
    Sort-Object CPU -Descending |
    Select-Object -First 5 Name, Id, CPU |
    Format-Table -AutoSize

# =====================
# SERVEIS
# =====================
$serveis = @(Get-Service)
$serveisEnExecucio = @($serveis | Where-Object { $_.Status -eq 'Running' })
$serveisNoExecutats = @($serveis | Where-Object { $_.Status -ne 'Running' })
Write-Output '===== SERVEIS ====='
Write-Output "Total de serveis: $($serveis.Count)"
Write-Output "Serveis en execució: $($serveisEnExecucio.Count)"
Write-Output "Serveis no executats: $($serveisNoExecutats.Count)"
Write-Output ''

# =====================
# FITXERS
# =====================
$fitxers = @(Get-ChildItem -Force -File)
Write-Output '===== FITXERS ====='
Write-Output 'Tres fitxers més grans (Length en bytes):'
if ($fitxers.Count -gt 0) {
    $fitxers |
        Sort-Object Length -Descending |
        Select-Object -First 3 Name, Length |
        Format-Table -AutoSize
} else {
    Write-Output 'No hi ha fitxers en aquesta carpeta.'
}

# =====================
# RESUM
# =====================
Write-Output '===== RESUM ====='
Write-Output ''
Write-Output "Processos analitzats: $($processos.Count)"
Write-Output "Serveis analitzats: $($serveis.Count)"
Write-Output "Fitxers analitzats: $($fitxers.Count)"

#requires -Version 7.0

$elements = @(Get-ChildItem -Force)
$fitxers = @($elements | Where-Object { -not $_.PSIsContainer })

Write-Output '===== ANÀLISI DE LA CARPETA ====='
Write-Output "Carpeta: $((Get-Location).Path)"
Write-Output "Nombre total d'elements: $($elements.Count)"
Write-Output ''
Write-Output 'Cinc fitxers més grans (Length en bytes):'

if ($fitxers.Count -gt 0) {
    $fitxers |
        Sort-Object Length -Descending |
        Select-Object -First 5 Name, Length |
        Format-Table -AutoSize
} else {
    Write-Output 'No hi ha fitxers en aquesta carpeta.'
}

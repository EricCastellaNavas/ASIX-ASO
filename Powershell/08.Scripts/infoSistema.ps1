#requires -Version 7.0

# Recullo les dades abans de mostrar-les.
$nomEquip = $env:COMPUTERNAME
$usuariActual = $env:USERNAME
$versioPowerShell = $PSVersionTable.PSVersion.ToString()
$dataActual = Get-Date -Format 'dd/MM/yyyy HH:mm:ss'
$directoriActual = (Get-Location).Path

Write-Output '===== INFORMACIÓ DEL SISTEMA ====='
Write-Output ''
Write-Output "Equip: $nomEquip"
Write-Output "Usuari: $usuariActual"
Write-Output "PowerShell: $versioPowerShell"
Write-Output "Data: $dataActual"
Write-Output "Directori actual: $directoriActual"

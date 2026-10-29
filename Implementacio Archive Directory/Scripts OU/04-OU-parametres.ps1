param (
    [string]$nomOU,
    [string]$ruta
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

if ([string]::IsNullOrWhiteSpace($nomOU) -or [string]::IsNullOrWhiteSpace($ruta)) {
    throw "Cal indicar -nomOU i -ruta."
}

$OU = Get-ADOrganizationalUnit -Filter { Name -eq $nomOU } `
    -SearchBase $ruta -SearchScope OneLevel

if (-not $OU) {
    $OU = New-ADOrganizationalUnit -Name $nomOU -Path $ruta -PassThru
    Write-Host "OU creada: $nomOU"
}
else {
    Write-Host "L'OU ja existeix: $nomOU"
}

$OU | Select-Object Name, DistinguishedName

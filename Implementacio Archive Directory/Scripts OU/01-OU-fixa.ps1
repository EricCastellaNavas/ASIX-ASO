$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

$nomOU = "MusicCloud"
$ruta = "DC=musiccloud,DC=local"

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

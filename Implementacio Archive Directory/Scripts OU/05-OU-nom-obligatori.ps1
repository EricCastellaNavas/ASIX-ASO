param (
    [Parameter(Mandatory=$true)]
    [string]$nomOU,

    [string]$ruta = "DC=musiccloud,DC=local"
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

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

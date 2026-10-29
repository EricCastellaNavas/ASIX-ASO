$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

if ($args.Count -ne 1) {
    throw 'Us: .\02-OU-nom-variable.ps1 "Usuaris"'
}

$nomOU = $args[0]
$ruta = "OU=MusicCloud,DC=musiccloud,DC=local"

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

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

if ($args.Count -ne 2) {
    throw 'Us: .\03-OU-nom-i-ruta.ps1 "Equips" "OU=MusicCloud,DC=musiccloud,DC=local"'
}

$nomOU = $args[0]
$ruta = $args[1]

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

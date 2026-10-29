param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ -not [string]::IsNullOrWhiteSpace($_) })]
    [string]$nomOU,

    [ValidateScript({ -not [string]::IsNullOrWhiteSpace($_) })]
    [string]$ruta = "DC=musiccloud,DC=local"
)

$ErrorActionPreference = "Stop"
Import-Module ActiveDirectory

# La ruta pot ser el domini o una OU.
try {
    $pare = Get-ADObject -Identity $ruta
}
catch {
    throw "No he pogut consultar la ruta '$ruta': $($_.Exception.Message)"
}

if ($pare.ObjectClass -notin @("domainDNS", "organizationalUnit")) {
    throw "La ruta ha de ser el domini o una OU."
}

$ruta = $pare.DistinguishedName
$OU = Get-ADOrganizationalUnit -Filter { Name -eq $nomOU } `
    -SearchBase $ruta -SearchScope OneLevel

if (-not $OU) {
    $OU = New-ADOrganizationalUnit -Name $nomOU -Path $ruta -PassThru
    Write-Host "OU creada: $nomOU"
}
else {
    Write-Host "L'OU ja existeix: $nomOU"
}

$departaments = @(
    "Direcció",
    "Administració",
    "Suport Tècnic",
    "Producció Musical",
    "Informàtica",
    "Externs"
)

foreach ($departament in $departaments) {
    $ouDepartament = Get-ADOrganizationalUnit -Filter { Name -eq $departament } `
        -SearchBase $OU.DistinguishedName -SearchScope OneLevel

    if (-not $ouDepartament) {
        New-ADOrganizationalUnit -Name $departament -Path $OU.DistinguishedName
        Write-Host "Creat: $departament"
    }
    else {
        Write-Host "Ja existeix: $departament"
    }
}

$OU | Select-Object Name, DistinguishedName
Get-ADOrganizationalUnit -Filter * -SearchBase $OU.DistinguishedName `
    -SearchScope OneLevel | Sort-Object Name | Select-Object Name, DistinguishedName

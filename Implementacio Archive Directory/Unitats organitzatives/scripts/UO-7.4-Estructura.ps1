param (
    [string]$nomOUPrincipal = "MusicCloud"
)

$domini = "DC=musiccloud,DC=local"

$nomOU = $nomOUPrincipal
$ruta = $domini

try {
    $OU = Get-ADOrganizationalUnit -Identity "OU=$nomOU,$ruta" -ErrorAction Stop
}
catch {
    $OU = $null
}

if (-not $OU) {
    New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
}
else {
    Write-Host "L'OU ja existeix: $nomOU"
}

$ruta = "OU=$nomOUPrincipal,$domini"
$unitats = @("Usuaris", "Equips", "Grups")

foreach ($nomOU in $unitats) {
    try {
        $OU = Get-ADOrganizationalUnit -Identity "OU=$nomOU,$ruta" -ErrorAction Stop
    }
    catch {
        $OU = $null
    }

    if (-not $OU) {
        New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
    }
    else {
        Write-Host "L'OU ja existeix: $nomOU"
    }
}

$ruta = "OU=Usuaris,OU=$nomOUPrincipal,$domini"
$departaments = @("Administracio", "Comercial", "Desenvolupament", "Sistemes", "Direccio")

foreach ($nomOU in $departaments) {
    try {
        $OU = Get-ADOrganizationalUnit -Identity "OU=$nomOU,$ruta" -ErrorAction Stop
    }
    catch {
        $OU = $null
    }

    if (-not $OU) {
        New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
    }
    else {
        Write-Host "L'OU ja existeix: $nomOU"
    }
}

$ruta = "OU=Equips,OU=$nomOUPrincipal,$domini"
$equips = @("Clients", "Servidors")

foreach ($nomOU in $equips) {
    try {
        $OU = Get-ADOrganizationalUnit -Identity "OU=$nomOU,$ruta" -ErrorAction Stop
    }
    catch {
        $OU = $null
    }

    if (-not $OU) {
        New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
    }
    else {
        Write-Host "L'OU ja existeix: $nomOU"
    }
}

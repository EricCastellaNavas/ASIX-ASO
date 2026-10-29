param (
    [Parameter(Mandatory=$true)]
    [string]$nomOU,

    [string]$ruta = "DC=musiccloud,DC=local"
)

try {
    $pare = Get-ADObject -Identity $ruta -ErrorAction Stop
}
catch {
    Write-Host "No existeix la ruta o no es pot consultar: $ruta"
    exit
}

try {
    $OU = Get-ADOrganizationalUnit -Identity "OU=$nomOU,$ruta" -ErrorAction Stop
}
catch {
    $OU = $null
}

if (-not $OU) {
    try {
        New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
    }
    catch {
        Write-Host "No s'ha pogut crear l'OU: $nomOU"
        exit
    }
}
else {
    Write-Host "L'OU ja existeix: $nomOU"
}

$rutaOU = "OU=$nomOU,$ruta"
$departaments = @("Direcció", "Administració", "Suport Tècnic", "Producció Musical", "Informàtica", "Externs")

foreach ($departament in $departaments) {
    try {
        $ouDepartament = Get-ADOrganizationalUnit -Identity "OU=$departament,$rutaOU" -ErrorAction Stop
    }
    catch {
        $ouDepartament = $null
    }

    if (-not $ouDepartament) {
        New-ADOrganizationalUnit -Name $departament -Path $rutaOU -ErrorAction Stop
    }
    else {
        Write-Host "L'OU ja existeix: $departament"
    }
}

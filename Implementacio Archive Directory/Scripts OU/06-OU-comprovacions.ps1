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
    New-ADOrganizationalUnit -Name $nomOU -Path $ruta -ErrorAction Stop
}
else {
    Write-Host "L'OU ja existeix: $nomOU"
}

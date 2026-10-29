$nomOU = $args[0]
$ruta = $args[1]

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

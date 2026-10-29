param (
    [string]$nomOUPrincipal = "MusicCloud"
)

$domini = "DC=musiccloud,DC=local"

$rutes = @(
    "OU=Administracio,OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Comercial,OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Desenvolupament,OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Sistemes,OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Direccio,OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Clients,OU=Equips,OU=$nomOUPrincipal,$domini",
    "OU=Servidors,OU=Equips,OU=$nomOUPrincipal,$domini",
    "OU=Usuaris,OU=$nomOUPrincipal,$domini",
    "OU=Equips,OU=$nomOUPrincipal,$domini",
    "OU=Grups,OU=$nomOUPrincipal,$domini",
    "OU=$nomOUPrincipal,$domini"
)

foreach ($ruta in $rutes) {
    try {
        $OU = Get-ADOrganizationalUnit -Identity $ruta -ErrorAction Stop
    }
    catch {
        $OU = $null
    }

    if ($OU) {
        try {
            $fills = Get-ADObject -Filter * -SearchBase $OU.DistinguishedName -ErrorAction Stop |
                Where-Object { $_.DistinguishedName -ne $OU.DistinguishedName }
        }
        catch {
            Write-Host "No es pot comprovar el contingut: $ruta"
            exit
        }

        if (-not $fills) {
            try {
                Set-ADOrganizationalUnit -Identity $OU.DistinguishedName -ProtectedFromAccidentalDeletion $false -ErrorAction Stop
                Remove-ADOrganizationalUnit -Identity $OU.DistinguishedName -Confirm:$false -ErrorAction Stop
                Write-Host "OU eliminada: $ruta"
            }
            catch {
                Write-Host "No es pot eliminar: $ruta. Revisa la proteccio i els permisos."
            }
        }
        else {
            Write-Host "Conservo l'OU perque encara conte objectes: $ruta"
        }
    }
    else {
        Write-Host "L'OU ja no existeix: $ruta"
    }
}

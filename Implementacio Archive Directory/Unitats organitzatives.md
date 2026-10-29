# Enunciat

## Objectiu

Crear l’estructura inicial d’unitats organitzatives del domini `musiccloud.local`.
## Escenari

MusicCloud ja disposa del domini:
```text
musiccloud.local
```
El servidor `SRV-AD-01` ja és controlador de domini.

Ara cal crear una estructura d’unitats organitzatives que permeti organitzar els objectes de l’empresa.
## Estructura que cal crear

Creeu l’estructura següent:
```text
musiccloud.local
└── MusicCloud
    ├── Usuaris
    │   ├── Administracio
    │   ├── Comercial
    │   ├── Desenvolupament
    │   ├── Sistemes
    │   └── Direccio
    ├── Equips
    │   ├── Clients
    │   └── Servidors
    └── Grups
```
## Part 1. Creació de la UO principal

Creeu una unitat organitzativa principal anomenada:
```text
MusicCloud
```
Aquesta UO serà el contenidor principal de l’estructura de l’empresa.


### Resolució de la part 1

He comprovat si MusicCloud ja existeix abans de crear-la. Així puc repetir la comanda sense duplicar la UO.

```powershell
$nomOU = "MusicCloud"
$ruta = "DC=musiccloud,DC=local"

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
```

## Part 2. Creació de les UO de primer nivell

Dins de la UO `MusicCloud`, creeu les UO següents:
```text
Usuaris
Equips
Grups
```

### Resolució de la part 2

He creat les UO de primer nivell dins de MusicCloud, conservant les que ja existien.

```powershell
$ruta = "OU=MusicCloud,DC=musiccloud,DC=local"
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
```

## Part 3. Creació de les UO de departaments

Dins de la UO `Usuaris`, creeu les UO següents:
```text
Administracio
Comercial
Desenvolupament
Sistemes
Direccio
```

### Resolució de la part 3

He utilitzat els noms de l’enunciat. A la VM ja hi havia Administració i Direcció amb accent; les consultes amb Administracio i Direccio localitzen aquestes mateixes UO i les he conservat. Les altres tres s’han creat.

```powershell
$ruta = "OU=Usuaris,OU=MusicCloud,DC=musiccloud,DC=local"
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
```

## Part 4. Creació de les UO d’equips

Dins de la UO `Equips`, creeu les UO següents:
```text
Clients
Servidors
```

### Resolució de la part 4

He creat Clients i Servidors dins d’Equips.

```powershell
$ruta = "OU=Equips,OU=MusicCloud,DC=musiccloud,DC=local"
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
```

## Part 5. Verificació

Executeu una consulta que mostri totes les unitats organitzatives del domini.

La sortida ha de mostrar, com a mínim, les UO creades en aquesta pràctica.

### Resolució de la part 5

He executat aquesta consulta al servidor:

```powershell
Get-ADOrganizationalUnit -Filter * -SearchBase "DC=musiccloud,DC=local" |
    Select-Object Name, DistinguishedName
```

Dins de la sortida he comprovat les UO de la pràctica:

| UO real | Ubicació |
| --- | --- |
| MusicCloud | Arrel de musiccloud.local |
| Usuaris | MusicCloud |
| Equips | MusicCloud |
| Grups | MusicCloud |
| Administració | MusicCloud / Usuaris |
| Comercial | MusicCloud / Usuaris |
| Desenvolupament | MusicCloud / Usuaris |
| Sistemes | MusicCloud / Usuaris |
| Direcció | MusicCloud / Usuaris |
| Clients | MusicCloud / Equips |
| Servidors | MusicCloud / Equips |

La consulta mostra també les UO dels exercicis anteriors, que he conservat.
El resultat final és de 22 UO dins de MusicCloud, comptant la principal,
i 23 al domini si hi incloc Domain Controllers.

## Part 6. Preguntes

Responeu breument:

1. Per què és útil crear una UO principal anomenada `MusicCloud`?  
2. Per què se separen `Usuaris`, `Equips` i `Grups`?  
3. Per què els departaments s’han creat dins de `Usuaris`?  
4. Per què no és recomanable deixar tots els usuaris dins del contenidor `Users`?  

## Part 7. Creació scripts

- 7.1. Crea un script per eliminar totes les OUs creades en la pràctica
- 7.2. Crea un script que crei l'OU principal (musiccloud).
- 7.3. Crea un script que crei l'OU principal i les OUs descendents: Usuaris, Equips i Grups
- 7.4. Crea un script que creï l'OU principal si no existeix i que creï únicament les UO descendents que encara no existeixin. El script s'ha de poder executar més d'una vegada sense generar errors ni duplicar objectes.
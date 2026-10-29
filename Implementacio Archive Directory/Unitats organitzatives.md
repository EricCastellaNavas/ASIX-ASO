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

   > Per agrupar els objectes de l’empresa en un mateix lloc i facilitar-ne l’administració. També permet vincular-hi polítiques comunes.

2. Per què se separen `Usuaris`, `Equips` i `Grups`?

   > Perquè són objectes amb funcions diferents. Separar-los facilita trobar-los i administrar-los; les polítiques d’usuari i d’equip es poden organitzar a les UO corresponents.

3. Per què els departaments s’han creat dins de `Usuaris`?

   > Per organitzar els comptes segons el departament on treballa cada persona i facilitar l’administració i l’aplicació de polítiques.

4. Per què no és recomanable deixar tots els usuaris dins del contenidor `Users`?

   > Perquè Users és un contenidor predeterminat, no una UO. No hi podem vincular GPO directament i no permet organitzar els comptes per departaments com amb una estructura de UO.


## Part 7. Creació scripts

- 7.1. Crea un script per eliminar totes les OUs creades en la pràctica
- 7.2. Crea un script que crei l'OU principal (musiccloud).
- 7.3. Crea un script que crei l'OU principal i les OUs descendents: Usuaris, Equips i Grups
- 7.4. Crea un script que creï l'OU principal si no existeix i que creï únicament les UO descendents que encara no existeixin. El script s'ha de poder executar més d'una vegada sense generar errors ni duplicar objectes.

### Resolució de la part 7

Els quatre scripts estan dins de la carpeta existent `Scripts OU`.
He utilitzat variables, arrays, `foreach`, `try/catch`, `if/else`,
`Get-ADOrganizationalUnit`, `New-ADOrganizationalUnit` i `Write-Host`,
seguint els apunts. Comproven si cada UO existeix abans de crear-la.

#### 7.1. Eliminació de les UO

Fitxer: [UO-7.1-Eliminar.ps1](<Scripts OU/UO-7.1-Eliminar.ps1>)

Elimina primer les UO de departaments i equips, després Usuaris, Equips
i Grups i, finalment, MusicCloud. Només elimina les UO de la llista que
estan buides. Si una UO encara conté objectes, la conserva i ho mostra.
Això evita eliminar usuaris, equips o altres branques que no formen part
d’aquest exercici.

Les UO estan protegides contra l’eliminació accidental. Per això he afegit,
amb autorització, aquesta comanda abans de cada eliminació:

```powershell
Set-ADOrganizationalUnit -Identity $OU.DistinguishedName -ProtectedFromAccidentalDeletion $false
Remove-ADOrganizationalUnit -Identity $OU.DistinguishedName -Confirm:$false
```

Aquesta comanda no apareix als apunts. L’he consultat a la
[documentació de Microsoft](https://learn.microsoft.com/en-us/powershell/module/activedirectory/set-adorganizationalunit?view=windowsserver2022-ps).
La primera línia treu la protecció de la UO i la segona l’elimina.
L’script fa servir `-ErrorAction Stop` per poder tractar els errors amb `catch`.

La comprovació del contingut utilitza `Get-ADObject`, `-Filter`,
`-SearchBase` i `Where-Object`, treballats als apunts.
No he executat l’eliminació sobre MusicCloud: l’he provat en una branca temporal.
Si s’executa sobre l’estructura actual, també pot eliminar les UO reutilitzades
que pertanyen a la llista i estan buides; conservarà les que encara tinguin objectes.

#### 7.2. Creació de la UO principal

Fitxer: [UO-7.2-Principal.ps1](<Scripts OU/UO-7.2-Principal.ps1>)

Comprova si MusicCloud existeix a l’arrel del domini. Si no existeix, la crea;
si ja hi és, la conserva.

#### 7.3. Creació de la principal i les UO de primer nivell

Fitxer: [UO-7.3-Primer-nivell.ps1](<Scripts OU/UO-7.3-Primer-nivell.ps1>)

Comprova MusicCloud i recorre un array amb Usuaris, Equips i Grups.
Només crea les UO que falten.

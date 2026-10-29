# Scripts de creació d'OU

He separat l'exercici en set scripts per veure els canvis de cada apartat.
Els he executat per SSH al servidor `SRV-AD-01`, dins del domini
`musiccloud.local`, amb Windows PowerShell 5.1.

## Fitxers

| Apartat | Script | Què hi he canviat |
| --- | --- | --- |
| 1 | `01-OU-fixa.ps1` | El nom `MusicCloud` i la ruta del domini són fixos. |
| 2 | `02-OU-nom-variable.ps1` | El nom es passa amb `$args[0]`; la ruta continua fixa. |
| 3 | `03-OU-nom-i-ruta.ps1` | El nom i la ruta es passen amb `$args[0]` i `$args[1]`. |
| 4 | `04-OU-parametres.ps1` | Faig servir `param` per poder indicar els paràmetres en qualsevol ordre. |
| 5 | `05-OU-nom-obligatori.ps1` | El nom és obligatori i la ruta per defecte és l'arrel del domini. |
| 6 | `06-OU-comprovacions.ps1` | Comprovo el nom, la ruta pare i el tipus d'objecte abans de crear. |
| 7 | `07-OU-departaments.ps1` | Creo l'OU indicada i les sis OU de departaments a dins. |

## Preparació

Els scripts estan desats al servidor a `C:\ASO\Scripts-OU`.
Cal executar-los amb un compte amb permisos per crear OU i amb el mòdul
ActiveDirectory disponible. Els fitxers estan en UTF-8 amb BOM perquè
Windows PowerShell 5.1 llegeixi correctament els accents.

```powershell
Set-Location C:\ASO\Scripts-OU
hostname
Import-Module ActiveDirectory
Get-ADDomain | Select-Object DNSRoot, DistinguishedName
```

## 1. Nom i ruta fixos

```powershell
.\01-OU-fixa.ps1
```

Crea `OU=MusicCloud,DC=musiccloud,DC=local`. Si ja existeix, la conserva.

## 2. Nom variable

```powershell
.\02-OU-nom-variable.ps1 "Usuaris"
```

Guardo el primer argument a `$nomOU`. La ruta fixa és
`OU=MusicCloud,DC=musiccloud,DC=local`, per tant primer cal executar l'apartat 1.

## 3. Nom i ruta variables

```powershell
.\03-OU-nom-i-ruta.ps1 "Equips" "OU=MusicCloud,DC=musiccloud,DC=local"
```

El primer argument és el nom i el segon és la ruta. Aquí l'ordre encara importa.

## 4. Paràmetres amb nom

Aquestes dues comandes treballen sobre la mateixa OU:

```powershell
.\04-OU-parametres.ps1 -nomOU "Grups" -ruta "OU=MusicCloud,DC=musiccloud,DC=local"
.\04-OU-parametres.ps1 -ruta "OU=MusicCloud,DC=musiccloud,DC=local" -nomOU "Grups"
```

Ara cada valor queda identificat pel nom del paràmetre.

## 5. Nom obligatori i ruta per defecte

```powershell
.\05-OU-nom-obligatori.ps1 -nomOU "MusicCloud"
```

Sense `-ruta`, utilitza `DC=musiccloud,DC=local`. Amb
`[Parameter(Mandatory=$true)]`, PowerShell demana el nom si no l'indiquem.
En una execució no interactiva, la crida sense nom falla.

## 6. Comprovacions

```powershell
.\06-OU-comprovacions.ps1 -nomOU "Comptes_Servei" -ruta "OU=MusicCloud,DC=musiccloud,DC=local"
```

He afegit aquestes comprovacions:

- El nom i la ruta no poden ser buits ni contenir només espais.
- La ruta pare ha d'existir i ha de ser el domini o una OU.
- Utilitzo `Get-ADObject` per consultar el pare: l'arrel del domini no és una OU.
- La cerca amb `SearchScope OneLevel` només comprova els fills directes del pare.
- Si l'OU ja existeix en aquell lloc, es conserva.
- Els errors de consulta o creació aturen l'script amb un missatge; no es confonen amb una OU inexistent.

No es crea automàticament una cadena de pares inexistents. Primer cal crear
la ruta pare. Si una execució queda a mitges, les OU creades es conserven i
es pot tornar a executar l'script quan s'hagi resolt el problema.

## 7. OU i departaments

```powershell
.\07-OU-departaments.ps1 -nomOU "Usuaris" -ruta "OU=MusicCloud,DC=musiccloud,DC=local"
.\07-OU-departaments.ps1 -ruta "OU=MusicCloud,DC=musiccloud,DC=local" -nomOU "Equips"
```

Si no existeix l'OU indicada, primer la crea. Després recorre l'array
`$departaments` amb `foreach` i crea només les OU que falten:

- Direcció
- Administració
- Suport Tècnic
- Producció Musical
- Informàtica
- Externs

Són els cinc departaments i la categoria Externs dels apunts.
He conservat els noms amb accents i espais. Els mateixos noms poden existir
sota Usuaris i sota Equips perquè tenen un DN diferent.

## Resultat al servidor

```text
MusicCloud
├── Usuaris
│   ├── Direcció
│   ├── Administració
│   ├── Suport Tècnic
│   ├── Producció Musical
│   ├── Informàtica
│   └── Externs
├── Equips
│   ├── Direcció
│   ├── Administració
│   ├── Suport Tècnic
│   ├── Producció Musical
│   ├── Informàtica
│   └── Externs
├── Grups
└── Comptes_Servei
```

Són 17 OU comptant MusicCloud. La creació dels departaments sota Equips
correspon al cas que demana l'apartat 7.

Per comprovar els fills directes d'Equips:

```powershell
Get-ADOrganizationalUnit -Filter * `
    -SearchBase "OU=Equips,OU=MusicCloud,DC=musiccloud,DC=local" `
    -SearchScope OneLevel | Select-Object Name, DistinguishedName
```

## Proves fetes el 29/10/2026

| Prova | Resultat |
| --- | --- |
| Executar els set scripts al servidor | Correcte. |
| Analitzar els set fitxers amb el parser de Windows PowerShell 5.1 | Cap error de sintaxi. |
| Repetir la creació de les OU | Es conserven sense duplicar-les. |
| Invertir l'ordre dels paràmetres amb nom | Es conserva el mateix GUID. |
| Ometre la ruta a l'apartat 5 | Utilitza l'arrel del domini. |
| Ometre el nom en mode no interactiu | Rebutjat amb codi de sortida 1. |
| Passar nom buit, ruta buida, ruta inexistent o el contenidor CN=Users a l'apartat 6 | Rebutjat; cap OU creada. |
| Completar Usuaris amb Direcció ja existent | Conserva Direcció i crea les cinc OU que falten. |
| Crear departaments sota Usuaris i Equips | Sis fills directes a cada branca. |
| Repetir el setè script en totes dues branques | Mateixos GUID i cap duplicat. |
| Crear una OU pare nova amb coma, apòstrof i espais | Pare i sis departaments creats correctament. |
| Netejar la branca temporal d'aquesta última prova | Eliminada només la branca creada per a la prova. |
| Revisar la protecció de les OU definitives | Les 17 OU estan protegides contra eliminació accidental. |
| Comparar els scripts locals amb els de la VM | Mateixes signatures SHA-256. |

Les sortides de les execucions estan a `evidencies/`. L'estat final,
la versió de PowerShell i les signatures dels fitxers estan a
`evidencies/verificacio-final.json`.

## Referències

- [Get-ADObject](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-adobject)
- [New-ADOrganizationalUnit](https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adorganizationalunit)

# Scripts de creació d'OU

He corregit els set scripts seguint els exemples d'ASO APUNTS-1,
sobretot les pàgines 35 a 40. Els arrays i el `foreach` també apareixen
als apunts de PowerShell.

## Apartats

| Script | Canvi |
| --- | --- |
| `01-OU-fixa.ps1` | Nom i ruta fixos. |
| `02-OU-nom-variable.ps1` | Nom amb `$args[0]` i ruta fixa. |
| `03-OU-nom-i-ruta.ps1` | Nom i ruta amb `$args[0]` i `$args[1]`. |
| `04-OU-parametres.ps1` | `param` amb nom i ruta; es poden passar en qualsevol ordre amb el seu nom. |
| `05-OU-nom-obligatori.ps1` | Nom obligatori i ruta per defecte. |
| `06-OU-comprovacions.ps1` | Comprova que la ruta pare existeixi abans de continuar. |
| `07-OU-departaments.ps1` | Crea l'OU indicada i els departaments que falten a dins. |

## Idempotència

Tots set comproven si l'OU existeix abans de crear-la:

```powershell
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

`-ErrorAction Stop` permet entrar al `catch`. Si no es troba l'OU,
la variable queda a `$null` i s'intenta crear. Si ja existeix, es conserva.
Si hi ha un error de connexió o permisos, l'error de creació s'ha de resoldre
abans de repetir l'execució.

En els apartats 6 i 7 comprovo el pare amb `Get-ADObject`, com a objecte
del directori. Aquesta comanda apareix a la pàgina 35 i permet consultar
tant una OU com l'arrel `DC=musiccloud,DC=local`.
Si la consulta falla, mostro el missatge i surto amb `exit`, seguint els apunts.

No he afegit validacions de text avançades: a la pàgina 38 s'indica que
aquestes validacions es treballaran més endavant. Els exemples utilitzen
els noms i DN senzills de la pràctica; no incorporen tractament especial
de comes o altres caràcters reservats dins del nom d'una OU.

## Execució al servidor

Els fitxers estan a `C:\ASO\Scripts-OU`, en UTF-8 amb BOM per conservar
els accents amb Windows PowerShell 5.1. Cal un compte amb permisos per crear OU.

```powershell
Set-Location C:\ASO\Scripts-OU

.\01-OU-fixa.ps1
.\02-OU-nom-variable.ps1 "Usuaris"
.\03-OU-nom-i-ruta.ps1 "Equips" "OU=MusicCloud,DC=musiccloud,DC=local"
.\04-OU-parametres.ps1 -ruta "OU=MusicCloud,DC=musiccloud,DC=local" -nomOU "Grups"
.\05-OU-nom-obligatori.ps1 -nomOU "MusicCloud"
.\06-OU-comprovacions.ps1 -nomOU "Comptes_Servei" -ruta "OU=MusicCloud,DC=musiccloud,DC=local"
.\07-OU-departaments.ps1 -nomOU "Usuaris" -ruta "OU=MusicCloud,DC=musiccloud,DC=local"
.\07-OU-departaments.ps1 -ruta "OU=MusicCloud,DC=musiccloud,DC=local" -nomOU "Equips"
```

El setè script utilitza un array i un `foreach` per crear Direcció,
Administració, Suport Tècnic, Producció Musical, Informàtica i Externs.
Comprova cada departament pel seu DN complet, per tant els d'Usuaris i
els d'Equips no es confonen. Si només falten alguns departaments, crea els que falten.

## Correcció i comprovacions del 29/10/2026

He retirat `ValidateScript`, mètodes de .NET, `$ErrorActionPreference`,
`throw`, `SearchScope`, `PassThru` i la comprovació d'`ObjectClass`.
Ara el codi segueix el patró de variables, `param`, `try/catch`,
`if/else`, `$null`, `Write-Host`, `exit`, arrays i `foreach` dels apunts.

He repetit els set scripts al servidor: es mantenen les 17 OU i els mateixos
GUID. També he comprovat una ruta inexistent i la creació des de zero
d'una OU amb els sis departaments. En repetir aquesta última prova,
no es creen duplicats. La branca temporal de prova s'ha retirat.

Les proves de la versió corregida estan a `evidencies/09-correccions.txt`.
`evidencies/verificacio-final.json` conté l'estat i les signatures actuals.
Les evidències 01 a 08 corresponen a la versió inicial, anterior a aquesta
simplificació; les proves avançades que hi consten no descriuen aquesta versió.

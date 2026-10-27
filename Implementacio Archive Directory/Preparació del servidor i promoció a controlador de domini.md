# Pràctica

## Objectiu

Preparar el servidor `SRV-AD-01` i promocionar-lo com a primer controlador de domini del domini `musiccloud.local`.
## Escenari

L’empresa **MusicCloud** vol iniciar la implantació d’Active Directory Domain Services.

El servidor Windows Server que s’utilitzarà com a controlador de domini serà:
```text
SRV-AD-01
```
El domini que es crearà serà:
```text
musiccloud.local
```
Aquest servidor també proporcionarà el servei DNS del domini.
## Tasques

### Part 1. Configuració inicial del servidor

Configureu el servidor perquè compleixi els requisits següents:

| Element           | Valor              |
| ----------------- | ------------------ |
| Nom del servidor  | `SRV-AD-01`        |
| Adreça IP         | fixa               |
| DNS preferit      | el mateix servidor |
| Connexió de xarxa | operativa          |
| Zona horària      | correcta           |
| Hora del sistema  | correcta           |
La configuració IP concreta dependrà de la xarxa del laboratori. Anoteu els valors utilitzats.

Completeu la taula següent:

| Paràmetre        | Valor configurat |
| ---------------- | ---------------- |
| Adreça IP        | `192.168.56.109/24` (Ethernet 2, xarxa del laboratori) |
| Màscara          | `255.255.255.0` |
| Porta d’enllaç   | Sense porta d'enllaç a Ethernet 2; sortida a Internet per `10.0.2.2` a Ethernet (NAT) |
| DNS preferit     | `192.168.56.109` (el mateix servidor) |
| Nom del servidor | `SRV-AD-01` |

He preparat un Windows Server 2022 Standard Evaluation. La màquina tenia dues targetes amb DHCP: he mantingut les adreces del laboratori i les he configurat de manera fixa. La targeta NAT té `10.0.2.15/24` i és l'única amb porta d'enllaç. Les dues targetes utilitzen el servidor mateix com a DNS.

He desactivat el registre DNS de la targeta NAT perquè els clients del laboratori trobin el controlador a `192.168.56.109`. He comprovat la zona horària `Romance Standard Time` (Madrid) i l'hora del sistema. Després he reiniciat per aplicar el nom nou.

Comandes utilitzades a PowerShell com a administrador:

```powershell
netsh interface ipv4 set address name="Ethernet" source=static address=10.0.2.15 mask=255.255.255.0 gateway=10.0.2.2 gwmetric=10
netsh interface ipv4 set address name="Ethernet 2" source=static address=192.168.56.109 mask=255.255.255.0 gateway=none
Set-DnsClient -InterfaceAlias 'Ethernet' -RegisterThisConnectionsAddress $false
Set-DnsClient -InterfaceAlias 'Ethernet 2' -RegisterThisConnectionsAddress $true
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet','Ethernet 2' -ServerAddresses '192.168.56.109'
Set-TimeZone -Id 'Romance Standard Time'
Get-TimeZone
Get-Date -Format o
Rename-Computer -NewName 'SRV-AD-01' -Force
shutdown.exe /r /t 15
```

He comprovat la connexió de xarxa i la resolució externa a través del DNS de la NAT abans de configurar el DNS local. Les evidències de la preparació són a [01-preparacio.txt](evidencies/01-preparacio.txt).

### Part 2. Instal·lació del rol AD DS

Localitzeu i utilitzeu el procediment adequat per instal·lar el rol AD DS i promocionar el servidor a controlador de domini. Documenteu breument les comandes o passos utilitzats.

He seguit el procediment de PowerShell de [Microsoft Learn per instal·lar AD DS](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-), i l'ordre dels apunts: preparar la xarxa, instal·lar AD DS amb les eines de gestió i crear el bosc i el domini.

```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Get-WindowsFeature AD-Domain-Services,RSAT-AD-Tools,RSAT-AD-PowerShell
Get-Command Install-ADDSForest,Test-ADDSForestInstallation,Get-ADDomain
```

La instal·lació ha retornat `Success: True`, `ExitCode: Success` i `RestartNeeded: No`. El rol `AD-Domain-Services`, les eines `RSAT-AD-Tools` i el mòdul `RSAT-AD-PowerShell` han quedat instal·lats. En aquest punt encara calia promocionar el servidor per crear el domini.

Evidència: [02-installacio-adds.txt](evidencies/02-installacio-adds.txt).


### Part 3. Promoció a controlador de domini
Promocioneu el servidor a controlador de domini amb les opcions següents:

| Opció                                  | Valor              |
| -------------------------------------- | ------------------ |
| Tipus d’implantació                    | Crear un nou bosc  |
| Nom del domini arrel                   | `musiccloud.local` |
| Servidor DNS                           | Sí                 |
| Catàleg global                         | Sí                 |
| Nom NetBIOS                            | `MUSICCLOUD`       |
| Controlador de domini de només lectura | No                 |
| Reinici final                          | Sí                 |
Definiu una contrasenya segura per al mode de restauració de serveis de directori.

He creat el bosc i el domini `musiccloud.local` amb el nom NetBIOS `MUSICCLOUD`, tal com indica aquest enunciat i els apunts. He utilitzat el nivell funcional Windows Server 2016 (`WinThreshold`), compatible amb Windows Server 2022.

Primer he comprovat els requisits i després he executat la promoció. La contrasenya DSRM s'ha proporcionat com a `SecureString` i s'ha guardat fora del repositori.

```powershell
# La contrasenya es demana de manera oculta; no s'escriu dins del script.
$dsrmPassword = Read-Host 'Contrasenya DSRM' -AsSecureString
$opcions = @{
    DomainName = 'musiccloud.local'
    DomainNetbiosName = 'MUSICCLOUD'
    InstallDns = $true
    CreateDnsDelegation = $false
    DomainMode = 'WinThreshold'
    ForestMode = 'WinThreshold'
    SafeModeAdministratorPassword = $dsrmPassword
}
Test-ADDSForestInstallation @opcions
Install-ADDSForest @opcions -Force
```

En l'execució per SSH he passat la contrasenya per l'entrada estàndard xifrada de la connexió i l'he convertit a `SecureString`; el bloc anterior mostra l'equivalent interactiu per repetir el procediment.

Les comprovacions prèvies han retornat `Status: Success`. Han aparegut avisos sobre la protecció contra criptografia antiga i la impossibilitat de crear una delegació DNS a la zona pare; no són errors de la instal·lació. No he creat cap delegació DNS perquè és un bosc nou del laboratori. El primer controlador d'un bosc és un controlador d'escriptura i catàleg global. He deixat el reinici automàtic habilitat i he tornat a entrar per SSH després del reinici.

Evidències: [03-precomprovacions.txt](evidencies/03-precomprovacions.txt) i [04-promocio.txt](evidencies/04-promocio.txt).

### Part 4. Verificació

Després del reinici, comproveu:

1. Que el servidor s’anomena `SRV-AD-01`.
    
2. Que el domini `musiccloud.local` existeix.
    
3. Que el servidor és controlador de domini.
    
4. Que el servei DNS està instal·lat.
    
5. Que el DNS resol correctament el domini.
    
    
Completeu la taula següent. Adjunta la comanda que has utilitzat per a cada una de les comprovacions.

| Comprovació                          | Resultat |
| ------------------------------------ | -------- |
| Nom del servidor                     |          |
| IP fixa configurada                  |          |
| AD DS instal·lat                     |          |
| Domini creat                         |          |
| DNS instal·lat                       |          |
| Resolució de `musiccloud.local`      |          |
| Eines d’Active Directory disponibles |          |

## Preguntes

Responeu breument:

1. Per què `SRV-AD-01` necessita una IP fixa?
    
2. Per què és necessari DNS en un domini Active Directory?
    
3. Quina diferència hi ha entre instal·lar AD DS i promocionar el servidor a controlador de domini?
    
4. Quin és el nom del domini creat?
    
5. Quin és el nom NetBIOS del domini?
    
6. Per què no és recomanable que els clients del domini utilitzin un DNS extern com a DNS principal?

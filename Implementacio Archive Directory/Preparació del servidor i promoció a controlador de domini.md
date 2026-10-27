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

| Comprovació | Comanda utilitzada | Resultat |
| --- | --- | --- |
| Nom del servidor | `hostname` | `SRV-AD-01` |
| IP fixa configurada | `Get-NetIPAddress -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4` i `Get-NetIPInterface -InterfaceAlias 'Ethernet 2' -AddressFamily IPv4` | `192.168.56.109/24`, origen `Manual` i DHCP `Disabled` |
| AD DS instal·lat | `Get-WindowsFeature AD-Domain-Services` | `Installed` |
| Domini creat | `Get-ADDomain` | `DNSRoot: musiccloud.local`, `NetBIOSName: MUSICCLOUD` |
| DNS instal·lat | `Get-WindowsFeature DNS` i `Get-Service DNS` | Rol `Installed` i servei `Running` |
| Resolució de `musiccloud.local` | `Resolve-DnsName musiccloud.local -Type A -Server 192.168.56.109` | `192.168.56.109` |
| Eines d'Active Directory disponibles | `Get-WindowsFeature RSAT-AD-Tools,RSAT-AD-PowerShell` i `Get-Command Get-ADDomain,Get-ADUser` | Eines instal·lades i comandes disponibles al mòdul `ActiveDirectory` |

També he comprovat que el servidor és un controlador d'escriptura i catàleg global:

```powershell
Get-CimInstance Win32_ComputerSystem | Select-Object Name,Domain,DomainRole
Get-ADDomainController -Identity SRV-AD-01 |
    Select-Object HostName,IPv4Address,IsGlobalCatalog,IsReadOnly
Get-ADForest | Select-Object RootDomain,ForestMode,GlobalCatalogs
Get-Service NTDS,DNS,Netlogon,Kdc,ADWS,DFSR,sshd
Get-SmbShare -Name SYSVOL,NETLOGON
```

Resultat: `DomainRole: 5`, `IsGlobalCatalog: True`, `IsReadOnly: False`, serveis en execució i recursos `SYSVOL` i `NETLOGON` disponibles.

#### Ajustos DNS per a les dues targetes de xarxa

He mantingut `192.168.56.109` per a SSH i per als serveis del domini. Després de la promoció he limitat l'escolta DNS a aquesta IP i he configurat el reenviador `10.0.2.3` de la NAT per resoldre noms externs. Les targetes continuen utilitzant `192.168.56.109` com a DNS preferit.

```powershell
$dnsSettings = Get-DnsServerSetting -All
$dnsSettings.ListeningIPAddress = @('192.168.56.109')
Set-DnsServerSetting $dnsSettings
Set-DnsServerForwarder -IPAddress '10.0.2.3'
Restart-Service DNS
```

He evitat la publicació de la targeta NAT al DNS i he comprovat que els registres del domini i del servidor apunten a `192.168.56.109`. També he creat la zona inversa `56.168.192.in-addr.arpa` i el registre PTR de `192.168.56.109` cap a `SRV-AD-01.musiccloud.local`.

He deixat les regles DNS d'entrada limitades a l'adreça del servidor i als clients de la xarxa del laboratori:

```powershell
Set-NetFirewallRule -Name 'DNSSrv-DNS-UDP-In','DNSSrv-DNS-TCP-In' -Enabled True -Profile Any -LocalAddress '192.168.56.109' -RemoteAddress '192.168.56.0/24'
```

```powershell
Resolve-DnsName SRV-AD-01.musiccloud.local -Type A -Server 192.168.56.109
Resolve-DnsName _ldap._tcp.dc._msdcs.musiccloud.local -Type SRV -Server 192.168.56.109
Resolve-DnsName _kerberos._tcp.musiccloud.local -Type SRV -Server 192.168.56.109
Resolve-DnsName 192.168.56.109 -Type PTR -Server 192.168.56.109
Resolve-DnsName www.microsoft.com -Type A -Server 192.168.56.109
nltest /dsgetdc:musiccloud.local /force
dcdiag /test:Advertising /test:Services /test:NetLogons /test:SysVolCheck /test:Replications
dcdiag /test:DNS /DnsBasic
```

Els registres SRV localitzen `srv-ad-01.musiccloud.local` als ports `389` (LDAP) i `88` (Kerberos). Les comprovacions del controlador i el diagnòstic DNS han passat.

Des de l'amfitrió he comprovat l'accés als ports SSH `22`, Kerberos `88`, LDAP `389`, SMB `445` i catàleg global `3268`. La consulta DNS des d'aquest entorn no s'ha pogut validar: l'obertura del port `53` retorna l'error de permisos de socket `10013`. La resolució directa, inversa, externa i SRV sí que s'ha verificat dins de la VM. Per tant, la prova DNS des d'un client extern queda pendent d'un entorn que permeti aquesta connexió.

#### Hora del controlador i eines DNS

Després de la promoció he detectat que el PDC utilitzava `Local CMOS Clock` i tenia un desajust horari. He configurat una font NTP externa i he comprovat que l'hora UTC del servidor coincideix amb la de l'amfitrió.

```powershell
w32tm /config /manualpeerlist:"time.windows.com,0x8" /syncfromflags:manual /reliable:yes /update
Restart-Service W32Time
w32tm /resync /rediscover
w32tm /query /status
w32tm /query /source
```

La sincronització ha acabat correctament i la font és `time.windows.com,0x8`. També he instal·lat explícitament la consola de gestió DNS:

```powershell
Install-WindowsFeature -Name RSAT-DNS-Server
```

Evidències: [05-configuracio-dns.txt](evidencies/05-configuracio-dns.txt), [06-verificacio.txt](evidencies/06-verificacio.txt), [07-verificacio-amfitrio.txt](evidencies/07-verificacio-amfitrio.txt), [08-sincronitzacio-hora.txt](evidencies/08-sincronitzacio-hora.txt), [09-eines-dns.txt](evidencies/09-eines-dns.txt) i [10-tallafoc-dns.txt](evidencies/10-tallafoc-dns.txt).

## Preguntes

Responeu breument:

1. Per què `SRV-AD-01` necessita una IP fixa?

    > Perquè els clients puguin trobar sempre el controlador de domini i el DNS a la mateixa adreça, sense canvis provocats pel DHCP.
    
2. Per què és necessari DNS en un domini Active Directory?

    > Perquè permet resoldre els noms del domini i trobar els serveis del controlador mitjançant registres SRV, com LDAP i Kerberos.
    
3. Quina diferència hi ha entre instal·lar AD DS i promocionar el servidor a controlador de domini?

    > Instal·lar AD DS afegeix el rol i les eines. Promocionar configura el directori i converteix el servidor en controlador de domini; en aquesta pràctica també crea el bosc i el domini.
    
4. Quin és el nom del domini creat?

    > `musiccloud.local`.
    
5. Quin és el nom NetBIOS del domini?

    > `MUSICCLOUD`.
    
6. Per què no és recomanable que els clients del domini utilitzin un DNS extern com a DNS principal?

    > Perquè un DNS extern no coneix la zona interna ni els registres SRV d'Active Directory, i els clients podrien no trobar el controlador ni autenticar-se. Han d'utilitzar el DNS del domini, que pot reenviar les consultes externes.


## Fonts consultades

- Apunts de classe, *ASO APUNTS*, apartat 3 «Active Directory» (pàgines 32-34).
- [Microsoft Learn: instal·lació d'AD DS](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-).
- [Microsoft Learn: Install-ADDSForest](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2022-ps).
- [Microsoft Learn: configurar les interfícies i els reenviadors DNS](https://learn.microsoft.com/en-us/windows-server/networking/dns/quickstart-install-configure-dns-server).
- [Microsoft Learn: evitar el registre de targetes no desitjades al DNS](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/unwanted-nic-registered-dns-mulithomed-dc).
- [Microsoft Learn: configurar la font horària del PDC](https://learn.microsoft.com/en-us/services-hub/microsoft-engage-center/health/remediation-steps-ad/configure-the-root-pdc-with-an-authoritative-time-source-and-avoid-widespread-time-skew).

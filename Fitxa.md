# Fitxa 1 — Anàlisi inicial de MusicCloud

**Nom i cognoms:** Eric Castellà Navas 
**Data:** 17/09/26
**Equip / parella:** 

## Objectiu

MusicCloud necessita reorganitzar la seva infraestructura informàtica. Abans d'instal·lar o configurar cap servei, cal entendre:

- qui treballa a l'empresa;
    
- quines funcions té cada persona;
    
- quins recursos existeixen;
    
- qui necessita accedir a cada recurs;
    
- com podem gestionar aquests accessos de manera eficient.
    

---

# 1. Conèixer MusicCloud

Consulta la informació disponible sobre els departaments, treballadors i perfils d'usuari de MusicCloud.

Completa la taula següent.

| Persona | Departament | Funció / responsabilitat | Necessita privilegis especials? Per què? |
|---|---|---|---|
| Aina Ciurans | Direcció | Gestió general de l'empresa | Sí. Ha de poder gestionar els recursos de Direcció i consultar informació dels altres departaments. |
| Rut Tornil | Direcció | Gestió general de l'empresa | Sí. Ha de poder gestionar els recursos de Direcció i consultar informació dels altres departaments. |
| Dídac Gassó | Administració | Gestió de factures, contractes i documentació interna | No. Necessita els permisos habituals del departament d'Administració. |
| Laia Macias | Administració | Cap d'Administració i responsable de la documentació del departament | Sí. Com a responsable, necessita accés complet a `gestio_departament`. |
| Estel Birosta | Suport tècnic | Manteniment de sistemes i resolució d'incidències | Pot necessitar accessos temporals i registrats per resoldre incidències. |
| Aina Zuriguel | Suport tècnic | Manteniment de sistemes i resolució d'incidències | Pot necessitar accessos temporals i registrats per resoldre incidències. |
| Lluïsa Richart | Suport tècnic | Cap de Suport tècnic i coordinació d'incidències | Sí. Necessita accés complet a `gestio_departament` i als recursos tècnics del departament. |
| Roser Alberch | Producció musical | Gestió de continguts musicals | No. Necessita els permisos habituals de Producció musical. |
| Guillem Adella | Producció musical | Gestió de continguts musicals | No. Necessita els permisos habituals de Producció musical. |
| Meritxell Reglat | Producció musical | Cap de Producció musical i coordinació del catàleg | Sí. Necessita accés complet a `gestio_departament`. |
| Alícia Monclús | Producció musical | Gestió de continguts musicals | No. Necessita els permisos habituals de Producció musical. |
| Carles Molins | Producció musical | Gestió de continguts musicals | No. Necessita els permisos habituals de Producció musical. |
| Eulàlia Galcera | Producció musical | Gestió de continguts musicals | No. Necessita els permisos habituals de Producció musical. |
| Talia Costas | Informàtica | Cap d'Informàtica i administració dels sistemes | Sí. Com a administradora, ha de gestionar usuaris, grups, permisos, còpies de seguretat, registres i configuracions. |
| Alex Soriano | Informàtica | Administració i manteniment dels sistemes informàtics | Sí. Ha de gestionar els recursos tècnics necessaris per mantenir els sistemes. |
| Pere Espinalt | Extern | Col·laborador temporal | Sí, però de manera restrictiva. Només ha d'accedir als recursos compartits que necessiti. |
| Neus Bages | Extern | Col·laboradora temporal | Sí, però de manera restrictiva. Només ha d'accedir als recursos compartits que necessiti. |

### 1.1. Reflexió

Un **treballador** és una persona concreta que forma part de l'empresa i disposa d'un compte d'usuari. Un **departament** és una unitat organitzativa que agrupa treballadors amb un àmbit de feina comú. Una **funció o responsabilitat** defineix les tasques que fa una persona i pot justificar que necessiti permisos diferents dels de la resta del seu departament.

Hi ha persones que, pel seu càrrec o funció, necessiten accessos diferents dels altres membres del seu departament?

- [x] Sí
- [ ] No

**Exemple:** Laia Macias és membre d'Administració, però també n'és la responsable. Per això, a més dels recursos compartits del departament, necessita accés de lectura i escriptura a la carpeta `gestio_departament`. Talia Costas també necessita privilegis d'administració perquè és la responsable d'Informàtica.

---

# 2. Recursos de l'empresa

Analitza l'estructura d'informació de MusicCloud.

Classifica alguns dels recursos següents segons la seva finalitat.

| Recurs | Qui l'hauria d'utilitzar? | Per a què? |
|---|---|---|
| `/empresa/comu/intercanvi` | Tots els departaments i els usuaris externs autoritzats | Intercanviar temporalment documents, inclosos fitxers amb col·laboradors externs. |
| `/empresa/comu/comunicats` | Direcció en lectura i escriptura; la resta de treballadors interns en lectura | Publicar i consultar comunicats interns de l'empresa. |
| `/empresa/departaments/administracio/compartida` | Administració en lectura i escriptura; Direcció en lectura | Compartir els documents de treball habituals del departament d'Administració. |
| `/empresa/departaments/administracio/gestio_departament` | La responsable d'Administració en lectura i escriptura; Direcció en lectura | Desar informació de coordinació i gestió reservada a la responsable del departament. |
| `/empresa/projectes/campanya_estiu` | Només les persones assignades al projecte | Compartir els documents i materials necessaris per desenvolupar la campanya d'estiu. |
| `/empresa/administracio_sistema/backups` | El personal d'Informàtica amb funcions d'administració | Crear, conservar i gestionar les còpies de seguretat dels sistemes. |

---

# 3. Qui ha de poder fer què?

Per a cada situació, indica quin nivell d'accés consideres adequat.

| Situació | Accés proposat | Justificació |
|---|---|---|
| Dídac accedeix a la carpeta compartida d'Administració | **L/E** | És membre d'Administració i necessita consultar, crear i modificar els documents del departament. |
| Laia accedeix a la gestió del departament d'Administració | **L/E** | És la responsable d'Administració i ha de gestionar la documentació reservada del departament. |
| Pere, treballador extern, accedeix als comunicats interns | **NA** | Els comunicats són informació interna i els usuaris externs no hi han d'accedir. |
| Talia accedeix als backups del sistema | **ADM** | Com a responsable d'Informàtica, ha de gestionar les còpies de seguretat i el seu manteniment. |
| Un membre de Producció musical accedeix a la carpeta d'Administració | **NA** | No necessita aquesta informació per desenvolupar la seva feina. |
| Un participant de `campanya_estiu` accedeix als fitxers del projecte | **L/E** | Les persones assignades al projecte han de poder consultar i modificar els seus fitxers. |

---

# 4. Primer problema: com assignem els permisos?

Imagina que MusicCloud té només quatre treballadors:

- Anna
- Biel
- Carla
- David

Tots quatre treballen al mateix departament i necessiten accedir a la mateixa carpeta.

Una possible solució seria configurar:

```text
Anna  → lectura/escriptura
Biel  → lectura/escriptura
Carla → lectura/escriptura
David → lectura/escriptura
```

### 4.1.

Caldria assignar i revisar els mateixos permisos cent vegades. Seria un procés lent, repetitiu i difícil de controlar, amb més probabilitat de cometre errors.

### 4.2.

S'haurien de configurar manualment tots els permisos que necessita. També es podria oblidar algun recurs o assignar-li un accés incorrecte.

### 4.3.

Caldria eliminar un per un els permisos del departament anterior i assignar-li manualment els del nou. Si se n'oblidés algun, la persona podria conservar accessos que ja no necessita.

### 4.4.

Proposa una manera de gestionar aquestes persones conjuntament.

Es podria crear un conjunt per a cada departament o necessitat d'accés. Els permisos s'assignarien al conjunt i després només caldria afegir-hi o retirar-ne les persones corresponents.

---

# 5. Canvis a MusicCloud

### Cas A: Dídac deixa Administració i passa a Producció musical

**Quins accessos hauria de perdre?**

Hauria de perdre l'accés de lectura i escriptura a les carpetes `compartida` i `documentacio_interna` d'Administració. També hauria de deixar de rebre qualsevol permís associat exclusivament al seu departament anterior.

**Quins accessos hauria d'obtenir?**

Hauria d'obtenir lectura i escriptura a les carpetes `compartida`, `artistes` i `cataleg` de Producció musical. No hauria d'accedir a `gestio_departament`, perquè no és el responsable del nou departament.

### Cas B: S'incorpora una nova treballadora al departament d'Administració

Caldria crear-li un compte personal, una carpeta personal i assignar-li els accessos generals de l'empresa. També necessitaria lectura i escriptura a `administracio/compartida` i `administracio/documentacio_interna`. Si és una treballadora estàndard, no se li hauria de donar accés a `gestio_departament`.

### Cas C: Pere Espinalt deixa de col·laborar amb MusicCloud

S'hauria de desactivar immediatament el seu compte i revocar tots els seus accessos. També caldria revisar les sessions o credencials actives, conservar només la informació empresarial necessària i, després del període establert per l'empresa, eliminar el compte si ja no és necessari.

---

# 6. Busquem una solució millor

Suposa ara que podem crear conjunts de persones que comparteixen unes mateixes necessitats d'accés.

Per exemple:

```text
Administració
    ├── Dídac
    └── Laia
```

I podem donar permisos directament al conjunt:

```text
Administració → carpeta_administracio → L/E
```

### 6.1. Quin avantatge té aquesta solució respecte a donar permisos persona per persona?

Permet administrar els permisos de manera centralitzada. Un únic canvi aplicat al conjunt afecta totes les persones que en formen part, cosa que redueix el temps de gestió, els errors i els accessos indeguts.

### 6.2. Si Dídac passa d'Administració a Producció musical, què caldria modificar?

Només caldria retirar Dídac del conjunt d'Administració i afegir-lo al de Producció musical. Així perdria els permisos anteriors i rebria automàticament els del nou departament.

### 6.3. Com anomenaries aquests conjunts de persones?

Els anomenaria **grups d'usuaris** o **grups de seguretat**.

---

# 7. Primera proposta per a MusicCloud

A partir de l'organització de l'empresa, proposa els primers conjunts de persones que crearies.

**No cal trobar encara la solució definitiva.**

| Nom proposat | Qui hi pertanyeria? | Per què existeix aquest conjunt? |
|---|---|---|
| `GG_Direccio` | Aina Ciurans i Rut Tornil | Agrupa les persones de Direcció i facilita l'accés als recursos directius. |
| `GG_Administracio` | Dídac Gassó i Laia Macias | Dona accés als recursos compartits d'Administració. |
| `GG_Suport_Tecnic` | Estel Birosta, Aina Zuriguel i Lluïsa Richart | Dona accés als recursos de suport, incidències i eines pròpies del departament. |
| `GG_Produccio_Musical` | Roser Alberch, Guillem Adella, Meritxell Reglat, Alícia Monclús, Carles Molins i Eulàlia Galcera | Dona accés als continguts, artistes i catàleg musical. |
| `GG_Informatica` | Talia Costas i Alex Soriano | Agrupa el personal que administra i manté els sistemes informàtics. |
| `GG_Externs` | Pere Espinalt i Neus Bages | Limita els col·laboradors externs als recursos compartits autoritzats. |
| `GG_Caps_Departament` | Laia Macias, Lluïsa Richart, Meritxell Reglat i Talia Costas | Permet assignar accessos específics a les persones responsables dels departaments. |
| `GG_Projecte_Campanya_Estiu` | Persones assignades temporalment al projecte | Dona accés al projecte sense modificar el departament habitual de cada participant. |

---

# 8. Cas que complica el model

Laia treballa al departament d'Administració, però també és la responsable del departament.

És suficient que pertanyi només al conjunt `Administració`?

- [ ] Sí
- [x] No

**Per què?**

El conjunt `Administració` ha de donar els permisos comuns a tots els membres del departament, però Laia també necessita accedir a informació reservada de gestió. Si aquest privilegi es donés al grup general, Dídac també el rebria sense necessitar-lo.

**Quina possible solució proposes?**

Laia hauria de pertànyer al grup general `GG_Administracio` i a un altre grup específic, com ara `GG_Responsables_Administracio`, amb lectura i escriptura sobre `administracio/gestio_departament`.

---

# 9. Un altre cas

Diverses persones de departaments diferents participen temporalment en el projecte `Campanya Estiu`.

Creus que hauríem de canviar-les de departament?

- [ ] Sí
- [x] No

**Si no, com podríem donar-los accés als recursos del projecte?**

Es podria crear el grup temporal `GG_Projecte_Campanya_Estiu`, assignar-li lectura i escriptura sobre la carpeta del projecte i afegir-hi només les persones participants. Quan el projecte acabés, se les retiraria del grup o es desactivaria el grup, sense modificar els seus departaments habituals.

---

# 10. Conclusions

### Usuari

Un usuari representa una persona o identitat que pot iniciar sessió al sistema i utilitzar els recursos que tingui autoritzats.

### Recurs

Un recurs és qualsevol element del sistema al qual es pot accedir, com ara una carpeta, un fitxer, una impressora, una aplicació o un servidor.

### Permís

Un permís determina quines accions pot fer un usuari o grup sobre un recurs, per exemple llegir-lo, modificar-lo o administrar-lo.

### Grup

Un grup serveix per reunir usuaris amb necessitats semblants i assignar-los permisos de manera conjunta.

---

# 11. Regla de mínim privilegi

Analitza aquesta afirmació:

> Un usuari només hauria de tenir els permisos estrictament necessaris per realitzar la seva feina.

Explica amb les teves paraules què significa.

---

---

Posa un exemple relacionat amb MusicCloud.

---

---

---

# 12. Pregunta final

Imagina que demà MusicCloud passa de 14 treballadors a 500.

Quina de les dues estratègies consideres més adequada?

☐ Assignar permisos individualment a cada usuari.

☐ Organitzar els usuaris segons les seves necessitats i assignar permisos a aquests conjunts.

Justifica la resposta.

---

---

---

Jo **no faria obligatori que acabessin tota la fitxa abans d'explicar res**. La utilitzaria de manera sincronitzada amb la classe:

**0–40 min:** apartats 1–3 → analitzen MusicCloud i els accessos.  
**40–65 min:** apartats 4–5 → apareix el problema de gestionar permisos individualment.  
**65–85 min:** explicació curta de **usuari, grup, recurs, permís i mínim privilegi**.  
**85–110 min:** apartats 6–9 → apliquen immediatament el concepte de grup.  
**110–120 min:** apartats 10–12 → revisió i tancament.

Hi ha una decisió pedagògica important: a l'apartat 4 **no utilitzo la paraula “grup” fins que l'alumnat ha intentat resoldre el problema**. Això encaixa molt millor amb el cicle que vols seguir: primer tenen el problema, després apareix la necessitat i només aleshores introdueixes el concepte teòric.

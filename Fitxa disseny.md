# Fitxa 2 — Organització del servei de directori de MusicCloud

## Objectiu

En aquesta sessió hem decidit com organitzar els diferents objectes de MusicCloud dins d'un servei de directori.

Aquesta fitxa forma part de la **documentació de disseny del sistema**. Les decisions que hi indiquis s'utilitzaran posteriorment durant la implantació.

# 1. Objectes que hem de gestionar

| Tipus d'objecte | Exemples a MusicCloud |
|---|---|
| Usuaris | Dídac Gassó, Laia Macias, Talia Costas i els col·laboradors externs Pere Espinalt i Neus Bages. |
| Grups | `GG_Administracio`, `GG_Informatica`, `GG_Externs` i `GG_Projecte_Campanya_Estiu`. |
| Equips | Ordinadors de sobretaula i portàtils dels treballadors; el model de classe també identifica mòbils i impressores. |
| Servidors | Servidor de fitxers, d'aplicacions i controlador de domini, quan s'implantin. |
| Comptes d'aplicacions o serveis | Comptes propis de l'aplicació, de les còpies de seguretat i d'altres tasques automàtiques. |

**Hi afegiria algun altre tipus d'objecte?** El dibuix de classe també enumera elements de **xarxa** (encaminadors, commutadors, tallafocs, NAS i SAI) i **programari**. Cal inventariar-los i gestionar-los, però no tots es representen necessàriament com a objectes o OU d'un directori Active Directory. Les impressores compartides es poden publicar al directori; els mòbils es gestionaran segons si la solució escollida permet integrar-los-hi.

---

# 2. Organització mitjançant unitats organitzatives

| OU | Què contindrà? | Per què la crees? |
|---|---|---|
| `Usuaris` | Comptes personals, subdividits per departament i en `Externs`. | Gestionar incorporacions, baixes i polítiques segons el tipus de persona. |
| `Grups` | Grups de departaments, projectes i funcions. | Localitzar i mantenir els grups de seguretat. |
| `Equips` | Equips de sobretaula i portàtils, subdividits per tipus. | Seguir l'esquema de classe i aplicar configuracions pròpies dels clients. |
| `Equips/Servidors` | Comptes dels equips que fan de servidors. | Seguir l'esquema de classe i aplicar-los controls diferents dels clients. |
| `Comptes_Servei` | Identitats d'aplicacions i processos automàtics. | Controlar separadament els seus permisos i credencials. |

En la representació general de classe, `Equips` inclou també **impressores** i **mòbils**. Els mostrem al disseny com a categories previstes; la seva presència real dins del directori dependrà de com s'implantin. Els dispositius de xarxa i el programari es documentaran en un inventari tècnic.

## 2.1. Organització dels usuaris

```text
MusicCloud
└── Usuaris
    ├── Direccio
    ├── Administracio
    ├── Suport_Tecnic
    ├── Produccio_Musical
    ├── Informatica
    └── Externs
```

Cada treballador intern s'ubica a l'OU del seu departament habitual. Pere Espinalt i Neus Bages s'ubiquen a `Externs` perquè la seva col·laboració és externa i temporal.

---

# 3. OU o grup?

| Necessitat | OU | Grup |
|---|:-:|:-:|
| Organitzar els treballadors d'Administració | ☑ | ☐ |
| Donar accés a la carpeta d'Administració | ☐ | ☑ |
| Organitzar els ordinadors clients | ☑ | ☐ |
| Identificar les persones que participen en Campanya Estiu | ☐ | ☑ |
| Organitzar els servidors | ☑ | ☐ |
| Donar privilegis als administradors del sistema | ☐ | ☑ |
| Organitzar els comptes utilitzats per aplicacions | ☑ | ☐ |

### Explica amb les teves paraules la diferència principal entre una OU i un grup

**OU:** És una divisió de l'arbre del directori que serveix per col·locar i administrar objectes i aplicar-los polítiques. El compte d'una persona ocupa una ubicació dins d'aquest arbre.

**Grup:** És un conjunt d'identitats que comparteixen permisos o una funció. Tal com indica l'esquema de classe, els **grups serveixen per assignar permisos**. Una persona pot pertànyer simultàniament a diversos grups sense canviar d'OU.

---

# 4. Un mateix usuari: ubicació i pertinença

**Dídac Gassó** treballa a Administració i participa en el projecte Campanya Estiu.

**En quina OU ubicaries el seu compte?** A `MusicCloud/Usuaris/Administracio`, que correspon al seu departament habitual.

**A quins grups podria pertànyer?** A `GG_Administracio` i `GG_Projecte_Campanya_Estiu`. Si hi ha un grup general de treballadors interns, també en podria ser membre. No necessita `GG_Responsables_Administracio`, perquè no és el cap del departament.

### Per què no és contradictori que estigui en una OU però pertanyi a diversos grups?

L'OU indica **on s'administra el compte**; els grups indiquen **a quins recursos pot accedir**. Dídac continua treballant a Administració mentre participa en un projecte transversal. Quan acabi la campanya, n'hi haurà prou de retirar-lo del grup del projecte.

---

# 5. Servei de directori

Un **servei de directori** és un sistema centralitzat que organitza informació sobre usuaris, grups, equips i altres objectes d'una xarxa. Permet trobar-los i gestionar les identitats des d'un lloc comú.

**Quin problema resol a MusicCloud?** Evita mantenir comptes i accessos de manera independent a cada equip o recurs. Quan algú entra a l'empresa, canvia de funció o se'n va, Informàtica pot actualitzar el compte i els grups corresponents de manera coherent.

---

# 6. LDAP

**LDAP és:** Un protocol estàndard que permet consultar i modificar informació d'un directori, com ara usuaris, grups i atributs.

**LDAP no és:** Un producte concret ni un sinònim d'Active Directory. Per si sol tampoc no constitueix tota la gestió de l'autenticació, les polítiques i els permisos.

| Afirmació | C | F |
|---|:-:|:-:|
| LDAP és sinònim d'Active Directory | ☐ | ☑ |
| LDAP permet accedir i consultar informació d'un directori | ☑ | ☐ |
| OpenLDAP és una implementació d'un servei de directori | ☑ | ☐ |
| Active Directory utilitza LDAP, entre altres tecnologies | ☑ | ☐ |

---

# 7. DIT de MusicCloud

Aquesta és la proposta d'arbre lògic. Els servidors i comptes de servei que hi apareixen són exemples de la futura implantació.

```text
MusicCloud
├── Usuaris
│   ├── Direccio                 (Aina Ciurans, Rut Tornil)
│   ├── Administracio            (Dídac Gassó, Laia Macias)
│   ├── Suport_Tecnic            (Estel Birosta, Aina Zuriguel,
│   │                             Lluïsa Richart)
│   ├── Produccio_Musical        (Roser Alberch, Guillem Adella,
│   │                             Meritxell Reglat, Alícia Monclús,
│   │                             Carles Molins, Eulàlia Galcera)
│   ├── Informatica              (Talia Costas, Alex Soriano)
│   └── Externs                  (Pere Espinalt, Neus Bages)
├── Grups
│   ├── Departaments             (GG_Direccio, GG_Administracio,
│   │                             GG_Suport_Tecnic, GG_Produccio_Musical,
│   │                             GG_Informatica, GG_Externs)
│   ├── Projectes                (GG_Projecte_Campanya_Estiu)
│   └── Funcions                 (GG_Caps_Departament,
│                                 GG_Responsables_Administracio,
│                                 GG_Administradors_Sistema)
├── Equips
│   ├── Sobretaula              (clients fixos)
│   ├── Portatils                (clients portàtils)
│   ├── Servidors                (fitxers, aplicacions i domini)
│   ├── Impressores              (si es publiquen al directori)
│   └── Mobils                   (si s'integren en la solució)
└── Comptes_Servei               (aplicació i còpies de seguretat)
```

Les carpetes compartides són recursos als quals s'assignaran permisos mitjançant grups; no són subdivisions d'aquest arbre d'objectes. L'apartat **Xarxa** i el de **Programari** que apareixen a la pissarra descriuen altres àrees que cal inventariar i administrar; aquest DIT se centra en els objectes que la fitxa demana organitzar dins del servei de directori.

---

# 8. Justificació del disseny

### Decisió 1

Separar els comptes personals per departament i reservar una OU pròpia per a `Externs`.

**Justificació:** Facilita les altes i baixes i permet aplicar als col·laboradors externs polítiques més restrictives, com una durada limitada del compte. La ubicació reflecteix la relació habitual de la persona amb MusicCloud.

### Decisió 2

Crear grups diferents per departament, projecte i funció especial.

**Justificació:** Podem assignar l'accés a les carpetes als grups. Dídac accedeix a Administració i a Campanya Estiu sense duplicar el compte; Laia pot rebre permisos de responsable sense concedir-los a tot el departament.

---

# 9. Comprovació final

Respon breument.

### a) Per què no seria una bona idea guardar tots els usuaris, grups, equips i servidors al mateix nivell sense organitzar-los?

---

---

### b) Per què no hauríem d'utilitzar les OU per substituir els grups de permisos?

---

---

### c) Si MusicCloud passa de 14 a 500 treballadors, quina característica del disseny que has fet avui facilitarà més l'administració?

---

---

---

# Documentació final del sistema

A partir de les decisions preses durant la sessió, deixa definida la proposta que utilitzarem inicialment per a MusicCloud.

## Estructura d'unitats organitzatives

```text
MusicCloud
│
│
│
│
```

## Criteri utilitzat per organitzar els objectes

---

---

## Criteri utilitzat per diferenciar OU i grups

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
| `Equips` | Ordinadors clients dels treballadors. | Aplicar configuracions pròpies dels llocs de treball. |
| `Servidors` | Comptes dels equips que fan de servidors. | Aplicar controls i configuracions diferents dels clients. |
| `Comptes_Servei` | Identitats d'aplicacions i processos automàtics. | Controlar separadament els seus permisos i credencials. |

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

Indica quina opció utilitzaries principalment en cada cas.

|Necessitat|OU|Grup|
|---|:-:|:-:|
|Organitzar els treballadors d'Administració|☐|☐|
|Donar accés a la carpeta d'Administració|☐|☐|
|Organitzar els ordinadors clients|☐|☐|
|Identificar les persones que participen en Campanya Estiu|☐|☐|
|Organitzar els servidors|☐|☐|
|Donar privilegis als administradors del sistema|☐|☐|
|Organitzar els comptes utilitzats per aplicacions|☐|☐|

### Explica amb les teves paraules la diferència principal entre una OU i un grup.

**OU:**

---

---

**Grup:**

---

---

---

# 4. Un mateix usuari: ubicació i pertinença

Considera aquest cas:

**Dídac Gassó**

- treballa a Administració;
    
- participa en el projecte Campanya Estiu.
    

Indica:

**En quina OU ubicaries el seu compte?**

---

**A quins grups podria pertànyer?**

---

---

### Per què no és contradictori que estigui en una OU però pertanyi a diversos grups?

---

---

---

# 5. Servei de directori

Explica breument què entens per **servei de directori**.

---

---

Quin problema resol a MusicCloud?

---

---

---

# 6. LDAP

Completa les frases següents.

**LDAP és:**

---

**LDAP no és:**

---

Indica si les afirmacions són certes o falses.

|Afirmació|C|F|
|---|:-:|:-:|
|LDAP és sinònim d'Active Directory|☐|☐|
|LDAP permet accedir i consultar informació d'un directori|☐|☐|
|OpenLDAP és una implementació d'un servei de directori|☐|☐|
|Active Directory utilitza LDAP, entre altres tecnologies|☐|☐|

---

# 7. DIT de MusicCloud

Dibuixa la proposta final de **Directory Information Tree (DIT)** de MusicCloud.

Ha de mostrar, com a mínim:

- usuaris;
    
- grups;
    
- equips;
    
- servidors;
    
- comptes d'aplicacions o serveis;
    
- les subdivisions que consideris necessàries.
    

```text
MusicCloud
│
│
│
│
│
```

---

# 8. Justificació del disseny

Escull **dues decisions** del teu DIT que consideris importants i justifica-les.

### Decisió 1

---

**Justificació:**

---

---

### Decisió 2

---

**Justificació:**

---

---

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

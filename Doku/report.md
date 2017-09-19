Abkürzungsverzeichnis
=====================

Einleitung
==========

Projektüberblick und Ziele
--------------------------

Relevante Grundlagen zu LTE
---------------------------

OpenAirInterface (OAI)
----------------------

Versuchsaufbau
--------------

Aufsetzen der Projektumgebung
=============================

Evolved Node B (eNodeB)
-----------------------

### Konfiguration der Hardware/Software
SW = Ubuntu 14.4_03
phy. PC mit USB 3
Ettus SDR (B210)

### OAI Installation

Evolved Packet Core (EPC)
-------------------------

Reihenfolge:
- Git Repositories openair-cn auschecken (Wichtig develop branch)
- Kernel > 4.7.x oai
- hostname und etc/hosts konfigurieren
- Konfigurationsdateien nach /usr/local/etc/oai kopieren
- Zertifikate kopiert + installiert
- installieren von hss,mme,spgw
- in mmeidentity-Tabelle epc hostnamen 'hss.openair4G.eur' eintragen, Achtung ID merken
- in users und pdn sim karte eintragen, außerdem in mmeidentity-Spalte (Fremdschlüssel auf mmeidentity-Tabelle) eintragen

### Konfiguration der Hardware/Software
SW = Ubuntu 14.4_03 (Kernel > 4.7.x) wegen GTP Library
VM

### OAI Installation

### Konfiguration von HSS, MME und S+P-GW

User Equipment (UE)
-------------------
Huawei LTE-Stick

Aufbau der Projektumgebung
--------------------------
LTE- Stick, eNB + EPC

Herstellen einer Internetverbindung
===================================

Evaluation
==========

Datenrate
---------

### Uplink

### Downlink

### Evaluierung der Messdaten

Latenz
----------

### Verzögerung der S1-Schnittstelle

### Evaluierung der Messdaten

Fazit und Ausblick
==================

Quellenverzeichnis
==================

Anhang
======
Arbeitsaufteilung
-----------------

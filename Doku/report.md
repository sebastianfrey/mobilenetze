Abkürzungsverzeichnis
=====================
Am Ende Alphabetisch sortieren!

**LTE:** Long Term Evolution  
**eNodeB:** Evolved Node B  
**EPC:** Evolved Packet Core  
**OAI:** Open Air Interface  
**HSS:** Home Subscriber Server  
**MME:** Mobility Management Entity  
**S+P-GW:** Serving Gateway (S-GW) + PDN (Paket Data Network) Gateway (P-GW)  

Einleitung
==========
Die vorliegende Projektdokumentation ist Teil der Veranstaltung „Mobile Netze“ an der Fakultät für Informatik und Mathematik (FK 07) der Hochschule München im Sommersemester 2017. Das Projekt dient dabei der Vertiefung der in den Vorlesungsanteilen erworbenen Kenntnisse und Fähigkeiten durch praktisches Experimentieren mit mobiler Kommunikation. Im Fall dieses Projekts, geht es um das Verständnis für die grundlegenden Prinzipien von LTE-Netzwerken, sowie die Kenntnis und praktische Erfahrungen mit dort verwendeten Techniken und Standards.

Projektüberblick und Ziele
--------------------------
Das Projekt befasst sich mit dem experimentellen Aufbau eines LTE-Netzwerks und versucht sich dabei über dieses Netzwerk mit einem LTE-Stick ins Internet zu verbinden. Das Netzwerk, bestehend aus einer Evolved Node B (eNodeB) und dem Kernnetzwerk (Evolved Packet Core, EPC), soll dabei mit Hilfe des OpenAirInterface (OAI) simuliert werden.
Im Kern ist das Projekt in die folgenden drei Stufen unterteilt:
- Stufe 1: Aufbau einer durchgehenden Verbindung von einem LTE-Stick über die eNodeB bis zur EPC (mit den Komponenten HSS, MME und S+P-GW) mit Hilfe des OpenAirInterface.
- Stufe 2: Erweiterung der Verbindung durch Anschluss an das Internet.
- Stufe 3: Evaluierung der Performance bzw. genauere Untersuchungen auf Protokollebene mit Wireshark. 

Stufe 1 umfasst dabei die Minimalanforderungen an das Projekt. Die Stufen 2 und 3 sind entsprechende Erweiterungen der Mindestumsetzung.
Der experimentelle Aufbau soll am Ende die Möglichkeit bieten, ein LTE-Netzwerk und dessen Zusammenhänge genauer zu untersuchen um ein Verständnis für die Performance sowie die internen Abläufe der einzelnen Netzwerkkomponenten zu bekommen.

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

Der EPC ist das zentrale Element des aufzubauenden LTE-Netzwerkes. Es setzt sich aus den drei Komponenten HSS, MME und SPGW zusammen. Dabei ist es möglich die einzelnen Komponenten des EPC auf verschiedenen Rechnern zu installieren. Im Rahmen dieses Projektes wurden der Einfachheit halber jedoch die EPC Komponenten auf einem Rechner installiert. Die einzelnen Schritte zur Installation und Integration des OAI EPC's werden in den Folgenden Abschnitten erörtert.

### Konfiguration der Hardware/Software

Als Betriebssystem für den EPC empfiehlt das OAI auf seiner Website Ubuntu 16.04 LTS (Xenial Xerus) auf einem dedizierten Rechner. Im Rahmen der Projektausführung wurde der EPC jedoch zuerst auf einer Virtuellen Maschine (VM) mit Ubuntu 14.04 LTS (Trusty Tahr) lauffähig installiert. Aufgrund eines Netzwerkproblems zwischen eNodeB-Rechner und der EPC-VM, wurde im weiteren Projektverlauf der EPC erneut auf einem dedizierten Rechner mit Ubuntu 16.04 LTS installiert. Verursacht wurde das Kommunikationsproblem durch den CiscoAnyConnect-VPN-Client auf dem eNodeB-Rechner, wodurch die beiden Komponenten über das erforderliche SCTP-Protokoll nicht miteinander kommunizieren konnten und sommit ein Zusammenschluss beider Komponenten nicht möglich war.

Nach der Installation von Ubuntu 16.04 auf dem dedizierten Rechner wird zuerst ein Kernelupgrade auf die Version 4.7 durchgeführt. Wichtig beim Upgrade des Kernels ist, dass dieser das GTP (GPRS Transport Protool) Modul beinhaltet. Mit folgenden Kommandos kann der Kernel installiert werden:

```sh
cd ~/Documents
git clone https://gitlab.eurecom.fr/oai/linux-4.7.x.git
cd linux-4.7.x
sudo dpkg -i linux-headers-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb linux-image-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb
``` 

Mit dem Befehl `uname -r` lässt sich überprüfen ob die Kernelinstallation erfolgreich war oder nicht. Als Ausgabe in der Kommandzeile sollte hier `4.7.7-oaiepc` oder ähnlich erscheinen.

Im nächsten Schritt gilt es den Hostnamen des Rechners anzupassen. Für den EPC-Rechner wurder der Hostname `hss` gewählt.

```sh
sudo hostname hss
```

Außerdem muss die `/etc/hosts`-Datei angepasst werden.

```sh
nano /etc/hosts

127.0.0.1    localhost
127.0.1.1    hss.openair4G.eur    hss

```

### OAI Installation

TODO ausformulieren

- Git Repositories openair-cn auschecken (Wichtig develop branch)
- Kernel > 4.7.x oai
- hostname und etc/hosts konfigurieren
- Konfigurationsdateien nach /usr/local/etc/oai kopieren
- Zertifikate kopiert + installiert
- installieren von hss,mme,spgw
- in mmeidentity-Tabelle epc hostnamen 'hss.openair4G.eur' eintragen, Achtung ID merken
- in users und pdn sim karte eintragen, außerdem in mmeidentity-Spalte (Fremdschlüssel auf mmeidentity-Tabelle) eintragen

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
| Gliederungspunkt | Name |
| :--------------- | ---: |
| a                | b    |

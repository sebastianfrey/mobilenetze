Abkürzungsverzeichnis
=====================
Am Ende Alphabetisch sortieren!

**LTE:** Long Term Evolution  
**eNodeB/eNB:** Evolved Node B  
**EPC:** Evolved Packet Core  
**OAI:** Open Air Interface  
**HSS:** Home Subscriber Server  
**MME:** Mobility Management Entity  
**S+P-GW:** Serving Gateway (S-GW) + PDN (Paket Data Network) Gateway (P-GW)  
**3GPP:** 3rd Generation Partnership Project  
**SDR:** Software Defined Radio  
**EUTRAN:** Evolved UMTS Terrestrial Radio Access  
**UMTS:** Universal Mobile Telecommunications System  
**OFDM:** Orthogonal Frequency Division Multiplexing  

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
Der LTE (Long Term Evolution) Standard ist eine Weiterentwicklung von UMTS (Universal Mobile Telecommunications System) und wurde als erste Version in 3GPP Release 8 spezifiziert [5]. Mit 3GPP Release 10 (LTE Advanced) wurden zudem Erweiterungen spezifiziert, um das System noch schneller und effizienter zu machen.

Zu den wichtigsten Neuerungen von LTE gegenüber UMTS gehört zum einen ein neues Übertragungsverfahren und zum anderen der Fokus auf das paketvermittelnde Internet-Protokoll (IP). LTE verwendet das Übertragungsverfahren Orthogonal Frequency Division Multiplexing (OFDM), dass einen schnellen Datenstrom in viele langsamere Datenströme aufteilt und diese dann gleichzeitig überträgt. Dies führt zu einer erhöhten Datenrate unter LTE. „Während UMTS noch ein leitungsvermittelndes Kernnetz für Sprache-, SMS und andere Dienste hatte, gibt es in LTE nur noch ein paketvermittelndes Kernnetz, über das alle Dienste abgewickelt werden. Einzige Ausnahme ist der SMS-Dienst, der nach wie vor über Signalisierungsnachrichten abgewickelt wird.“ ([1], S. 231 ff.)

Die LTE-Netzwerk-Architektur ist wie bei GSM und UMTS grob in ein Radionetz und ein Kernnetz unterteilt. Unter LTE wurde aber der Anteil logischer Komponenten reduziert, um die Effizienz zu steigern, Kosten zu senken und die Latenzzeiten zu minimieren.  
Abbildung 1 zeigt alle Komponenten eines LTE-Netzwerks von den mobilen Endgeräten (UEs) bis ins Internet. Die Basisstationen (eNodeBs) bilden zusammen mit den UEs das oben bereits erwähnte Radionetz. Das Kernnetz besteht aus einer Teilnehmerdatenbank (HSS), dem Serving Gateway (Serving-GW), dem Paket Data Network Gateway (PDN-GW) sowie der Benutzerverwaltung (MME). Die MME ist der Netzwerkknoten, der für die Signalisierung zwischen den eNodeBs und dem Kernnetzwerk verantwortlich ist. Das Serving-GW ist verantwortlich für die Weiterleitung von Nutzerdaten in IP-Tunneln zwischen den eNodeBs und dem PDN-Gateway. Das PDN-Gateway bildet am Ende den Übergang zum Internet.

![LTE-Netzwerk im Überblick ([1], S. 234)]{img/LTE-Netzwerk_im_Überblick.pdf}

Verbunden sind alle Komponenten über die in Abbildung 1 gezeigten Schnittstellen, die nachfolgend aufgelistet und kurz beschrieben werden ([1], S. 234 ff.):
- S6a: Schnittstelle für den Informationsaustausch zwischen HSS und MME über das IP-basierte DIAMETER-Protokoll.
- S1: Schnittstelle zwischen den Basisstationen und dem Kernnetz.
  - S1-CP: Steuerebene (Control Plane) für die Kommunikation der eNodeBs mit dem Kernnetz (um sich beim Netzwerk anzumelden, um Status- und Keep-Alive-Nachrichten zu senden, um Konfigurationsinformationen vom Netzwerk zu erhalten) sowie dem Austausch benutzerspezifischer Signalisierung.
  - S1-UP: Nutzerebene (User Plane) zur Übertragung der Nutzdaten über das GPRS Tunneling Protocol (GTP).
- S11: Schnittstelle für die Übertragung von Kommandos der MME zum S-GW, über das GPRS Tunneling Protocol (GTP), wenn die MME neue Tunnel und deren Modifikation erstellt. Dies wird immer dann notwendig, wenn eine neue eNodeB von einer anderen MME und einem anderen S-GW bedient wird.
- S5: Schnittstelle zwischen dem SGW und dem PGW
  - S5-CP: Control Plane, über die die MME über das PGW eine IP-Adresse für ein Endgerät anfordert.
  - S5-UP: User Plane, zur Übertragung von Nutzdaten zwischen SGW und PGW über das GPRS Tunneling Protocol (GTP).
- SGi: Schnittstelle ins Internet.

OpenAirInterface (OAI)
----------------------
Das OpenAirInterface (OAI) ist eine Hardware und Software Technologie-Plattform zum Erstellen einer vollständigen und realitätsnahen LTE-Netzwerknachbildung. Die experimentelle LTE-Implementierung (Release 8 und partiell Release 10) des OAI ist in Standard C für mehrere Echtzeit-Linux-Varianten geschrieben, die für Intel x86 und ARM-Prozessoren optimiert und als freie Software unter dem OAI-Lizenzmodell veröffentlicht wurden. Die Implementierung beinhaltet sowohl EUTRAN (eNB und UE) als auch EPC (MME, S+P-GW, und HSS) und umfasst dabei den kompletten Protokoll-Stack des 3GPP Standards. Das OAI bietet eine umfangreiche Entwicklungsumgebung mit einer Reihe von integrierten Tools wie hoch realistische Emulationsmodi, Soft-Monitoring und Debugging-Tools, einen Protokollanalyzer, Performance-Profiler und ein konfigurierbares Logging-System für alle Layer und Kanäle. [2]  
Im vorliegenden Projekt wird das OAI dazu genutzt, um eine LTE Base Station (OAI eNB) und ein Core Network (OAI EPC) auf je einem PC zu bauen und einzurichten (siehe Abbildung 2 und 3). Die OAI eNB kann entweder mit kommerziellen UEs oder OAI UEs verbunden werden, um verschiedene Konfigurationen und Netzwerkaufbauten zu testen und das Netzwerk sowie das mobile Gerät in Echtzeit zu überwachen. Im Folgenden steht jedoch die Verwendung eines kommerziellen User Equipments (UE) im Fokus.

![OpenAirInterface und dessen Bestandteile]{img/OpenAirInterface_und_dessen_Bestandteile.pdf}

Im Vergleich zum Standard LTE-Netzwerk aus Abbildung 1 werden im OpenAirInterface die beiden Komponenten SGW und PGW zu einer gemeinsamen Komponente (S+P-GW) zusammengeschlossen. Dadurch fällt auch die Schnittstelle S5 (CP und UP) als solches weg und wandert ins Innere von S+P-GW.  
Des Weiteren ist zu erwähnen, dass für die Erstellung der LTE-Netzwerknachbildung zum einen zahlreiche Tutorials [3] als auch entsprechende Mailing-Lists [4] über die Homepage des OAI abrufbar sind. Diese kommen beim Aufsetzen der Projektumgebung (Kapitel 3) vermehrt zum Einsatz.

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
[1] M. Sauter, Grundkurs Mobile Kommunikationssysteme, Springer Fachmedien, Wiesbaden, 2015  
[2] Homepage von OpenAirInterface: <http://www.openairinterface.org/?page_id=864>, Stand: 21.09.2017  
[3] OAI Tutorials: <https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/OpenAirUsage>, Stand: 21.09.2017  
[4] OAI Mailing-Lists: <https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/MailingList>, Stand: 21.09.2017 
[5] 3GPP Release 8: < http://www.3gpp.org/specifications/releases/72-release-8>, Stand 21.09.2017  

Anhang
======
Arbeitsaufteilung
-----------------
| Gliederungspunkt | Name |
| :--------------- | ---: |
| a                | b    |

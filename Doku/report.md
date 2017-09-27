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
**UE:** User Equipment
**GUMMEI:** Globally Unique Mobile Management Entity Identifer
**TAI:** Tracking Area Identity

Einleitung (Michael)
==========
Die vorliegende Projektdokumentation ist Teil der Veranstaltung „Mobile Netze“ an der Fakultät für Informatik und Mathematik (FK 07) der Hochschule München im Sommersemester 2017. Das Projekt dient der Vertiefung der in dem Vorlesungsanteil erworbenen Kenntnisse und Fähigkeiten durch praktisches Experimentieren mit mobiler Kommunikation. Im Fall dieses Projekts, geht es um das Verständnis für die grundlegenden Prinzipien von LTE-Netzwerken, sowie die Kenntnis und praktische Erfahrungen mit dort verwendeten Techniken und Standards.

Projektüberblick und Ziele
--------------------------
Das Projekt befasst sich mit dem experimentellen Aufbau eines LTE-Netzwerks und versucht sich über dieses Netzwerk mit einem LTE-Stick ins Internet zu verbinden. Das Netzwerk, bestehend aus einer Evolved Node B (eNodeB) und dem Kernnetzwerk (Evolved Packet Core, EPC), soll dabei mit Hilfe des OpenAirInterface (OAI) simuliert werden.
Im Kern ist das Projekt in die folgenden drei Stufen unterteilt:
- Stufe 1: Aufbau einer durchgehenden Verbindung von einem LTE-Stick über die eNodeB bis zur EPC (mit den Komponenten HSS, MME und S+P-GW) mit Hilfe des OpenAirInterface.
- Stufe 2: Erweiterung der Verbindung durch Anschluss an das Internet.
- Stufe 3: Evaluierung der Performance bzw. genauere Untersuchungen auf Protokollebene mit Wireshark.

Stufe 1 umfasst dabei die Minimalanforderungen an das Projekt. Die Stufen 2 und 3 sind entsprechende Erweiterungen der Mindestumsetzung.
Der experimentelle Aufbau soll am Ende die Möglichkeit bieten, ein LTE-Netzwerk und dessen Zusammenhänge genauer zu untersuchen, um ein Verständnis für die Performance sowie die internen Abläufe der einzelnen Netzwerkkomponenten zu bekommen.

Relevante Grundlagen zu LTE
---------------------------
Der LTE (Long Term Evolution) Standard ist eine Weiterentwicklung von UMTS (Universal Mobile Telecommunications System) und wurde als erste Version in 3GPP Release 8 spezifiziert [@3gpprel8]. Mit 3GPP Release 10 (LTE Advanced) wurden zudem Erweiterungen spezifiziert, um das System noch schneller und effizienter zu machen.

Zu den wichtigsten Neuerungen von LTE gegenüber UMTS gehört zum einen ein neues Übertragungsverfahren und zum anderen der Fokus auf das paketvermittelnde Internet-Protokoll (IP). LTE verwendet das Übertragungsverfahren Orthogonal Frequency Division Multiplexing (OFDM), dass einen schnellen Datenstrom in viele langsamere Datenströme aufteilt und diese dann gleichzeitig überträgt. Dies führt zu einer erhöhten Datenrate unter LTE. „Während UMTS noch ein leitungsvermittelndes Kernnetz für Sprache-, SMS und andere Dienste hatte, gibt es in LTE nur noch ein paketvermittelndes Kernnetz, über das alle Dienste abgewickelt werden. Einzige Ausnahme ist der SMS-Dienst, der nach wie vor über Signalisierungsnachrichten abgewickelt wird.“ [@sauter15, S. 231 ff.]

Die LTE-Netzwerk-Architektur ist wie bei GSM und UMTS grob in ein Radionetz und ein Kernnetz unterteilt. Unter LTE wurde aber der Anteil logischer Komponenten reduziert, um die Effizienz zu steigern, Kosten zu senken und die Latenzzeiten zu minimieren.  
Abbildung 1 zeigt alle Komponenten eines LTE-Netzwerks von den mobilen Endgeräten (UEs) bis ins Internet. Die Basisstationen (eNodeBs) bilden zusammen mit den UEs das oben bereits erwähnte Radionetz. Das Kernnetz besteht aus einer Teilnehmerdatenbank (HSS), dem Serving Gateway (Serving-GW), dem Paket Data Network Gateway (PDN-GW) sowie der Benutzerverwaltung (MME). Die MME ist der Netzwerkknoten, der für die Signalisierung zwischen den eNodeBs und dem Kernnetzwerk verantwortlich ist. Das Serving-GW ist verantwortlich für die Weiterleitung von Nutzerdaten in IP-Tunneln zwischen den eNodeBs und dem PDN-Gateway. Das PDN-Gateway bildet am Ende den Übergang zum Internet.

![LTE-Netzwerk im Überblick](img/LTE-Netzwerk_im_Ueberblick.pdf)

Verbunden sind alle Komponenten über die in Abbildung 1 gezeigten Schnittstellen, die nachfolgend aufgelistet und kurz beschrieben werden [@sauter15, S. 234 ff.]:
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
Das OpenAirInterface (OAI) ist eine Hardware und Software Technologie-Plattform zum Erstellen einer vollständigen und realitätsnahen LTE-Netzwerknachbildung. Die experimentelle LTE-Implementierung (Release 8 und partiell Release 10) des OAI ist in Standard C für mehrere Echtzeit-Linux-Varianten geschrieben, die für Intel x86 und ARM-Prozessoren optimiert und als freie Software unter dem OAI-Lizenzmodell veröffentlicht wurden. Die Implementierung beinhaltet sowohl EUTRAN (eNB und UE) als auch EPC (MME, S+P-GW, und HSS) und umfasst dabei den kompletten Protokoll-Stack des 3GPP Standards. Das OAI bietet eine umfangreiche Entwicklungsumgebung mit einer Reihe von integrierten Tools wie hoch realistische Emulationsmodi, Soft-Monitoring und Debugging-Tools, einen Protokollanalyzer, Performance-Profiler und ein konfigurierbares Logging-System für alle Layer und Kanäle. [@openairinterface]  
Im vorliegenden Projekt wird das OAI dazu genutzt, um eine LTE Base Station (OAI eNB) und ein Core Network (OAI EPC) auf je einem PC zu bauen und einzurichten (siehe Abbildung 2 und 3). Die OAI eNB kann entweder mit kommerziellen UEs oder OAI UEs verbunden werden, um verschiedene Konfigurationen und Netzwerkaufbauten zu testen und das Netzwerk sowie das mobile Gerät in Echtzeit zu überwachen. Im Folgenden steht jedoch die Verwendung eines kommerziellen User Equipments (UE) im Fokus.

![OpenAirInterface und dessen Bestandteile](img/OpenAirInterface_und_dessen_Bestandteile.pdf)

Im Vergleich zum Standard LTE-Netzwerk aus Abbildung 1 werden im OpenAirInterface die beiden Komponenten SGW und PGW zu einer gemeinsamen Komponente (S+P-GW) zusammengeschlossen. Dadurch fällt auch die Schnittstelle S5 (CP und UP) als solches weg und wandert ins Innere von S+P-GW.  
Des Weiteren ist zu erwähnen, dass für die Erstellung der LTE-Netzwerknachbildung zum einen zahlreiche Tutorials [@oaitutorial] als auch entsprechende Mailing-Lists [@oaimailinglist] über die Homepage des OAI abrufbar sind. Diese kommen beim Aufsetzen der Projektumgebung (Kapitel 3) vermehrt zum Einsatz.

Versuchsaufbau
--------------
Der in diesem Projekt verwendete Versuchsaufbau ist der untenstehenden Abbildung 3 zu entnehmen. Er besteht aus vier zentralen Komponenten, die nachfolgend kurz beschrieben werden. Das mobile Endgerät, sprich die UE, besteht aus einem Huawei LTE-Stick (E3372), welcher mit der Basisstation (eNodeB) verbunden ist. Die eNodeB wird durch das OAI abgebildet und läuft auf einem physikalischen PC. Da im Umfeld dieses Projekts nicht gefunkt werden darf, ist die Verbindung vom UE zur eNodeB kabelgebunden. Dafür wird neben einem Softwere Defined Radio (USRP B210) auch ein LTE Band7 Duplexer sowie entsprechende Dämpfungsglieder zwischengeschalten. Die EPC, bestehend aus der MME, der HSS und dem S+P-GW, wird ebenfalls durch das OAI abgebildet und läuft auf einem zweiten physischen PC. Die vierte und letzte Komponente stellt dann noch das Internet dar, mit dem sich am Ende der LTE-Stick über die eNodeB und den EPC verbinden soll.

![Versuchsaufbau](img/Versuchsaufbau.pdf)

Aufsetzen der Projektumgebung
=============================

Evolved Node B (eNodeB) (René)
-----------------------

### Konfiguration der Hardware/Software
SW = Ubuntu 14.4_03
phy. PC mit USB 3
Ettus SDR (B210)

### OAI Installation

Evolved Packet Core (EPC) (Sebastian)
-------------------------

Der EPC ist das zentrale Element des aufzubauenden LTE-Netzwerkes. Es setzt sich aus den drei Komponenten HSS, MME und SPGW zusammen. Dabei ist es möglich die einzelnen Komponenten des EPC auf verschiedenen Rechnern zu installieren. Im Rahmen dieses Projektes wurden der Einfachheit halber jedoch die EPC Komponenten auf einem Rechner installiert. Die einzelnen Schritte zur Installation und Integration des OAI EPC's werden in den Folgenden Abschnitten erörtert.

### Konfiguration der Hardware/Software

Als Betriebssystem für den EPC empfiehlt das OAI auf seiner Website Ubuntu 16.04 LTS (Xenial Xerus) auf einem physischen Rechner. Im Rahmen der Projektausführung wurde der EPC jedoch zuerst auf einer Virtuellen Maschine (VM) mit Ubuntu 14.04 LTS (Trusty Tahr) lauffähig installiert. Aufgrund eines Netzwerkproblems zwischen eNodeB-Rechner und der EPC-VM, wurde im weiteren Projektverlauf der EPC erneut auf einem physischen Rechner mit Ubuntu 16.04 LTS installiert. Verursacht wurde das Kommunikationsproblem durch den CiscoAnyConnect-VPN-Client auf dem eNodeB-Rechner, wodurch die beiden Komponenten nicht über das für die Signalisierung verwendete SCTP-Protokoll miteinander kommunizieren konnten. Dadurch war das Zusammenschließen von eNodeB und EPC nicht möglich.

Nach der Installation von Ubuntu 16.04 auf dem physischen Rechner sollte zuerst zuerst ein Kernelupgrade auf die Version 4.7 oder größer durchgeführt werden. Wichtig beim Kernelupgrade ist, dass dieser das GTP (GPRS Transport Protool) Modul beinhaltet. Auf `gitlab.eurocom.fr` stellt das OAI ein optimiertes Kernelpacket, welches das GTP-Modul enthält, zum Download bereit. Im Rahmen des Projektes wurde der zum Zeitpunkt der Projektdurchführung aktuelle Master-Branch des OAI Git-Repositories verwendet.

Der Kernel wurde dann mit Folgenden Kommandos installiert:

```sh
cd ~/Documents
git clone https://gitlab.eurecom.fr/oai/linux-4.7.x.git
cd linux-4.7.x
sudo dpkg -i linux-headers-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb linux-image-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb
```

Mit dem Befehl `uname -r` lässt sich überprüfen ob die Kernelinstallation erfolgreich war oder nicht. Als Ausgabe in der Kommandzeile sollte hier `4.7.7-oaiepc` oder ähnlich erscheinen.

Im nächsten Schritt gilt es den Hostnamen des Rechners anzupassen. Für den EPC-Rechner wurder der Hostname `hss` gewählt. Prinzipiell kann für den EPC-Rechner jeder beliebige Hostname verwendet werden. Im weiteren Verlauf dieses Dokuments wird jedoch angenommen, dass der Hostname des EPC-Rechners `hss` lautet.

Zuerst wird der Hostname mit nachfolgendem Befehl neu gesetzt.

```sh
sudo hostname hss
```

Anschließend muss noch die `/etc/hosts`-Datei angepasst werden. Wie schon beim Hostnamen kann das Realm beliebig gewählt werden. Im weiteren Verlauf dieses Dokuments wird jedoch ebenfalls angenommen, dass der Real des EPC-Rechners `openair4G.eur` lautet.

```sh
sudo nano /etc/hosts

127.0.0.1    localhost
127.0.1.1    hss.openair4G.eur    hss

```

Nachdem dem Kernelupdate und dem Anpassen des Hostnames sowie der Hosts-Konfiguration, empfiehlt es sich den Rechner neu zu starten und die vorher getätigten Anpassungen noch einmal zu überprüfen. So kann es eventuell passieren, dass während dem Bootvorgang ein anderer Kernel als der zuvor installierte geladen wird. Dies lässt sich beheben in dem man beim Bootvorgang den korrekten Kernel manuell wählt. Damit nicht bei jedem Neustart des EPC-Rechners der Kernel manuell gewählt werden muss, empfiehlt es sich in der  `/etc/default/grub` Konfigurationsdatei den `GRUB_DEFAULT` Wert anzupassen. Null bedeutet, dass der Default Kernel geladen wird. Entweder setzt man den `GRUB_DEFAULT` Wert auf den Index des beim Bootvorgang gewünschten Kernels oder man gibt hier den vollen Namen des Kernels wie er im Grub-Menü angezeigt wird an. Vorsicht vor Tippfehlern, denn die können dazu führen, dass der Rechner unter Umständen nicht mehr korrekt bootet.

### OAI Installation

Im Vorherigen Abschnitt wurde beschrieben, wie ein Rechner für die Installation des OAI-EPCs vorbreitet werden muss. Im nachfolgendem Abschnitt wird angenommen, dass die Installation und Vorbereitung des Rechners nach der Anleitung im vorherigen Abschnitt durchgeführt wurde.

Zuerst muss man den Sourcecode für das EPC auschecken.

```bash
git clone https://gitlab.eurecom.fr/oai/openair-cn.git
```

Nach erfoglreichem Download wechselt man in das Verzeichnis `openair-cn`, wechselt in den Developbranch und aktualisiert diesen.

```bash
cd openair-cn
git checkout develop
git pull
```

Mit `git status` lässt sich überprüfen ob man tatsächlich auf dem aktuellsten Stand ist. Anschließend wechselt man in das `script`-Verzeichnis und installiert nacheinander die einzelnen Komponenten des EPC, die da wären:

- MME
- HSS
- S+P-GW

Die Befehle zum Installieren der Komponenten sollten der Reihe nach und einzeln ausgeführt werden.

```bash
./build_mme -i
./build_hss -i
./build_spgw -i
```

Während dem Installationsvorgang der einzelnen Komponenten werden zusätzliche System Abhängigkeiten installiert. Hierbei muss man interaktiv die Installation verschiedener Pakete zulassen. Des Weiteren wird ein MySQL-Server, sofern nicht vorhanden, und phpMyAdmin als Datenbanktool installiert und eingerichtet. Ein Stolperstein bei der Installation von phpMyAdmin ist die korrekte Auswahl des Webservers im Installationsmenü vorzunehmen. Hier sollte darauf geachtet werden, dass der gewünschte Webserver für die Ausführung von phpMyAdmin durch ein vorangestellten roten Punkt gekennzeichnet ist.

Nach erfolgreicher Installation von MME, HSS und S+P-GW kann noch überprüft werden ob der MySQL-Server und phpMyAdmin auf dem EPC-Rechner korrekt installiert wurden. Dazu navigiert man im Browser auf `http://localhost/phpmyadmin`.

### Konfiguration von HSS, MME und S+P-GW

Da nun MME, HSS und S+P-GW erfolgreich installiert wurden, müsse die Konfigurationsdateien zu jeder Komponente angepasst werden. Dazu muss man die Standardtemplates der einzelnen Konfigurationen nach `/usr/local/etc/oai` kopieren. Außerdem muss das Verzeichnis `/usr/local/etc/oai/freeDiameter` erstellt werden.

Zum Kopieren der Konfigurationsdateien kann man Folgende Befehel verwenden:

```bash
sudo cp ~/openair-cn/etc/mme.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/hss.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/spgw.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/acl.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/mme_fd.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/hss_fd.conf /usr/local/etc/oai/freeDiameter
``` 

Zunächst wird die Konfiguration der MME  `/usr/local/etc/oai/mme.conf`. Der Einfachheit halber werden die einzelenen Konfigurationsparameter in tabellarischer Form aufgelistet. Es werden zudem nur die im Rahmen dieses Projektes angepassten Konfigurationsparameter aufgelistet.

| Eigenschaft | Bedeutung  |
|-------------------------------|------------------------------------------------------|
| REALM | Definiert den Domainbereich unter dem MME, HSS und S+P-GW ansprechbar sind. Wenn bei der Konfiguration des Hosts ein anderes Realm als `openair4G.eur` verwendet wurde, muss dieser Parameter entsprechend angepasst werden. |
| GUMMEI_LIST | Konfiguriert die von der MME zur Verfügung gestellten GUMMEIs. Im Rahmen der Projektdurchführung wurden ein MCC von `001` und ein MNC von `93` verwendet. |
| TAI_LIST | Konfiguriert den TAI der MME. Für den MCC und den MNC in der TAI_LIST wurden die selben Werte wie für dei GUMMEI_LIST verwendet. |
| MME_INTERFACE_NAME_ FOR_S1_MME | Konfiguriert das für die S1-Signalisierung zu Verwendende Interface Hier muss das Netzwerkinterface eingetragen werden, über das die eNB erreicht werden kann. |
| MME_IPV4_ADDRESS_ FOR_S1_MME | Definiert unter welcher IP-Adresse und Subnetzmaske die MME auf S1-Signalisierungsnachrichten reagiert. Unter Umständen muss hier die Subnetzmaske angepasst werden, sofern sich das Netzwerkgateway ändern sollte.

Als nächstes wird die Konfiguration der MME für das Diameter Protokoll unter `/usr/local/etc/oai/mme_fd.conf` angepasst.

| Eigenschaft | Bedeutung |
|-------------------------------|------------------------------------------------------|
| Identity | Der Hostname unter dem die MME erreichbar ist. Dieser wurde von `yang.openair4G.eur` zu `hss.openair4G.eur` geändert.
| Realm | Wie schon in der mme.conf, muss der Domainbreich nur angepasst werden, wenn nicht der Standard Domainbereich `openair4G.eur` verwendet wurde.



TODO ausformulieren

- Git Repositories openair-cn auschecken (Wichtig develop branch)
- Kernel > 4.7.x oai
- hostname und etc/hosts konfigurieren
- Konfigurationsdateien nach /usr/local/etc/oai kopieren
- Zertifikate kopiert + installiert
- installieren von hss,mme,spgw
- in mmeidentity-Tabelle epc hostnamen 'hss.openair4G.eur' eintragen, Achtung ID merken
- in users und pdn sim karte eintragen, außerdem in mmeidentity-Spalte (Fremdschlüssel auf mmeidentity-Tabelle) eintragen


### Betrieb von HSS, MME und S+P-GW


User Equipment (UE) (Fabian)
-------------------
Huawei LTE-Stick

Aufbau der Projektumgebung
--------------------------
LTE- Stick, eNB + EPC

Herstellen einer Internetverbindung (René)
===================================

Performance (Sebastian)
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

Signalisierung (Fabian)
==========

Authentifizierung
----------

An- und Abmeldung (Attach/Deattach)
----------


Fazit und Ausblick (Michael)
==================
Was haben wir im Verlauf des Projekts gelernt:
- Verständnis, wie zellulare Mobilfunknetze funktionieren und wie sich Daten dort übertragen lassen

Umsetzungsstand:

| Stufe | Umsetzungsgrad | dabei aufgetretene Probleme |
| :---- | :------------: | --------------------------: |
| 1     |                |                             |
| 2     |                |                             |
| 3     |                |                             |

Wie kann das vorliegende Projekt zukünftig genutzt/weiter verwendet bzw. erweitert werden?

Ausblick bezüglich des OpenAirInterface (siehe 5G)

Anhang
======
Arbeitsaufteilung
-----------------
| Gliederungspunkt | Name |
| :--------------- | ---: |
| a                | b    |

Bibliography
============

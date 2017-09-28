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
**USRP:** Universal Software Radio Peripheral 

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

In diesem Kapitel wird der Projektablauf beschrieben, was dem Aufbau, der Installation und Konfiguration des in dem vorhergehenden Kapitel beschriebenen Versuchsaufbaus entspricht. Besonders wird auf benötigte Komponenten und speziellen Konfigurationen eingegangen, die für die erfolgreiche Umsetzung essentiell gewesen sind.

Als Vorlage zum Vorgehen wurde ein Tutorial von OAI herangezogen. [@oaicotsuetutorial] Dieses gibt bereits eine gute Hilfe zum Einstieg und beschreibt die wichtigsten Schritte zum Aufbau des Netzes (ohne Internetverbindung). Leider ist es in manchen Punkten etwas zu ungenau bzw. nicht vollständig, sodass tiefgründigere und nicht vom Tutorial beschriebene Konfigurationen nötig waren. Hauptsächlich lag dies an abweichenden Rahmenbedingungen, weshalb im folgenden der gesamte Ablauf beschrieben wird.

Evolved Node B (eNodeB)
-----------------------------

Die eNodeB ist die Schnittstelle zwischen dem Kernnetz (EPC) und den Teilnehmergeräten (UEs). Es bildet eine Funkzelle, mit der einzelne UEs kommunizieren können und Daten von bzw. zum Kernnetz weitergeleitet werden. Der Aufbau besteht aus einem Universal Software Radio Peripheral (USRP) welches durch einen einen physischen Rechner betrieben wird. Der genaue Aufbau und die Konfiguration werden im folgenden Abschnitt beschrieben.

### Konfiguration der Hardware/Software

Als Betriebssystem für die eNodeB wird vom OAI ein Ubuntu in der Version 14.04.3 mit low-latency Kernel 3.19 empfohlen, da dieses für die Tests der OAI herangezogen wird. Grundsätzlich können auch andere Distributionen verwendet werden. Hier gibt es jedoch keine Garantie, dass die Build-Skripte sich erwartungsgemäß verhalten. Aus diesem Grund wurde das vorgeschlagene Ubuntu installiert.

Wichtig ist, dass das Betriebssystem auf einem physischen Rechner installiert wird und nicht auf einer virtuellen Maschine. Nur so kann die Echtzeitfähigkeit, welche durch den low-latency Kernel freigeschaltet wird, erreicht werden, die für die Verbindung mit der USRP benötigt wird. Nachdem das Betriebssystem auf dem Rechner installiert wurde, musste somit noch der low-latency Kernel installiert werden. Dies lies sich einfach durch den folgenden Befehl in der Kommandozeile erreichen:

```sh
  sudo apt-get install linux-image-3.19.0-61-lowlatency\
   linux-headers-3.19.0-61-lowlatency
```

Damit diese Änderung einen Effekt hatte, musste der Rechner neugestartet werden. Anschließend konnte der Erfolg durch den Befehl `uname -a` überprüft werden. Die Ausgabe entsprach folgender Meldung:

```sh
Linux [NAME] 3.19-lowlatency
```

Mit diesen Schritten wurde die Grundlage für die Installation des Openairinterfaces geschaffen, welche im nächsten Kapitel beschrieben wird.

### OAI Installationsvorbereitungen

Das Openairinterface liegt als Quelldateien in einem Git Repository vor. Es empfiehlt sich das gesamte Repository zu klonen, da man eventuell auf verschiedenen Branches und Tags zugreifen muss, falls es Probleme gibt. Auch bei diesem Aufbau gab es später Probleme die auf dem vorliegenden Quellcode basieren konnten, da man nach Anleitung auf dem `develop` Branch arbeitet. Um diese auszuschließen, war es hilfreich, ältere Tags auszuchecken und die Funktionen zu überprüfen. Aus diesem Grund wurde das Repository mit folgendem Befehl geklont.

```sh
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
```

Nach erfolgreichem Download wurde in das Verzeichnis `openairinterface5g` gewechselt und die Working Copy auf den `develop`-Branch aktualisiert.

```sh
cd openairinterface5g
git checkout develop
git pull
```

Die vorliegenden Quelldateien konnten nun installiert werden. Bei diesem Vorgang werden die nötigen Abhängigkeiten nachgeladen und passend konfiguriert. Hierzu steht bereits ein automatisches Build-Skript bereit, welches wie folgt ausgeführt werden muss.

```sh
source oaienv
cd cmake_targets
./build_oai -I --eNB -x --install-system-files -w USRP
```

Was die einzelnen Parameter bewirken, wurde hier festgehalten:

 -I
~ Installiert die Abhängigkeiten

 --eNB
~ OAI Konfigurations-Flag für eNodeB

 -x
~ Fügt ein Software-Oszilloskop zu den erstellten Binärdateien

 --install-system-files
~ Installiert vom OAI benötigte Dateien ins Linux-System

 -w USRP
~ Konfiguriert den Hardwaresupport, was in diesem Fall `USRP` ist

Dies sind nicht alle Parameter, die zur Verfügung stehen. Mit dem Befehl `./build_oai -h` lassen sich alle möglichen Einstellungen und dessen Bedeutung anzeigen.

### Konfiguration der eNodeB

Nachdem die eNodeB erfolgreich installiert wurde, konnte sie für den Einsatz konfiguriert werden. Hierzu gibt es im Ordner `targets/PROJECTS/GENERIC-LTE-EPC/CONF/` verschiedene Konfigurationsdateien, die für unterschiedliche Frequenzbänder und eingesetzte Hardware gültig sind. Da hier eine eNodeB mit USRP-B210 im LTE Band 7 konfiguriert werden soll, war die Datei `enb.band7.tm1.usrpb210.conf` für diesen Anwendungsfall passend. Da nicht alle Konfigurationspunkte in der Datei angepasst werden mussten bzw. relevant für den weiteren Verlauf sind, werden in der folgenden Tabelle die wesentlichen Parameter beschrieben. Dabei werden auch die vergebenen Werte für die Eigenschaften angegeben, wobei diese bei einem Nachbau eventuell angepasst werden müssen.

| Eigenschaft | Wert | Bedeutung |
|-------------------------------------|---------------|------------------------------|
| tracking_area_code | 1 | Konfiguriert das Gebiet, in dem sich die eNB befindet. |
| mobile_country_code | 001 | Gibt die Länderkennung an, zu der die eNB gehört. |
| mobile_network_code | 93 | Setzt die Netzbetreiberkennung, zu der die eNB gehört. |
| **mme_ip_address** |
| ipv4 | 10.0.158.254 | IPv4 Adresse der MME, mit der sich die eNB verbinden soll. |
| ipv6 | 10:10:10::1 | IPv6 Adresse der MME, mit der sich die eNB verbinden soll. |
| active | yes | Mit diesem Flag wird die Verbindung zur MME aktiviert. |
| preference | ipv4 | Bestimmt die IP Art, die für die Verbindung bevorzugt wird. |
| **NETWORK_INTERFACES** |
| ENB_INTERFACE_NAME_ FOR_S1_MME | eth0 | Interfacename für die Verbindung zur MME bei der eNB. |
| ENB_IPV4_ADDRESS_ FOR_S1_MME | 10.0.158.254/24 | Adressbereich für die Verbindung zur MME bei der eNB. |
| ENB_INTERFACE_NAME_ FOR_S1U | eth0 | Interfacename für die Verbindung zur SPGW bei der eNB. |
| ENB_IPV4_ADDRESS_ FOR_S1U | 10.0.158.254/24 | Adressbereich für die Verbindung zur SPGW eNB. |
| ENB_PORT_ FOR_S1U | 2152 | Kommunikationsport für die Verbindung zur SPGW. |
| **component_carriers** |
| downlink_frequency | 2680000000L | Downlink-Frequenz für die eNB. (Hier Band 7) |
| uplink_frequency_offset | -120000000 | Offset für die Uplink-Frequenz von der DL-Frequenz. |

Bei den restlichen Konfigurationen haben die Standardwerte für dieses Projekt keinen Einfluss gehabt und werden daher nicht berücksichtigt. Die vollständige im Projekt verwendete Konfigurationsdatei befindet sich in der Anlage.

Nachdem die eNodeB konfiguriert war, kann diese 

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
sudo dpkg -i linux-headers-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb
             linux-image-4.7.7-oaiepc_4.7.7-oaiepc-10.00.Custom_amd64.deb
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

Nachdem dem Kernelupdate und dem Anpassen des Hostnames sowie der Hosts-Konfiguration, empfiehlt es sich den Rechner neu zu starten und die vorher getätigten Anpassungen noch einmal zu überprüfen. So kann es eventuell passieren, dass während dem Bootvorgang ein anderer Kernel als der zuvor installierte geladen wird. Dies lässt sich beheben in dem man beim Bootvorgang den korrekten Kernel manuell wählt. Damit nicht bei jedem Neustart des EPC-Rechners der Kernel manuell gewählt werden muss, empfiehlt es sich in der  `/etc/default/grub` Konfigurationsdatei den `GRUB_DEFAULT` Wert anzupassen. Null bedeutet, dass der Default Kernel geladen wird. Entweder wird der `GRUB_DEFAULT`-Wert auf den Index des beim Bootvorgang gewünschten Kernels oder auf den vollen Namen des Kernels, so wie er im Grub-Bootmenu angezeigt wird, gesetzt. Vorsicht vor Tippfehlern, denn die können dazu führen, dass der Rechner unter Umständen nicht mehr korrekt bootet.

### EPC Installationsvorbereitungen

Im Vorherigen Abschnitt wurde beschrieben, wie ein Rechner für die Installation des OAI-EPCs vorbreitet werden muss. In nachfolgendem Abschnitt wird angenommen, dass die Installation und Vorbereitung des Rechners nach der Anleitung im vorherigen Abschnitt durchgeführt wurde.

Zuerst muss der Sourcecode für das EPC ausgecheckt werden.

```bash
git clone https://gitlab.eurecom.fr/oai/openair-cn.git
```

Nach erfoglreichem Download wird in das Verzeichnis `openair-cn` gewechselt und die Working Copy auf den `develop`-Branch aktualisiert.

```bash
cd openair-cn
git checkout develop
git pull
```

Mit `git status` lässt sich überprüfen ob die Working Copy tatsächlich auf dem aktuellsten Stand ist. Anschließend wird in das `<openair-cn>/scripts`-Verzeichnis gewechselt und nacheinander jede EPC-Komponente einzelnen kompiliert. Die Befehle zum Kompilieren der Komponenten sollten der Reihe nach und sperat ausgeführt werden.

```bash
./build_mme -
./build_hss -i
./build_spgw -i
```

Während des Kompiliervorgangs der einzelnen Komponenten werden zusätzliche System Abhängigkeiten installiert. Hierbei muss interaktiv die Installation verschiedener Pakete zugelassen werden. Des Weiteren wird ein MySQL-Server, sofern nicht vorhanden, und phpMyAdmin als Datenbanktool installiert und eingerichtet. Ein Stolperstein bei der Installation von phpMyAdmin ist die korrekte Auswahl des Webservers im Installationsmenü vorzunehmen. Hier sollte darauf geachtet werden, dass der gewünschte Webserver für die Ausführung von phpMyAdmin durch ein vorangestellten roten Punkt gekennzeichnet ist.

Nach erfolgreicher Installation von MME, HSS und S+P-GW kann noch überprüft werden ob der MySQL-Server und phpMyAdmin auf dem EPC-Rechner korrekt installiert wurden. Dazu navigiert man im Browser auf `http://localhost/phpmyadmin`.

### Konfiguration von HSS, MME und S+P-GW

Da nun MME, HSS und S+P-GW erfolgreich installiert wurden, müsse die Konfigurationsdateien zu jeder Komponente angepasst werden. Dazu müssen die Standardtemplates der einzelnen Konfigurationen nach `/usr/local/etc/oai` kopieret werden. Außerdem muss das Verzeichnis `/usr/local/etc/oai/freeDiameter` erstellt werden.

Die Konfigurationsdateien können über folgende Befehele kopiert werden:

```bash
sudo cp ~/openair-cn/etc/mme.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/hss.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/spgw.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/acl.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/mme_fd.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/hss_fd.conf /usr/local/etc/oai/freeDiameter
``` 

In tabellarischer Form werden nachfolgend für jede Komponente seperat die angepassten Konfigurationsparameter aufgelistet und kurz hinsichtlich ihrer Funktion beschrieben.

`/usr/local/etc/oai/mme.conf`

| Eigenschaft | Bedeutung  |
|-------------------------------|------------------------------------------------------|
| REALM | Definiert den Domainbereich unter dem MME, HSS und S+P-GW ansprechbar sind. Wenn bei der Konfiguration des Hosts ein anderes Realm als `openair4G.eur` verwendet wurde, muss dieser Parameter entsprechend angepasst werden. |
| GUMMEI_LIST | Konfiguriert die von der MME zur Verfügung gestellten GUMMEIs. Im Rahmen der Projektdurchführung wurden ein MCC von `001` und ein MNC von `93` verwendet. |
| TAI_LIST | Konfiguriert den TAI der MME. Für den MCC und den MNC in der TAI_LIST wurden die selben Werte wie für die GUMMEI_LIST verwendet. |
| MME_INTERFACE_NAME_ FOR_S1_MME | Konfiguriert das für die S1-Signalisierung zu verwendende Netzwerkinterface. Hier muss ein Netzwerkinterface eingetragen werden, über das die eNB erreicht werden kann. |
| MME_IPV4_ADDRESS_ FOR_S1_MME | Definiert unter welcher IP-Adresse und Subnetzmaske die MME auf S1-Signalisierungsnachrichten reagiert. Unter Umständen muss hier die Subnetzmaske angepasst werden, sofern sich das Netzwerkgateway ändern sollte. |


`/usr/local/etc/oai/mme_fd.conf`


| Eigenschaft | Bedeutung |
|-------------------------------|------------------------------------------------------|
| Identity | Der Hostname unter dem die MME erreichbar ist. Dieser wurde von `yang.openair4G.eur` zu `hss.openair4G.eur` geändert.
| Realm | Der Domainbreich muss nur angepasst werden, wenn der Standarddomainbereich `openair4G.eur` nicht verwendet wurde.


`/usr/local/etc/oai/hss.conf`

| Eigenschaft | Bedeutung |
|-------------------------------|------------------------------------------------------|
| MySQL_user | Benutzername des Datenbanknutzers, der bei der Installation des MySQL-Servers angegeben wurde. |
| MySQL_pass | Passwort des Benutzernamens. |
| OPERATOR_key | Zeichenkette die zur dynamischen Generierung des SIM-Karten OPcs verwendet wird. Im Rahmen der Projektumsetzung wurde auf die dynamische Generierung verzichtet, da die zur Verfügung stehenden SIM-Karten mit einem festen OPc programmiert wurden. Dazu wurde der Wert auf Leerstring gesetzt. |

`/usr/local/etc/oai/hss_fd.conf`

| Eigenschaft | Bedeutung |
|-------------------------------|------------------------------------------------------|
| Identity | Der Hostname unter dem der HSS erreichbar ist. Hier entspricht der Standardwert dem im Projekt verwendeten Hostnamen `hss.openair4G.eur`. |
| Realm | Der Domainbreich muss nur angepasst werden, wenn der Standarddomainbereich `openair4G.eur` nicht verwendet wurde. |

`/usr/local/etc/oai/spgw.conf`

| Eigenschaft | Bedeutung |
|-------------------------------|------------------------------------------------------|
| SGW_INTERFACE_NAME_ FOR_S1U_S12_S4_UP | Konfiguriert das für S1U-, S12- und S4-Signalisierungsnachrichten zu verwendende Netzwerkinterface. Hier muss ein Netzwerkinterface eingetragen werden, über das die eNB erreicht werden kann. |
| SGW_IPV4_ADDRESS_ FOR_S1U_S12_S4_UP | Definiert unter welcher IP-Adresse und Subnetzmaske das S-GW auf Signalisierungsnachrichten reagiert. Unter Umständen muss hier die Subnetzmaske angepasst werden, sofern sich das Netzwerkgateway ändern sollte. |
| PGW_INTERFACE_NAME_ FOR_SGI | Konfiguriert das für die Internetanbindung zu verwendende Netzwerkinterface. Hier muss ein Netzwerkinterface eingetragen werden, welches über Internetanbindung verfügt. | 
| PGW_MASQUERADE_SGI | Über diesen Parameter kann konfiguriert werden, ob das P-GW Netzwerkadressübersetzung durchführt oder nicht. Der Standardwert ist `no`. Bei der Projektumsetzung wurde der Wert auf `yes` gesetzt. |
| UE_TCP_MSS_CLAMPING | Über diesen Parameter kann konfiguriert werden, ob das P-GW die Anzahl der Bytes für Nutzerdaten maximieren soll oder nicht. Der Standardwert ist `no`. Bei der Projektumsetzung wurder der Wert auf `yes` gesetzt, da mit dem Standardwert keine Internetkommunikation möglich war. |
| DEFAULT_DNS_IPV4_ ADDRESS | Konfiguriert den Standard DNS-Server, welcher den UE beim Verbindungsaufbau mit dem P-GW mitgeteilt wird. |
| DEFAULT_DNS_SEC_ IPV4_ADDRESS | Konfiguriert den abgesicherten Standard DNS-Server, welcher den UE beim Verbindungsaufbau mit dem P-GW mitgeteilt wird. |


Neben der zurvor getätigten Konfiguration des EPCs, müssen noch zwei Zertifikate für MME und HSS installiert werden. Mit Hilfe dieser beiden Zertifikate wird die S6a-Schnittstelle zwischen MME und HSS abgesichert. Zum installieren der Zertifikate wird in das `<openair-cn>/scripts`-Verzeichnis des EPC-Rootverzeichnisses gewechselt. Anschließend kann die Installation der Zertifikate wie folgt vorgenommen werden:

```bash
./check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur
./check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter/ hss.openair4G.eur
```

Wurden MME und HSS auf seperaten Rechnern installiert oder ein anderer Hostname und/oder anderes Realm als `hss` beziehungsweise `openair4G.eur` verwendet, müssen oben stehende Kommandos entsprechend angepasst werden.

Bevor nun mit der Installation des EPCs fortgefahren wird, muss unter `<openair-cn-dir>/src/common` die Header-Datei `common_types.h` angepasst werden. Denn hier befindet sich in ca. Zeile 88 ein Bug, durch den IMSI's mit zwei führenden Nullen nicht korrekt erkannt werden. Da im Rahmen des Projektes ein MCC von `001` verwendet wurde, musst die Datei entsprechend angepasst werden:

```c
// Quelle: https://gitlab.eurecom.fr/oai/openair-cn/commit/0d574905cbdedd30fdba7f6e3062db268761f0b7
// #define IMSI_64_FMT              "%"SCNu64
// Erkennt nun auch IMSI's der Struktur 001############
#define IMSI_64_FMT              "%015"SCNu64
``` 

### Installation von HSS, MME und S+P-GW

Nachdem der EPC der Anleitung gemäß konfiguriert wurde, können die einzelnen Komponenten der Reihe nach installiert werden. Dazu wird in das `<openair-cn>/scripts`-Verzeichnis gewechselt.

Zuerst wird der HSS erneut kompiliert und anschließend gestartet. Beim erstmaligen Starten des HSS wird über den Parameter `i` ein SQL-Skript übergeben, dass das erforderliche Datenbankschema und einige IMSI-Einträge enthält.

```bash
./build_hss -c
./run_hss -i ~/openair-cn/src/oai_hss/db/oai_db.sql  # Erstmaliges starten des HSS
./run_hss
```

Bevor nun die MME installiert wird, muss in der gerade zuvor erstellten Datenbank `oai_db` der Hostname des EPC-Rechners eingetragen werden. Dazu wird über ein MySQL-Client in die Tabelle `mmeidentitiy` folgender Eintrag hinzugefügt:

```sql
INSERT INTO mmeidentity (`mmehost`, `mmerealm`, `UE-Reachability`)
  VALUES ('hss.openair4G.eur', 'openair4G.eur', 0);
```

Wurden ein anderer Hostname oder Realm, wie im Rahmen des Projektes verwendet, muss obiges SQL-Statment entsprechend angepasst werden. Desweiteren empfiehlt es sich die ID des neu angelegten Eintrags zu merken, da dieser später beim Eintragen der SIM-Konfigurationen in die `users`-Tabelle als Fremdschlüssel benötigt wird.

TODO ausformulieren

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

# Netzwerkdrucker-Problemlöser

Startet die Windows-Druckerwarteschlange (Dienst `Spooler`) per Doppelklick neu.

## Problem

Nach einem Remote-Desktop-Zugriff auf den Büro-PC (mit aktivierter Druckerumleitung) ist der
Netzwerkdrucker lokal an diesem PC nicht mehr erreichbar. Ein Neustart der Druckerwarteschlange
behebt das – die Druckerumleitung kann aktiviert bleiben.

## Verwendung

1. `Druckerwarteschlange_neu_starten.bat` auf den betroffenen PC kopieren.
2. Doppelklick → Windows-Abfrage („Möchten Sie zulassen …?“) bestätigen.
3. Das Skript stoppt und startet den Dienst und meldet `[OK]` oder `[FEHLER]`.

Tipp: Rechtsklick → *Senden an* → *Desktop (Verknüpfung erstellen)* für einen Knopf auf dem Desktop.

## Was das Skript genau tut

1. **Rechte prüfen:** Mit `net session` wird geprüft, ob das Skript als Administrator läuft.
   Falls nicht, startet es sich über PowerShell (`Start-Process -Verb RunAs`) mit
   Administratorrechten neu – daher die Windows-Abfrage.
2. **Dienst stoppen:** `net stop spooler /y` beendet die Druckerwarteschlange
   (inkl. abhängiger Dienste).
3. **Kurz warten:** 2 Sekunden Pause, damit der Dienst vollständig beendet ist.
4. **Dienst starten:** `net start spooler` startet die Druckerwarteschlange neu. Dabei werden
   die hängengebliebenen Drucker-Zuordnungen aus der Remote-Desktop-Sitzung verworfen und
   die lokalen Drucker neu geladen.
5. **Ergebnis prüfen:** `sc query spooler` kontrolliert, ob der Dienst wieder läuft, und
   zeigt `[OK]` bzw. `[FEHLER]` an.
6. Das Fenster schließt sich nach 5 Sekunden automatisch.

Das entspricht dem manuellen Weg: *Dienste* (`services.msc`) → *Druckerwarteschlange* →
Rechtsklick → *Neu starten*.

## Hinweise

- Benötigt Administratorrechte auf dem PC.
- Druckaufträge, die beim Neustart in der Warteschlange hängen, können verloren gehen.

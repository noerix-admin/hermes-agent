# Noerix · Hermes — Molekulare 3D-Architektur (WebXR)

Eine eigenständige, interaktive 3D-Visualisierung der gesamten Hermes-Architektur
im Jarvis/Stark-Hologramm-Look. Drehbar, zoombar und **VR-tauglich** (WebXR).

## Öffnen

Einfach `noerix-molecular.html` in einem modernen Browser öffnen
(Chrome/Edge/Firefox). Three.js wird per CDN (jsdelivr) geladen — also
Internetverbindung nötig.

Für VR: Headset (Meta Quest o.ä.) mit WebXR-fähigem Browser öffnen und auf
**„ENTER VR"** klicken. Mit den Controllern auf Knoten zeigen und auswählen.

> Lokaler Start ohne CDN-Probleme: aus dem Repo-Root z.B.
> `python3 -m http.server` und dann
> `http://localhost:8000/docs/architecture-3d/noerix-molecular.html`.

## Steuerung

- **Maus:** Drag = drehen, Rad = zoomen, Rechts-Drag = verschieben.
- **Tasten:** `1` `2` `3` = Detailstufe, `R` = Ansicht zurücksetzen.
- **VR-Controller:** Strahl auf Knoten + Trigger = auswählen.

## Funktionen

- **Detailstufen (LOD):** Zonen → Komponenten → Module (alles).
- **Filter:** nach Zonen, nach Art (Hardware/Software/Daten/Extern/Logik),
  nach Tenant/Isolation (global, profil-isoliert, Kanban-Board, Kanban-Tenant).
- **Datenströme:** benannte Flows (eingehende Nachricht, CLI-Schleife, Cron,
  Delegation, Memory-Sync, Kanban-Dispatch, TUI-RPC, Provider-Call,
  Dashboard/PTY) als animierte Partikel verfolgen.
- **Datenstrom-Modus:** Knoten anklicken → alle Ströme/Verbindungen, die ihn
  berühren, leuchten auf.
- **Wenn-Dann-Modus:** Knoten „abschalten" → alle stromabwärts betroffenen
  Komponenten färben sich rot (Impact-/Ausfallanalyse).

## Datenmodell

Der Graph ist datengetrieben: die Konstanten `ZONES`, `FLOWS` und `LINKS` im
`<script>`-Block von `noerix-molecular.html` spiegeln die in `AGENTS.md`
dokumentierte Architektur wider (Core-Waist, Agent-Internals,
Tools/Environments, Surfaces, Gateway-Plattformen, Plugins, Provider, Skills,
Subsysteme, Config/State, Runtime/Hardware). Zum Aktualisieren einfach diese
Strukturen erweitern — Layout, Filter, Labels und Flows leiten sich automatisch
ab.

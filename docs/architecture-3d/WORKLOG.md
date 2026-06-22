# Worklog — Noerix Hermes 3D-Architektur

Durchsuchbare, versionierte Chronik der Arbeit an diesem Feature. Ergänzt die
verstreuten Chat-Sessions (Claude Code on the web) durch **einen** Klartext-Überblick:
was erledigt wurde, was offen ist, mit Verweis auf Commits / PR / Issues.

- **PR:** noerix-admin/hermes-agent#1
- **Live (Branch-Preview):** https://noerix-admin.github.io/hermes-agent/previews/claude-serene-mccarthy-iy1d17/
- **Offene To-dos:** als GitHub Issues im Repo (Label-Suche `architecture-3d`)
- **Chat-Sessions:** liegen in der Claude-Code-Weboberfläche (nicht im Repo) —
  siehe https://code.claude.com/docs/en/claude-code-on-the-web

Konvention: pro Arbeits-Session ein Abschnitt; erledigte Punkte mit Commit-Bezug,
offene Punkte unten verlinkt auf Issues.

---

## 2026-06-22 — Aufbau & Iterationen des 3D/VR-Viewers

**Erledigt**
- Neuer WebXR-Viewer `docs/architecture-3d/noerix-molecular.html` (Three.js, VR-tauglich),
  datengetrieben aus der in `AGENTS.md` dokumentierten Architektur
  (Zonen, Komponenten, Module, Datenströme, Abhängigkeiten).
- Auto-Veröffentlichung via GitHub Pages mit Branch-Previews
  (`.github/workflows/deploy-architecture-3d.yml`).
- Detailstufen (LOD), Filter (Zone / Art / Tenant), Datenstrom-Verfolgung, Wenn-Dann-Analyse.
- Physik: ziehbare Atome (Maus + VR-Greifen), „durchwischen", `GRUNDFORM`-Reset.
- Galaxie-Layout (Spirale + organische Cluster), Galaxie-Kern/Nebel, runde Sterne.
- Gläserne „Jarvis"-Atome (Fresnel-Schale), runde Kerne.
- Lesbare Labels (Rajdhani), Info-Karte am Atom, zuverlässiger Klick-Inspektor.
- Atmen = **Arbeitsstatus** (abgeschlossen=ruhig, geplant=blass, in Arbeit=atmet,
  Tempo ∝ Kritikalität/Blast-Radius); Status pro Atom setzbar (localStorage).
- Diverse Feinschliffe: Schriftgröße/-farbe, Hofgröße, dicke Verbindungslinien (Line2),
  Atem-Aufschaukel-Bug behoben.

**Offen** (siehe Issues)
- Status-Semantik final festlegen (A: Software-Reife vs. B: Mapping-Fortschritt).
- Reale „in Arbeit"/„geplant"-Bereiche fest ins Datenmodell eintragen (statt nur localStorage).
- Visual-Feinschliff nach Review (Linienstärke pro Typ, Atem-Maß, Sterndichte).
- Test im echten VR-Headset.

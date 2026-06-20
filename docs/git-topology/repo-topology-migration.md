# GitHub Repo-Topologie & Migrationsplan (BL-GIT-IDENTITY-01)

> **Status:** Planungsartefakt — NICHTS ist ausgeführt. Executor ist Claude Code
> unter der GitHub-App-Identität (Modell 1), nicht Chat-Claude und nicht ein
> breiter OAuth-Token. Dieses Dokument + `migrate-repos.sh` sind die Vorlage.
>
> **Erstellt:** 2026-06-20 · **Quelle:** read-only Inventory via GitHub-API
> (authentifiziert als `noerix-admin`).

## Beschlossenes Zielmodell (Modell 1)

- `silversurfer911` = Mensch + Owner der Org.
- **Org `noeRIX`** = Firmen-/Produkt-Namespace. ⚠️ **Existiert noch nicht** —
  der Handle `noerix` ist durch ein fremdes 2014er-Konto belegt
  (`noerix/PHPTaka`). Es muss ein **freier Org-Name** gewählt/angelegt werden
  (z. B. `noeRIX-GmbH`, `noerix-io`, `noerix-hq`).
- GitHub App („noeRIX Agent") = Bot-Zugriff, pro-Repo gescoped, auto-rotierende
  Tokens, `[bot]`-gelabelt, einzeln widerrufbar. **Kein Machine-User.**
- `amarux` = eigene Produktlinie (Account/Org bleibt bestehen). ⚠️ Der reale
  `amarux`-Account enthält aktuell nur alte BioStatistik-Kursrepos (2014–2024) —
  Alt-/Privatkonto, noch keine Produktlinie.
- `noerix-admin` + `amarux-dev` → stilllegen (nach Migration).

## 🔴 Reihenfolge-Riegel (HARTE BLOCKER, in dieser Reihenfolge)

| # | Aktion | Grund | Ausführbar von hier? |
|---|--------|-------|----------------------|
| **P0** | `och-dev` auf **privat** stellen | öffentliches Praxis-Repo (OCH), potenzielles Zone-2-Leak | ❌ nein (Scope + kein Visibility-Tool) → manuell/`gh` |
| **P1** | `doctolib-charly-sync` von GitHub **runter → Praxis-Gitea** + Credential-Rotation | Termin-/Patientendaten, **Zone 2 / §203 StGB** | ❌ nein → Praxis-Gitea + manuell |
| **P2** | restliche Praxis-Repos (OCH-Familie, `drupal`) → Gitea | Zone 2 | Skript-Vorlage |
| **P3** | Tech-Repos → Org `noeRIX` (sobald angelegt) | Konsolidierung | Skript-Vorlage |
| **P4** | `CC` löschen | Entscheidung des Owners | Skript-Vorlage (guarded) |
| **P5** | `noerix-admin` / `amarux-dev` stilllegen | Aufräumen | manuell |

**Keine Org-/Repo-Umverteilung startet, bevor P0 und P1 erledigt sind.**

## Inventory & Klassifikation — `noerix-admin` (11 Repos)

Legende: 🔴 löschen/exfiltrieren (Zone 2 §203) · 🟠 Praxis → Gitea ·
🟡 Praxis-Marketing → Gitea · 🟢 Tech → Org noeRIX

| Repo | Sichtbarkeit | Klasse | Ziel | Aktion |
|------|--------------|--------|------|--------|
| `doctolib-charly-sync` | privat | 🔴 Zone 2 §203 (Termine/Patienten) | Praxis-Gitea | **P1** runter + Rotation |
| `CC` | privat | 🔴 löschen (Owner-Entscheidung) | — | **P4** delete (guarded) |
| `oralchirurgie-haidhausen` | privat | 🟠 Praxis (OCH) | Praxis-Gitea | P2 transfer/mirror → Gitea |
| `och-dev` | **öffentlich** | 🟠 Praxis (OCH) | Praxis-Gitea | **P0** privat → dann Gitea |
| `och-gluecksrad` | privat | 🟡 Praxis-Marketing | Praxis-Gitea | P2 → Gitea |
| `och-gluecksrad-live` | **öffentlich** | 🟡 Praxis-Marketing | Praxis-Gitea | P2 privat → Gitea |
| `drupal` (`kathiligenz@drupal`) | privat | 🟠 Praxis/Kunde (Zone 2) | Praxis-Gitea | P2 → Gitea |
| `rimax` | privat | 🟢 Tech (AI-Assistant) | Org noeRIX | P3 transfer → Org |
| `noerix-os` | privat | 🟢 Tech (Governance-Core) | Org noeRIX | P3 transfer → Org |
| `KImemory` | privat | 🟢 Tech (AI-Memory) | Org noeRIX | P3 transfer → Org |
| `openclaw-test-suite` | **öffentlich** | 🟢 Tech (Agent-Tests) | Org noeRIX | P3 (Sichtbarkeit prüfen) → Org |

> `hermes-agent` (dieses Repo) erschien nicht in der `user:noerix-admin`-Suche
> (Index-Lag oder anderer Owner) — Klasse: 🟢 Tech → Org noeRIX (P3).

## Inventory — `amarux` (4 Repos, Alt-/Privatkonto)

| Repo | Sichtbarkeit | Hinweis |
|------|--------------|---------|
| `biostatsI` | öffentlich | BioStatistik-Kurs (UNA Costa Rica), 2024 |
| `bioestadistica2` | öffentlich | BioStatistik-Kurs, 2024–2026 |
| `datasciencecoursera` | öffentlich | Coursera-Assignment, 2014 |
| `test-repo` | öffentlich | Test, 2014 |

→ Entscheidung offen: bleiben diese im `amarux`-Account (Produktlinie wird
neu aufgebaut) oder werden sie archiviert? **Nicht Teil dieser Migration.**

## Nicht einsehbar (als `noerix-admin`)

- `amarux-dev` → 422 (existiert nicht oder privat/fremd)
- `silversurfer911` → 422 (existiert nicht oder privat/fremd)
- Ziel-Org `noeRIX` → nur `noerix/PHPTaka` (2014, fremd) sichtbar

## Offene Entscheidungen vor Ausführung

1. **Org-Name** für noeRIX (Handle `noerix` belegt) festlegen + Org anlegen.
2. **Praxis-Gitea**-Zielpfade/Org für die OCH-Familie + `drupal` festlegen.
3. `amarux`-Altrepos: behalten / archivieren?
4. App („noeRIX Agent") anlegen, pro-Repo Installation scopen.

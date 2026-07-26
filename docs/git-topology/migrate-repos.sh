#!/usr/bin/env bash
#
# migrate-repos.sh — BL-GIT-IDENTITY-01 Repo-Rochade (Vorlage)
#
# AUSFÜHRUNG: durch Claude Code unter der GitHub-App-Identität ("noeRIX Agent"),
# NICHT durch Chat-Claude und NICHT mit einem breiten persönlichen OAuth-Token.
#
# SICHERHEIT:
#   * Default = DRY_RUN (zeigt nur, was passieren würde — ändert nichts).
#   * Destruktive Schritte (Löschen, Visibility, Transfer) sind einzeln per
#     Flag freizuschalten und in der vorgesehenen Reihenfolge zu fahren.
#   * P0 und P1 MÜSSEN vor jedem Transfer (P3) abgeschlossen sein.
#
# Voraussetzungen: gh CLI authentifiziert als App, jq.
#
set -euo pipefail

# ---- Konfiguration (anpassen!) ---------------------------------------------
SRC_OWNER="noerix-admin"
ORG="REPLACE_ME_noeRIX_ORG"      # Handle 'noerix' ist belegt -> freien Namen setzen
GITEA_NOTE="Praxis-Gitea-Migration erfolgt OUTSIDE GitHub (manuell + Rotation)"

DRY_RUN="${DRY_RUN:-1}"          # 1 = nur anzeigen; 0 = wirklich ausführen
STEP="${1:-help}"                # p0 | p2 | p3 | p4 | help

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[DRY-RUN] $*"
  else
    echo "[EXEC]    $*"
    eval "$@"
  fi
}

confirm() {
  [[ "$DRY_RUN" == "1" ]] && return 0
  read -r -p "  >> $1 [tippe JA]: " ans
  [[ "$ans" == "JA" ]] || { echo "  abgebrochen."; exit 1; }
}

# ---- P0: och-dev sofort auf privat -----------------------------------------
p0_visibility() {
  echo "== P0: öffentliche Praxis-Repos auf privat =="
  run "gh repo edit $SRC_OWNER/och-dev --visibility private --accept-visibility-change-consequences"
  run "gh repo edit $SRC_OWNER/och-gluecksrad-live --visibility private --accept-visibility-change-consequences"
  echo "  Hinweis: openclaw-test-suite (öffentlich, Tech) — Sichtbarkeit bewusst prüfen, NICHT blind umschalten."
}

# ---- P1: doctolib-charly-sync -> Gitea (NICHT hier) ------------------------
p1_exfil_note() {
  echo "== P1: doctolib-charly-sync (Zone 2 / §203) =="
  echo "  Dieses Repo wird NICHT per gh transferiert."
  echo "  -> nach Praxis-Gitea spiegeln, GitHub-Repo danach löschen, Credentials rotieren."
  echo "  -> $GITEA_NOTE"
}

# ---- P2: Praxis-Repos -> Gitea ---------------------------------------------
PRAXIS_REPOS=(oralchirurgie-haidhausen och-dev och-gluecksrad och-gluecksrad-live drupal)
p2_praxis_to_gitea() {
  echo "== P2: Praxis-Repos -> Praxis-Gitea (Zone 2) =="
  for r in "${PRAXIS_REPOS[@]}"; do
    echo "  - $SRC_OWNER/$r  ->  Gitea (mirror + GitHub-Repo löschen, OUTSIDE gh)"
  done
  echo "  -> $GITEA_NOTE"
}

# ---- P3: Tech-Repos -> Org noeRIX ------------------------------------------
TECH_REPOS=(rimax noerix-os KImemory openclaw-test-suite hermes-agent)
p3_tech_to_org() {
  echo "== P3: Tech-Repos -> Org $ORG =="
  [[ "$ORG" == REPLACE_ME* ]] && { echo "  FEHLER: ORG nicht gesetzt. Erst Org anlegen."; exit 1; }
  for r in "${TECH_REPOS[@]}"; do
    confirm "Transfer $SRC_OWNER/$r -> $ORG"
    run "gh api -X POST repos/$SRC_OWNER/$r/transfer -f new_owner=$ORG"
  done
}

# ---- P4: CC löschen (guarded) ----------------------------------------------
p4_delete_cc() {
  echo "== P4: CC löschen =="
  echo "  Letzter Check vor dem Löschen — Inhalt sichten:"
  run "gh repo view $SRC_OWNER/CC"
  confirm "Repo $SRC_OWNER/CC UNWIDERRUFLICH löschen"
  run "gh repo delete $SRC_OWNER/CC --yes"
}

case "$STEP" in
  p0) p0_visibility ;;
  p1) p1_exfil_note ;;
  p2) p2_praxis_to_gitea ;;
  p3) p3_tech_to_org ;;
  p4) p4_delete_cc ;;
  *)
    cat <<EOF
Usage: DRY_RUN=1 ./migrate-repos.sh <step>

  p0   och-dev / och-gluecksrad-live auf privat (P0, sofort)
  p1   Hinweis doctolib-charly-sync -> Gitea (P1, manuell)
  p2   Praxis-Repos -> Gitea (P2, manuell/mirror)
  p3   Tech-Repos -> Org noeRIX (P3, braucht ORG)
  p4   CC löschen (P4, guarded)

Default DRY_RUN=1. Für echte Ausführung: DRY_RUN=0 ./migrate-repos.sh <step>
Reihenfolge: p0 -> p1 -> p2 -> p3 -> p4. P0+P1 zwingend vor p3.
EOF
    ;;
esac

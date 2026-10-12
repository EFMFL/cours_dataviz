#!/usr/bin/env bash
# Vérifie que la machine est prête pour le cours.  Usage : bash scripts/diagnostic.sh
# Chaque ligne affiche OK ou un conseil. Si une ligne est en échec : passer au plan B (dossier plan-b/).

ok()   { printf "  \033[32mOK\033[0m   %s\n" "$1"; }
ko()   { printf "  \033[31mKO\033[0m   %s\n       → %s\n" "$1" "$2"; ECHEC=1; }
ECHEC=0
cd "$(dirname "$0")/.."

echo "Diagnostic du poste — cours Visualisation de données"
echo

command -v docker >/dev/null 2>&1 && ok "Docker installé ($(docker --version | cut -d, -f1))" \
  || ko "Docker introuvable" "Installer/lancer Docker Desktop puis ouvrir un nouveau terminal"

docker info >/dev/null 2>&1 && ok "Docker Desktop démarré" \
  || ko "Docker ne répond pas" "Lancer Docker Desktop et attendre que la baleine soit immobile"

docker compose version >/dev/null 2>&1 && ok "Docker Compose disponible" \
  || ko "Docker Compose absent" "Mettre à jour Docker Desktop"

MEM=$(docker info --format '{{.MemTotal}}' 2>/dev/null || echo 0)
if [ "${MEM:-0}" -ge 6000000000 ] 2>/dev/null; then ok "Mémoire allouée à Docker : $((MEM/1024/1024/1024)) Go"
else ko "Mémoire Docker insuffisante ($((MEM/1024/1024/1024)) Go)" "Docker Desktop → Settings → Resources → 8 Go"; fi

for p in 8888 9000 9001 5432 8080; do
  if lsof -iTCP:$p -sTCP:LISTEN >/dev/null 2>&1 && ! docker ps --format '{{.Ports}}' | grep -q ":$p->"; then
    ko "Port $p déjà utilisé par un autre programme" "Fermer ce programme (ex. un PostgreSQL local sur 5432)"
  else ok "Port $p libre"; fi
done

ls data/raw/yellow_tripdata_*.parquet >/dev/null 2>&1 && ok "Données NYC Taxi présentes" \
  || ko "Données absentes" "bash scripts/telecharger_donnees.sh"

LIBRE=$(df -g . 2>/dev/null | awk 'NR==2{print $4}' || df -BG . | awk 'NR==2{gsub("G","",$4);print $4}')
[ "${LIBRE:-0}" -ge 15 ] && ok "Espace disque libre : ${LIBRE} Go" \
  || ko "Espace disque faible (${LIBRE:-?} Go)" "Prévoir au moins 15 Go pour les images Docker"

echo
[ $ECHEC -eq 0 ] && echo "Poste prêt." || echo "Au moins un point à corriger (voir ci-dessus), sinon plan B."

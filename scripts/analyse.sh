#!/bin/bash
set -euo pipefail

FICHIER=""
TOP=0

usage() {
    echo "Usage : bash scripts/analyse.sh <fichier.log> [--top N] (exemple : bash scripts/analyse.sh logs/access.log --top 5)" >&2
}

parse_args() {
    if [ $# -ne 1 ] && [ $# -ne 3 ]; then
        usage
        exit 1
    fi
    FICHIER="$1"
    if [ $# -eq 3 ]; then
        if [ "$2" != "--top" ] || ! [[ "$3" =~ ^[1-9][0-9]*$ ]]; then
            usage
            exit 1
        fi
        TOP="$3"
    fi
}

verifier_environnement() {
    if [ -z "${MATRICULE:-}" ]; then
        echo "Erreur : la variable MATRICULE n'est pas définie" >&2
        exit 1
    fi
    if [ ! -f "$FICHIER" ]; then
        echo "Erreur : le fichier $FICHIER n'existe pas" >&2
        exit 2
    fi
    if [ ! -s "$FICHIER" ]; then
        echo "Erreur : le fichier $FICHIER est vide" >&2
        exit 3
    fi
}

entete() {
    echo "=== Rapport d'analyse ==="
    echo "Date        : $(date '+%F %T')"
    echo "Utilisateur : $(whoami)@$(hostname)"
    echo "Matricule   : $MATRICULE"
    echo "Fichier     : $FICHIER"
    echo "sha256      : $(sha256sum "$FICHIER" | awk '{print $1}')"
}

compter_familles() {
    echo "--- Requêtes par famille ---"
    local fam n
    for fam in 2 3 4 5; do
        n=$(awk -v c="$fam" 'substr($9,1,1)==c {n++} END {print n+0}' "$FICHIER")
        echo "${fam}xx : $n"
    done
}

top_endpoints() {
    echo "--- Top $TOP des endpoints ---"
    awk '{print $7}' "$FICHIER" | sed 's/?page=.*//' | sort | uniq -c | sort -rn | awk -v n="$TOP" 'NR<=n'
}

ip_suspecte() {
    echo "--- IP suspecte (échecs 401 sur /api/auth/login) ---"
    awk '$7=="/api/auth/login" && $9==401 {print $1}' "$FICHIER" | sort | uniq -c | sort -rn | awk 'NR==1'
}

temps_moyen() {
    echo "--- Temps de réponse moyen des 200 ---"
    awk '$9==200 {s+=$11; n++} END {if (n>0) printf "%.1f ms\n", s/n; else print "n/a"}' "$FICHIER"
}

requetes_par_heure() {
    echo "--- Requêtes par heure (UTC) ---"
    awk '{split($4,a,":"); print a[2]}' "$FICHIER" | sort | uniq -c | awk '{print $2 "h : " $1}'
}

generer_rapport() {
    entete
    echo
    compter_familles
    echo
    top_endpoints
    echo
    ip_suspecte
    echo
    temps_moyen
    echo
    requetes_par_heure
}

main() {
    parse_args "$@"
    verifier_environnement
    mkdir -p rapports
    local rapport="rapports/rapport_${MATRICULE}_$(date +%Y%m%d_%H%M).txt"
    generer_rapport > "$rapport"
    cat "$rapport"
    echo "Rapport écrit dans : $rapport"
}

main "$@"

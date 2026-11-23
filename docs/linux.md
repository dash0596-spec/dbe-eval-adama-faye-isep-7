# Journal des commandes et résultats

Matricule : adama-faye-isep-7
Généré le : 2026-11-23 05:38:33

```
Script started on 2026-11-23 05:10:40-05:00 [TERM="xterm-256color" TTY="/dev/pts/0" COLUMNS="203" LINES="44"]
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ cat > src/GenerateurLogs.java << 'EOF'
import java.util.Random;

/**
 * Génère un journal d'accès d'API back-end, propre à chaque étudiant.
 * Usage : java -cp out GenerateurLogs <matricule> <nombreDeLignes>
 */
public class GenerateurLogs {
    static final String[] ENDPOINTS = {
        "/api/etudiants", "/api/etudiants/", "/api/notes", "/api/cours",
        "/api/auth/login", "/api/paiements", "/api/health"
    };

    public static void main(String[] args) {
        if (args.length != 2) {
            System.err.println("Usage : java -cp out GenerateurLogs <matricule> <nombreDeLignes>");
            System.exit(1);
        }
        int n;
        try {
            n = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.err.println("Erreur : le nombre de lignes doit être un entier");
            System.exit(2);
            return;
        }
        Random r = new Random(args[0].hashCode());
        String suspecte = "197.149." + r.nextInt(256) + "." + (1 + r.nextInt(254));
        int seconde = 8 * 3600;
        for (int i = 0; i < n; i++) {
            seconde += 1 + r.nextInt(12);
            boolean attaque = r.nextInt(100) < 6;
            String ip = attaque ? suspecte : "10.0." + r.nextInt(4) + "." + (10 + r.nextInt(15));
            String chemin = attaque ? "/api/auth/login" : ENDPOINTS[r.nextInt(ENDPOINTS.length)];
            String methode = "GET";
            int statut = 200;
            int duree = 5 + r.nextInt(300);
            switch (chemin) {
                case "/api/etudiants/":
                    chemin += (1 + r.nextInt(120));
                    statut = r.nextInt(100) < 15 ? 404 : 200;
                    break;
                case "/api/notes":
                    chemin += "?page=" + (1 + r.nextInt(5));
                    statut = r.nextInt(100) < 8 ? 400 : 200;                    break;                case "/api/auth/login":                    methode = "POST";                    statut = attaque ? 401 : (r.nextInt(100) < 20 ? 401 : 200);                    break;                case "/api/paiements":                    methode = r.nextBoolean() ? "POST" : "GET";                    int t = r.nextInt(100);                    statut = t < 6 ? 500 : (t < 10 ? 503 : (methode.equals("POST") ? 201 : 200));                    if (r.nextInt(100) < 5) {                        duree = 1500 + r.nextInt(1500);                    }                    break;                default:                    break;            }            int octets = statut >= 400 ? 60 + r.nextInt(100) : 200 + r.nextInt(4000);            System.out.printf("%s - - [23/Nov/2026:%02d:%02d:%02d +0000] \"%s %s HTTP/1.1\" %d %d %dms%n",                    ip, seconde / 3600, (seconde / 60) % 60, seconde % 60, methode, chemin,                    statut, octets, duree);        }    }}EOF        }
        Random r = new Random(args[0].hashCode());
        String suspecte = "197.149." + r.nextInt(256) + "." + (1 + r.nextInt(254));
        int seconde = 8 * 3600;
        for (int i = 0; i < n; i++) {
            seconde += 1 + r.nextInt(12);
            boolean attaque = r.nextInt(100) < 6;
            String ip = attaque ? suspecte : "10.0." + r.nextInt(4) + "." + (10 + r.nextInt(15));
            String chemin = attaque ? "/api/auth/login" : ENDPOINTS[r.nextInt(ENDPOINTS.length)];
            String methode = "GET";
            int statut = 200;
            int duree = 5 + r.nextInt(300);
            switch (chemin) {
                case "/api/etudiants/":
                    chemin += (1 + r.nextInt(120));
                    statut = r.nextInt(100) < 15 ? 404 : 200;
                    break;
                case "/api/notes":
                    chemin += "?page=" + (1 + r.nextInt(5));
                    statut = r.nextInt(100) < 8 ? 400 : 200;                    break;                case "/api/auth/login":                    methode = "POST";                    statut = attaque ? 401 : (r.nextInt(100) < 20 ? 401 : 200);                    break;                case "/api/paiements":                    methode = r.nextBoolean() ? "POST" : "GET";                    int t = r.nextInt(100);                    statut = t < 6 ? 500 : (t < 10 ? 503 : (methode.equals("POST") ? 201 : 200));                    if (r.nextInt(100) < 5) {                        duree = 1500 + r.nextInt(1500);                    }                    break;                default:                    break;            }            int octets = statut >= 400 ? 60 + r.nextInt(100) : 200 + r.nextInt(4000);            System.out.printf("%s - - [23/Nov/2026:%02d:%02d:%02d +0000] \"%s %s HTTP/1.1\" %d %d %dms%n",                    ip, seconde / 3600, (seconde / 60) % 60, seconde % 60, methode, chemin,                    statut, octets, duree);        }    }}EOF
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ ls -l src/ && head -5 src/GenerateurLogs.javals -l src/ && head -5 src/GenerateurLogs.java
total 4
-rw-rw-r-- 1 ada ada 2854 Nov 23 05:13 GenerateurLogs.java
import java.util.Random;

/**
 * Génère un journal d'accès d'API back-end, propre à chaque étudiant.
 * Usage : java -cp out GenerateurLogs <matricule> <nombreDeLignes>
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ mkdir -p out && javac -d out src/GenerateurLogs.java && ls outmkdir -p out && javac -d out src/GenerateurLogs.java && ls out
GenerateurLogs.class
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ java -cp out GenerateurLogs 2> logs/gen.err; echo "Code de retour : $?"java -cp out GenerateurLogs 2> logs/gen.err; echo "Code de retour : $?"
Code de retour : 1
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ cat logs/gen.errcat logs/gen.err
Usage : java -cp out GenerateurLogs <matricule> <nombreDeLignes>
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ java -cp out GenerateurLogs $MATRICULE 2000 > logs/access.log
wc -l logs/access.log
head -1 logs/access.logada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ java -cp out GenerateurLogs $MATRICULE 2000 > logs/access.log
wc -l logs/access.log
head -1 logs/access.log
2000 logs/access.log
10.0.2.17 - - [23/Nov/2026:08:00:11 +0000] "GET /api/notes?page=5 HTTP/1.1" 200 2022 152ms
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '{print $9}' logs/access.log | sort | uniq -c | sort -rnawk '{print $9}' logs/access.log | sort | uniq -c | sort -rn
   1613 200
    169 401
    118 201
     54 404
     19 500
     15 503
     12 400
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '{print $7}' logs/access.log | sed 's/?page=.*//' | sort | uniq -c | sort -rn | head -3awk '{print $7}' logs/access.log | sed 's/?page=.*//' | sort | uniq -c | sort -rn | head -3
    394 /api/auth/login
    283 /api/etudiants
    280 /api/notes
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '{print $1}' logs/access.log | sort -u | wc -lawk '{print $1}' logs/access.log | sort -u | wc -l
61
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '$7=="/api/auth/login" && $9==401 {print $1}' logs/access.log | sort | uniq -c | sort -rn | head -1awk '$7=="/api/auth/login" && $9==401 {print $1}' logs/access.log | sort | uniq -c | sort -rn | head -1
    111 197.149.198.46
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '$9==200 {s+=$11; n++} END {printf "%.1f\n", s/n}' logs/access.logawk '$9==200 {s+=$11; n++} END {printf "%.1f\n", s/n}' logs/access.log
156.4
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '{d=$11+0; if (d>max) {max=d; l=$0}} END {print l}' logs/access.logawk '{d=$11+0; if (d>max) {max=d; l=$0}} END {print l}' logs/access.log
10.0.3.10 - - [23/Nov/2026:11:00:20 +0000] "POST /api/paiements HTTP/1.1" 500 92 2702ms
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ awk '{split($4,a,":"); print a[2]}' logs/access.log | sort | uniq -cawk '{split($4,a,":"); print a[2]}' logs/access.log | sort | uniq -c
    540 08
    549 09
    553 10
    358 11
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ grep -E '" 5[0-9]{2} ' logs/access.log | tee logs/erreurs_5xx.log | wc -lgrep -E '" 5[0-9]{2} ' logs/access.log | tee logs/erreurs_5xx.log | wc -l
34
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ sed -E 's/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/x.x.x.x/' logs/access.log > logs/access_anonyme.logsed -E 's/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/x.x.x.x/' logs/access.log > logs/access_anonyme.log
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ find . -name '*.log' -mmin -60 -size +1k -exec wc -l {} +find . -name '*.log' -mmin -60 -size +1k -exec wc -l {} +
   113 ./docs/preuves/linux.log
  2000 ./logs/access.log
    34 ./logs/erreurs_5xx.log
  2000 ./logs/access_anonyme.log
  4147 total
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ find . -name '*.log' -mmin -60 -size +1k -exec wc -l {} +find . -name '*.log' -mmin -60 -size +1k -exec wc -l {} +
   113 ./docs/preuves/linux.log
  2000 ./logs/access.log
    34 ./logs/erreurs_5xx.log
  2000 ./logs/access_anonyme.log
  4147 total
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ head -3 logs/access_anonyme.loghead -3 logs/access_anonyme.log
x.x.x.x - - [23/Nov/2026:08:00:11 +0000] "GET /api/notes?page=5 HTTP/1.1" 200 2022 152ms
x.x.x.x - - [23/Nov/2026:08:00:17 +0000] "GET /api/notes?page=1 HTTP/1.1" 200 1625 151ms
x.x.x.x - - [23/Nov/2026:08:00:22 +0000] "GET /api/paiements HTTP/1.1" 200 3544 290ms
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ cat > scripts/analyse.sh << 'EOF'
#!/bin/bash
set -euo pipefail

FICHIER=""
TOP=3

usage() {
    echo "Usage : bash scripts/analyse.sh <fichier.log> [--top N]" >&2
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
    echo "Utilisateur : $(whoami)@$(hostname)"    echo "Matricule   : $MATRICULE"    echo "Fichier     : $FICHIER"    echo "sha256      : $(sha256sum "$FICHIER" | awk '{print $1}')"}compter_familles() {    echo "--- Requêtes par famille ---"    local fam n    for fam in 2 3 4 5; do        n=$(awk -v c="$fam" 'substr($9,1,1)==c {n++} END {print n+0}' "$FICHIER")        echo "${fam}xx : $n"    done}top_endpoints() {    echo "--- Top $TOP des endpoints ---"    awk '{print $7}' "$FICHIER" | sed 's/?page=.*//' | sort | uniq -c | sort -rn | awk -v n="$TOP" 'NR<=n'}ip_suspecte() {    echo "--- IP suspecte (échecs 401 sur /api/auth/login) ---"    awk '$7=="/api/auth/login" && $9==401 {print $1}' "$FICHIER" | sort | uniq -c | sort -rn | awk 'NR==1'}temps_moyen() {    echo "--- Temps de réponse moyen des 200 ---"    awk '$9==200 {s+=$11; n++} END {if (n>0) printf "%.1f ms\n", s/n; else print "n/a"}' "$FICHIER"}generer_rapport() {    entete    echo    compter_familles    echo    top_endpoints    echo    ip_suspecte    echo    temps_moyen}main() {    parse_args "$@"    verifier_environnement    mkdir -p rapports    local rapport="rapports/rapport_${MATRICULE}_$(date +%Y%m%d_%H%M).txt"    generer_rapport > "$rapport"    cat "$rapport"    echo "Rapport écrit dans : $rapport"}main "$@"EOF        n=$(awk -v c="$fam" 'substr($9,1,1)==c {n++} END {print n+0}' "$FICHIER")        echo "${fam}xx : $n"    done}top_endpoints() {    echo "--- Top $TOP des endpoints ---"    awk '{print $7}' "$FICHIER" | sed 's/?page=.*//' | sort | uniq -c | sort -rn | awk -v n="$TOP" 'NR<=n'}ip_suspecte() {    echo "--- IP suspecte (échecs 401 sur /api/auth/login) ---"    awk '$7=="/api/auth/login" && $9==401 {print $1}' "$FICHIER" | sort | uniq -c | sort -rn | awk 'NR==1'}temps_moyen() {    echo "--- Temps de réponse moyen des 200 ---"    awk '$9==200 {s+=$11; n++} END {if (n>0) printf "%.1f ms\n", s/n; else print "n/a"}' "$FICHIER"}generer_rapport() {    entete    echo    compter_familles    echo    top_endpoints    echo    ip_suspecte    echo    temps_moyen}main() {    parse_args "$@"    verifier_environnement    mkdir -p rapports    local rapport="rapports/rapport_${MATRICULE}_$(date +%Y%m%d_%H%M).txt"    generer_rapport > "$rapport"    cat "$rapport"    echo "Rapport écrit dans : $rapport"}main "$@"EOF
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ bash scripts/analyse.sh logs/access.log; echo "Code : $?"     # (0)
bash scripts/analyse.sh; echo "Code : $?"                     # (1)
bash scripts/analyse.sh logs/absent.log; echo "Code : $?"     # (2)
: > logs/vide.log; bash scripts/analyse.sh logs/vide.log; echo "Code : $?"   # (3)bash scripts/analyse.sh logs/access.log; echo "Code : $?"     # (0)
bash scripts/analyse.sh; echo "Code : $?"                     # (1)
bash scripts/analyse.sh logs/absent.log; echo "Code : $?"     # (2)
: > logs/vide.log; bash scripts/analyse.sh logs/vide.log; echo "Code : $?"   # (3)
=== Rapport d'analyse ===
Date        : 2026-11-23 05:25:33
Utilisateur : ada@ada-virtual-machine
Matricule   : adama-faye-isep-7
Fichier     : logs/access.log
sha256      : 1acf12da9fe05de8a508f8f7826405f609f8f51f5833b51fa326460fa32d38dc

--- Requêtes par famille ---
2xx : 1731
3xx : 0
4xx : 235
5xx : 34

--- Top 3 des endpoints ---
    394 /api/auth/login
    283 /api/etudiants
    280 /api/notes

--- IP suspecte (échecs 401 sur /api/auth/login) ---
    111 197.149.198.46

--- Temps de réponse moyen des 200 ---
156.4 ms
Rapport écrit dans : rapports/rapport_adama-faye-isep-7_20261123_0525.txt
Code : 0
Usage : bash scripts/analyse.sh <fichier.log> [--top N]
Code : 1
Erreur : le fichier logs/absent.log n'existe pas
Code : 2
Erreur : le fichier logs/vide.log est vide
Code : 3
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ env -u MATRICULE bash scripts/analyse.sh logs/access.log; echo "Code : $?"env -u MATRICULE bash scripts/analyse.sh logs/access.log; echo "Code : $?"
Erreur : la variable MATRICULE n'est pas définie
Code : 1
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ bash scripts/analyse.sh logs/access.log --top 5bash scripts/analyse.sh logs/access.log --top 5
=== Rapport d'analyse ===
Date        : 2026-11-23 05:27:12
Utilisateur : ada@ada-virtual-machine
Matricule   : adama-faye-isep-7
Fichier     : logs/access.log
sha256      : 1acf12da9fe05de8a508f8f7826405f609f8f51f5833b51fa326460fa32d38dc

--- Requêtes par famille ---
2xx : 1731
3xx : 0
4xx : 235
5xx : 34

--- Top 5 des endpoints ---
    394 /api/auth/login
    283 /api/etudiants
    280 /api/notes
    258 /api/paiements
    256 /api/health

--- IP suspecte (échecs 401 sur /api/auth/login) ---
    111 197.149.198.46

--- Temps de réponse moyen des 200 ---
156.4 ms
Rapport écrit dans : rapports/rapport_adama-faye-isep-7_20261123_0527.txt
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ cat > scripts/surveille.sh << 'EOF'
#!/bin/bash
LOG=logs/surveillance.log

trap 'echo "$(date "+%F %T") arrêt propre" >> "$LOG"; exit 0' TERM

while true; do
    echo "$(date '+%F %T') $(wc -l < logs/access.log) lignes" >> "$LOG"
    sleep 5 &
    wait $!
done
EOFada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ cat > scripts/surveille.sh << 'EOF'
#!/bin/bash
LOG=logs/surveillance.log

trap 'echo "$(date "+%F %T") arrêt propre" >> "$LOG"; exit 0' TERM

while true; do
    echo "$(date '+%F %T') $(wc -l < logs/access.log) lignes" >> "$LOG"
    sleep 5 &
    wait $!
done
EOF
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ nohup bash scripts/surveille.sh > /dev/null 2>&1 &nohup bash scripts/surveille.sh > /dev/null 2>&1 &
[1] 2823
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ PID=$(pgrep -f scripts/surveille.sh); echo "PID = $PID"
ps -o pid,ppid,stat,etime,cmd -p $PIDada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ PID=$(pgrep -f scripts/surveille.sh); echo "PID = $PID"
ps -o pid,ppid,stat,etime,cmd -p $PID
PID = 2823
    PID    PPID STAT     ELAPSED CMD
   2823    2628 S          00:21 bash scripts/surveille.sh
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ kill -TERM $PID; sleep 1; tail -3 logs/surveillance.logkill -TERM $PID; sleep 1; tail -3 logs/surveillance.log
[1]+  Done                    nohup bash scripts/surveille.sh > /dev/null 2>&1
2026-11-23 05:36:21 2000 lignes
2026-11-23 05:36:27 2000 lignes
2026-11-23 05:36:30 arrêt propre
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ pgrep -f scripts/surveille.sh || echo "processus arrêté"pgrep -f scripts/surveille.sh || echo "processus arrêté"
processus arrêté
ada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ history > docs/preuves/historique_linux.txt
exitada@ada-virtual-machine:~/dbe-eval-adama-faye-isep-7$ history > docs/preuves/historique_linux.txt
exit
exit

Script done on 2026-11-23 05:38:16-05:00 [COMMAND_EXIT_CODE="0"]
```

# dbe-eval-adama-faye-isep-7

Analyse d'un journal d'accès d'API back-end (évaluation DBE, Linux et Git/GitHub).

## Description
- `src/GenerateurLogs.java` : génère un journal d'accès propre à un matricule.
- `scripts/analyse.sh` : produit un rapport d'analyse du journal.
- `scripts/surveille.sh` : surveille le journal en tâche de fond.

## Usage
```bash
javac -d out src/GenerateurLogs.java
java -cp out GenerateurLogs <matricule> 2000 > logs/access.log
bash scripts/analyse.sh logs/access.log --top 3
```

## Auteur
Adama Faye, ISEP Amadou Trawaré, promotion P7.

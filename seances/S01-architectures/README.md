# S01 — Architectures et ingestion

## Objectif

Choisir et justifier une architecture (data lake, data warehouse ou lakehouse),
installer la stack du cours et déposer les données brutes NYC Taxi dans la couche *bronze*.

## Prérequis

- Docker Desktop installé, 8 Go de mémoire alloués
- Données téléchargées : `bash scripts/telecharger_donnees.sh 2025-01`
- `bash scripts/diagnostic.sh` → tout est OK (sinon : [plan B](../../plan-b/README.md))

```bash
docker compose up -d
docker compose ps        # jupyter, rustfs, postgres : « running »
```

## Apports

- **Data warehouse** : données structurées, schéma défini à l'écriture, requêtes SQL rapides, coûteux à faire évoluer.
- **Data lake** : tout type de fichier, schéma défini à la lecture, peu coûteux, mais risque de « marécage » sans gouvernance.
- **Lakehouse** : un data lake + un format de table transactionnel (**Delta Lake**, Apache Iceberg) qui apporte historique, transactions et contrôle du schéma.
- **Architecture médaillon** : *bronze* (brut) → *silver* (nettoyé) → *gold* (prêt pour la décision).
- **Stockage objet S3** : le standard du cloud. En cours, RustFS le reproduit en local.

## Démonstration

1. Ouvrir JupyterLab : http://localhost:8888/lab?token=cours → `work/seances/S01-architectures/`
2. Notebook **`01a_decouvrir_pyspark.ipynb`** : lire les données, évaluation paresseuse, Spark UI.
3. Ouvrir la console du data lake : http://localhost:9001 (`rustfsadmin` / `rustfsadmin`), créer le bucket `datalake`.
4. Notebook **`01b_ingestion_bronze.ipynb`** : écrire la couche *bronze* en Delta, *time travel*, contrôle du schéma.

### Variante : travailler dans VS Code plutôt que JupyterLab

Le code s'exécute toujours dans le conteneur ; VS Code sert seulement d'interface.

1. La stack tourne (`docker compose ps`) et l'extension **Jupyter** (Microsoft) est installée dans VS Code.
2. *File → Open Folder…* → le dossier `cours_dataviz`, puis ouvrir le notebook.
3. En haut à droite : **Select Kernel → Existing Jupyter Server…** → coller `http://localhost:8888/?token=cours`.
4. Choisir le noyau **Python 3 (ipykernel)**, puis exécuter les cellules (Shift + Entrée).

⚠ Ne pas choisir un Python local (conda, etc.) : il n'a pas Spark, ne voit ni `rustfs` ni `postgres`,
et les chemins `/home/jovyan/work/...` n'existent pas sur votre machine.

## À vous de jouer

1. En équipe, dessinez l'architecture cible du projet (sources → bronze → silver → gold → restitution) et justifiez par écrit le choix d'un lakehouse plutôt que d'un data warehouse.
2. Exécutez les deux notebooks.
3. Répondez à l'exercice de fin de `01a` (la zone la plus rentable).
4. Question de réflexion : *pourquoi garder une couche bronze « brute » si on va la nettoyer de toute façon ?*

## C'est réussi quand…

- `docker compose ps` montre les 3 services actifs ;
- la console RustFS affiche `bronze/yellow_trips`, `bronze/zones`, `bronze/meteo` ;
- l'historique Delta de `bronze/yellow_trips` montre plusieurs versions ;
- le schéma d'architecture est argumenté.

## Dépôt pour le dossier MSPR 4.1

Schéma d'architecture + justification du lakehouse (½ page) + capture de la console RustFS.

## Nettoyage

```bash
docker compose stop      # garde tout pour la séance suivante
```

## Séance suivante

[S02 — Préparation à l'échelle](../S02-preparation-spark/README.md)

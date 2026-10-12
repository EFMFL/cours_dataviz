# Visualisation de données — M1 Big Data & IA

Cours de 35 h (10 séances de 3 h 30) · Sup de Vinci

**Fil rouge :** aider le responsable d'exploitation d'une flotte de taxis new-yorkais à savoir
*où, quand et comment ses chauffeurs gagnent le plus*, à partir des données publiques NYC Taxi.

```
NYC Taxi (Parquet) ─► data lake S3 : bronze ─► silver ─► gold ─► PostgreSQL ─► Streamlit · Superset · Grafana
                                                     └──► ontologie RDF/OWL ─► graphe de connaissances
```

## Déroulé

Chaque séance est publiée dans `seances/` au fil du cours.

| Séance | Thème | Dossier |
|---|---|---|
| S01 | Architectures data lake / warehouse / lakehouse, ingestion *bronze* | `S01-architectures` |
| S02 | Préparation à l'échelle avec Spark : *silver*, *gold*, PostgreSQL | `S02-preparation-spark` |
| S03 | Sémantique : RDF, OWL, SPARQL, graphe de connaissances | `S03-semantique` |
| S04 | Perception visuelle et choix des graphiques | `S04-perception` |
| S05 | Visualisation en code : Plotly, Altair, Streamlit | `S05-viz-code` |
| S06 | Storytelling et conception d'un dashboard décisionnel | `S06-storytelling` |
| S07 | BI décisionnelle avec Apache Superset | `S07-bi-superset` |
| S08 | Temps réel avec Grafana | `S08-temps-reel` |
| S09 | Analyse critique : biais, accessibilité, performance | `S09-analyse-critique` |
| S10 | Challenge final : soutenance bout-en-bout | `S10-challenge` |

## Installer (une seule fois)

À installer sur votre machine : **Docker Desktop** (8 Go de mémoire dans *Settings → Resources*),
**Git**, **VS Code** (extensions Python, Jupyter, Docker conseillées) et un navigateur à jour.
Rien d'autre : Python, Spark et les bases tournent dans des conteneurs.

1. Sur GitHub, cliquez sur **Fork** en haut de cette page : vous obtenez votre propre copie du dépôt.
2. Clonez **votre** fork et reliez-le au dépôt du cours :

```bash
git clone https://github.com/<votre-compte>/cours_dataviz.git && cd cours_dataviz
git remote add upstream https://github.com/laminendao/cours_dataviz.git
cp .env.example .env
bash scripts/telecharger_donnees.sh 2025-01    # ≈ 60 Mo
bash scripts/diagnostic.sh                     # tout doit être OK
docker compose up -d                           # 1er lancement : plusieurs Go d'images
```

Si le diagnostic échoue et que ça ne se règle pas en 15 min : [plan B](plan-b/README.md).

## Récupérer une nouvelle séance

Au début de chaque séance :

```bash
git pull upstream main
```

Ou, depuis GitHub : bouton **Sync fork** sur la page de votre fork, puis `git pull` dans votre terminal.

## Où travailler : `mon_travail/`

**Ne modifiez pas les fichiers du cours** (`seances/`, `commun/`, `compose.yaml`…) :
ils peuvent être mis à jour, et vos modifications bloqueraient le `git pull`.

Copiez les notebooks dans votre dossier avant de les compléter :

```bash
mkdir -p mon_travail
cp seances/S01-architectures/*.ipynb mon_travail/
```

Pensez à enregistrer votre travail sur votre fork à la fin de chaque séance :

```bash
git add mon_travail
git commit -m "S01 : ingestion bronze"
git push
```

> Un fork d'un dépôt public est lui aussi public. Pour un dépôt privé : créez un dépôt privé vide
> sur GitHub, clonez-le, puis ajoutez ce dépôt comme `upstream` avec la même commande que ci-dessus.

## Services

| Service | Adresse | Identifiants | Lancé avec |
|---|---|---|---|
| JupyterLab + Spark | http://localhost:8888/lab?token=cours | jeton `cours` | `docker compose up -d` |
| Spark UI | http://localhost:4040 | — | (pendant une session Spark) |
| Data lake RustFS (console) | http://localhost:9001 | `rustfsadmin` / `rustfsadmin` | `docker compose up -d` |
| PostgreSQL (console Adminer) | http://localhost:8080 | système *PostgreSQL*, serveur `postgres`, `cours` / `cours`, base `nyctaxi` | `docker compose up -d` |
| PostgreSQL | `localhost:5432`, base `nyctaxi` | `cours` / `cours` | `docker compose up -d` |
| Serveur SPARQL Fuseki | http://localhost:3030 | `admin` / `admin` | `docker compose --profile semantique up -d` |
| Application Streamlit | http://localhost:8501 | — | `docker compose --profile app up -d --build` |
| Apache Superset | http://localhost:8088 | `admin` / `admin` | `docker compose --profile bi up -d` |
| Grafana | http://localhost:3000 | `admin` / `admin` | `docker compose --profile temps-reel up -d` |

## Commandes utiles

```bash
docker compose ps                         # ce qui tourne
docker compose logs -f jupyter            # journal d'un service (Ctrl + C pour sortir)
docker compose --profile "*" down         # tout arrêter (les données sont conservées)
docker compose --profile "*" down -v      # tout arrêter ET effacer les données des volumes
```

En cas de problème : [pannes fréquentes](docs/pannes-frequentes.md).

## Organisation du dépôt

```
compose.yaml   .env.example   scripts/   commun/ (code partagé)   grafana/ (configuration)   data/ (non versionné)
seances/   (un README + les notebooks de chaque séance, publiés au fil du cours)
mon_travail/   (votre travail : notebooks complétés, captures, livrables)
plan-b/   (sans Docker : Google Colab)      docs/   (pannes fréquentes)
```

## Sources des données

- NYC Taxi & Limousine Commission, *TLC Trip Record Data* — https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Open-Meteo, archive météo horaire — https://open-meteo.com/

# Plan B — sans Docker

À utiliser si `bash scripts/diagnostic.sh` échoue et que le problème ne se règle pas en 15 minutes.
Les notions et les livrables sont les mêmes ; seuls les outils changent.

| Brique | Plan A (Docker) | Plan B (navigateur + compte Google) |
|---|---|---|
| Spark | JupyterLab local | Google Colab : `!pip install pyspark delta-spark` |
| Data lake | RustFS (S3) | Dossier Google Drive (`/content/drive/MyDrive/datalake`) |
| Base de restitution | PostgreSQL | Fichier DuckDB |
| Visualisation en code | Streamlit local | Streamlit Community Cloud |
| BI | Superset | Looker Studio |
| Temps réel | Grafana | Page Streamlit à rafraîchissement automatique |

Les notebooks de `seances/` fonctionnent dans Colab
en remplaçant `creer_session()` par une session Spark simple et `LAKE` par un chemin Google Drive.

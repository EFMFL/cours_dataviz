# Pannes fréquentes

| Symptôme | Cause | Solution |
|---|---|---|
| `command not found: docker` | Docker Desktop jamais lancé, ou terminal ouvert avant l'installation | Lancer Docker Desktop, attendre la baleine immobile, ouvrir un **nouveau** terminal |
| `Cannot connect to the Docker daemon` | Docker Desktop n'est pas démarré | Lancer Docker Desktop |
| `The container name "/…" is already in use` | Un ancien conteneur porte déjà ce nom | `docker rm -f <nom>` |
| `port is already allocated` | Un autre programme utilise ce port (ex. un PostgreSQL local sur 5432) | Fermer ce programme, ou changer le chiffre de **gauche** dans `ports:` |
| Le terminal ne rend pas la main | Conteneur lancé au premier plan | `control + C` (pas cmd), ou lancer avec `-d` |
| 404 sur une adresse `localhost` | L'application n'a rien à cette adresse | Vérifier la bonne route (ex. `/docs`, `/lab`) |
| Spark : `OutOfMemoryError` / noyau qui meurt | Mémoire Docker trop faible | Docker Desktop → Settings → Resources → 8 Go ; redémarrer le noyau |
| Spark : `ClassNotFoundException … S3AFileSystem` ou `delta` | Session Spark démarrée avant `creer_session()` | *Kernel → Restart*, puis lancer `creer_session()` en premier |
| Spark très long au 1er démarrage | Téléchargement des jars Delta/S3 (plusieurs centaines de Mo) | Normal la 1re fois ; à faire chez soi avant le cours |
| `NoSuchBucket` | Le bucket `datalake` n'existe pas | Le créer dans la console RustFS ou avec `creer_bucket()` |
| RustFS redémarre en boucle | Droits du volume | `docker compose up -d rustfs-init rustfs` puis `docker compose logs rustfs` |
| Superset : page blanche au 1er lancement | Initialisation en cours (1 à 2 min) | Attendre, puis `docker compose logs -f superset` |
| Superset ne trouve pas la base | Mauvais hôte | Hôte **`postgres`** (pas `localhost`), port 5432, base `nyctaxi` |
| Images Docker trop lentes à télécharger en cours | Wi-Fi saturé | Lancer `docker compose --profile "*" pull` chez soi avant la séance |
| VS Code : `FileNotFoundError` sur `/home/jovyan/work/...` ou `No module named pyspark` | Mauvais noyau : un Python local est sélectionné | *Select Kernel → Existing Jupyter Server* → `http://localhost:8888/?token=cours` |
| `Py4JJavaError` sur `format("delta")`, ou message « ⚠ Delta Lake indisponible » | Version de Spark de l'image plus récente que celles connues de `spark_utils.py` | Ajouter la version dans `_DELTA_POUR_SPARK` (voir https://delta.io), *Kernel → Restart*, relancer depuis le début |
| `relation "gold_trajets_horaires" does not exist` | Le notebook S02 n'a pas été exécuté jusqu'à l'export PostgreSQL | Relancer `02_silver_gold.ipynb` jusqu'au bout |
| Streamlit : « Carte indisponible » | `data/zones.geojson` n'existe pas encore | Exécuter la partie 3 du notebook `05a_plotly_altair.ipynb` |
| Streamlit ne prend pas en compte une modification | Page non rechargée | Bouton *Rerun* en haut à droite, ou `docker compose --profile app restart streamlit` |
| Grafana : panneaux vides | Le script de rejeu n'est pas lancé, ou la table `courses_live` est vide | Lancer `rejeu.py` (voir README S08) |
| Grafana : erreur sur la source de données | PostgreSQL arrêté | `docker compose up -d postgres` |

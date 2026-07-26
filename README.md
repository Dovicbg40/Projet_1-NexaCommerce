# NexaCommerce Data - Projet 1

Analyse exploratoire des données opérationnelles de NexaCommerce Cameroun,
une startup de livraison de proximité basée à Douala.

## Contexte

NexaCommerce traite plus de 2 800 commandes par jour sur Douala, Yaoundé
et Bafoussam. Ce projet vise à auditer, nettoyer et analyser les données
pour fournir à la direction des indicateurs fiables.

## Structure du projet
NexaCommerce_data/
├── data/ # Datasets bruts (orders.csv, customers.csv)
├── Notebook/ # Notebooks Jupyter (analyse stats, EDA)
├── Sql/ # Scripts SQL (audit, KPIs, vue v_order_kpis)
├── src/
│ └── projet1_nexacom/
│ ├── data_loader.py # Chargement CSV avec gestion d'erreurs
│ └── inspect_dataset.py # Inspection et rapport qualité
├── tests/
│ └── test_data_loader.py # Tests unitaires Pytest
├── pyproject.toml
├── .pre-commit-config.yaml
└── README.md


## Installation

```bash
pip install poetry
poetry install
```

## Utilisation

```python
from src.projet1_nexacom.data_loader import load_csv
import pandas as pd

df = pd.DataFrame(load_csv("data/orders.csv"))
```

## Lancer les tests

```bash
pytest -v
```

## Livrables

| Livrable | Description |
|----------|-------------|
| L1 - Dépôt Git | Code Python modulaire, testé et versionné |
| L2 - Script SQL | Audit qualité + vue v_order_kpis |
| L3 - Notebook Statistique | Stats descriptives, Bayes, t-test, IQR |
| L4 - Rapport EDA Final | Pipeline nettoyage + visualisations |
| L5 - Support Présentation | 5 insights clés pour le comité de direction |

## Stack technique

- Python 3.12
- Pandas, NumPy, Matplotlib, Seaborn, Scipy
- MySQL / DBeaver
- Poetry, Git, Pytest, Black, Flake8

## Auteur

BABOGA BAGAGNA Franck Ludovic — DHI Academy, Avril 2026
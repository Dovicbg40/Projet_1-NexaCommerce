import csv


def load_csv(fichier):
    try:
        with open(fichier, encoding="utf-8") as file:
            reader = csv.DictReader(file)
            for ligne in reader:
                yield dict(ligne)
    except FileNotFoundError:
        print(f"Fichier introuvable : {fichier}")
    except PermissionError:
        print(f"Accès refusé : {fichier}")


def load_all(filenames: list):
    for filename in filenames:
        yield from load_csv(filename)


def get_column_names(fichier):
    with open(fichier, encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return [colonne.strip().lower() for colonne in reader.fieldnames]

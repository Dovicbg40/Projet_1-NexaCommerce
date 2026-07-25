import pandas as pd


def inspect_dataset(df: pd.DataFrame) -> dict:
    valeurs_nulles = dict(map(lambda col: (col, df[col].isnull().sum()), df.columns))
    null_columns = list(filter(lambda col: df[col].isnull().sum() > 0, df.columns))
    types_col = dict(map(lambda col: (col, df[col].dtype), df.columns))
    doublons = df.duplicated().sum()

    return {
        "Valeur_Nulle": valeurs_nulles,
        "Col_Nulles": null_columns,
        "Types_Col": types_col,
        "Nbres_Doublons": int(doublons),
    }

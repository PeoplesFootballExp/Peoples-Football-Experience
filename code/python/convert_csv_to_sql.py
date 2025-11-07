import polars as pl
import sqlite3
from pathlib import Path

def csv_to_sqlite(csv_path: str, db_path: str, table_name: str, if_exists: str = "replace"):
    """
    Converts a CSV file into a SQLite table.

    Args:
        csv_path (str): Path to the input CSV file.
        db_path (str): Path to the SQLite database file.
        table_name (str): Name of the table to create/insert into.
        if_exists (str): What to do if the table already exists. 
                         Options: "replace", "append", or "fail".
    """

    # --- Validate inputs ---
    csv_path = Path(csv_path)
    db_path = Path(db_path)

    if not csv_path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")

    if if_exists not in {"replace", "append", "fail"}:
        raise ValueError("if_exists must be 'replace', 'append', or 'fail'.")

    # --- Load CSV using Polars (fast + type inference) ---
    print(f"Loading CSV: {csv_path}")
    df = pl.read_csv(csv_path)

    # --- Connect to SQLite ---
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # --- Handle table creation or replacement ---
    if if_exists == "replace":
        cursor.execute(f"DROP TABLE IF EXISTS {table_name}")
    elif if_exists == "fail":
        # Check if table exists
        cursor.execute(
            "SELECT name FROM sqlite_master WHERE type='table' AND name=?", (table_name,)
        )
        if cursor.fetchone():
            raise RuntimeError(f"Table '{table_name}' already exists.")

    # --- Write Polars DataFrame to SQLite ---
    # Convert to pandas since sqlite3’s native adapter expects it
    df.to_pandas().to_sql(table_name, conn, if_exists="append", index=False)

    conn.commit()
    conn.close()
    print(f"Table '{table_name}' successfully written to {db_path}")




csv_to_sqlite("Wikidata League Info - Territories.csv", "PFE_Database.db", "Territory", "replace")

import requests
import polars as pl
import sys
from typing import List
import time
import sqlite3

def save_confederation_members_to_sqlite(db_path: str, confederation_qids: List[str], confederation_names: List[str]):
    """
    Fetch member countries for multiple confederations and save into SQLite database.
    
    Parameters:
        db_path (str): Path to SQLite database file.
        confederation_qids (List[str]): List of Wikidata QIDs for confederations.
        confederation_names (List[str]): List of English names for confederations.
    """
    if len(confederation_qids) != len(confederation_names):
        raise ValueError("confederation_qids and confederation_names must have the same length")
    
    # Connect to SQLite
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    
    # Create table if it doesn't exist
    c.execute('''
    CREATE TABLE IF NOT EXISTS nations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country_uri TEXT,
        country_name TEXT,
        confederation_qid TEXT,
        confederation_name TEXT,
        UNIQUE(country_uri, confederation_qid)
    )
    ''')
    conn.commit()
    
    # Loop through confederations
    for qid, name in zip(confederation_qids, confederation_names):
        # Fetch countries using your existing function
        df = fetch_confederation_members(qid)  # returns country, countryLabel
        
        # Add confederation info
        df = df.with_columns([
            pl.lit(qid).alias("confederation_qid"),
            pl.lit(name).alias("confederation_name")
        ])
        
        # Insert rows into SQLite one by one (only if not exists)
        for row in df.iter_rows(named=True):
            c.execute('''
            INSERT OR IGNORE INTO nations (country_uri, country_name, confederation_qid, confederation_name)
            VALUES (?, ?, ?, ?)
            ''', (row["country"], row["countryLabel"], row["confederation_qid"], row["confederation_name"]))
        
        conn.commit()
        time.sleep(15)  # wait 15 seconds to avoid rate limit
    
    conn.close()
    print("All confederation members saved to database successfully.")

import requests
import polars as pl

def fetch_confederation_members(confederation_qid: str) -> pl.DataFrame:
    """
    Fetch member countries of a confederation, including the confederation's QID and English name.
    
    Returns a Polars DataFrame with columns:
    - country
    - countryLabel
    - confederation_qid
    - confederation_name
    """
    query = f"""
    SELECT ?association ?associationLabel ?country ?countryLabel ?confederationLabel WHERE {{
        wd:{confederation_qid} wdt:P355 ?association.

        OPTIONAL {{ ?association wdt:P1001 ?p1001. }}
        OPTIONAL {{ ?association wdt:P17 ?p17. }}
        BIND(COALESCE(?p1001, ?p17) AS ?country)

        BIND(wd:{confederation_qid} AS ?confederation)

        # Get English labels for all items, including confederation
        SERVICE wikibase:label {{ bd:serviceParam wikibase:language 'en'. }}
        }}
    ORDER BY ?countryLabel ?associationLabel
    """

    url = "https://query.wikidata.org/sparql"
    headers = {"Accept": "application/sparql-results+json"}
    response = requests.get(url, params={"query": query}, headers=headers)
    
    if response.status_code != 200:
        raise Exception(f"SPARQL query failed: {response.status_code} {response.text}")

    results = response.json()["results"]["bindings"]

    data = {
        "country": [],
        "countryLabel": [],
        "confederation_qid": [],
        "confederation_name": []
    }

    for item in results:
        data["country"].append(item["country"]["value"] if "country" in item else None)
        data["countryLabel"].append(item["countryLabel"]["value"] if "countryLabel" in item else None)
        data["confederation_qid"].append(confederation_qid)
        # The confederation name is returned via ?confederationLabel, fallback to QID if missing
        data["confederation_name"].append(item.get("confederationLabel", {}).get("value", confederation_qid))

    df = pl.DataFrame(data)
    return df


def fetch_all_confederation_members(confederation_ids: List[str]) -> pl.DataFrame:
    """
    Fetch member countries for multiple confederations and combine into a single table.
    
    Parameters:
        confederation_ids (List[str]): List of Wikidata QIDs for confederations.
        
    Returns:
        polars.DataFrame: Columns: country, countryLabel, sorted by countryLabel.
    """
    all_dfs = []

    for conf_id in confederation_ids:
        time.sleep(15.0)
        df = fetch_confederation_members(conf_id)
        all_dfs.append(df)
        print(f"Completed {conf_id}")


    # Concatenate all DataFrames
    combined_df = pl.concat(all_dfs)

    # Remove duplicates (some countries may appear in multiple confederations)
    combined_df = combined_df.unique()
    combined_df = combined_df.filter(pl.col("country").is_not_null())
    combined_df = combined_df.unique(subset=["countryLabel"])

    # Sort alphabetically by countryLabel
    combined_df = combined_df.sort("countryLabel")

    return combined_df

def save_dataframe_to_sqlite(df: pl.DataFrame, db_path: str, table_name: str = "ConfederationMembers"):
    """
    Saves a Polars DataFrame to SQLite, appending only new rows.
    Assumes df has columns: country, countryLabel, confederation_qid, confederation_name
    """
    conn = sqlite3.connect(db_path)
    c = conn.cursor()

    # Create table if not exists
    c.execute(f'''
    CREATE TABLE IF NOT EXISTS {table_name} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country_uri TEXT,
        country_name TEXT,
        confederation_qid TEXT,
        confederation_name TEXT,
        UNIQUE(country_uri, confederation_qid)
    )
    ''')
    conn.commit()

    # Insert rows using INSERT OR IGNORE
    for row in df.iter_rows(named=True):
        c.execute(f'''
        INSERT OR IGNORE INTO {table_name} 
        (country_uri, country_name, confederation_qid, confederation_name)
        VALUES (?, ?, ?, ?)
        ''', (row["country"], row["countryLabel"], row["confederation_qid"], row["confederation_name"]))

    conn.commit()
    conn.close()
    print(f"Data saved to {table_name} in {db_path}")

if __name__ == "__main__":
    confederation_qids = ["Q35572", "Q58733", "Q160549", "Q168360", "Q83276", "Q180344"] # All confederations

    # 
    df_members = fetch_all_confederation_members(confederation_ids= confederation_qids)

    # For Python 3.7+ you can set stdout encoding
    sys.stdout.reconfigure(encoding='utf-8')

    # Print
    print(df_members)

    # Save to SQL
    save_dataframe_to_sqlite(df_members, "data_collection/data_collected/football.db")
    
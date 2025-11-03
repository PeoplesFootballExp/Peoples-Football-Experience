import requests
import polars as pl
import sys
from typing import List
import time
import sqlite3


def get_football_leagues():
    url = "https://query.wikidata.org/sparql"
    
    query = """
    SELECT DISTINCT 
      ?league ?leagueLabel ?country ?countryLabel
      ?inception_year ?logo_image ?competition_classLabel
      ?season_start_monthLabel ?number_of_participants
      ?sports_league_levelLabel ?season_endsLabel ?league_systemLabel
      ?opta_id ?fbref_id
    WHERE {
      ?league wdt:P31 wd:Q15991303.

      OPTIONAL { ?league wdt:P17 ?country. }

      # Only the year of inception
      OPTIONAL { ?league wdt:P571 ?inception. }
      BIND(YEAR(?inception) AS ?inception_year)

      OPTIONAL { ?league wdt:P154 ?logo_image. }
      OPTIONAL { ?league wdt:P2094 ?competition_class. }
      OPTIONAL { ?league wdt:P4794 ?season_start_month. }
      OPTIONAL { ?league wdt:P1132 ?number_of_participants. }
      OPTIONAL { ?league wdt:P2983 ?sports_league_level. }
      OPTIONAL { ?league wdt:P6118 ?season_ends. }
      OPTIONAL { ?league wdt:P6587 ?league_system. }
      OPTIONAL { ?league wdt:P8735 ?opta_id. }
      OPTIONAL { ?league wdt:P13664 ?fbref_id. }

      SERVICE wikibase:label { bd:serviceParam wikibase:language 'en'. }
    }
    ORDER BY ?countryLabel ?leagueLabel
    """
    
    headers = {"Accept": "application/sparql-results+json"}
    
    response = requests.get(url, params={"query": query}, headers=headers)
    response.raise_for_status()
    results = response.json()
    
    data = []
    for item in results["results"]["bindings"]:
        league_uri = item["league"]["value"]
        league_id = league_uri.split("/")[-1]
        league_label = item.get("leagueLabel", {}).get("value")
        country_uri = item.get("country", {}).get("value")
        country_id = country_uri.split("/")[-1] if country_uri else None
        country_label = item.get("countryLabel", {}).get("value")
        
        data.append({
            "league": league_id,
            "leagueLabel": league_label,
            "country": country_id,
            "countryLabel": country_label,
            "inception_year": item.get("inception_year", {}).get("value"),
            "logo_image": item.get("logo_image", {}).get("value"),
            "competition_class": item.get("competition_classLabel", {}).get("value"),
            "season_start_month": item.get("season_start_monthLabel", {}).get("value"),
            "number_of_participants": item.get("number_of_participants", {}).get("value"),
            "sports_league_level": item.get("sports_league_levelLabel", {}).get("value"),
            "season_ends": item.get("season_endsLabel", {}).get("value"),
            "league_system": item.get("league_systemLabel", {}).get("value"),
            "opta_id": item.get("opta_id", {}).get("value"),
            "fbref_id": item.get("fbref_id", {}).get("value")
        })
    
    # Convert to Polars DataFrame with explicit nullable string types
    df = pl.DataFrame(
        data,
        schema={
            "league": pl.Utf8,
            "leagueLabel": pl.Utf8,
            "country": pl.Utf8,
            "countryLabel": pl.Utf8,
            "inception_year": pl.Utf8,
            "logo_image": pl.Utf8,
            "competition_class": pl.Utf8,
            "season_start_month": pl.Utf8,
            "number_of_participants": pl.Utf8,
            "sports_league_level": pl.Utf8,
            "season_ends": pl.Utf8,
            "league_system": pl.Utf8,
            "opta_id": pl.Utf8,
            "fbref_id": pl.Utf8
        }
    )
    
    # Filter out rows with null or Q-ID labels
    df = df.filter(
        (pl.col("leagueLabel").is_not_null()) &
        (~pl.col("leagueLabel").str.contains(r"^Q\d+$"))
    )
    
    # Sort by countryLabel then leagueLabel
    df = df.sort(["countryLabel", "leagueLabel"])
    
    return df

def save_leagues_to_sql_upsert(df: pl.DataFrame, db_path: str, table_name: str = "League"):
    """
    Saves a Polars DataFrame to an SQLite database using UPSERT.
    - Inserts new leagues if they do not exist.
    - Updates existing leagues without changing the primary key (league ID).
    
    Parameters:
        df (pl.DataFrame): Polars DataFrame containing league data.
        db_path (str): Path to SQLite database.
        table_name (str): Name of the table to save to.
    """
    # Connect to SQLite
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Create table if it doesn't exist
    cursor.execute(f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            league TEXT PRIMARY KEY,
            leagueLabel TEXT,
            country TEXT,
            countryLabel TEXT,
            inception_year TEXT,
            logo_image TEXT,
            competition_class TEXT,
            season_start_month TEXT,
            number_of_participants TEXT,
            sports_league_level TEXT,
            season_ends TEXT,
            league_system TEXT,
            opta_id TEXT,
            fbref_id TEXT
        )
    """)
    
    # Iterate over DataFrame rows and UPSERT
    for row in df.iter_rows(named=True):
        cursor.execute(f"""
            INSERT INTO {table_name} 
            (league, leagueLabel, country, countryLabel, inception_year, logo_image,
             competition_class, season_start_month, number_of_participants, sports_league_level,
             season_ends, league_system, opta_id, fbref_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(league) DO UPDATE SET
                leagueLabel=excluded.leagueLabel,
                country=excluded.country,
                countryLabel=excluded.countryLabel,
                inception_year=excluded.inception_year,
                logo_image=excluded.logo_image,
                competition_class=excluded.competition_class,
                season_start_month=excluded.season_start_month,
                number_of_participants=excluded.number_of_participants,
                sports_league_level=excluded.sports_league_level,
                season_ends=excluded.season_ends,
                league_system=excluded.league_system,
                opta_id=excluded.opta_id,
                fbref_id=excluded.fbref_id
        """, (
            row["league"], row["leagueLabel"], row["country"], row["countryLabel"], row["inception_year"],
            row["logo_image"], row["competition_class"], row["season_start_month"], row["number_of_participants"],
            row["sports_league_level"], row["season_ends"], row["league_system"], row["opta_id"], row["fbref_id"]
        ))
    
    # Commit and close
    conn.commit()
    conn.close()
    
    print(f"Data upserted to '{table_name}' in {db_path} ({df.height} rows).")

def get_teams_in_league(league_qid: str) -> pl.DataFrame:
    """
    Fetches all current association football teams in a given league.
    
    Parameters:
        league_qid (str): The Wikidata Q-ID of the league (e.g., "Q9448" for Premier League)
    
    Returns:
        pl.DataFrame: DataFrame with columns 'team' (Wikidata ID) and 'teamLabel'
    """
    url = "https://query.wikidata.org/sparql"
    
    query = f"""
    SELECT DISTINCT ?team ?teamLabel
    WHERE {{
      VALUES ?league {{ wd:{league_qid} }}

      ?team p:P118 ?leagueStatement.
      ?leagueStatement ps:P118 ?league.

      # Optional time filtering: current teams only
      OPTIONAL {{ ?leagueStatement pq:P580 ?start. }}
      OPTIONAL {{ ?leagueStatement pq:P582 ?end. }}

      FILTER(
        !BOUND(?end) || ?end > NOW()
      )

      # Ensure we’re only getting football clubs
      ?team wdt:P31/wdt:P279* wd:Q476028.  # 'association football club' or subclass

      SERVICE wikibase:label {{ bd:serviceParam wikibase:language 'en'. }}
    }}
    ORDER BY ?teamLabel
    """
    
    headers = {
        "Accept": "application/sparql-results+json",
        "User-Agent": "FootballDataBot/0.1 (youremail@example.com)"
    }
    
    response = requests.get(url, params={"query": query}, headers=headers)
    response.raise_for_status()
    results = response.json()
    
    data = []
    for item in results["results"]["bindings"]:
        team_uri = item["team"]["value"]
        team_id = team_uri.split("/")[-1]
        team_label = item.get("teamLabel", {}).get("value")
        data.append({
            "team": team_id,
            "teamLabel": team_label
        })
    
    # Convert to Polars DataFrame
    df = pl.DataFrame(
        data,
        schema={
            "team": pl.Utf8,
            "teamLabel": pl.Utf8
        }
    )
    
    # Filter out rows where teamLabel is null or just a Q-ID
    df = df.filter(
        (pl.col("teamLabel").is_not_null()) &
        (~pl.col("teamLabel").str.contains(r"^Q\d+$"))
    )
    
    return df


if __name__ == "__main__":
    # leagues = get_football_leagues()

    # save_leagues_to_sql_upsert(df=leagues, db_path="data_collection/data_collected/wikidata_football.db")

    teams = get_teams_in_league("Q793457")

    # For Python 3.7+ you can set stdout encoding
    sys.stdout.reconfigure(encoding='utf-8')

    print(teams)


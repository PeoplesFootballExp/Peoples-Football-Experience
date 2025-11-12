import requests
import polars as pl
from typing import List
import time

WIKIDATA_ENDPOINT = "https://query.wikidata.org/sparql"
HEADERS = {"Accept": "application/sparql-results+json"}

def run_sparql(query: str, schema: dict = None) -> pl.DataFrame:
    """
    Executes a SPARQL query on Wikidata and returns a Polars DataFrame.
    """
    response = requests.get(WIKIDATA_ENDPOINT, params={"query": query}, headers=HEADERS)
    response.raise_for_status()
    results = response.json()["results"]["bindings"]

    if not results:
        return pl.DataFrame()

    # Convert results to a list of dictionaries
    data = []
    for item in results:
        row = {k: v.get("value") for k, v in item.items()}
        data.append(row)

    # Convert to Polars DataFrame with schema if given
    if schema:
        df = pl.DataFrame(data, schema=schema)
    else:
        df = pl.DataFrame(data)

    return df

# Template Query: get football team data
TEAM_QUERY_TEMPLATE = """
    SELECT ?club ?clubLabel
        ?nameEn
        ?officialNameEn ?officialNameStart ?officialNameEnd
        ?inception
        ?country ?countryLabel
        ?headCoach ?headCoachLabel ?coachStart ?coachEnd
        ?league ?leagueLabel ?leagueStart ?leagueEnd
        ?venue ?venueLabel ?venueStart ?venueEnd
        ?owner ?ownerLabel ?ownershipShare
        ?flag
        ?color ?colorLabel
        ?fbrefID
        ?optaID
        ?transfermarktID
        ?worldfootballID
    WHERE {{
    VALUES ?club {{ wd:{team_qid} }} 

    OPTIONAL {{ ?club wdt:P2561 ?nameEn. FILTER(LANG(?nameEn) = 'en') }} 
    OPTIONAL {{
        ?club p:P1448 ?officialNameStatement.
        ?officialNameStatement ps:P1448 ?officialNameEn.
        FILTER(LANG(?officialNameEn) = 'en')
        OPTIONAL {{ ?officialNameStatement pq:P580 ?officialNameStart. }}
        OPTIONAL {{ ?officialNameStatement pq:P582 ?officialNameEnd. }}
    }}
    OPTIONAL {{ ?club wdt:P571 ?inception. }}
    OPTIONAL {{ ?club wdt:P17 ?country. }}
    OPTIONAL {{
        ?club p:P286 ?coachStatement.
        ?coachStatement ps:P286 ?headCoach.
        OPTIONAL {{ ?coachStatement pq:P580 ?coachStart. }}
        OPTIONAL {{ ?coachStatement pq:P582 ?coachEnd. }}
    }}
    OPTIONAL {{
        ?club p:P118 ?leagueStatement.
        ?leagueStatement ps:P118 ?league.
        OPTIONAL {{ ?leagueStatement pq:P580 ?leagueStart. }}
        OPTIONAL {{ ?leagueStatement pq:P582 ?leagueEnd. }}
    }}
    OPTIONAL {{
        ?club p:P115 ?venueStatement.
        ?venueStatement ps:P115 ?venue.
        OPTIONAL {{ ?venueStatement pq:P580 ?venueStart. }}
        OPTIONAL {{ ?venueStatement pq:P582 ?venueEnd. }}
    }}
    OPTIONAL {{
        ?club p:P127 ?ownerStatement.
        ?ownerStatement ps:P127 ?owner.
        OPTIONAL {{ ?ownerStatement pq:P1107 ?ownershipShare. }}
    }}
    OPTIONAL {{ ?club wdt:P41 ?flag. }}
    OPTIONAL {{ ?club wdt:P6364 ?color. }}
    OPTIONAL {{ ?club wdt:P8642 ?fbrefID. }}
    OPTIONAL {{ ?club wdt:P8737 ?optaID. }}
    OPTIONAL {{ ?club wdt:P7223 ?transfermarktID. }}
    OPTIONAL {{ ?club wdt:P7287 ?worldfootballID. }}

    SERVICE wikibase:label {{ bd:serviceParam wikibase:language 'en'. }}
    }}
    """

# Template Query: get nation/territory data
NATION_QUERY_TEMPLATE = """
    SELECT 
    ?territory ?territoryLabel 
    ?official_name ?demonym 
    ?national_anthem ?country 
    ?geoshape ?coordinates 
    ?population ?population_point_in_time
    ?gdp_nominal ?gdp_point_in_time
    ?language ?languageLabel ?language_number_of_speakers ?language_characteristic
    ?area ?area_point_in_time
    ?flag ?flag_start_time ?flag_end_time
    ?iso_alpha3
    WHERE {{
    VALUES ?territory {{ wd:{territory_qid} }}

    # Official name (English only)
    OPTIONAL {{
        ?territory wdt:P1448 ?official_name.
        FILTER(LANG(?official_name) = 'en')
    }}

    # Demonym (English only)
    OPTIONAL {{
        ?territory wdt:P1549 ?demonym.
        FILTER(LANG(?demonym) = 'en')
    }}

    # Other direct properties
    OPTIONAL {{ ?territory wdt:P85 ?national_anthem. }}
    OPTIONAL {{ ?territory wdt:P17 ?country. }}
    OPTIONAL {{ ?territory wdt:P3896 ?geoshape. }}
    OPTIONAL {{ ?territory wdt:P625 ?coordinates. }}
    OPTIONAL {{ ?territory wdt:P298 ?iso_alpha3. }}

    # --- Population with qualifier ---
    OPTIONAL {{
        ?territory p:P1082 ?population_statement.
        ?population_statement ps:P1082 ?population.
        OPTIONAL {{ ?population_statement pq:P585 ?population_point_in_time. }}
    }}

    # --- GDP nominal with qualifier ---
    OPTIONAL {{
        ?territory p:P2131 ?gdp_statement.
        ?gdp_statement ps:P2131 ?gdp_nominal.
        OPTIONAL {{ ?gdp_statement pq:P585 ?gdp_point_in_time. }}
    }}

    # --- Language used with qualifiers ---
    OPTIONAL {{
        ?territory p:P2936 ?language_statement.
        ?language_statement ps:P2936 ?language.
        OPTIONAL {{ ?language_statement pq:P1098 ?language_number_of_speakers. }}
        OPTIONAL {{ ?language_statement pq:P1552 ?language_characteristic. }}
    }}

    # --- Area with qualifier ---
    OPTIONAL {{
        ?territory p:P2046 ?area_statement.
        ?area_statement ps:P2046 ?area.
        OPTIONAL {{ ?area_statement pq:P585 ?area_point_in_time. }}
    }}

    # --- Flag image with qualifiers ---
    OPTIONAL {{
        ?territory p:P41 ?flag_statement.
        ?flag_statement ps:P41 ?flag.
        OPTIONAL {{ ?flag_statement pq:P580 ?flag_start_time. }}
        OPTIONAL {{ ?flag_statement pq:P582 ?flag_end_time. }}
    }}

    SERVICE wikibase:label {{ bd:serviceParam wikibase:language 'en'. }}
    }}
"""

# Template Query: get nations in confederation
CONFED_NATIONS_QUERY_TEMPLATE = """
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

# Gather Countries Members from Confederations
def get_confed_member_terrs(confed_qid: str) -> pl.DataFrame:
    """
    Fetches raw Wikidata information about the territories member of a confederation by its Q-ID.
    
    Parameters:
        confed_qid (str): Wikidata Q-ID of the confederation

    Returns:
        pl.DataFrame: Raw data as a Polars DataFrame
    """
    query = CONFED_NATIONS_QUERY_TEMPLATE.format(confederation_qid=confed_qid)

    return run_sparql(query)

def get_all_confed_member_terrs(confed_qids: List[str], delay: float = 15.0):
    """
    Fetches raw Wikidata data for multiple confeds and combines them into a single DataFrame.
    
    Parameters:
        confed_qids (List[str]): List of Wikidata Q-IDs (e.g., ["Q30", "Q145"])
        delay (float): Delay in seconds between requests to avoid overloading Wikidata
        
    Returns:
        pl.DataFrame: Combined DataFrame for all confed territory members
    """
    all_dfs = []
    
    for qid in confed_qids:
        try:
            df = get_confed_member_terrs(qid)  # Uses the existing single-nation function
            if not df.is_empty():
                all_dfs.append(df)
        except Exception as e:
            print(f"Error querying nation {qid}: {e}")
        
        time.sleep(delay)  # polite delay
    
    if all_dfs:
        return pl.concat(all_dfs, rechunk=True)
    else:
        return pl.DataFrame()  # return empty if nothing succeeded


# Gather Nation Data
def get_nation_data(territory_qid: str) -> pl.DataFrame:
    """
    Fetches raw Wikidata information about a nation (territory) by its Q-ID.
    
    Parameters:
        territory_qid (str): Wikidata Q-ID of the country/territory (ex "Q851" for USA)
    
    Returns:
        pl.DataFrame: Raw data as a Polars DataFrame
    """
    query = NATION_QUERY_TEMPLATE.format(territory_qid=territory_qid)
    NATION_SCHEMA = {
        "territory": pl.Utf8,
        "territoryLabel": pl.Utf8,
        "official_name": pl.Utf8,
        "demonym": pl.Utf8,
        "national_anthem": pl.Utf8,
        "country": pl.Utf8,
        "geoshape": pl.Utf8,
        "coordinates": pl.Utf8,
        "population": pl.Utf8,
        "population_point_in_time": pl.Utf8,
        "gdp_nominal": pl.Utf8,
        "gdp_point_in_time": pl.Utf8,
        "language": pl.Utf8,
        "languageLabel": pl.Utf8,
        "language_number_of_speakers": pl.Utf8,
        "language_characteristic": pl.Utf8,
        "area": pl.Utf8,
        "area_point_in_time": pl.Utf8,
        "flag": pl.Utf8,
        "flag_start_time": pl.Utf8,
        "flag_end_time": pl.Utf8,
        "iso_alpha3": pl.Utf8
    }

    return run_sparql(query=query, schema=NATION_SCHEMA) 

def get_multiple_nations_data(territory_qids: List[str], delay: float = 15.0) -> pl.DataFrame:
    """
    Fetches raw Wikidata data for multiple nations and combines them into a single DataFrame.
    
    Parameters:
        territory_qids (List[str]): List of Wikidata Q-IDs (e.g., ["Q30", "Q145"])
        delay (float): Delay in seconds between requests to avoid overloading Wikidata
        
    Returns:
        pl.DataFrame: Combined DataFrame for all nations
    """
    all_dfs = []
    
    for qid in territory_qids:
        try:
            df = get_nation_data(qid)  # Uses the existing single-nation function
            if not df.is_empty():
                all_dfs.append(df)
        except Exception as e:
            print(f"Error querying nation {qid}: {e}")
        
        time.sleep(delay)  # polite delay
    
    if all_dfs:
        return pl.concat(all_dfs, rechunk=True)
    else:
        return pl.DataFrame()  # return empty if nothing succeeded
    



# Gather Team Data
def get_team_data(team_qid: str) -> pl.DataFrame:
    """
    Get raw Wikidata information for a given team.

    Parameters:
        team_qid: The Wikidata ID in string format (ex. Q8682 Real Madrid's Wikidata ID)

    Returns: 
        Dataframe: A polars dataframe with all the raw results of the query. 
    """
    query = TEAM_QUERY_TEMPLATE.format(team_qid=team_qid)
    TEAM_SCHEMA = {
        "club": pl.Utf8,
        "clubLabel": pl.Utf8,
        "officialNameEn": pl.Utf8,
        "officialNameStart": pl.Utf8,
        "officialNameEnd": pl.Utf8,
        "inception": pl.Utf8,
        "country": pl.Utf8,
        "countryLabel": pl.Utf8,
        "headCoach": pl.Utf8,
        "headCoachLabel": pl.Utf8,
        "coachStart": pl.Utf8,
        "coachEnd": pl.Utf8,
        "league": pl.Utf8,
        "leagueLabel": pl.Utf8,
        "leagueStart": pl.Utf8,
        "leagueEnd": pl.Utf8,
        "venue": pl.Utf8,
        "venueLabel": pl.Utf8,
        "venueStart": pl.Utf8,
        "venueEnd": pl.Utf8,
        "owner": pl.Utf8,
        "ownerLabel": pl.Utf8,
        "ownershipShare": pl.Utf8,
        "flag": pl.Utf8,
        "color": pl.Utf8,
        "colorLabel": pl.Utf8,
        "fbrefID": pl.Utf8,
        "optaID": pl.Utf8,
        "transfermarktID": pl.Utf8,
        "worldfootballID": pl.Utf8
    }

    return run_sparql(query=query, schema=TEAM_SCHEMA)

def get_multiple_teams_data(team_qids: List[str], delay: float = 15.0) -> pl.DataFrame:
    """
    Get raw Wikidata data for multiple teams and combine into a single DataFrame.
    
    Parameters:
        team_qids (List[str]): List of Wikidata QIDs (e.g., ["Q18656", "Q11945"])
        delay (float): Optional delay in seconds between requests to be polite to Wikidata
        
    Returns:
        pl.DataFrame: Combined DataFrame of all teams
    """
    all_dfs = []
    
    for qid in team_qids:
        try:
            df = get_team_data(qid)  # Use your existing function
            if not df.is_empty():
                all_dfs.append(df)
        except Exception as e:
            print(f"Error querying {qid}: {e}")
        
        # Optional: polite delay
        time.sleep(delay)
    
    if all_dfs:
        return pl.concat(all_dfs, rechunk=True)
    else:
        return pl.DataFrame()  # return empty if nothing succeeded


# 

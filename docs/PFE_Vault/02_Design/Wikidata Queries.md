
## Grabbing Team Data

```
# Example: Manchester United (Q18656)
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
WHERE {
  VALUES ?club { wd:Q11945 }   # 👈 Replace this Q-ID with any other team

  OPTIONAL { ?club wdt:P2561 ?nameEn. FILTER(LANG(?nameEn) = "en") }

  OPTIONAL {
    ?club p:P1448 ?officialNameStatement.
    ?officialNameStatement ps:P1448 ?officialNameEn.
    FILTER(LANG(?officialNameEn) = "en")
    OPTIONAL { ?officialNameStatement pq:P580 ?officialNameStart. }
    OPTIONAL { ?officialNameStatement pq:P582 ?officialNameEnd. }
  }

  OPTIONAL { ?club wdt:P571 ?inception. }
  OPTIONAL { ?club wdt:P17 ?country. }

  OPTIONAL {
    ?club p:P286 ?coachStatement.
    ?coachStatement ps:P286 ?headCoach.
    OPTIONAL { ?coachStatement pq:P580 ?coachStart. }
    OPTIONAL { ?coachStatement pq:P582 ?coachEnd. }
  }

  OPTIONAL {
    ?club p:P118 ?leagueStatement.
    ?leagueStatement ps:P118 ?league.
    OPTIONAL { ?leagueStatement pq:P580 ?leagueStart. }
    OPTIONAL { ?leagueStatement pq:P582 ?leagueEnd. }
  }

  OPTIONAL {
    ?club p:P115 ?venueStatement.
    ?venueStatement ps:P115 ?venue.
    OPTIONAL { ?venueStatement pq:P580 ?venueStart. }
    OPTIONAL { ?venueStatement pq:P582 ?venueEnd. }
  }

  OPTIONAL {
    ?club p:P127 ?ownerStatement.
    ?ownerStatement ps:P127 ?owner.
    OPTIONAL { ?ownerStatement pq:P1107 ?ownershipShare. }
  }

  OPTIONAL { ?club wdt:P41 ?flag. }

  # ✅ Fixed: Use ?color instead of ?colors, and get its label
  OPTIONAL { ?club wdt:P6364 ?color. }

  OPTIONAL { ?club wdt:P8642 ?fbrefID. }
  OPTIONAL { ?club wdt:P8737 ?optaID. }
  OPTIONAL { ?club wdt:P7223 ?transfermarktID. }
  OPTIONAL { ?club wdt:P7287 ?worldfootballID. }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}

```



## Grabbing Nation Data

```
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
WHERE {
  VALUES ?territory { wd:Q851 }

  # Official name (English only)
  OPTIONAL {
    ?territory wdt:P1448 ?official_name.
    FILTER(LANG(?official_name) = "en")
  }

  # Demonym (English only)
  OPTIONAL {
    ?territory wdt:P1549 ?demonym.
    FILTER(LANG(?demonym) = "en")
  }

  # Other direct properties
  OPTIONAL { ?territory wdt:P85 ?national_anthem. }
  OPTIONAL { ?territory wdt:P17 ?country. }
  OPTIONAL { ?territory wdt:P3896 ?geoshape. }
  OPTIONAL { ?territory wdt:P625 ?coordinates. }
  OPTIONAL { ?territory wdt:P298 ?iso_alpha3. }

  # --- Population with qualifier ---
  OPTIONAL {
    ?territory p:P1082 ?population_statement.
    ?population_statement ps:P1082 ?population.
    OPTIONAL { ?population_statement pq:P585 ?population_point_in_time. }
  }

  # --- GDP nominal with qualifier ---
  OPTIONAL {
    ?territory p:P2131 ?gdp_statement.
    ?gdp_statement ps:P2131 ?gdp_nominal.
    OPTIONAL { ?gdp_statement pq:P585 ?gdp_point_in_time. }
  }

  # --- Language used with qualifiers ---
  OPTIONAL {
    ?territory p:P2936 ?language_statement.
    ?language_statement ps:P2936 ?language.
    OPTIONAL { ?language_statement pq:P1098 ?language_number_of_speakers. }
    OPTIONAL { ?language_statement pq:P1552 ?language_characteristic. }
  }

  # --- Area with qualifier ---
  OPTIONAL {
    ?territory p:P2046 ?area_statement.
    ?area_statement ps:P2046 ?area.
    OPTIONAL { ?area_statement pq:P585 ?area_point_in_time. }
  }

  # --- Flag image with qualifiers ---
  OPTIONAL {
    ?territory p:P41 ?flag_statement.
    ?flag_statement ps:P41 ?flag.
    OPTIONAL { ?flag_statement pq:P580 ?flag_start_time. }
    OPTIONAL { ?flag_statement pq:P582 ?flag_end_time. }
  }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}

```


## Grabbing all teams in league

```
# Replace wd:Q9448 with your league's Q-ID
SELECT DISTINCT ?team ?teamLabel
WHERE {
  VALUES ?league { wd:Q324867 }  # 👈 Replace this with league id

  ?team p:P118 ?leagueStatement.
  ?leagueStatement ps:P118 ?league.

  # Optional time filtering: current teams only
  OPTIONAL { ?leagueStatement pq:P580 ?start. }
  OPTIONAL { ?leagueStatement pq:P582 ?end. }
  FILTER(!BOUND(?end) || ?end > NOW())

  # Ensure we’re only getting football clubs
  ?team wdt:P31/wdt:P279* wd:Q476028.

  # Exclude dissolved or defunct clubs
  FILTER NOT EXISTS { ?team wdt:P576 ?dissolved. }
  FILTER NOT EXISTS { ?team wdt:P31 wd:Q94579592. }

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
ORDER BY ?teamLabel

```


## Grabbing all leagues in Wikidata

```
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

  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
ORDER BY ?countryLabel ?leagueLabel

```


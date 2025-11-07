import requests
import polars as pl
import sys
from typing import List
import time
import sqlite3
from lib.wikidata_queries import *

team_data = get_team_data("Q11945")

# For Python 3.7+ you can set stdout encoding
sys.stdout.reconfigure(encoding='utf-8')

print(team_data)
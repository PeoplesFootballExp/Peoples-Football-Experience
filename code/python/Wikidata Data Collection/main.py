import requests
import polars as pl
import sys
from typing import List
import time
import sqlite3
from lib.wikidata_queries import *

team_data = get_confed_member_terrs("Q35572")

print(team_data.get_column("association"))

# For Python 3.7+ you can set stdout encoding
sys.stdout.reconfigure(encoding='utf-8')

print(team_data)
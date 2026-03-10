# OpenFlightsPipeline
A simple data engineering pipeline that ingests aviation data from the OpenFlights dataset, cleans and transforms it using Python, stores it in PostgreSQL, and generates analytical insights using SQL.

OpenFlights API → Python → PostgreSQL → SQL Analytics

Dataset:
OpenFlights Dataset
https://openflights.org/data.html

Pipeline Steps:
1.Download OpenFlights Dataset
python src/download_data.py

Datasets downloaded:
airports
airlines
routes

2️.Data Cleaning
Converts raw .dat files into structured CSV files.

Handles:
missing values (\N)
formatting
header creation
python src/clean_csv.py

3️.Load Data into PostgreSQL
bulk loads cleaned CSV files using PostgreSQL COPY for efficiency.

python src/load_to_postgres.py

Tables created:
raw.airports
raw.airlines
raw.routes

4️.Transform Data
Creates enriched analytics views.
psql -f sql/02_transforms.sql

Views created:
analytics.v_airports
analytics.v_routes_enriched

5️.Run Analytics Queries
psql -f sql/03_analytics.sql

Queries generate insights such as:
Most connected airports
Airports with highest outgoing routes
Busiest aviation countries
Airlines operating the most routes
Routes served by the highest number of airlines

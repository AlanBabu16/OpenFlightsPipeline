BEGIN;

-- A “clean” airport dimension with some basic transformations and null handling
DROP VIEW IF EXISTS analytics.v_airports;
CREATE VIEW analytics.v_airports AS
SELECT
  airport_id,
  name,
  city,
  country,
  NULLIF(iata, '') AS iata,
  NULLIF(icao, '') AS icao,
  latitude,
  longitude,
  altitude_ft,
  timezone_hours,
  tz_database,
  type,
  source
FROM raw.airports;

-- Route facts with joined airport + airline names
DROP VIEW IF EXISTS analytics.v_routes_enriched;
CREATE VIEW analytics.v_routes_enriched AS
SELECT
  r.airline,
  r.airline_id,
  al.name AS airline_name,
  r.source_airport,
  r.source_airport_id,
  a1.name AS source_airport_name,
  a1.city AS source_city,
  a1.country AS source_country,
  a1.latitude AS source_lat,
  a1.longitude AS source_lon,
  r.dest_airport,
  r.dest_airport_id,
  a2.name AS dest_airport_name,
  a2.city AS dest_city,
  a2.country AS dest_country,
  a2.latitude AS dest_lat,
  a2.longitude AS dest_lon,
  r.codeshare,
  r.stops,
  r.equipment
FROM raw.routes r
LEFT JOIN raw.airlines al ON al.airline_id = r.airline_id
LEFT JOIN raw.airports a1 ON a1.airport_id = r.source_airport_id
LEFT JOIN raw.airports a2 ON a2.airport_id = r.dest_airport_id;

COMMIT;
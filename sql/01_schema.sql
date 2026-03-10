BEGIN;

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Raw OpenFlights tables 
DROP TABLE IF EXISTS raw.airports CASCADE;
CREATE TABLE raw.airports (
  airport_id        INTEGER PRIMARY KEY,
  name              TEXT,
  city              TEXT,
  country           TEXT,
  iata              TEXT,  
  icao              TEXT,  
  latitude          DOUBLE PRECISION,
  longitude         DOUBLE PRECISION,
  altitude_ft       INTEGER,
  timezone_hours    DOUBLE PRECISION,
  dst               TEXT,
  tz_database       TEXT,
  type              TEXT,
  source            TEXT
);

DROP TABLE IF EXISTS raw.airlines CASCADE;
CREATE TABLE raw.airlines (
  airline_id   INTEGER PRIMARY KEY,
  name         TEXT,
  alias        TEXT,
  iata         TEXT,
  icao         TEXT,
  callsign     TEXT,
  country      TEXT,
  active       TEXT
);

DROP TABLE IF EXISTS raw.routes CASCADE;
CREATE TABLE raw.routes (
  airline            TEXT,
  airline_id         INTEGER,
  source_airport     TEXT,
  source_airport_id  INTEGER,
  dest_airport       TEXT,
  dest_airport_id    INTEGER,
  codeshare          TEXT,
  stops              INTEGER,
  equipment          TEXT
);


CREATE INDEX IF NOT EXISTS idx_routes_src_id ON raw.routes(source_airport_id);
CREATE INDEX IF NOT EXISTS idx_routes_dst_id ON raw.routes(dest_airport_id);
CREATE INDEX IF NOT EXISTS idx_routes_airline_id ON raw.routes(airline_id);

COMMIT;
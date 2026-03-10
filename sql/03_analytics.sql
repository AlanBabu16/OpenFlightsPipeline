-- Top airports by number of outgoing routes
SELECT
  source_airport_id,
  source_airport AS source_iata,
  source_airport_name,
  source_city,
  source_country,
  COUNT(*) AS outgoing_routes
FROM analytics.v_routes_enriched
WHERE source_airport_id IS NOT NULL
GROUP BY 1,2,3,4,5
ORDER BY outgoing_routes DESC
LIMIT 25;

-- Top airports by total connectivity (outgoing + incoming)
WITH out_counts AS (
  SELECT source_airport_id AS airport_id, COUNT(*) AS out_routes
  FROM raw.routes
  WHERE source_airport_id IS NOT NULL
  GROUP BY 1
),
in_counts AS (
  SELECT dest_airport_id AS airport_id, COUNT(*) AS in_routes
  FROM raw.routes
  WHERE dest_airport_id IS NOT NULL
  GROUP BY 1
)
SELECT
  a.airport_id,
  a.iata,
  a.name,
  a.city,
  a.country,
  COALESCE(o.out_routes,0) AS out_routes,
  COALESCE(i.in_routes,0) AS in_routes,
  (COALESCE(o.out_routes,0) + COALESCE(i.in_routes,0)) AS total_routes
FROM raw.airports a
LEFT JOIN out_counts o ON o.airport_id = a.airport_id
LEFT JOIN in_counts i ON i.airport_id = a.airport_id
ORDER BY total_routes DESC
LIMIT 25;

-- “Busiest” countries by number of routes touching any airport in that country
WITH airports_by_country AS (
  SELECT airport_id, country
  FROM raw.airports
  WHERE airport_id IS NOT NULL AND country IS NOT NULL
)
SELECT
  c.country,
  COUNT(*) AS routes_touching_country
FROM raw.routes r
JOIN airports_by_country c
  ON c.airport_id IN (r.source_airport_id, r.dest_airport_id)
GROUP BY 1
ORDER BY routes_touching_country DESC
LIMIT 25;

-- Most common direct routes (pair frequency)
SELECT
  source_airport AS src_iata,
  dest_airport AS dst_iata,
  COUNT(*) AS route_rows
FROM raw.routes
WHERE source_airport IS NOT NULL AND dest_airport IS NOT NULL
GROUP BY 1,2
ORDER BY route_rows DESC
LIMIT 25;

-- Airlines with the most routes
SELECT
  COALESCE(al.name, r.airline) AS airline,
  COUNT(*) AS routes_count
FROM raw.routes r
LEFT JOIN raw.airlines al ON al.airline_id = r.airline_id
GROUP BY 1
ORDER BY routes_count DESC
LIMIT 25;

-- Routes with the most different airlines operating them
SELECT
  r.source_airport AS src_iata,
  r.dest_airport AS dst_iata,
  COUNT(DISTINCT COALESCE(r.airline_id::TEXT, r.airline)) AS airlines_on_route
FROM raw.routes r
WHERE r.source_airport IS NOT NULL AND r.dest_airport IS NOT NULL
GROUP BY 1,2
ORDER BY airlines_on_route DESC
LIMIT 25;
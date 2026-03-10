import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv

load_dotenv()

def conn_str():
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "5433")
    dbname = os.getenv("DB_NAME", "openflights")
    user = os.getenv("DB_USER", "postgres")
    password = os.getenv("DB_PASSWORD", "postgres")
    return f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

COPY_MAP = [
    ("raw.airports", "data/clean/airports.csv"),
    ("raw.airlines", "data/clean/airlines.csv"),
    ("raw.routes",   "data/clean/routes.csv"),
]

def copy_csv(cur, table: str, csv_path: str):
    p = Path(csv_path)
    if not p.exists():
        raise FileNotFoundError(f"Missing {p}. Run download_data.py and clean_csv.py first.")

    with p.open("r", encoding="utf-8") as f:
        with cur.copy(f"COPY {table} FROM STDIN WITH (FORMAT CSV, HEADER TRUE, NULL '')") as copy:
            for line in f:
                copy.write(line)

def main():
    try:
        with psycopg.connect(conn_str()) as conn:
            with conn.cursor() as cur:
                # truncate to allow re-loads
                cur.execute("TRUNCATE raw.routes, raw.airports, raw.airlines;")

                for table, path in COPY_MAP:
                    print(f"COPY {path} -> {table}")
                    copy_csv(cur, table, path)

            conn.commit()
        print("Load complete.")
    except psycopg.OperationalError as e:
        print(f"Database connection failed: {e}")
        print("Ensure PostgreSQL is running, the database exists, and credentials in .env are correct.")

if __name__ == "__main__":
    main()
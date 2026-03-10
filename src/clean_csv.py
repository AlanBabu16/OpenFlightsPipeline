import csv
from pathlib import Path

NULL_TOKEN = r"\N"

SPECS = {
    "airports": {
        "infile": "data/raw/airports.dat",
        "outfile": "data/clean/airports.csv",
        "headers": [
            "airport_id","name","city","country","iata","icao","latitude","longitude",
            "altitude_ft","timezone_hours","dst","tz_database","type","source"
        ],
    },
    "airlines": {
        "infile": "data/raw/airlines.dat",
        "outfile": "data/clean/airlines.csv",
        "headers": ["airline_id","name","alias","iata","icao","callsign","country","active"],
    },
    "routes": {
        "infile": "data/raw/routes.dat",
        "outfile": "data/clean/routes.csv",
        "headers": [
            "airline","airline_id","source_airport","source_airport_id","dest_airport",
            "dest_airport_id","codeshare","stops","equipment"
        ],
    }
}

def norm(value: str):
    if value is None:
        return None
    v = value.strip()
    if v == "" or v == NULL_TOKEN:
        return None
    return v

def convert(name: str):
    spec = SPECS[name]
    in_path = Path(spec["infile"])
    out_path = Path(spec["outfile"])
    out_path.parent.mkdir(parents=True, exist_ok=True)

    with in_path.open("r", encoding="utf-8", newline="") as fin, out_path.open("w", encoding="utf-8", newline="") as fout:
        reader = csv.reader(fin)  # handles quotes properly
        writer = csv.writer(fout)
        writer.writerow(spec["headers"])

        for row in reader:
            row = [norm(x) for x in row]
            writer.writerow(row)

    print(f"Wrote {out_path}")

def main():
    for name in ["airports", "airlines", "routes"]:
        convert(name)

if __name__ == "__main__":
    main()
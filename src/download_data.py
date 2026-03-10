import os
import requests
from pathlib import Path

#  OpenFlights data files
BASE = "https://raw.githubusercontent.com/jpatokal/openflights/master/data"
FILES = ["airports.dat", "airlines.dat", "routes.dat"]

def download(url: str, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    r = requests.get(url, timeout=60)
    r.raise_for_status()
    out_path.write_bytes(r.content)

def main():
    data_dir = Path("data/raw")
    for f in FILES:
        url = f"{BASE}/{f}"
        out_path = data_dir / f
        print(f"Downloading {url} -> {out_path}")
        download(url, out_path)
    print("Done.")

if __name__ == "__main__":
    main()
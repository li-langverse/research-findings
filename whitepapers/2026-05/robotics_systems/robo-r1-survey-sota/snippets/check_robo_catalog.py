from __future__ import annotations

import argparse
import json
from pathlib import Path

import tomllib


def main() -> int:
    ap = argparse.ArgumentParser(description="Extract robo_* benchmarks from catalog.toml")
    ap.add_argument("--catalog", required=True, help="Path to benchmarks/catalog.toml")
    ap.add_argument("--json-out", default=None, help="Write extracted rows to JSON")
    args = ap.parse_args()

    catalog_path = Path(args.catalog)
    data = tomllib.loads(catalog_path.read_text(encoding="utf-8"))
    benches = data.get("benchmark", [])
    robo = [b for b in benches if str(b.get("id", "")).startswith("robo_")]
    robo_sorted = sorted(robo, key=lambda b: str(b.get("id", "")))

    out = {
        "catalog": str(catalog_path),
        "robo_count": len(robo_sorted),
        "robo_ids": [b.get("id") for b in robo_sorted],
        "rows": robo_sorted,
    }

    if args.json_out:
        Path(args.json_out).write_text(json.dumps(out, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(out, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())


#!/usr/bin/env bash
# DB-R0-1 — reproducible static diff (study-only). No lidb engine required.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WP_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
FINDINGS_ROOT="$(cd "${WP_DIR}/../../../.." && pwd)"
LANGVERSE_ROOT="${LI_LANGVERSE_ROOT:-$(cd "${FINDINGS_ROOT}/.." && pwd)}"

BENCH_SQL="${LANGVERSE_ROOT}/benchmarks/benchmarks/tier_db_registry/schema/registry-v1.sql"
LIDB_SQL="${LANGVERSE_ROOT}/lidb/migrations/001_registry.sql"
LIP_OPENAPI="${LANGVERSE_ROOT}/lip/registry/api/openapi-stub.yaml"
LIP_INDEX="${LANGVERSE_ROOT}/lip/registry/index.json"
PG_SUBSET="${LANGVERSE_ROOT}/lidb/docs/pg-subset-v1.md"

echo "=== DB-R0-1 reproduce ==="
echo "langverse_root=${LANGVERSE_ROOT}"
echo

for f in "$BENCH_SQL" "$LIDB_SQL" "$LIP_OPENAPI" "$LIP_INDEX" "$PG_SUBSET"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
  echo "OK $(realpath --relative-to="${LANGVERSE_ROOT}" "$f")"
done
echo

echo "--- diff: bench registry-v1.sql vs lidb 001_registry.sql ---"
diff -u "$BENCH_SQL" "$LIDB_SQL" || true
echo

echo "--- lip OpenAPI stub (paths) ---"
grep -nE '^\s+/' "$LIP_OPENAPI" || true
echo

echo "--- lip index.json package keys ---"
python3 - <<'PY' "$LIP_INDEX"
import json, sys
data = json.load(open(sys.argv[1]))
for pkg in data.get("packages", []):
    print("keys:", sorted(pkg.keys()))
PY
echo

echo "--- CREATE TABLE inventory ---"
echo "# bench:"
grep -n '^CREATE TABLE' "$BENCH_SQL" || true
echo "# lidb:"
grep -n '^CREATE TABLE' "$LIDB_SQL" || true
echo

echo "--- pg-subset v1 NOT list (first 15 lines) ---"
grep -n '^- ' "$PG_SUBSET" | head -15 || true
echo
echo "Done. See README.md for interpretation."

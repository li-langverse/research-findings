---
goal_id: database_platform
agent: goal_researcher
run_id: db-r0-1-postgres-subset-boundary-2026-05-26
generated_at: "2026-05-26T20:00:00Z"
domains: [database, ecosystem]
validity_grade: study-only
experiment_id: DB-R0-1
title: "DB-R0-1 — Postgres-subset boundary (registry DDL vs lip)"
status: complete
parent_seed: db-r0-vertical-seed
links:
  - benchmarks/benchmarks/tier_db_registry/schema/registry-v1.sql
  - lidb/migrations/001_registry.sql
  - lip/registry/api/openapi-stub.yaml
  - lidb/docs/pg-subset-v1.md
---

# DB-R0-1 — Postgres-subset boundary (registry)

> **Grade:** study-only · **Does not claim** a shipped **lidb** engine or green **tier_db_registry** rows.

## Question

What must **lidb** v1 implement for registry OLTP and **lip** publish/read, given three sources that currently disagree?

| Source | Role |
|--------|------|
| `benchmarks/.../registry-v1.sql` | Bench DDL (Postgres 15+ oracle for **PH-DB-5**) |
| `lidb/migrations/001_registry.sql` | Proposed native catalog (PH-DB-1 / PH-DB-4) |
| `lip` v1 stub API + `registry/index.json` | Client-visible publish fields |

## Method

Static diff and field inventory (2026-05-26). Reproduce: `scripts/reproduce.sh` from this directory.

## Executive findings

1. **Three-way schema drift** — bench v1, lidb `001`, and lip JSON are not byte-aligned; **PH-DB-4** and **WP-C** must pick a single canonical DDL before parity timing.
2. **ID strategy split** — bench uses `BIGSERIAL`; lidb uses `UUID` + `gen_random_uuid()`. Parity harness must map types, not assume identical physical layout.
3. **lip v1 surface is narrower than either DDL** — OpenAPI stub documents only `tree_digest`, `proof_digest`, `coverage_pct` on GET; many lidb columns are forward-looking (publisher crypto, yank provenance).
4. **Postgres types in play** — registry paths need at least: `TEXT`, `TIMESTAMPTZ`, `REAL`/`DOUBLE PRECISION`, `JSONB` (bench attestations), `BYTEA` (lidb publishers/signatures). See **lidb** `pg-subset-v1.md` for explicit NOT list (replication, extensions, etc.).

## lip / client required fields (v1 evidence)

From `lip/registry/index.json` and publish scripts (not exhaustive OpenAPI):

| Field | Required for v1 client | In bench `registry-v1` | In lidb `001_registry` |
|-------|------------------------|-------------------------|-------------------------|
| `name` (package) | yes | `packages.name` | `packages.name` |
| `version` | yes | `package_versions.version` | `package_versions.version` |
| `tree_digest` | yes | `package_versions.tree_digest` | `package_versions.tree_digest` NOT NULL |
| `proof_digest` | yes (gate) | nullable | nullable |
| `coverage_pct` | yes (gate) | `REAL` | `DOUBLE PRECISION` + CHECK 0–100 |

## Structural gaps (bench v1 ↔ lidb `001`)

| Area | Bench v1 | lidb `001` | Recommendation |
|------|----------|------------|----------------|
| Primary keys | `BIGSERIAL` | `UUID` | **Defer** wire-format choice to PH-DB-4 ADR; bench may stay BIGINT for Postgres oracle until lidb ratio measured |
| `packages.publisher_id` | FK on package | absent; `publisher_id` on version | **Required** for lidb auth story; update bench DDL or document adapter view |
| Yank model | `yanks` table only | `yanked` bool + `yanks` row + `yanked_by` | **Required** for lip yank UX; bench DDL lags |
| `blocklist` | `pattern` UNIQUE | `package_name` OR `tree_digest` CHECK | **Required** for digest-level blocks; align bench before WP-C |
| `attestations` | `kind` + `JSONB payload` | `kind` + `digest` + `BYTEA signature` | **Defer** JSONB vs structured cols in v1 engine; lip can emit digest rows first |
| `publishers` | name only | `public_key BYTEA`, `revoked_at` | **Defer** crypto columns for R0; **required** before PH-8d attestation |
| Indexes | `published_at DESC` | `(package_id, version)` | Bench hot path `registry_read_latest` needs `published_at` index on lidb |

## Postgres-subset: required vs defer (ADR input)

| Capability | v1 registry consumer need | lidb pg-subset v1 doc | Verdict |
|------------|---------------------------|------------------------|---------|
| `TIMESTAMPTZ` | yes | in scope | **Required** |
| `TEXT` / `NOT NULL` / `UNIQUE` | yes | in scope | **Required** |
| `JSONB` (attestations) | bench only | subset operators | **Defer** full JSONB until attestations shape frozen |
| `BYTEA` | lidb publishers | in scope | **Required** for lidb DDL; optional for bench-only runs |
| `UUID` + `gen_random_uuid()` | lidb DDL | in scope | **Required** if `001_registry` is canonical |
| `BIGSERIAL` | bench DDL | not listed as v1 PK style | **Defer** or emulate via INTEGER PK in embed |
| `REFERENCES` / `ON DELETE CASCADE` | yes | implied | **Required** |
| `CHECK` constraints | coverage bounds | in scope (simple scalar) | **Required** |
| RLS / multi-tenant | PH-DB-7 | NOT list (use Li capability model) | **Defer** |
| Replication | PH-DB-9 | NOT list | **Defer** |

## Honesty gates

- **lidb** native embed may not apply all of `001_registry.sql` yet — this note inventories targets, not runtime behavior.
- **tier_db_registry** dashboard must remain **unknown** / **stub** until WP-C measures lidb P95.

## Unblocks

- **PH-DB-0** ADR: canonical registry DDL + type subset
- **PH-DB-4** / **WP-D**: lip OpenAPI field parity table (extend stub beyond three GET fields)
- **WP-C**: sync `registry-v1.sql` with chosen canonical migration before harness

## References

- Reproduce: [scripts/reproduce.sh](./scripts/reproduce.sh)
- Seed: [../db-r0-vertical-seed/README.md](../db-r0-vertical-seed/README.md)

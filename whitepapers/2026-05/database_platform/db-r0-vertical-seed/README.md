---
goal_id: database_platform
agent: goal_researcher
run_id: seed-db-r0-vertical-seed-2026-05-26
generated_at: "2026-05-26T18:00:00Z"
domains: [database, ecosystem]
validity_grade: study-only
title: "Database platform — vertical seed (R0 scope & PH-DB map)"
status: active
links:
  - lic/docs/superpowers/plans/ph-db-lidb-platform.md
  - li-cursor-agents/docs/plans/lidb-migration-control-plane.md
  - benchmarks/docs/ecosystem/tier-db-registry-benchmark.md
  - benchmarks/docs/ecosystem/plan-cross-links.md
---

# Database platform — vertical seed (R0)

> **Goal:** `database_platform` · **Agent:** `goal_researcher` · **Grade:** study-only  
> **Plan track:** PH-DB-0 … PH-DB-10 ([ph-db-lidb-platform.md](https://github.com/li-langverse/lic/blob/main/docs/superpowers/plans/ph-db-lidb-platform.md))

## Executive summary

Li’s data platform is **roadmap-tracked, not shipped**: the **`lidb`** engine repo is proposed; runtime persistence today uses Supabase/Postgres (control plane) and disk cache (CI). This seed defines the **research vertical scope** — embedded OLTP, registry OLTP, and agent control-plane persistence — maps **PH-DB phases to open research questions**, surveys **SQLite / DuckDB / Postgres-embedded** patterns at a high level, and proposes **R0 experiments** that produce evidence without claiming a finished engine.

**Honesty gate:** Benchmark tiers under `benchmarks/tier_db_*` are **CI stubs / manifests** until a **`lidb`** harness exists. Dashboard rows must stay **unknown**, not green.

---

## Li stack terminology (canonical)

| Term | Role | Phase / repo |
|------|------|--------------|
| **`lidb`** | Embedded OLTP engine (Postgres-subset DDL, WAL, catalog) | **PH-DB-1** → `li-langverse/lidb` (*proposed*) |
| **`liorm`** | Typed query/execute layer over lidb catalog (migrations, plans) | **PH-DB-2** |
| **`liq`** | Agent-safe read language → parameterized plans (no raw mutating SQL) | **PH-DB-2**; MCP in **PH-DB-10** |
| **`lis db`** | Supervisor bundle: `start \| migrate \| status`, `LI_DATA_DIR`, registry-min profile | **PH-DB-3** |

Cross-links: control-plane migration target (**PH-DB-10**) is documented in `li-cursor-agents/docs/plans/lidb-migration-control-plane.md` (stub MCP + mock `liq-query.ts` only — not production persist).

---

## Vertical scope (three workloads)

### 1. Embedded OLTP (local-first apps)

**Question:** Can Li ship a **single-process, file-backed** store with ACID writes, bounded memory, and a **Postgres-shaped** subset sufficient for tooling — without requiring Docker?

**Success signals (research, not product claims):**

- WAL + page cache design note vs SQLite pager model
- Migration story from ad-hoc JSON/disk stores → lidb files
- Security posture: parameterized paths only (**liq** / **liorm**), injection probes (**PH-DB-SEC**)

**Out of scope for R0:** distributed replication, full Postgres compatibility, GPU OLTP.

### 2. Registry OLTP (package index hot paths)

**Question:** Does **lidb** via **`lis db`** registry-min meet **P95 parity** with Postgres 15+ on identical DDL for publish/read/latest?

**Anchors:**

- DDL: `benchmarks/tier_db_registry/schema/registry-v1.sql` (sync with **lip** / **lidb** migrations)
- Scenarios: `registry_publish`, `registry_read_by_name`, `registry_read_latest` ([tier-db-registry-benchmark.md](https://github.com/li-langverse/benchmarks/blob/main/docs/ecosystem/tier-db-registry-benchmark.md))
- **PH-DB-4** blocks **PH-8d-v2** (remote registry v2 central DB) — research must not assume 8d v2 shipped

**Out of scope for R0:** full lip API surface; attestation crypto (cite lip plan only).

### 3. Agent control plane (swarm persistence)

**Question:** Can agents explore run/handoff state via **liq MCP** (allowlisted tables, compiled plans) replacing raw SQL + Supabase REST?

**Today → target (research framing):**

| Today | PH-DB-10 target |
|-------|-----------------|
| `LI_CONTROL_PLANE_STORE=supabase` | `LI_CONTROL_PLANE_STORE=lidb` + **`lis db start`** |
| `@supabase/supabase-js` in `persist.ts` | **liorm** execute paths |
| `li-control-plane-db` MCP + raw SQL | **`li-control-plane-liq`** MCP + **liq** |

**Out of scope for R0:** flipping default store; backfill from disk cache (checklist item, not done).

---

## Competitors & alternatives (high-level survey)

| Engine / pattern | Strengths | Li-relevant gaps | Research use |
|------------------|-----------|------------------|--------------|
| **SQLite** | Mature embedded OLTP, single-file, excellent read concurrency (WAL) | No server RLS story; Li wants Postgres-subset + agent **liq** compiler | Baseline for pager/WAL and “zero-ops local DB” UX |
| **DuckDB** | Analytical columnar, embedded, strong SQL | OLTP/registry latency profile differs; not target for hot publish path | Compare only for **adjacent** agent analytics (exports), not registry SLO |
| **Postgres (server)** | Registry v1 truth today; RLS, extensions, lip compatibility | Docker/ops burden for dev agents | **Parity reference** for tier_db_registry P95 ratio (`BENCH_DB_REGISTRY_THRESHOLD` default 1.2) |
| **Postgres embedded patterns** (e.g. PGlite, WASM Postgres) | Familiar SQL in-process | Binary size, startup, Li supervisor integration | Document trade table: why **lidb** vs “ship Postgres in **`lis`**” |
| **libSQL / Turso** | SQLite fork + sync story | Diverges from Postgres-subset goal for **lip** DDL | Cite sync/replication ideas only for future PH-DB-9+ |
| **Supabase stack (current)** | Fast agent iteration, REST, Realtime | External dependency, raw SQL MCP risk | Migration source for **PH-DB-10**, not long-term architecture |

**Survey deliverable (R1+):** one-page decision matrix: embedded OLTP choice, registry reference engine, control-plane read path — each row cites threat notes (injection, tenant isolation).

---

## PH-DB phases → research questions

| Phase | ID | Depends | Primary research question | Evidence / bench hook |
|-------|-----|---------|---------------------------|------------------------|
| 0 | **PH-DB-0** | — | ADR scope: Postgres-subset boundary, repo policy, honesty rules | Roadmap ADR; this vertical seed |
| 1 | **PH-DB-1** | PH-DB-0 | Minimal engine + `001_registry.sql` — what is v1 DDL/WAL? | Human creates **`lidb`** repo; no engine claims until merge |
| 2 | **PH-DB-2** | PH-DB-1 | **liorm** + **liq** grammar — how do agents read safely? | `lidb/tests/security/`; tier_db_security stub |
| 3 | **PH-DB-3** | PH-DB-1 | **`lis db`** UX — one command for registry-min profile? | `lis db status` health gate for e2e |
| 4 | **PH-DB-4** | PH-DB-1–3, lip OpenAPI | Registry v2 central DB schema + API alignment | Blocks **PH-8d-v2**; tier_db_registry DDL sync |
| 5 | **PH-DB-5** | PH-DB-4 | Registry OLTP P95 parity vs Postgres | [tier_db_registry](https://github.com/li-langverse/benchmarks/blob/main/docs/ecosystem/tier-db-registry-benchmark.md) |
| 6 | **PH-DB-6** | PH-DB-4 | Realtime slice needs for registry/control plane? | tier_db_realtime stub |
| 7 | **PH-DB-7** | PH-DB-4 | Auth/tenant model vs RLS probes | tier_db_security RLS scenarios |
| 8 | **PH-DB-8** | PH-DB-1 | Vector ANN for agent/registry search — in-engine or extension? | tier_db_vector_ann; **PH-DB-G0** ADR |
| 9 | **PH-DB-9** | PH-DB-4 | Replication/sync (if any) for registry | Research only; no ship claim |
| 10 | **PH-DB-10** | PH-DB-4 | Control-plane store swap: Supabase → **lidb** + **liq** MCP | `lidb-control-plane.e2e.ts` (skipped until gates) |
| G0 | **PH-DB-G0** | — | Multi-model (graph / vector / GPU) — build vs defer? | tier_db_graph_registry, tier_db_gpu_speedup stubs |

**WP-N4 audit tiers** (memory, parallel, audit log) map to cross-cutting research for **PH-DB-SEC/MEM/PAR/AUD** — run manifests only until harness lands.

---

## Suggested R0 experiments

Each experiment outputs a **study-only** note under `database_platform/` (or handoff ticket); none assert a working **lidb** engine.

| ID | Experiment | Method | Output | Unblocks |
|----|------------|--------|--------|----------|
| **DB-R0-1** | **Postgres-subset boundary** | Diff `registry-v1.sql` vs lip OpenAPI fields; list unsupported types | Markdown table: required vs defer | PH-DB-0 ADR input |
| **DB-R0-2** | **Embedded OLTP pattern survey** | 2-page compare SQLite pager/WAL vs proposed lidb WAL (literature + SQLite docs) | Survey section in R1 whitepaper | PH-DB-1 design |
| **DB-R0-3** | **Registry reference baseline** | Run tier_db_registry **ci** profile; document Postgres-only manifest path | `tier-db-registry.json` + interpretation (no lidb timing) | PH-DB-5 prep |
| **DB-R0-4** | **Control-plane schema parity** | Diff `supabase/migrations/` vs proposed lidb migrations list in migration plan | Gap table + threat notes for **liq** allowlist | PH-DB-10 |
| **DB-R0-5** | **Agent read-path threat model** | Enumerate `CONTROL_PLANE_TABLES`; map each to **liq** `read … limit` vs raw SQL | Security appendix for PH-DB-2 | tier_db_security scenarios |
| **DB-R0-6** | **Postgres-embedded alt scan** | High-level table: PGlite/WASM Postgres vs **lidb** on size, startup, RLS | Decision memo (no implementation) | PH-DB-0 |

**Recommended R0 sequencing:** DB-R0-1 → DB-R0-4 → DB-R0-5 (registry + control plane are Li’s near-term consumers); DB-R0-2 and DB-R0-6 in parallel for ADR support.

### Completed R0 experiments (WP-F)

| ID | Artifact | Status |
|----|----------|--------|
| **DB-R0-1** | [db-r0-1-postgres-subset-boundary](../db-r0-1-postgres-subset-boundary/README.md) | complete (study-only) |
| **DB-R0-4** | [db-r0-4-control-plane-schema-parity](../db-r0-4-control-plane-schema-parity/README.md) | complete (study-only) |

---

## Handoff criteria

| Consumer | When to hand off | Artifact |
|----------|------------------|----------|
| `package_architect` | New official PKG boundary (**PKG-lidb**) or **`lis db`** profile contract | ADR draft + schema ownership |
| `issue_planner` | R0 experiment spawns tracked work (repo creation, bench harness) | Issues with PH-DB id + acceptance criteria |
| `code_implementer` | **Not first** for this vertical — engine lives in **`lidb`** repo after human creates it | Only after PH-DB-1 gate |

---

## References

- Master plan cross-link: [ph-db-lidb-platform.md](https://github.com/li-langverse/lic/blob/main/docs/superpowers/plans/ph-db-lidb-platform.md)
- Control plane migration stub: [lidb-migration-control-plane.md](https://github.com/li-langverse/li-cursor-agents/blob/main/docs/plans/lidb-migration-control-plane.md)
- Benchmark index: [plan-cross-links.md](https://github.com/li-langverse/benchmarks/blob/main/docs/ecosystem/plan-cross-links.md)
- Research scaffold: `li-cursor-agents/config/goal-scaffolds/database_platform.md`
- Vertical matrix: `li-cursor-agents/docs/ecosystem/research-verticals.md`

---
goal_id: database_platform
agent: goal_researcher
run_id: db-r0-4-control-plane-schema-parity-2026-05-26
generated_at: "2026-05-26T20:00:00Z"
domains: [database, ecosystem]
validity_grade: study-only
experiment_id: DB-R0-4
title: "DB-R0-4 — Control-plane schema parity (Supabase vs lidb plan)"
status: complete
parent_seed: db-r0-vertical-seed
links:
  - li-cursor-agents/supabase/migrations/
  - li-cursor-agents/docs/plans/lidb-migration-control-plane.md
  - li-cursor-agents/src/db/schema-catalog.ts
  - lidb/migrations/archive/002_control_plane_embedded.sql
---

# DB-R0-4 — Control-plane schema parity

> **Grade:** study-only · **Does not claim** `LI_CONTROL_PLANE_STORE=lidb` persist or green **PH-DB-10** e2e.

## Question

What is the gap between **Supabase migrations** (production-shaped control plane today) and **lidb** artifacts named in the migration plan — and what does that imply for **liq** allowlisting?

## Method

Inventory `li-cursor-agents/supabase/migrations/*.sql` tables vs `CONTROL_PLANE_TABLES` vs `lidb/migrations/archive/002_control_plane_embedded.sql` (SQLite smoke only). Reproduce: `scripts/reproduce.sh`.

## Executive findings

1. **No lidb migration ships full control-plane DDL** — only archived SQLite smoke (`002_control_plane_embedded.sql`) touching `agent_runs`; **PH-DB-10** checklist still marks schema parity TODO.
2. **Eight tables in `CONTROL_PLANE_TABLES`** — matches core `20260517120000_control_plane.sql` set used by persist/MCP docs; **not** the full Supabase schema.
3. **Eleven+ additional public tables** exist in later migrations (research lane, workers, native dashboard) — **outside** liq allowlist today; agents using raw SQL MCP could read them if enabled.
4. **Persist path** — `persistControlPlaneStateLidb` remains stub; parity work is schema + liorm plans before flipping store default.

## Supabase `public` tables (migration inventory)

| Table | Introduced in | In `CONTROL_PLANE_TABLES` | PH-DB-10 / liq notes |
|-------|---------------|---------------------------|----------------------|
| `agent_runs` | `20260517120000` | yes | Core; `read agent_runs limit N` target |
| `agent_run_events` | `20260517120000` | yes | Timeline; high row count — limit required |
| `control_plane_state` | `20260517120000` | yes | Singleton `id=1` |
| `control_plane_reports` | `20260517120000` | yes | `is_latest` partial unique index |
| `interventions_snapshots` | `20260517120000` | yes | JSONB `items` |
| `briefing_snapshots` | `20260517120000` | yes | + `is_latest` (`20260518180000`) |
| `heap_plan_snapshots` | `20260517120000` | yes | JSONB `payload` |
| `repo_workflow_rollouts` | `20260517120000` | yes | FK `run_id` → `agent_runs` |
| `queued_agent_tasks` | `20260517120000` | yes | Unique `(briefing_hash, fingerprint)` |
| `interventions_latest` | `20260517150000` | **no** | Dashboard fast path; add to allowlist or deny |
| `research_sessions` | `20260517151000` | **no** | Research lane; + `hypotheses` jsonb (`152000`) |
| `research_session_steps` | `20260517151000` | **no** | Child of sessions |
| `agent_handoffs` | `20260517151000` | **no** | Swarm handoffs |
| `lane_state` | `20260518180000` | **no** | Singleton JSONB |
| `runtime_settings` | `20260518180000` | **no** | Singleton JSONB |
| `supervisor_activity` | `20260518180000` | **no** | Append-only log |
| `worker_status` | `20260519100000` | **no** | Worker heartbeat |
| `work_queue_snapshots` | `20260519100000` | **no** | Queue mirror |

Column-level deltas (examples): `agent_runs` gained `input_trace` / dashboard indexes in `140000`, `170000`, `180000` — lidb migration must include these before persist backfill.

## lidb-side artifacts today

| Artifact | Contents | Parity with Supabase? |
|----------|----------|------------------------|
| `lidb/migrations/archive/002_control_plane_embedded.sql` | SQLite `agent_runs` stub + registry ALTER | **No** — smoke only, not target DDL |
| `lidb/migrations/001_registry.sql` | Registry only | N/A for control plane |
| Migration plan (`lidb-migration-control-plane.md`) | Checklist, store matrix | Documents intent; persist still stub |

## Gap summary (blocking PH-DB-10)

| Gap ID | Description | Severity |
|--------|-------------|----------|
| G1 | Missing native SQL migration listing all 8 allowlist tables + indexes | **blocking** |
| G2 | 10 tables in Supabase not in allowlist / no liq plans | **policy** — explicit deny vs extend allowlist |
| G3 | RLS enabled on Supabase (`FOR ALL USING (true)`) — lidb uses capability model (PH-DB-7) | **defer** |
| G4 | `persist.ts` lidb path no-op | **blocking** for persist e2e |
| G5 | Extensions: `pgcrypto` on Supabase | Map to lidb builtins / defer UUID default |

## liq / MCP threat notes (allowlist-focused)

| Threat | Mitigation today | Gap |
|--------|------------------|-----|
| Raw mutating SQL via agent | `read-query.ts` deprecated; liq compile path | lidb store still mock |
| Read exfiltration of non-allowlist tables | liq MCP only exposes `CONTROL_PLANE_TABLES` | Raw `li-control-plane-db` MCP still exists for `supabase` store |
| Unbounded `read … limit` | `liq-query.ts` parses limit | Enforce max limit in PH-DB-2 security harness |
| JSONB injection in filters | Parameterized plans (target) | Fuzz `payload` / `items` columns when engine wired |
| Cross-run PII in `agent_runs.output_md` | Operational policy | Document redaction; not schema |

**Recommendation:** For PH-DB-10 MVP, migrate **G1** for the eight allowlist tables only; classify research/worker tables as **deny-by-default** until product assigns lane owners (handoff to `issue_planner`).

## Honesty gates

- Default store remains **`supabase`**; do not mark PH-DB-10 green on mock persist.
- `LI_E2E_LIDB=1` todos in `lidb-control-plane.e2e.ts` stay skipped until G1+G4 close.

## Unblocks

- **PH-DB-10** / **WP-E**: migration list + `persist.ts` wiring order
- **PH-DB-2**: security scenarios for allowlist + max limit
- **WP-D**: only if registry tables overlap (they do not in v1)

## References

- Reproduce: [scripts/reproduce.sh](./scripts/reproduce.sh)
- Gap snippet: [snippets/supabase-tables-inventory.txt](./snippets/supabase-tables-inventory.txt)

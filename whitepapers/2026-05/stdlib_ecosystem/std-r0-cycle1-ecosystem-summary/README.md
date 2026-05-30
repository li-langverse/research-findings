---
goal_id: stdlib_ecosystem
agent: stdlib_researcher
session_id: cee09172-b61f-4f7b-84de-aae2d0e5972f
generated_at: 2026-05-28T21:30:00Z
domains: [ecosystem, scientific_computing, hpc]
validity_grade: B
title: "Stdlib ecosystem — cycle 1 summary (inventory + linalg gap)"
status: active
links:
  - lic/docs/ecosystem/stdlib-research/cycle-1-summary.md
  - lic/docs/ecosystem/stdlib-research/cycle-1-inventory-std-tree.md
  - lic/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md
  - lic/docs/ecosystem/research-sessions/stdlib_ecosystem-cycle.md
ph_ids: [PH-2i, PH-7e, PH-IO-5, PH-IO-7, AL-10, AL-11]
---

# Stdlib ecosystem — cycle 1 summary

> **Goal:** `stdlib_ecosystem` · **Session:** `cee09172-b61f-4f7b-84de-aae2d0e5972f` · **Step:** `synthesize_step` · **Grade:** B (file-backed audit, two prior steps rolled up)

## Executive summary

- **25** modules under `lic/std/**`; real implementations are **`runtime/seam`** and **`bytes`**; collections/heap/algorithms are **WP0-B compile-only stubs**.
- **Linear algebra** is in the **compiler prelude**, not `std/math` (tags only). Versus BLAS/LAPACK/NumPy: missing **tensors, sparse, decompositions**, and full broadcast.
- **`packages/linalg`** does not exist — **AL-10** is the top build priority.
- **Tier-1 perf** partially green; **`matmul_blocked`**, **`horner_pure_li`** fail strict ≤1.2×; **`simd_dot`** Li driver still uses an extern kernel.
- **`li-std-math`** mirrors `li-math` with weaker contracts; **`li-std-core`** is a stub.
- **PH-IO gaps:** `std.summary`, `std.plot` not on disk; explorer/stdlib.md drift on WP0-B modules.
- Implement via **`package_architect`** (placement) then **`code_implementer`** — no runtime work in this research cycle.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Li can match scientific-computing std expectations by keeping language LA in the prelude, adding `packages/linalg` for LAPACK-class work, and growing `std/*` as thin facades — without duplicating GEMM in tag-only `std/math`. |
| Status | proposed |

## Analysis

### Inventory (std tree)

| Tier | Examples | Notes |
|------|----------|-------|
| Trusted seam | `std/runtime/seam.li` | httpd/net/async extern surface |
| Implemented | `std/bytes/bytes.li` | Reader/Writer over buffer externs |
| WP0-B stub | `collections`, `heap`, `algorithms` | Blocked on Wave A |
| Tag / policy | `math`, `physics/*`, `scene` | Import stability, not ops |

Full table: [cycle-1-inventory-std-tree.md](https://github.com/li-langverse/lic/blob/main/docs/ecosystem/stdlib-research/cycle-1-inventory-std-tree.md).

### Linalg gap vs SOTA

| Capability | Li | Gap |
|------------|-----|-----|
| dot/sum/norm/axpy, 2d `@` | Prelude + tests | Low |
| Rank-N tensor, broadcast | — | High |
| LU/QR/eigen | — | High → `packages/linalg` |
| Strict tier-1 ≤1.2× | Partial | High → 7e / G-math |

Full matrix: [cycle-1-gap-vs-sota-linalg.md](https://github.com/li-langverse/lic/blob/main/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md).

## Recommendations

1. **`package_architect`:** confirm `packages/linalg` vs optional `std.linalg` facade.  
2. **`code_implementer`:** AL-10 scaffold; pure-Li `simd_dot`; `li-std-math` contract sync.  
3. **`bench_improver`:** strict tier-1 for `matmul_blocked`, `horner_pure_li`.  
4. **`docs_maintainer`:** `stdlib.md` + explorer rescan for WP0-B modules.

## Evidence

| Type | Path |
|------|------|
| Cycle summary | `lic/docs/ecosystem/stdlib-research/cycle-1-summary.md` |
| Inventory | `lic/docs/ecosystem/stdlib-research/cycle-1-inventory-std-tree.md` |
| Linalg gap | `lic/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md` |
| Std tags | `lic/std/math/math.li` |
| Seam | `lic/std/runtime/seam.li` |
| WP0-B | `lic/std/collections/collections.li` |
| Package math | `lic/packages/li-math/src/lib.li` |
| Org mirror | `li-std-math/src/lib.li` |
| Org stub | `li-std-core/src/lib.li` |

## Tradeoffs

Do not implement WP0-B runtime or stuff GEMM into `std/math` before Wave A **G-math** is Done. Prefer one prelude lowering + composable packages over NumPy-style runtime dispatch.

## Deferred

- Cycle 2: broader `li-std-*` audit, httpd `std/http` modules, collections runtime.
- `trusted.lean` edits — human-gated.

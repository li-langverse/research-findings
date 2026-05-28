---
goal_id: stdlib_ecosystem
agent: stdlib_researcher
session_id: cee09172-b61f-4f7b-84de-aae2d0e5972f
generated_at: 2026-05-28T21:00:00Z
domains: [ecosystem, scientific_computing, hpc]
validity_grade: B
title: "Stdlib ecosystem — linear algebra gap vs SOTA (cycle 1)"
status: active
links:
  - lic/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md
  - lic/docs/ecosystem/research-sessions/stdlib_ecosystem-cycle.md
  - lic/docs/language/linear-algebra.md
  - lic/docs/superpowers/plans/2026-05-16-li-math-linalg-surface.md
ph_ids: [PH-2i, PH-7e, AL-10, AL-11]
---

# Linear algebra stdlibs — Li gap vs SOTA

> **Goal:** `stdlib_ecosystem` · **Session:** `cee09172-b61f-4f7b-84de-aae2d0e5972f` · **Step:** `gap_vs_sota` · **Grade:** B (file-backed audit)

## Executive summary

- Dense LA is implemented in the **compiler prelude** (`dot`, `sum`, `norm`, `axpy`, 1d/2d `@`), not in `lic/std/math` (tag-only stubs).
- Versus BLAS/LAPACK/NumPy, Li lacks **general tensors, sparse LA, and decompositions**; `packages/linalg` is **missing** (AL-10).
- **Proof-first partial win:** shape errors at compile time (`math_linalg` compile_fail suite); **G-math** still **Partial** (strict tier-1 perf + float Props).
- **`simd_dot` bench** still uses an extern C kernel — not the documented math-first pure-Li path.
- **`li-std-math`** mirrors structural 3D math; contracts weaker than monorepo `li-math` on `vec3_dot`.
- Next implementers: scaffold **`packages/linalg`**, pure-Li **`simd_dot`**, close **WA-4** strict tier-1 perf.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Prelude GEMM + `packages/linalg` LAPACK-class APIs can share one shape/proof story without duplicating ops in `std/math`. |
| Status | proposed |

## Analysis

### SOTA reference

BLAS Level 1–3 + LAPACK (solve/QR/eigen) and NumPy-style N-D broadcast are the baseline for scientific Python, Julia, and C++ (Eigen).

### Li mapping

| PH | Mapping |
|----|---------|
| PH-2i | Prelude `@`/`dot`/`norm`/`axpy` + `math_linalg` tests |
| PH-7e | MIR SIMD matmul/dot; tier-1 ≤1.2× C++ (partial) |
| AL-10 | `packages/linalg` scaffold (not on disk) |
| AL-11 | Quaternion/Mat4 completion in `li-math` |

Deep dive: [lic cycle digest](https://github.com/li-langverse/lic/blob/main/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md).

### Grade matrix

| Axis | Li today | Target |
|------|----------|--------|
| Correctness | Compile-time shape checks; checksum tier-1 | maintain |
| API breadth | Fixed arrays + nested 2d `@` | tensor + linalg package |
| Performance | `matmul_blocked`/`horner` strict fail | WA-4 green |
| Provability | P-linalg partial | float `@` Props closed |

## Recommendations

1. **`package_architect`:** placement for `packages/linalg` vs `std.tensor` facade.  
2. **`code_implementer`:** AL-10 scaffold + `simd_dot` pure-Li driver.  
3. **`bench_improver`:** `LI_TIER1_PERF_STRICT=1` for `matmul_blocked`, `horner_pure_li`.

## Evidence

| Type | Path |
|------|------|
| Cycle digest | `lic/docs/ecosystem/stdlib-research/cycle-1-gap-vs-sota-linalg.md` |
| Language surface | `lic/docs/language/linear-algebra.md` |
| Std tags | `lic/std/math/math.li`, `lic/std/math/numerics.li` |
| Package math | `lic/packages/li-math/src/lib.li` |
| Org mirror | `li-std-math/src/lib.li` |
| Tests | `lic/li-tests/math_linalg/` (26 files) |
| Bench gap | `lic/benchmarks/tier1_micro/simd_dot/li/main.li` (extern kernel) |
| Gates | `lic/docs/ecosystem/wave-a-stdlib-unblock-checklist.md` |

## Tradeoffs

Do not stuff GEMM into `std/math` stubs before Wave A **G-math** is Done. Prefer one prelude lowering + composable `linalg` package over NumPy-style runtime dispatch (conflicts with proof pillar).

## Deferred

- Full `li-std-core` package audit (version stub only).  
- Cycle rollup: [std-r0-cycle1-ecosystem-summary](../std-r0-cycle1-ecosystem-summary/README.md).

---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-29-parallel-decorator-for
generated_at: 2026-05-29T14:45:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 5 (G-dec @parallel on plain for)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle5-parallel-decorator-for.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/decorators/parallel_decorator_on_for_serial.li
---

# Proof holes — cycle 5: `@parallel` on `for` does not parallelize

> **Goal:** `provability_holes` · **Focus:** **G-dec**, **7d-b** · **PH-2e, PH-2f, PH-7d**

## Executive summary

- `@vectorized` on `for` lowers to `ArraySimdScope`; **`@parallel` on `for` does not** lower to `OmpParallelFor`.
- `parallel for` keyword creates `__li_par_*` worker + `li_omp_parallel_for_i64` call; decorated plain `for` does not.
- Policy checks disjoint proofs only for `ParallelFor`, not decorated `for`.
- `@parallel` without `disjoint=` on `for` is accepted today (misleading surface).
- CI guard: `parallel_decorator_for_elaboration_gap.sh`.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle5-parallel-decorator-for.md).

## Recommended follow-ups

1. Elaborate `@parallel` on `for` → `ParallelFor` (or shared MIR tag) per 7d-b.
2. Reuse `check_stmt_parallel` for decorated `for` when `@parallel` present.
3. Flip guard script + manifest when closed.

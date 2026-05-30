---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-30-parallel-disjoint-lean-opaque
generated_at: 2026-05-30T12:45:00Z
domains: [ecosystem, scientific_computing]
validity_grade: B
title: "Proof holes — cycle 25 (G-par disjoint Lean opaque stubs)"
status: active
links:
  - benchmarks/data/digest/proof_gap_researcher-2026-05-30-parallel-disjoint-lean-opaque.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/race_shared_memory/good_disjoint_parallel.li
  - lic/li-tests/tooling/parallel_disjoint_lean_opaque_gap.sh
---

# Proof holes — cycle 25: parallel disjoint Lean certificate gap

> **Goal:** `provability_holes` · **Focus:** **G-par**, **P-par** · **PH-7b, PH-7d-c, PH-2f** (lic **#387**)

## Executive summary

- Parallel `requires disjoint_*` / `invariant row_ok` → AutoVC **`Prop := True`** + `trivial` (opaque comment).
- `expr_to_lean` translates only `abs` calls — no disjoint builtins in Lean semantics yet.
- `@parallel(disjoint=…)` on `def` without loop `requires` → **no** par requires VC emitted.
- CI: `parallel_disjoint_lean_opaque_gap.sh` in `contracts_discharge_corpus.sh`.

## Deliverable

Full session digest: [benchmarks proof_gap_researcher-2026-05-30-parallel-disjoint-lean-opaque](../../../../benchmarks/data/digest/proof_gap_researcher-2026-05-30-parallel-disjoint-lean-opaque.md).

## Recommended follow-ups

1. Add `Discharge.disjoint_*_spec` lemmas and wire `vc_emit_lean` Call translation (#387).
2. Emit synthetic par requires from decorator inheritance (`parallel_def_disjoint_inherit.li`).
3. Retire stub-gap script when certificate carries real disjoint Props.

---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: c8f2a91d-4e6b-4a1c-9f3d-202605291005
generated_at: 2026-05-29T10:30:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 2 (mat2 @ codegen vs Lean eval)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle2-mat2-codegen.md
  - lic/docs/verification/provability-gaps.md
  - lic/proof-database/discrepancies.json
---

# Proof holes — cycle 2: mat2 `@` codegen vs Lean eval

> **Goal:** `provability_holes` · **Focus:** `mat2_codegen_eval_drift` · **PH-2e, PH-2f**

## Executive summary

- **Register item:** `disc-mat2-trusted-vs-mir` (`spec_drift`, **G-trust** / **G-lean**).
- **Static:** LLVM IKJ matmul in `emit.cpp` matches `Li.Discharge.mat2_at2_eval` algebra.
- **Runtime:** New golden `golden_mat2_at2_float.li` + `verify-math-physics-goldens.sh`.
- **Proof gap:** AutoVC discharges `ensures` against `mat2_at2_eval`, not MIR — preservation still open (**G-meta**).
- **`mat2_at2_eval` is not in `trusted.lean`** (definitional in `Discharge.lean`).

## Deliverable

Full digest: [lic session file](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle2-mat2-codegen.md).

### Hypothesis snapshot

| Outcome | Claim |
|---------|--------|
| verified | IKJ codegen matches eval formulas |
| verified | 2×2 runtime golden passes |
| verified | AutoVC ties ensures to `mat2_at2_eval` |
| falsified | eval is a `trusted.lean` axiom |
| deferred | MIR preservation lemma |

## Recommended follow-ups

1. `MIR.lean` + 2×2 `@` preservation lemma → resolve `disc-mat2-trusted-vs-mir`.
2. Clarify **G-lean** register row (eval proved vs codegen unproved).

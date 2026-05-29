---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-29-disjoint-row
generated_at: 2026-05-29T10:45:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 3 (G-par disjoint_row policy soundness)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle3-disjoint-row-policy.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/race_shared_memory/disjoint_row_writes_row_i.li
---

# Proof holes — cycle 3: `disjoint_row` policy only guards `grid[0][0]`

> **Goal:** `provability_holes` · **Focus:** **G-par** · **PH-2e, PH-2f**

## Executive summary

- Policy catches **constant** `grid[0][0]` writes under `disjoint_row` (`false_disjoint_proof.li` → **E0350**).
- **Soundness hole:** `grid[i][0]` under the same contract still **passes** `lic check` (`disjoint_row_writes_row_i.li`).
- Root cause: `par_body_writes_constant_grid00` in `policy_module.cpp` (literal index `0` only).
- CI guard `policy_disjoint_row_soundness.sh` documents the gap until fixed.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle3-disjoint-row-policy.md).

### Hypothesis snapshot

| Outcome | Claim |
|---------|--------|
| verified | `grid[i][0]` + `disjoint_row` accepted |
| verified | `grid[0][0]` rejected (E0350) |
| verified | open VC CLI-only (`sqrt_open_bound`) |
| falsified | all unsound `disjoint_row` bodies rejected |
| deferred | Lean disjoint semantics |

## Recommended follow-ups

1. Extend policy AST check for loop-indexed `grid[i][…]` writes under `disjoint_row`.
2. Flip manifest to `compile_fail`; remove `policy_disjoint_row_soundness.sh` guard when closed.

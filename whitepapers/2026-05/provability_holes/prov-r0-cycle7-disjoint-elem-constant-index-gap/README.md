---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-29-disjoint-elem-constant
generated_at: 2026-05-29T16:00:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 7 (G-par disjoint_elem constant index)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle7-disjoint-elem-constant-index.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/race_shared_memory/false_disjoint_elem_constant_index.li
---

# Proof holes — cycle 7: `disjoint_elem` + `buf[0]` accepted

> **Goal:** `provability_holes` · **Focus:** **G-par** · **PH-2e, PH-2f, PH-7b**

## Executive summary

- Policy rejects `disjoint_row` + writes to constant `grid[0][0]` (E0350).
- **New hole:** `disjoint_elem(i, buf)` + `buf[0]` write still passes `lic check`.
- Per-iteration `buf[i]` / `grid[i][0]` remain sound (retest falsifies cycle-3 “row-i hole” claim).
- CI guard: `policy_disjoint_elem_soundness.sh`.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle7-disjoint-elem-constant-index.md).

## Recommended follow-ups

1. Extend `policy_module.cpp` to reject constant-index writes under `disjoint_elem` (mirror row guard).
2. Add `compile_fail` manifest row for `false_disjoint_elem_constant_index.li`; remove guard script when closed.
3. Open lic issue: **G-par: policy rejects disjoint_row+grid[0][0] but not disjoint_elem+buf[0]**.

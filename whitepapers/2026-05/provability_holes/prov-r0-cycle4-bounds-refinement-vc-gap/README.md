---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-29-bounds-refinement
generated_at: 2026-05-29T13:10:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 4 (G-bnd refinement Lean / codegen stub)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle4-bounds-refinement-vc.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/contracts_verify/index_refinement.li
---

# Proof holes — cycle 4: refinement indices without Lean bounds or runtime guard

> **Goal:** `provability_holes` · **Focus:** **G-bnd**, **P-refine** · **PH-2e, PH-2f**

## Executive summary

- `Index10` refinement type **typechecks** array access; raw `int` index **rejected** (E0201).
- AutoVC emits `vc_get_requires_0 (i : Int) : Prop := True` — no `0 <= i < 10` in Lean.
- Codegen `get` uses unchecked indexed load; **no** `li_bounds_fail` call (`bounds_refinement_lean_gap.sh`).
- Witnessed call-site refinement VCs also `True` (`vc_emit_lean.cpp:550-551`).
- `sqrt_open_bound` still fails build without `--allow-open-vc` (contract tier retest).

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle4-bounds-refinement-vc.md).

## Recommended follow-ups

1. Emit real refinement predicates to AutoVC for proc params and call sites.
2. Add `Discharge.lean` lemmas for index bounds; wire MIR/codegen proof or runtime guard policy.
3. Flip `bounds_refinement_lean_gap.sh` when closed.

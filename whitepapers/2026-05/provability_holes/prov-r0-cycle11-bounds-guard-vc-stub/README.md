---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-30-bounds-guard-vc
generated_at: 2026-05-30T05:06:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 11 (G-bnd guarded refinement VC stub)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle11-bounds-guard-vc-stub.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/contracts_verify/index_refinement.li
  - lic/li-tests/contracts_verify/refinement_guard_ok.li
---

# Proof holes — cycle 11: guarded refinement VCs stub to True

> **Goal:** `provability_holes` · **Focus:** **G-bnd**, **P-refine** · **PH-2e, PH-2f**

## Executive summary

- Refinement indices typecheck; raw `int` index rejected (E0201).
- AutoVC erases `Index10` → `Int` with `Prop := True`; guarded call-site refine also stubs `True`.
- Codegen: inbounds GEP only; `li_bounds_fail` never called.
- CI guard `bounds_refinement_lean_gap.sh` landed in `contracts_discharge_corpus.sh`.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle11-bounds-guard-vc-stub.md).

## Recommended follow-ups

1. Emit real refinement predicates to AutoVC for proc params and non-witnessed call sites.
2. Add `Discharge.lean` index-bound lemmas; link `ensures result == a[i]`.
3. Flip `bounds_refinement_lean_gap.sh` when closed.

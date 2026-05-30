---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-30-vec3-opaque-ensures
generated_at: 2026-05-30T05:40:00Z
domains: [ecosystem]
validity_grade: verified
title: "Proof holes — cycle 13 (G-vc vec3 opaque ensures)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle13-vec3-opaque-ensures.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/contracts_verify/vec3_dot_wrong_return.li
  - lic/li-tests/tooling/vec3_dot_ensures_lean_gap.sh
---

# Proof holes — cycle 13: vec3 ensures stub to True

> **Goal:** `provability_holes` · **Focus:** **G-vc**, **P-linalg** · **PH-2e, PH-2f, PH-2i**

## Executive summary

- FieldAccess in `ensures` is untranslatable; AutoVC defaults to **`Prop := True`** with trivial proof.
- Programs with **wrong return** (`return 0.0` vs dot-product ensures) still **`lic build`** — soundness hole.
- Body-local ensures discharge via static return witness without param↔result math.
- CI guard **`vec3_dot_ensures_lean_gap.sh`** documents the gap.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle13-vec3-opaque-ensures.md).

Repro specimen: [snippets/vec3_dot_wrong_return.li](snippets/vec3_dot_wrong_return.li).

## Recommended follow-ups

1. Add `FieldAccess` to `expr_to_lean` + Lean `Vec3` record type.
2. Opaque ensures should open-goal or fail — not default `True`.
3. Add `Discharge.lean` vec3_dot lemmas; flip wrong-return test to `compile_fail`.

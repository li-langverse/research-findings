---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-30-dot4-loop-ensures-stub
generated_at: 2026-05-30T12:00:00Z
domains: [ecosystem, scientific_computing]
validity_grade: B
title: "Proof holes — cycle 24 (P-linalg dot4 loop ensures True stub)"
status: active
links:
  - benchmarks/data/digest/proof_gap_researcher-2026-05-30-dot4-loop-ensures-stub.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/contracts_verify/linalg_dot4_int_loop_open.li
  - lic/li-tests/tooling/dot4_loop_ensures_lean_stub_gap.sh
---

# Proof holes — cycle 24: dot4 loop witness vs Lean certificate

> **Goal:** `provability_holes` · **Focus:** **G-vc**, **P-linalg** · **PH-2i, PH-2f** (lic **#472**)

## Executive summary

- `witness_dot4_int_loop` validates loop shape; AutoVC still uses **`Prop := True`** for `ensures`.
- `Discharge.lean` has `dot4_int_loop_eval_spec` but AutoVC does not reference it (unlike `mat2_at2_float_spec`).
- `_open` in specimen name = certificate honesty gap, not open Lean goals.
- CI: `dot4_loop_ensures_lean_stub_gap.sh` in `contracts_discharge_corpus.sh`.

## Deliverable

Full session digest: [benchmarks proof_gap_researcher-2026-05-30-dot4-loop-ensures-stub](../../../../benchmarks/data/digest/proof_gap_researcher-2026-05-30-dot4-loop-ensures-stub.md).

## Recommended follow-ups

1. Emit `Li.Discharge.dot4_int_spec a b (dot4_loop_eval a b)` from `vc_emit_lean` for loop witness (mirror mat2).
2. Add matmul loop witness + `Discharge` lemma for tier-1 IKJ path.
3. Retire stub-gap script when closed.

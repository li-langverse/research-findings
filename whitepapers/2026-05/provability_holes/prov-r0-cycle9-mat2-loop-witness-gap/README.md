---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-30-mat2-loop-witness
generated_at: 2026-05-30T04:30:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 9 (P-linalg mat2 loop witness + contract tiers)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle9-p-linalg-mat2-loop.md
  - lic/docs/verification/provability-gaps.md
  - lic/docs/verification/proof-corpus-roadmap.md
---

# Proof holes — cycle 9: P-linalg loop matmul witness + verify_ok tier honesty

> **Goal:** `provability_holes` · **Focus:** **G-vc**, **G-test-verify** · **PH-2e, PH-2f**

## Executive summary

- **P-linalg gap:** `witness_mat2_int_at2_spec` only covers `return A @ B`; IKJ loop matmul entry has **open** AutoVC (`linalg_mat2_int_loop_no_witness.li`).
- **CI guards:** `p_linalg_mat2_loop_witness_gap.sh`, `verify_ok_manifest_tier_gap.sh` wired into `contracts_discharge_corpus.sh`.
- **Contract tiers:** `verify_ok` in `run_all.sh` = `lic build` only; full zero-open discharge remains separate tooling (**G-test-verify**).
- **`sqrt_open_bound`:** still fails build without `--allow-open-vc` (P-float open).
- **No `trusted.lean` changes.**

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle9-p-linalg-mat2-loop.md).

## Recommended follow-ups

1. Add `witness_mat2_loop_entry00` (mirror `witness_dot4_int_loop`) + `Li.Discharge.mat2_loop_eval_spec`.
2. Split manifest `prove_lean_ok` vs `verify_ok` (**G-test-verify**).
3. lic issue: int nested-array IKJ loop codegen SSA / call ABI (**G-math**).

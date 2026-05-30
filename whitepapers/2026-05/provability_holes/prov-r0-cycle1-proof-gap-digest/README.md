---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: 97b0a884-e513-4a30-9793-5493bc1aed9e
generated_at: 2026-05-28T20:30:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 1 digest (register + contract tiers)"
status: active
links:
  - lic/docs/verification/provability-gaps.md
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle.md
  - lic/docs/semantics/trusted.lean
  - https://github.com/li-langverse/lic/blob/main/docs/superpowers/plans/2026-05-14-li-master-plan.md
---

# Proof holes — cycle 1 digest

> **Goal:** `provability_holes` · **Session:** `97b0a884-e513-4a30-9793-5493bc1aed9e` · **north_star_fit:** PH-2e, PH-2f · **Grade:** B

## Executive summary

- Default **`lic build`** now blocks open proof obligations and runs Lean AutoVC typecheck when installed — but **G-lean** / **G-vc** remain **Partial** in the official register.
- **Contract tiers** are testable: strict build rejects false `ensures`; **`--allow-open-vc`** is the documented downgrade (`false_ensures_*` + manifest).
- **`prove_lean_ok`** ≠ **`verify_ok`** in `run_all.sh`; **G-test-verify** is **Done** (14+ closed `contracts_verify` specimens).
- **Manifest lint** prevents duplicate `outcome` keys from silently skipping tests.
- **`trusted.lean`** unchanged this run; **Core.lean** stub only; **MIR.lean** still planned.
- **Benchmark tier-0** verify uses `--allow-open-vc --no-lean-verify` — not a certificate gate.
- Prior-cycle claim “build never calls Lean” is **falsified** with file:line + repro commands.
- **`uses_sorry`** now fails with a semantic sorry ban (not parse-only).

## Deliverable / findings

Full five-section digest: [lic session file](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle.md).

### 1. Compiler / semantics gaps

Open VCs fail strict build (`main.cpp:605-614`). `lic check` remains frontend-only. **G-meta** (preservation) missing.

### 2. Contract gaps

Tier A presence enforced; Tier B partial (witnesses + `Discharge.lean` slices); Tier C refinements mostly `verify_ok`. `--allow-open-vc` CLI-only downgrade.

### 3. Trusted surface

`trusted.lean` — IO, Net, libm sqrt axiom. No session edits.

### 4. External trust boundaries

LLVM, Lake, benchmark harness downgrades, tier-2 C++ oracles — human/platform ownership.

### 5. Evidence pack

See session file for hypothesis table and commands (`contracts_verify` pass=32, `prove_reject` pass=6, manifest lint ok).

## Recommended issues/PRs

| Repo | Title | Labels |
|------|-------|--------|
| `lic` | Close open AutoVC on high-value `verify_ok` corpus | `pillar:provable`, `PH-2f` |
| `lic` | MIR.lean preservation sketch | `PH-2e` |
| `lic` | Dedupe provability-gaps appendix blocks | `documentation` |

## Deferred

G-meta, universal kernel certificate, full `prove_lean_ok` migration for contract suite.

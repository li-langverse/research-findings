---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: 4c1f93b0-62ef-44f7-b08c-2c1cbca18ac9
generated_at: "2026-05-27T17:30:00Z"
domains: [ecosystem]
validity_grade: verified-in-repo
experiment_id: PROV-R0-1
title: "PROV-R0-1 — Proof-gap digest (contracts, register, trusted surface)"
status: complete
ph_ids: [PH-2e, PH-2f]
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle.md
  - lic/docs/verification/provability-gaps.md
  - lic/docs/semantics/trusted.lean
  - lic/li-tests/proof_gaps/false_ensures_still_builds.li
---

# PROV-R0-1 — Proof-gap digest (cycle 1)

> **Grade:** verified-in-repo · Session `4c1f93b0` · **Does not claim** `lic build` = Lean kernel certificate.

## Question

Where are the soundness holes between **provability-gaps register**, **contract test tiers**, and the **trusted axiom surface** — and what reproduces them in `li-tests/`?

## Method

Session steps: `read_register` (G-* inventory + Discharge drift), `contract_tier` (manifest tiers + false-ensures specimen), `synthesize_step` (trusted.lean audit, consolidated digest). No `trusted.lean` edits.

## Executive summary

1. **`lic build` ≠ universal proof certificate** — Tier B Lean when lake present; open VCs and partial discharge remain.
2. **Tier B regression** — duplicate `sqrt_open_bound_spec` in `Discharge.lean` blocks default lake build.
3. **Tier A/B/C honesty** — `lic check` does not prove postconditions; `verify_ok` ≡ `compile_ok` in `run_all.sh`; only `prove_lean_ok` is strict.
4. **G-CONTRACT-01** — `false_ensures_still_builds.li`: check passes; `--allow-open-vc` ships exit 42.
5. **Manifest bug fixed** — duplicate `outcome` keys downgraded Tier C silently (3 blocks).
6. **Register doc drift** — repeated G-* rows inflate audit Partial count (26 vs ~17 unique).
7. **Trusted surface** — 13 axioms in `trusted.lean`; `Discharge.lean` dual sqrt namespaces → drift.
8. **Tooling** — `check_discharge_duplicate_defs.sh` added; `run_all.sh` syntax-broken on branch.

## Compiler / semantics gaps

See [lic session file](https://github.com/li-langverse/lic/blob/main/docs/ecosystem/research-sessions/provability_holes-cycle.md) § synthesize §1. Priority fix: dedupe `Discharge.lean` sqrt spec.

## Contract gaps

Tier map and **G-CONTRACT-01** repro in `li-tests/proof_gaps/false_ensures_still_builds.li`. Manifest duplicate-key guard recommended for CI.

## Trusted surface

`trusted.lean` — IO, Net, `li_rt_sqrt` + square bound only. Expansion requires RFC. `Li.TrustedMath` in `Discharge.lean` is duplicate-path drift, not a second axiom file.

## External trust boundaries

libm (**G-hw**), OS/SDL IO, TCP stubs — axiomatic; human RFC for growth. Register markdown dedup is a doc PR, not compiler.

## Evidence pack

| Command | Expected |
|---------|----------|
| `./li-tests/tooling/check_discharge_duplicate_defs.sh` | exit 1 (sqrt dup) |
| `lic check li-tests/proof_gaps/false_ensures_still_builds.li` | exit 0 |
| `lic build --allow-open-vc --no-lean-verify …/false_ensures_still_builds.li` | links; run → exit 42 |
| `grep -c prove_lean_ok li-tests/manifest.toml` | 22 |

## Recommended handoffs

| Repo | Title |
|------|-------|
| `lic` | fix(lean): dedupe `sqrt_open_bound_spec` in Discharge.lean |
| `lic` | fix(tests): repair `run_all.sh` duplicate branches |
| `lic` | docs(verification): dedupe provability-gaps.md rows |
| `lic` | feat(contracts): reject false ensures at `lic check` |

## Deferred

- G-meta compiler≡Lean proof
- Loop `decreases` enforcement (G-CONTRACT-02)
- `mat2_at2` trusted vs MIR closure
- Batch `prove_lean_ok` after `run_all.sh` repair

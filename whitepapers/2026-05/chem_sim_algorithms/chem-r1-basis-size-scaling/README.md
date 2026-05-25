---
goal_id: chem_sim_algorithms
agent: numerics_researcher
run_id: seed-chem-r1-2026-05-25
generated_at: 2026-05-25T12:00:00Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "QM stub SCF — basis-size cost/accuracy scaling (placeholder)"
status: active
links:
  - lic/docs/ecosystem/sim-chem-research-backlog.md#chem-r1-basis-size-scaling
  - benchmarks/competitive/verticals.toml
---

# QM stub SCF — basis-size cost/accuracy scaling

> **Study-only seed** from `sim-chem-research` backlog theme `chem-r1-basis-size-scaling`.

## Executive summary

Documents expected cost/accuracy tradeoffs for a minimal Li `qm_dft_scf_energy` stub across STO-3G vs larger bases before claiming competitive perf. Honesty in `verticals.toml` for `qm_dft` must match composable smoke status (`import_chem_dft_smoke`).

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Stub SCF energy monotonic in basis quality at fixed geometry for H2/H2O toy systems. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. Psi4 — minimal SCF recipes and basis sets
2. PySCF — cost scaling with AO count
3. Gaussian/ORCA — production workflows (reference only, no CI binary)

### Li mapping

- Vertical: `qm_dft` in `benchmarks/competitive/verticals.toml`
- Registry: QM ids 401–432
- Handoff implement: `sim-p2-qm-dft-scf`

### Grade matrix

| Axis | Li today | Target | Notes |
|------|----------|--------|-------|
| Validity | stub/oracle honesty | locked | Match composable reality |
| Stability | SCF convergence | document | Max iter / damping |
| Performance | O(N_basis³) trend | study-only | After validity |

### Basis scaling (placeholder)

| Basis | AO count (H2) | iter | energy (Ha) | wall ms |
|-------|---------------|------|-------------|---------|
| STO-3G | TBD | TBD | TBD | TBD |
| 6-31G | TBD | TBD | TBD | TBD |
| cc-pVDZ | TBD | TBD | TBD | TBD |

## Recommendations

1. Update `verticals.toml` honesty when smoke compiles.
2. Link study in PR for `chem-r2-dft-scf-gap` handoff.

## Evidence

| Type | Path / command |
|------|----------------|
| Backlog | `lic/docs/ecosystem/sim-chem-research-backlog.md` |
| Snippet | `snippets/qm-vertical-honesty.toml` |

## Tradeoffs

No production DFT accuracy claims; external Gaussian/ORCA not required in CI.

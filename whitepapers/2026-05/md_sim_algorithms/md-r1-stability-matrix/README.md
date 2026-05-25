---
goal_id: md_sim_algorithms
agent: numerics_researcher
run_id: seed-md-r1-2026-05-25
generated_at: 2026-05-25T12:00:00Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "MD Lennard-Jones — CFL and neighbor-skin stability matrix (placeholder)"
status: active
links:
  - lic/docs/ecosystem/sim-md-research-backlog.md#md-r1-stability-matrix
  - lic/docs/ecosystem/sim-algo-research-grading.md
  - https://li-langverse.github.io/benchmarks/
---

# MD Lennard-Jones — CFL and neighbor-skin stability matrix

> **Study-only seed** from `sim-md-research` backlog theme `md-r1-stability-matrix`. Replace with agent-run evidence.

## Executive summary

Proposes a size-scaling stability matrix for `md_lennard_jones` covering CFL-like timestep bounds and neighbor-list skin depth before any perf claims. Li should add a tier-0 stability row proposal only after ≥3 system sizes show bounded energy drift under locked integrator settings.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Fixed symplectic integrator + cell neighbor list achieves bounded energy drift at documented (N, dt) pairs for tier-2 `md_lennard_jones`. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. LAMMPS — neighbor skin and rebuild criteria ([docs](https://docs.lammps.org/))
2. GROMACS — list update frequency vs drift tradeoffs
3. OpenMM — cutoff + PME stability practices for condensed phases

### Li mapping

- Bench: `benchmarks/tier2_physics/md_lennard_jones/`
- Packages: `li-sim-scientific`, `li-physics-particles`
- Registry: MD family 101–120 in `algo_registry.json`

### Grade matrix

| Axis | Li today | Target | Notes |
|------|----------|--------|-------|
| Validity | tier-2 checksum parity pending | locked | No perf row without parity |
| Stability | partial (backlog) | tier-0 proposal | See scaling table below |
| Performance | document only | deferred | After validity locked |

### Size-scaling (placeholder)

| N | dt | max \|ΔE/E\| | neighbor skin | notes |
|---|-----|--------------|---------------|-------|
| 128 | TBD | TBD | 1.0 σ | run harness |
| 512 | TBD | TBD | 1.0 σ | run harness |
| 2048 | TBD | TBD | 1.2 σ | run harness |

## Recommendations

1. Run `./scripts/sim-plan-gates.sh` after filling scaling table from harness output.
2. Handoff `md-r2-neighbor-list-gap` → `sim-p1-md-neighbor-cell` when validity row is green.

## Evidence

| Type | Path / command |
|------|----------------|
| Backlog | `lic/docs/ecosystem/sim-md-research-backlog.md` |
| Snippet | `snippets/scaling-table-stub.md` |
| Bench | `python3 benchmarks/harness/bench.py --tier 2 --only md_lennard_jones` |

## Tradeoffs

Do not relax `threshold_ratio_cpp` or tier-0 tolerances to pass stability probes faster.

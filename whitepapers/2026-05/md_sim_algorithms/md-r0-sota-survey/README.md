---
goal_id: md_sim_algorithms
agent: numerics_researcher
run_id: numerics_researcher-1779774622783
generated_at: 2026-05-26T06:15:00Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "MD algorithms — LAMMPS/GROMACS/OpenMM SOTA survey and Li gap map"
status: active
links:
  - lic/docs/numerics/studies/2026-05-26-md-r0-sota-survey.md
  - lic/docs/ecosystem/sim-md-research-backlog.md#md-r0-sota-survey
  - lic/docs/ecosystem/sim-algo-research-grading.md
  - https://li-langverse.github.io/benchmarks/
---

# MD algorithms — SOTA survey and Li gap map

> **Goal:** `md_sim_algorithms` · **Run:** `numerics_researcher-1779774622783` · **Grade:** `study-only`

## Executive summary

Surveyed LAMMPS, GROMACS, OpenMM, and standard NVE validation literature for short-range MD. Mapped **algo_registry 101–120** to incumbent patterns and Li packages (`li-sim-scientific`, `li-physics-particles`, tier-2 `md_lennard_jones`). Only **md_lennard_jones** has a full harness on `main`; neighbor/constraint/long-range catalog rows are **honesty stubs** until harness paths land. Preflight shows **near-threshold** `md_neighbor_cell_list` (1.18×) and `md_constraints_shake` (1.17×) with **missing lic paths** — next implement handoff is **`md-r2-neighbor-list-gap`** → `bench_improver` / `sim-p1-md-neighbor-cell`. Integrator microbench `num_integ_verlet` remains **red** (1.35× cpp) and blocks PH-7e MD integrator work.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Cell-linked neighbor list + shared `md_core.c` oracle achieves checksum parity before any perf claim on algo 105. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. [LAMMPS neighbor lists](https://docs.lammps.org/neighbor.html) — skin, binning, rebuild criteria  
2. [GROMACS algorithms manual](https://manual.gromacs.org/current/reference-manual/algorithms/index.html) — search grids, constraints, PME scope  
3. [OpenMM application guide](https://docs.openmm.org/latest/userguide/application.html) — cutoffs, thermostats, drift testing  
4. [Swope et al. 1997](https://doi.org/10.1006/jcph.1997.5740) — NVE conservation reference for `md_energy_drift`

### Li mapping

| PH | Mapping |
|----|---------|
| PH-5b | `md_core.c` oracle; `stability.py`; proof-db LEM-PHYS-001 |
| PH-7e | Force loop + `num_integ_verlet` microbench after parity |
| G-math | `requires dt > 0`, drift bounds in numerical policy |
| G-par | `parallel for (disjoint=)` on force loop post-proof |

Deep dive: `lic/docs/numerics/studies/2026-05-26-md-r0-sota-survey.md`

### Grade matrix

| Axis | Li today | Target |
|------|----------|--------|
| Validity | tier-2 LJ green; registry stubs honest | locked |
| Stability | stress suite documented | tier-0 matrix (`md-r1`) |
| Performance | near-limit catalog only | after validity |

## Recommendations

1. **`bench_improver`:** implement `md_neighbor_cell_list` harness (algo 105) — do not relax `threshold_ratio_cpp`.  
2. **`numerics_researcher`:** complete `md-r1-stability-matrix` with filled N=128/512/2048 drift table.  
3. **Issue:** `numerics-research` — track catalog path gaps for ids 105–114 on `main`.

## Evidence

| Type | Path |
|------|------|
| Study | `lic/docs/numerics/studies/2026-05-26-md-r0-sota-survey.md` |
| Audit | `benchmarks/data/latest/ecosystem-audit.json` |
| Snippet | `snippets/algo-registry-md-101-120.md` |

## Tradeoffs

Validity and stability remain locked. Speed wins on neighbor/constraint rows are deferred until checksum parity and ≥3-size scaling table are green.

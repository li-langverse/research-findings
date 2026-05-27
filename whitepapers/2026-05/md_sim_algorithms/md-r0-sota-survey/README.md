---
goal_id: md_sim_algorithms
agent: numerics_researcher
run_id: numerics_researcher-1779911656866
generated_at: 2026-05-27T19:55:37Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "MD algorithms — LAMMPS/GROMACS/OpenMM SOTA survey and Li gap map"
status: active
links:
  - lic/docs/numerics/studies/2026-05-27-md-r0-sota-survey.md
  - lic/docs/numerics/studies/2026-05-25-md-r2-neighbor-list-gap.md
  - lic/docs/ecosystem/sim-md-research-backlog.md#md-r0-sota-survey
  - lic/docs/ecosystem/sim-algo-research-grading.md
  - https://li-langverse.github.io/benchmarks/
---

# MD algorithms — SOTA survey and Li gap map

> **Goal:** `md_sim_algorithms` · **Session:** `f1114f06-7079-45f3-9d88-ce5106130118` · **Run:** `numerics_researcher-1779911656866` · **Grade:** `study-only`

## Executive summary

Surveyed LAMMPS, GROMACS, OpenMM, and Frenkel–Smit / Swope NVE literature for short-range MD. Mapped **algo_registry 101–120** to `li-sim-scientific`, `li-physics-particles`, and tier-2 benches. **`md_lennard_jones`** is the only production-grade physics path (brute O(N²) MIC); **`md_neighbor_cell_list`** has a catalog harness but shares the LJ oracle until cell traversal lands (md-r2). All **16 `md_*` dashboard rows are unknown** (stale ingest); org red is tier-1 `horner_pure_li` / `reduce_sum`. Next: **`sim-p1-md-neighbor-cell`** (algo 105) with brute-force parity before any `ratio_vs_cpp` claim.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Cell-linked neighbor list + shared `md_core` oracle achieves checksum parity before any perf claim on algo 105. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. [LAMMPS neighbor lists](https://docs.lammps.org/neighbor.html) — skin, binning, rebuild criteria  
2. [GROMACS algorithms manual](https://manual.gromacs.org/current/reference-manual/algorithms/index.html) — search grids, constraints, PME scope  
3. [OpenMM application guide](https://docs.openmm.org/latest/userguide/application.html) — cutoffs, thermostats, drift testing  
4. [Frenkel & Smit — *Understanding Molecular Simulation*](https://www.sciencedirect.com/book/9780123872324/understanding-molecular-simulation) — cell-linked O(N); [Swope et al. 1997](https://doi.org/10.1006/jcph.1997.5740) for NVE drift gates

### Li mapping

| PH | Mapping |
|----|---------|
| PH-5b | `md_core.c` oracle; `stability.py`; proof-db LEM-PHYS-001 |
| PH-7e | Force loop + `num_integ_verlet` microbench after parity |
| G-math | `requires dt > 0`, drift bounds in numerical policy |
| G-par | `parallel for (disjoint=)` on force loop post-proof |

Deep dive: `lic/docs/numerics/studies/2026-05-27-md-r0-sota-survey.md` · neighbor contract: `lic/docs/numerics/studies/2026-05-25-md-r2-neighbor-list-gap.md`

### Grade matrix

| Axis | Li today | Target |
|------|----------|--------|
| Validity | LJ harness + WP2 stubs on 105/106; cell list unproven | locked |
| Stability | `[conservation]` in params.toml; md-r1 matrix | tier-0 fill |
| Performance | MD ingest stale (unknown) | after parity on 105 |

## Recommendations

1. **`bench_improver` / `sim-p1-md-neighbor-cell`:** real cell-linked forces in `md_core` (algo 105) — max |F_cell − F_brute| gate.  
2. **`numerics_researcher`:** `li_gap_analysis` — package API surface vs registry.  
3. **Ecosystem:** run `ingest-lic.sh` so `md_lennard_jones` exits dashboard **unknown**.

## Evidence

| Type | Path |
|------|------|
| Study | `lic/docs/numerics/studies/2026-05-27-md-r0-sota-survey.md` |
| Audit | `benchmarks/data/latest/ecosystem-audit.json` |
| li-tests | `lic/li-tests/composable/import_sim_scientific_run.li` |
| Bench | `md_lennard_jones` @ git `48d23a7a`: verify drift=0.689; li/cpp≈0.996× (1.183s/1.188s) — `bench.py --tier 2 --only md_lennard_jones` |
| Snippet | `snippets/algo-registry-md-101-120.md` |

## Tradeoffs

Validity and stability remain locked. Speed wins on neighbor/constraint rows are deferred until checksum parity and ≥3-size scaling table are green.

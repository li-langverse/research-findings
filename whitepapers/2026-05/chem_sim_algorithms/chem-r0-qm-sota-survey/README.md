---
goal_id: chem_sim_algorithms
agent: numerics_researcher
run_id: numerics_researcher-1779943243424
generated_at: 2026-05-28T04:41:35Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "Chemistry / QM — Psi4/PySCF/ORCA SOTA survey and Li gap map (401–432)"
status: active
links:
  - lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md
  - lic/docs/research/goals/chem_sim_algorithms.md
  - lic/docs/ecosystem/sim-chem-research-backlog.md#chem-r0-sota-survey
  - lic/docs/ecosystem/research-sessions/chem_sim_algorithms-cycle.md
  - https://li-langverse.github.io/benchmarks/
---

# Chemistry / QM — SOTA survey and Li gap map

> **Goal:** `chem_sim_algorithms` · **Session:** `1bdb6322-8399-425d-9257-9b9098475e89` · **Digest run:** `numerics_researcher-1779943243424` · **Survey run:** `numerics_researcher-1779916590880` · **Grade:** `study-only`

## Executive summary

Surveyed **Psi4**, **PySCF**, **ORCA**, and **Helgaker/Szabo** texts for minimal QC workflows (AO integrals → Fock → SCF → DFT energy). Mapped **algo_registry 401–432** to catalog smokes, `li-sim-scientific` dispatch, and tier-2 benches. All **32 `qm_*` dashboard rows are unknown** (harness pending); registry smokes compile via **`schrodinger_1d_barrier` template** — not QC kernels. **`qm_dft_scf_energy` (418)** is the v1 implement target with **Psi4 `external_binary` oracle** before native RKS. **`std/physics/chem.li`** remains a tag stub; integral chain **401–404** precedes Fock/SCF. Next handoff: **`chem-r2-dft-scf-gap`** / `sim-p2-qm-dft-scf` to `bench_improver`.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Minimal Li SCF energy on H₂ STO-3G matches Psi4 reference within tier-0 tolerance before any `ratio_vs_cpp` claim on algo 418. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. [Psi4](https://psicode.org/) — [tutorial](https://psicode.org/psi4manual/master/tutorial.html): HF/DFT energy APIs, basis library, DIIS SCF. **Takeaway:** v1 oracle = Psi4 single-point H₂/H₂O (STO-3G, 6-31G*) as `external_binary` in `verticals.toml`.
2. [PySCF](https://pyscf.org/user.html) — [SCF module](https://pyscf.org/user/scf.html): AO `intor`, density-fitting ERIs, RKS/UKS. **Takeaway:** implement **401–404** before **408** or **418**; DF (407) is PH-7e, not v1.
3. [ORCA manual](https://www.faccts.de/orca/manual/) — DFT grids/XC/hybrid map to registry **412–417**; [RI-JK](https://doi.org/10.1063/1.4824486). **Takeaway:** XC/grid rows stay stub honesty until LDA (412) passes reference energies.
4. *Molecular Electronic-Structure Theory* (Helgaker et al.); *Modern Quantum Chemistry* (Szabo & Ostlund) — integral recurrences, SCF stability, basis limits. **Takeaway:** `chem-r1` basis table must show monotonic energy + O(N_basis⁴) wall-time trend before perf claims.

### Li mapping

| PH | Mapping |
|----|---------|
| PH-5b | Integral bounds; SCF convergence = validity axis; no `threshold_ratio_cpp` relaxation |
| PH-7e | ERI contraction / Fock build SIMD after `lic build` symmetry lemmas |
| G-math | Gaussian recurrence (Obara–Saika) for 401–404 |
| G-par | `@vectorized` / `parallel for (disjoint=)` on AO contractions post-proof |

| ID range | Registry focus | Li surface | Harness |
|----------|----------------|------------|---------|
| 401–404 | GTO / overlap / kinetic / nuclear | `std/physics/chem.li` (tag); future `li-physics-quantum` | Template smoke |
| 405–411 | ERI / HF / SCF | Catalog smokes | Template only |
| 412–417 | DFT XC / grid / hybrid | `qm_dft_*` tier-2 | Compile smoke; timing pending |
| **418** | **`qm_dft_scf_energy`** | `vertical_qm_dft()` → stub checksum **1.001** | **v1 target** |
| 419–432 | grad / correlated / xTB / ASE | Deferred | Template only |

Deep dive: `lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md`

### Grade matrix

| Axis | Li today | Target | Notes |
|------|----------|--------|-------|
| Validity | **pass (survey)** | locked | Registry honest; `qm_dft` vertical = stub + `external_binary` |
| Stability | document | SCF max-iter / damping | Required before perf |
| Performance | document only | after 418 parity | All `qm_*` unknown on dashboard |
| Accuracy | basis table in chem-r1 | Psi4 Ha refs | Monotonicity locked |

## Recommendations

1. **`bench_improver` / `sim-p2-qm-dft-scf`:** Psi4 subprocess oracle + `common/qm_scf_core.c` for H₂ STO-3G; wire harness off template.
2. **`code_implementer`:** `li-tests/composable/import_chem_dft_smoke.li`; flip `verticals.toml` only when green.
3. **`numerics_researcher` (next cycle):** `li_gap_analysis` — package placement vs registry (defer until this survey lands).

## Evidence

| Type | Path / command |
|------|----------------|
| Study | `lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md` |
| Audit | `benchmarks/data/latest/ecosystem-audit.json` @ 2026-05-27T21:03Z (32 unknown `qm_*`) |
| Catalog | `benchmarks/catalog.toml` → `qm_dft_scf_energy`, `qm_gto_eval`, … |
| Registry | `lic/benchmarks/competitive/algo_registry.json` ids 401–432 |
| Snippet | `snippets/qm-dft-scf-smoke-template.li` |
| Bench (when harness lands) | `python3 lic/benchmarks/harness/bench.py --tier 2 --only qm_dft_scf_energy` |

## Tradeoffs

Validity (SCF convergence, reference energies), accuracy (basis monotonicity), and registry honesty for template smokes are **locked**. Speed on ERI/Fock rows is deferred until checksum parity. No production DFT accuracy claims; Gaussian/ORCA binaries not required in CI.

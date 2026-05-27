---
goal_id: chem_sim_algorithms
agent: numerics_researcher
run_id: numerics_researcher-1779869405908
generated_at: 2026-05-27T08:11:07Z
domains: [scientific_computing, hpc]
validity_grade: study-only
title: "QM / DFT algorithms — Psi4/PySCF/ORCA SOTA survey and Li gap map"
status: active
links:
  - lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md
  - lic/docs/ecosystem/sim-chem-research-backlog.md#chem-r0-sota-survey
  - lic/docs/ecosystem/sim-algo-research-grading.md
  - https://li-langverse.github.io/benchmarks/
---

# QM / DFT algorithms — SOTA survey and Li gap map

> **Goal:** `chem_sim_algorithms` · **Run:** `numerics_researcher-1779869405908` · **Grade:** `study-only`

## Executive summary

Surveyed Psi4, PySCF, ORCA, and standard electronic-structure texts for minimal Hartree–Fock/DFT workflows. Mapped **algo_registry 401–432** to incumbent patterns and Li surfaces (`li-sim-scientific`, `std/physics/chem.li`, tier-2 `qm_*` catalog rows). All QM catalog benches currently use the **`schrodinger_1d_barrier` smoke template** — not QC kernels; dashboard shows **32 unknown `qm_*` rows** (harness pending). Vertical `qm_dft` honesty is **stub / external_binary** until `import_chem_dft_smoke` passes. v1 implement handoff: **`chem-r2-dft-scf-gap`** → integral chain **401–404** then **`qm_dft_scf_energy` (418)** with Psi4 subprocess oracle before native RKS perf.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Psi4 STO-3G H₂ reference energy + checksum oracle unblocks honest `qm_dft_scf_energy` harness without relaxing `threshold_ratio_cpp`. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. [Psi4 tutorials](https://psicode.org/psi4manual/master/tutorial.html) — minimal HF/DFT energy, basis sets, DIIS SCF  
2. [PySCF user guide](https://pyscf.org/user/scf.html) — AO integrals, density fitting, RKS drivers  
3. [ORCA manual](https://www.faccts.de/orca/manual/) — GGA/hybrid DFT, Becke/Lebedev grids (registry 412–417)  
4. Helgaker, Jørgensen, Olsen — *Molecular Electronic-Structure Theory* (integral recurrences, basis limits)

### Li mapping

| PH | Mapping |
|----|---------|
| PH-5b | SCF convergence + reference Ha energies before timing |
| PH-7e | ERI/Fock contraction loops after integral parity |
| G-math | Gaussian recurrence, symmetry in overlap/ERI |
| G-par | `parallel for (disjoint=)` on AO blocks post-proof |

Deep dive: `lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md`

### Grade matrix

| Axis | Li today | Target |
|------|----------|--------|
| Validity | registry smokes; vertical stub | locked — Psi4 oracle |
| Stability | SCF max-iter undocumented | DIIS + damping table |
| Performance | all `qm_*` unknown | after validity (`chem-r1` scaling) |
| Accuracy | template only | Ha refs H₂/H₂O |

## Recommendations

1. **`bench_improver` / `sim-p2-qm-dft-scf`:** replace `schrodinger_1d_barrier` template for `qm_dft_scf_energy` with `qm_scf_core` oracle.  
2. **`numerics_researcher`:** complete `chem-r1-basis-size-scaling` with filled STO-3G / 6-31G / cc-pVDZ table.  
3. **Issue:** `numerics-research` — track `import_chem_dft_smoke` composable gate + `verticals.toml` honesty flip.

## Evidence

| Type | Path |
|------|------|
| Study | `lic/docs/numerics/studies/2026-05-27-chem-r0-qm-sota-survey.md` |
| Audit | `benchmarks/data/latest/ecosystem-audit.json` |
| Snippet | `snippets/algo-registry-qm-401-432.md` |

## Tradeoffs

Validity (SCF convergence, reference energies) and accuracy (basis monotonicity) remain locked. Speed wins on ERI/Fock rows are deferred until checksum/Ha parity and `chem-r1` scaling table are green. External Gaussian/ORCA binaries are **not** required in CI.

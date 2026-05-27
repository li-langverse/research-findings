# QM algo_registry excerpt (401–432)

Source: `lic/benchmarks/competitive/algo_registry.json` · family `qm` · all `implemented_smoke: true`

| ID | name | v1 priority |
|----|------|-------------|
| 401 | qm_gto_eval | P0 |
| 402 | qm_overlap_integrals | P0 |
| 403 | qm_kinetic_integrals | P0 |
| 404 | qm_nuclear_attraction | P0 |
| 405–407 | qm_eri_* | P1 (after P0) |
| 408–411 | qm_hf_* / qm_scf_solver | P1 |
| 412–417 | qm_dft_xc_* / grid / hybrid | P2 |
| 418 | qm_dft_scf_energy | **P0 target** |
| 419+ | grad, opt, correlated, xTB, props | deferred |

Vertical: `vertical_qm_dft()` in `li-sim-scientific` → `algo_qm_dft_scf_energy()` today; registry stub for other ids.

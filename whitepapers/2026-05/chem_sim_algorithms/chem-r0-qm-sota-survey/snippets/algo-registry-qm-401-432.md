# algo_registry 401–432 (QM family) — survey snapshot

| id | name | implemented_smoke | v1 priority |
|----|------|-------------------|-------------|
| 401 | qm_gto_eval | true (template) | P0 integral chain |
| 402 | qm_overlap_integrals | true (template) | P0 |
| 403 | qm_kinetic_integrals | true (template) | P0 |
| 404 | qm_nuclear_attraction | true (template) | P0 |
| 405–407 | qm_eri_* | true (template) | PH-7e / DF defer |
| 408–411 | qm_hf_* / qm_scf_solver | true (template) | P1 SCF driver |
| 412–417 | qm_dft_xc_* / grid / hybrid | true (template) | stub until LDA ref |
| **418** | **qm_dft_scf_energy** | true (template) | **P0 implement** |
| 419–432 | grad / correlated / xTB / ASE | true (template) | deferred |

Source: `lic/benchmarks/competitive/algo_registry.json`

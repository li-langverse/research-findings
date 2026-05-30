# MD algo_registry 101–120 — survey snapshot (2026-05-27)

| id | name | harness on lic main |
|----|------|---------------------|
| 101 | md_lj_cutoff_mic | md_lennard_jones (production) |
| 102 | md_integrator_verlet | via md_lennard_jones |
| 103 | md_energy_drift | stability.py |
| 104 | md_oracle_external | stub |
| 105 | md_neighbor_cell_list | **WP2 stub** (includes LJ oracle; no cell traversal) |
| 106 | md_neighbor_verlet_skin | **WP2 stub** |
| 107–120 | integrators / thermostats / PME / init | catalog / stub |

Source: `lic/benchmarks/competitive/algo_registry.json` + `benchmarks/data/latest/ecosystem-audit.json` @ 2026-05-27.

---
goal_id: robotics_systems
agent: goal_researcher
run_id: goal_researcher-f32363a0-c1-2026-05-28
generated_at: 2026-05-28T10:03:49Z
domains: [robotics, scientific_computing, ai]
validity_grade: verified
title: "Robotics SOTA survey — planning, control, perception mapped to Li"
status: active
links:
  - https://li-langverse.github.io/benchmarks/
  - https://docs.nav2.org/
  - https://github.com/moveit/moveit2_tutorials/blob/main/doc/concepts/motion_planning.rst
  - https://ompl.kavrakilab.org/
  - https://drake.mit.edu/
  - https://mujoco.org/
---

# Robotics SOTA survey — planning, control, perception mapped to Li

> **Goal:** `robotics_systems` · **Agent:** `goal_researcher` · **Run:** `goal_researcher-f32363a0-c1-2026-05-28` · **Grade:** `verified`

## Executive summary

- **SOTA robotics stacks converge** on a layered architecture: global planning (graph / sampling), local control (MPC / PID / whole-body), and perception feeding state estimation.
- **Ecosystem incumbents** for planning: OMPL (sampling), MoveIt 2 / ROS 2 planning pipelines, and trajectory optimization toolkits (CHOMP/TrajOpt-style).
- **Control SOTA** in practice blends classical control (PID/LQR) with optimization (MPC), with increasing use of differentiable models and learned residuals when validity can be monitored.
- **Perception SOTA** is dominated by deep models (detectors/segmenters) wrapped in robust tracking + calibration + uncertainty estimation; deployment cares about determinism and latency budgets.
- **Li today has an explicit robotics “surface” in the org benchmark catalog** (`robo_*` ids), but the catalog entries appear to be **harness-pending stubs** (paths currently point at placeholder locations).
- **Immediate next step for implementation** is not “new algorithms”, but **turning the catalog stubs into a reproducible harness** in `lic` (or the correct robotics package) with a single sim-backed command.
- **Proof-before-perf fit**: robotics needs *provable safety envelopes* (constraints, invariants, bounded error) before chasing speed; Li can differentiate by making controllers/planners auditable and certified.
- **Handoff-ready**: a `code_implementer` can start by wiring one benchmark end-to-end (e.g. `robo_plan_rrt`) with a deterministic seed and validity oracle.

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | The Li ecosystem already tracks a robotics benchmark surface (`robo_*`) sufficient to anchor an initial motion-planning/control/perception roadmap, even if harnesses are pending. |
| Status | verified |

## Analysis

### Learned from (SOTA)

#### Motion planning

- **Sampling-based planning** remains the practical default for many high-DOF planning problems (RRT/RRT*, PRM and descendants), usually coupled with collision checking acceleration structures (OMPL) ([OMPL](https://ompl.kavrakilab.org/)).
- **Manipulation planning pipelines** frequently run planners behind a plugin interface and default to OMPL in common deployments (MoveIt 2) ([MoveIt 2 motion planning concepts](https://github.com/moveit/moveit2_tutorials/blob/main/doc/concepts/motion_planning.rst)).
- **Modern deployment** favors pipelines: global planner → local planner → controller, with explicit replanning and costmap/map updates; determinism and bounded worst-case matter more than average-case.

#### Control

- **MPC** (linear/nonlinear) is widely used when constraints matter and models are decent; otherwise PID/LQR dominate.
- **Whole-body control** and contact-rich dynamics lean on multibody dynamics engines and optimization toolkits (e.g. Drake) ([Drake](https://drake.mit.edu/)).
- **Learning-assisted control** is common as residual/model correction and policy learning, but production systems require monitors, fallback controllers, and explicit safety constraints.

#### Perception

- **Deep perception** is the default (2D/3D detection, segmentation); robustness comes from dataset breadth, augmentation, and uncertainty-aware post-processing.
- **State estimation** (EKF/UKF/graph-SLAM) remains central; “learning everywhere” does not replace the need for sensor fusion and calibration.
- **Latency and determinism** dominate robotics perception engineering; systems are tuned to match compute budgets and scheduling constraints.

### Li mapping

#### What exists in-repo today (benchmarks catalog surface)

Li’s org `benchmarks/catalog.toml` already includes a tier-2 robotics set:

- `robo_ik_jacobian`
- `robo_multibody_step`
- `robo_plan_prm`
- `robo_plan_rrt`
- `robo_traj_opt`

These are currently marked as harness-pending (`size_label = "harness pending"`) and `validity_required = true`, which is consistent with the proof-first mandate.

**Important note (verified):** these robotics rows are currently **catalog stubs**: their `path` fields point at unrelated `num_*` benchmark paths. See `snippets/robo_catalog_dump.json`.

### Grade matrix

| Axis | Li today | Target | Notes |
|------|----------|--------|-------|
| Validity | planned + required | locked | `validity_required = true` in catalog, but harness/oracle still needed. |
| Stability | unknown | tier-2 stable | requires deterministic seeds + CI profile for repeatability. |
| Performance | not measured | ≤ 1.2× vs oracle | only meaningful after validity locked. |

## Recommendations

1. **Turn one catalog entry into an end-to-end harness**: start with `robo_plan_rrt` (deterministic, easy to validate), then add `robo_plan_prm`.
2. **Define a minimal validity oracle** per benchmark: collision-free path + constraint satisfaction + cost threshold, not just runtime.
3. **Add a “robotics sim profile”** that runs quickly and deterministically in CI (seeded scenes, fixed dt).
4. **Handoff**: `code_implementer` should implement the harness + CI stub command once the owning repo is selected (likely `lic` unless a dedicated robotics package exists).

## Evidence

| Type | Path / command |
|------|----------------|
| Catalog query (script) | `python3 snippets/check_robo_catalog.py --catalog ../../../../../../benchmarks/catalog.toml` |
| Output | `snippets/robo_catalog_dump.json` |
| Source | `benchmarks/catalog.toml` (robotics `robo_*` entries) |

## Tradeoffs

Validity (and safety constraints) are not traded for speed. Robotics benchmarks must first lock correctness/validity and determinism; only then should perf comparisons be used to drive compiler/runtime work.


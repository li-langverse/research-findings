---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-2026-05-29-decorator-for-policy
generated_at: 2026-05-29T16:30:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 8 (G-par/G-dec decorator-for policy bypass)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle8-decorator-for-policy-bypass.md
  - lic/docs/verification/provability-gaps.md
  - lic/li-tests/tooling/parallel_decorator_policy_capture_gap.sh
---

# Proof holes — cycle 8: `@parallel` on `for` bypasses capture/borrow policy

> **Goal:** `provability_holes` · **Focus:** **G-par**, **G-dec** · **PH-2e, PH-2f, PH-7b, PH-7d**

## Executive summary

- `parallel for` rejects outer `var` mutation and `borrow mut` in the loop body (E0350).
- **`@parallel(disjoint=disjoint_elem)` on plain `for` skips those guards** — both hole specimens pass `lic check`.
- Root cause: `check_stmt_parallel` / `check_stmt_parallel_capture` only inspect `Stmt::ParallelFor`.
- Composes with cycle 5 (no OpenMP lowering) and cycle 7 (`disjoint_elem` constant-index hole).
- CI guard: `parallel_decorator_policy_capture_gap.sh`.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle8-decorator-for-policy-bypass.md).

## Recommended follow-ups

1. Extend `policy_module.cpp` to run parallel body checks on `@parallel` `Stmt::For` (or elaborate to `ParallelFor`).
2. Add `compile_fail` manifest rows when policy closes; retire guard script.
3. Open lic issue: **G-par/G-dec: decorator-for bypasses mut-capture and borrow-in-par policy**.

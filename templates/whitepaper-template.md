---
goal_id: <goal-id>
agent: <agent-id>
run_id: <run-id>
generated_at: <ISO-8601>
domains: [scientific_computing]
validity_grade: study-only
title: "<short title>"
status: active
links:
  - lic/docs/ecosystem/<backlog>.md
  - https://li-langverse.github.io/benchmarks/
---

# <Title>

> **Goal:** `<goal_id>` · **Agent:** `<agent>` · **Run:** `<run_id>` · **Grade:** `<validity_grade>`

## Executive summary

2–4 sentences: what was investigated, key finding, recommended next action (implement / defer / handoff).

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | … |
| Status | proposed \| testing \| verified \| falsified \| deferred |

## Analysis

### Learned from (SOTA)

1. …
2. …

### Li mapping

- Packages / benches / registry rows touched
- Validity axes locked (stability, parity, honesty)

### Grade matrix

| Axis | Li today | Target | Notes |
|------|----------|--------|-------|
| Validity | … | locked | … |
| Stability | … | … | … |
| Performance | … | document only if validity locked | … |

## Recommendations

1. …
2. Handoff: `code_implementer` / `issue_planner` when …

## Evidence

| Type | Path / command |
|------|----------------|
| Bench | `benchmarks/...` or dashboard URL |
| Test | `li-tests/...` |
| Snippet | `snippets/<name>.li` |

## Tradeoffs

Validity (+ stability for MD/QM) are not traded for speed unless explicitly approved with locked axes listed.

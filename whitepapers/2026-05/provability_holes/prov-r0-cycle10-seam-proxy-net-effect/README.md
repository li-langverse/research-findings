---
goal_id: provability_holes
agent: proof_gap_researcher
run_id: proof_gap_researcher-1780118603001
generated_at: 2026-05-30T05:30:00Z
domains: [ecosystem]
validity_grade: B
title: "Proof holes — cycle 10 (G-net trusted proxy seam Net effect omission)"
status: active
links:
  - lic/docs/ecosystem/research-sessions/provability_holes-cycle10-seam-proxy-net-effect.md
  - lic/docs/verification/provability-gaps.md
  - lic/docs/superpowers/specs/2026-05-16-li-trusted-net-rfc.md
---

# Proof holes — cycle 10: trusted proxy seam hides Net effects

> **Goal:** `provability_holes` · **Focus:** **G-net**, **G-trust** · **PH-2f**

## Executive summary

- **34** `httpd_li_proxy_*` seam procs omit `raises Net`; C handlers perform `recv`/`send`.
- **`tcp_listen`** control path still enforces Net on callers (`seam_missing_net.li`).
- Gap specimen + CI guard encode the hole until seam audit lands.
- No `trusted.lean` changes.

## Deliverable

Full session digest: [lic research session](../../../../lic/docs/ecosystem/research-sessions/provability_holes-cycle10-seam-proxy-net-effect.md).

## Recommended follow-ups

1. Add `raises Net` to I/O-bearing proxy seam procs (RFC + manifest review).
2. Split pure slot accessors from syscall paths in seam.li.
3. Retire `seam_proxy_net_effect_gap.sh` when policy closes.

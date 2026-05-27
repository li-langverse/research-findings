---
goal_id: offensive_security
agent: security_auditor
run_id: security_auditor-1779904309903
generated_at: 2026-05-27T18:15:00Z
domains: [ecosystem, web]
validity_grade: study-only
title: "Offensive security — MITRE/OWASP/nginx SOTA survey and Li gap map"
status: active
links:
  - lic/docs/security/studies/2026-05-27-offensive-r0-sota-survey.md
  - lic/docs/ecosystem/security-research-backlog.md
  - lic/docs/ecosystem/security-research-grading.md
  - lic/docs/superpowers/plans/2026-05-16-li-httpd-plan.md
  - https://li-langverse.github.io/benchmarks/
---

# Offensive security — SOTA survey and Li gap map

> **Goal:** `offensive_security` · **Session:** `d6142e7a-d613-41cb-a295-4f5ffe1d2c5f` · **Run:** `security_auditor-1779904309903` · **Grade:** `study-only`

## Executive summary

Surveyed MITRE CWE Top 25, OWASP Top 10, nginx mitigation practice, and industry fuzz stacks (libFuzzer, AFL++, tlsfuzzer, h2spec) against Li’s **CVE catalog**, **tier5 exploit harness**, and **parser fuzz** corpus. Preflight feed sync shows **19/25 Top 25 CWEs absent** from `cve-catalog.json` while **catalog_gaps** (li-tests path coverage) = 0. Li ships **32 tier5 exploit TOMLs** with `li_behavior = "stricter"` vs nginx and **15 CWE classes** in-catalog; parser libFuzzer is live under `compiler/fuzz/`. Next implement pass: **`sec-r1-httpd-fuzz-smoke`** (standalone HTTP parse fuzz) then **`sec-r2-tier5-gap-exploit`** (close nginx_mitigations rows + Top25 catalog honesty).

## Hypothesis

| Field | Value |
|-------|-------|
| Statement | Adding catalog rows for web CWEs (22, 918, 798) with existing tier5 refs unblocks honest `needsWeb` reporting without new exploit logic. |
| Status | proposed |

## Analysis

### Learned from (SOTA)

1. [MITRE CWE Top 25](https://cwe.mitre.org/top25/) — prioritization baseline for `security-cwe-feed-sync.py`  
2. [OWASP Top 10](https://owasp.org/Top10/) — maps to tier5 `owasp = [...]` tags on exploit rows  
3. [nginx http core](https://nginx.org/en/docs/http/ngx_http_core_module.html) — distributed limits mirrored in `nginx_mitigations.toml`  
4. [libFuzzer](https://llvm.org/docs/LibFuzzer.html) / [AFL++](https://github.com/AFLplusplus/AFLplusplus) — parser + planned `http_parse_fuzz`  
5. [tlsfuzzer](https://github.com/tlsfuzzer/tlsfuzzer) — M2 TLS attack driver in tier5 plan

### Li mapping

| Asset | Path | Notes |
|-------|------|-------|
| CVE catalog | `lic/security/cve-catalog.json` | 39 CVE rows, 15 CWE ids |
| CWE tests | `lic/security/cwe-to-li-tests.toml` | compile_fail / fuzz_seed obligations |
| Tier5 exploits | `lic/benchmarks/tier5_http/exploits/` | 32 scenarios, stricter-or-equal |
| Parser fuzz | `lic/compiler/fuzz/` | corpus + `parse_fuzz.cpp` |
| Feed delta | `benchmarks/data/latest/security-cwe-feed-delta.json` | 19 Top25 missing |

Deep dive: `lic/docs/security/studies/2026-05-27-offensive-r0-sota-survey.md`

### Grade matrix

| Axis | Li today | Target |
|------|----------|--------|
| Posture validity | tier5 contract locked | no `li_stricter` regressions |
| CWE freshness | feed 0d old | ≤7d (gates) |
| Fuzz coverage | parser only | + httpd parse fuzz (`sec-r1`) |
| Tier5 parity | 32 TOML rows | live vs nginx all enabled (`sec-r2`) |
| ASan / native | N/A this step | on `*_core.c` touch |

## Recommendations

1. **`li_gap_analysis`:** Prioritize catalog rows for CWE-22, CWE-918, CWE-798 (tier5 refs already exist).  
2. **`sec-r1-httpd-fuzz-smoke`:** Standalone `http_parse_fuzz` + corpus path in study.  
3. **Handoff `code_implementer`:** httpd plan `gap-phase2-mitigation-exploits`, live exploit runtime gate.  
4. **Handoff `issue_planner`:** Roadmap entries for CWE-79/89/352 when web form/SQL surfaces land.

## Evidence

| Type | Path / command |
|------|----------------|
| Feed | `benchmarks/data/latest/security-cwe-feed-delta.json` |
| Study | `lic/docs/security/studies/2026-05-27-offensive-r0-sota-survey.md` |
| Gates | `SECURITY_RESEARCH_BACKLOG_STUDY_ONLY=1 ./scripts/security-research-gates.sh` |
| Snippet | `snippets/tier5-expect-stricter.toml` |

## Tradeoffs

Posture validity and `li_stricter` are locked. Fuzz campaign throughput and bench memory are documented only — not traded for exploit expectations.

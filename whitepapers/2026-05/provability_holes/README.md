## provability_holes — cycle 1 (focus: contract tiers)

### Executive summary

- **Verified**: `li-tests/manifest.toml` parsing in `li-tests/run_all.sh` is **not a TOML parser** and can silently ignore malformed `[[tests]]` blocks (missing `file`/`outcome`) or accept duplicate keys → **tier/contract intent can drift from what CI actually runs**.
- **Fixed + tested**: added a manifest lint (`tooling/lint_manifest_no_duplicate_keys.sh`) and registered it in `li-tests/manifest.toml` so CI catches duplicate keys / missing required keys.
- **Verified**: `--allow-open-vc` is the explicit downgrade path; strict `lic build` fails with open VCs and suggests `--allow-open-vc` (contract tier boundary is enforceable in-repo).
- **Fixed**: Lean typecheck mismatch for `sqrt_open_bound` semantic ensures witness (AutoVC theorem now proves `requires → ensures`).

### Digest (contract tiers)

1. **Compiler / semantics gaps**
   - `sqrt_open_bound` semantic discharge theorem was emitted as unconditional `ensures`, but the proof lemma is conditional on `requires`. This broke Lean typechecking for the *Tier “prove_lean_ok”* contract corpus until fixed.

2. **Contract gaps**
   - Tier boundary is meaningful: a false `ensures` compiles only under `--allow-open-vc` (manifest `verify_open_ok`), and is rejected under strict build (manifest `compile_fail`).

3. **Trusted surface**
   - No edits to `docs/semantics/trusted.lean`.

4. **External trust boundaries**
   - N/A (all reproduction and fixes are inside `lic/` + `li-tests/`).

5. **Evidence pack**
   - **G-test-verify / manifest parsing hole**:
     - `li-tests/run_all.sh` collects rows by regex and **drops** a block unless both `cur_file` and `cur_outcome` were set; it does not detect duplicate keys.
   - **Contract tier repro**:
     - `li-tests/contracts_verify/false_ensures_strict_reject.li` (strict build fails with “allow-open-vc” hint).
     - `li-tests/contracts_verify/false_ensures_allow_open_ok.li` (passes under `verify_open_ok` / `--allow-open-vc`).
   - **Lean discharge fix**:
     - `compiler/verify/vc_emit_lean.cpp` updated so `sqrt_open_bound` emits `requires → ensures`, matching `Li.Discharge.sqrt_open_bound_spec_proved`.
   - **Commands (repro + verification)**:
     - `./li-tests/run_all.sh tooling` → PASS
     - `./li-tests/run_all.sh contracts_verify` → PASS

### Hypotheses (this focus step)

- HYPOTHESIS: **verified** — `li-tests/manifest.toml` can silently weaken/skip intended contract tiers because `run_all.sh` is a line-oriented parser that ignores malformed `[[tests]]` blocks and does not detect duplicate keys. | evidence: `li-tests/run_all.sh` `collect_manifest_rows()` logic + added manifest lint wired into manifest.
- HYPOTHESIS: **verified** — semantic discharge for `sqrt_open_bound` was unsoundly wired (`ensures` theorem missing `requires` premise), breaking Lean typecheck for a Tier “prove_lean_ok” specimen. | evidence: `lic build li-tests/contracts_verify/sqrt_open_bound.li` previously failed with Lean type mismatch; fixed by emitting `requires → ensures`.
- HYPOTHESIS: **verified** — strict build rejects open VCs and the downgrade is explicit (`--allow-open-vc`), enabling a testable tier split (`compile_fail` vs `verify_open_ok`). | evidence: `false_ensures_*` fixtures + manifest outcomes.


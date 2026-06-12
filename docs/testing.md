# jankurai-tools-dedup Testing

Testing is routed proof. Agents should not guess which tests matter; route
changed paths through [`agent/test-map.json`](../agent/test-map.json) to the
smallest lane that proves them.

| Lane | Purpose |
| --- | --- |
| `fast` | deterministic local proof for most edits (`cargo check` + tests) |
| `copy-code` | exact and high-confidence duplicate source scan over the crate |
| `security` | secret and dependency scanning |
| `audit` | jankurai repo score and hard-rule findings |
| `full` | release/merge gate: format, lint, fast, security, and self-audit |

## Rust proof obligations

The crate carries both property and integration tests so the copy-code scanner
cannot silently regress:

- Property tests use `proptest` to assert invariants of the fingerprint and
  redundancy accounting (for example: a class never reports fewer than two
  instances, and redundant byte counts are monotonic in instance count).
- Integration tests under `crates/jankurai-audit-dedup/tests/` exercise the
  public scanner surface end to end with `#[test]` cases.

Run them through the fast lane:

```bash
cargo check --workspace --locked
cargo nextest run --workspace
```

## Repair receipts and telemetry

When a proof lane fails, keep the next agent on the shortest possible rerun path.
Every repair receipt should record, as typed fields rather than free-form prose:

- The lane **purpose** — what the lane proves and why it ran.
- The **reason** the lane failed — the failing command, exit code, and the
  changed paths that triggered it.
- The **common fixes** for the failure class, so the next rerun is obvious.
- A `docs_url` pointing back to this document, plus a `repair_hint` naming the
  exact proof command the next agent should trust.

Prefer typed telemetry or JSON envelopes under `target/jankurai/` over ad hoc
log spam. Structured errors with `purpose`, `reason`, `common fixes`, `docs_url`,
and `repair_hint` fields keep the next rerun local and deterministic. The crate's
scanner errors are modeled as an `enum Error` (an `Exception`-shaped surface)
that carries these same fields rather than opaque strings.

## Budgets, quotas, and stops

Paid or unbounded work needs an explicit ceiling before it starts.

- State the budget in time, runner minutes, tokens, API calls, or dollars.
- State the quota or cap that will stop the run.
- State the kill switch or stop condition that aborts the work once the cap is
  hit, and capture evidence of the stop in the receipt.
- Do not keep retrying a paid job after the cap is reached without a fresh
  approval receipt.

For this workspace every lane is local, hermetic, and free of network spend, so
the budget ceiling is the lane `timeout_seconds` declared in
[`agent/proof-lanes.toml`](../agent/proof-lanes.toml). The copy-code scan is
bounded by `max_findings` in the report policy (see
[`schemas/copy-code.schema.json`](../schemas/copy-code.schema.json)).

## Schema-first work

For changes to [`schemas/copy-code.schema.json`](../schemas/copy-code.schema.json),
add a Rust test that loads the JSON and checks the required fields so the contract
stays machine-readable. Keep that proof under `cargo test --workspace --locked`.

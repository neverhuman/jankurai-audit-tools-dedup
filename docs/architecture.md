# jankurai-tools-dedup Architecture

`jankurai-tools-dedup` is a single-purpose Rust crate that implements the
copy-code redundancy scanner for the jankurai audit standard. It detects exact
file duplication, exact unit (function/impl) duplication, and high-confidence
token-block duplication across a repository's active source, then fingerprints
each duplicate class so that stable redundancy can be triaged and, where
justified, allowlisted.

The product standard the wider family targets is:

```text
Rust core + TypeScript/React/Vite product surface + PostgreSQL truth
+ generated contracts + exception-only Python AI/data service
```

This repository is Rust-only. New implementation must be Rust-first. Agents must
not add Python for repo tools, proof lanes, product services, general backend
glue, authorization, or production database writes.

## Crate layout

| Path | Role |
| --- | --- |
| `crates/jankurai-audit-dedup` | the copy-code scanner library crate |
| `schemas/copy-code.schema.json` | JSON Schema contract for the copy-code report |
| `agent/` | machine-readable owner, test, boundary, and proof maps |
| `docs/` | architecture, testing, boundaries, release, and exception docs |
| `ops/` | pinned CI script entrypoints |
| `scripts/` | local CI helpers |
| `tips/` | reference corpus distilled from the duplicate-detection research |

The crate depends on `jankurai-audit-kernel` for the shared audit context and
finding model; it contributes the `copy-code` analyzer surface back to the
auditor binary in `jankurai-core`.

## Ownership and proof

Agents should prefer [`agent/owner-map.json`](../agent/owner-map.json) and
[`agent/test-map.json`](../agent/test-map.json) for changes, then route to the
smallest proof lane in [`agent/proof-lanes.toml`](../agent/proof-lanes.toml).

Boundaries are declared in [`agent/boundaries.toml`](../agent/boundaries.toml)
and described in prose in [`docs/boundaries.md`](boundaries.md).

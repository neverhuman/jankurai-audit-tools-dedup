# jankurai-tools-dedup

This is a thin agent adapter. The durable, machine-readable instructions live in
[`AGENTS.md`](AGENTS.md) and the manifests under [`agent/`](agent/). Read those
first.

- Ownership: [`agent/owner-map.json`](agent/owner-map.json)
- Proof routing: [`agent/test-map.json`](agent/test-map.json) and
  [`agent/proof-lanes.toml`](agent/proof-lanes.toml)
- Boundaries: [`agent/boundaries.toml`](agent/boundaries.toml) /
  [`docs/boundaries.md`](docs/boundaries.md)

Run `bash scripts/ci-local.sh required` before handing off changes.

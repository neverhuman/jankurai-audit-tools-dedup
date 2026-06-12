# crates Agent Instructions

This cell owns the Rust copy-code dedup scanner crate.

- Owns: `crates/jankurai-audit-dedup/src` (scanner source) and
  `crates/jankurai-audit-dedup/tests` (property and integration proof).
- Forbidden: hand-editing the kernel dependency pin; reaching for ambient I/O in
  pure domain code (see `agent/boundaries.toml`).
- Proof lane: `cargo test --workspace --locked` (routed in
  `agent/test-map.json`).

The scanner source is jankurai's own detection vocabulary; keep behavior changes
covered by tests under `crates/jankurai-audit-dedup/tests/`.

# Changelog

All notable changes to jankurai-tools-dedup are documented in this file. The
format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). The authoritative
version string lives in [`VERSION`](VERSION).

## [Unreleased]

### Removed

- GitHub Actions workflows (`.github/`), the workflow-only job aggregator
  (`ops/ci/aggregate.sh`), and the zizmor/actionlint workflow lint. GitHub is a
  publishing mirror only; CI, scoring, and release builds run on our own
  servers.

### Added

- Root `Justfile` command surface with `setup`, `fast`, `check`, `security`, and
  `audit` lanes for one-command setup and validation.
- GitHub Actions CI (`.github/workflows/ci.yml`) with build, security, and
  jankurai audit jobs, all third-party actions pinned to commit SHAs.
- Agent-readable documentation: `README.md`, `docs/architecture.md`,
  `docs/testing.md`, `docs/boundaries.md`, `docs/release.md`, and
  `docs/exceptions.md`.
- Rescoped `agent/` control plane: `audit-policy.toml`, `boundaries.toml`,
  `owner-map.json`, `test-map.json`, `generated-zones.toml`, `proof-lanes.toml`,
  `coverage-sources.toml`, `copy-code-allowlist.toml`, `security-policy.toml`,
  and `tool-adoption.toml`.
- Property and integration tests for the copy-code scanner crate under
  `crates/jankurai-audit-dedup/tests/`.

## [0.1.0] - 2026-06-12

### Added

- Initial split-family extraction of the jankurai copy-code dedup scanner crate.

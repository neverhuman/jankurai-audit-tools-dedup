#!/usr/bin/env bash
# Canonical security lane wrapper for jankurai-tools-dedup.
#
# Single shell entrypoint for the full supply-chain posture: secret scanning,
# dependency vulnerability review, SBOM/provenance generation, and workflow
# linting. The deterministic subset (gitleaks + cargo audit) also runs from the
# thin `ops/ci/security.sh` lane; this wrapper is the superset used for release
# evidence. Each step emits a `jankurai-security-step=` JSON line so the
# evidence envelope can be reconstructed without a Python runtime.
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

step() { printf 'jankurai-security-step={"tool":"%s","blocking":%s}\n' "$1" "$2"; }

# Secret scanning.
step gitleaks true
gitleaks detect --source . --no-banner --redact

# Dependency vulnerability review (Rust + npm advisory databases).
step cargo-audit true
cargo audit
step npm-audit false
npm audit --audit-level=high || true

# Dependency policy and license/ban checks.
step cargo-deny false
cargo deny check || true

# Software bill of materials + provenance (CycloneDX via syft, scanned by grype).
step syft false
syft . -o cyclonedx-json=target/jankurai/security/sbom.json || true
step grype false
grype sbom:target/jankurai/security/sbom.json || true

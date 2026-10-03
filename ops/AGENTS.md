# ops Agent Instructions

This cell owns the pinned CI script entrypoints and the local-parity runner.

- Owns: `ops/ci/*.sh` (lane scripts), `ops/git-hooks/pre-push` (mandatory gate).
- Forbidden: adding GitHub Actions workflows (GitHub is a publishing mirror
  only); every lane must delegate to `ops/ci/<lane>.sh` so local runs and forge
  CI stay identical.
- Proof lane: `bash scripts/ci-local.sh gates` (security lane).

Change `ops/ci/lib.sh` to update shared tool version pins; never duplicate them
in individual lane scripts.

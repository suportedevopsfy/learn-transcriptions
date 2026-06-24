#!/usr/bin/env bash
# n07.sh — SecureFile payload for N07.Run.
#
# Upload this to the TO project's Secure Files as "n07.sh". It is a SKELETON:
# it carries NO secrets itself — CLONE_URL / OUT_KEY arrive as masked env vars
# from the variable group "n07". Safe to keep this template in git; the real
# secrets never live here.
#
# Contract:
#   - clone the private target (URL is tokened, comes from env, never logged)
#   - run the build/test, capturing ALL output to a file kept OFF the console
#   - encrypt that file into $BUILD_ARTIFACTSTAGINGDIRECTORY/n07-out.enc
#   - print only a one-line status to the (public) console
set -euo pipefail

OUT_DIR="${BUILD_ARTIFACTSTAGINGDIRECTORY:-$PWD}"
LOG="$(mktemp)"
WORK="$(mktemp -d)"
cleanup() { rm -rf "$WORK"; rm -f "$LOG"; }
trap cleanup EXIT

STATUS=0
{
  echo "[n07] start $(date -u +%FT%TZ)"
  git clone --depth 1 ${REF:+--branch "$REF"} "$CLONE_URL" "$WORK/src"
  cd "$WORK/src"

  # ----------------------------------------------------------------------------
  # >>> build/test commands for the private target go here <<<
  # Keep them generic / arch-neutral (this is a fungible runner). Example:
  #   ./mvnw -q -B verify
  echo "[n07] (placeholder) build step — replace with the real command"
  # ----------------------------------------------------------------------------

  echo "[n07] done $(date -u +%FT%TZ)"
} >"$LOG" 2>&1 || STATUS=$?

# Encrypt the full log into the artifact; only the status line reaches the console.
# (CLONE_URL is already masked by ADO because it is a secret VG var.)
openssl enc -aes-256-cbc -pbkdf2 -salt -pass env:OUT_KEY -in "$LOG" -out "$OUT_DIR/n07-out.enc"
echo "[n07] finished status=${STATUS} (full log encrypted -> n07-out.enc)"
exit "$STATUS"

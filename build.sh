#!/usr/bin/env bash
# Build the nimony aowlc — post-hexer `.c.nif` → C. NIM = a nimony checkout.
# (The hand-written aowlc.js remains as the differential oracle / browser seed.)
set -e
NIM="${NIM:-$HOME/nimony}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$ROOT/bin"
"$NIM/bin/nimony" c -o:"$ROOT/bin/aowlc-native" \
  -p:"$NIM/src/lib" -p:"$NIM/src/nimony" -p:"$NIM/src/models" -p:"$NIM/src/gear2" \
  -p:"$ROOT/src" "$ROOT/src/aowlc_cli.nim"
echo "built $ROOT/bin/aowlc-native"

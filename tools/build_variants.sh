#!/usr/bin/env bash
# Builds the NeedleBench firmware variants and copies them into docs/fw/ for the web flasher.
# Needs ESP-IDF v5.5 on PATH (. $HOME/esp/esp-idf/export.sh).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/esp32/needle_demo"
OUT="${OUT:-$ROOT/docs/fw}"
VERSION="${VERSION:-1.1}"

build() {   # build <variant> <fw-id> <schema.json> [extra idf args...]
  local v="$1" id="$2" schema="$3"; shift 3
  echo "== $v ($id)"
  idf.py -C "$APP" -B "$APP/build_$v" -DND_FW_ID="$id" -DND_SCHEMA_PATH="$schema" "$@" build
  mkdir -p "$OUT/$v"
  cp "$APP/build_$v/bootloader/bootloader.bin"           "$OUT/$v/bootloader.bin"
  cp "$APP/build_$v/partition_table/partition-table.bin" "$OUT/$v/partition-table.bin"
  cp "$APP/build_$v/needle_demo.bin"                     "$OUT/$v/app.bin"
  cp "$schema"                                           "$OUT/$v/tools.json"
}

idf.py -C "$APP" set-target esp32s3 >/dev/null
build needle2-led      "needle2-led-$VERSION"      "$ROOT/tools/led.json"
build needle2-led-prof "needle2-led-prof-$VERSION" "$ROOT/tools/led.json" -DND_PROFILE=1
build needle2-kettle   "needle2-kettle-$VERSION"   "$ROOT/tools/kettle.json"
(cd "$OUT" && sha256sum */*.bin > SHA256SUMS)
echo "Done. Images are in docs/fw/; commit them to publish."

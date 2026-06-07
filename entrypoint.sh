#!/bin/sh
set -e
export PATH="/opt:$PATH"
if ! command -v xray >/dev/null; then
  7z x -y -bsp0 -bso0 "xray.7z" -o"/opt"
  chmod +x "/opt/xray"
  chmod +x "/opt/command.sh"
fi
exec "$@"

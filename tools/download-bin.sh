#!/bin/bash
set -e

echo "[INFO] Downloading UDP binaries"

ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
  UDP_BIN="udp-custom-linux-amd64"
else
  UDP_BIN="udp-custom-linux-arm64"
fi

curl -L -o /usr/local/bin/udp-custom \
https://github.com/xtaci/udp-custom/releases/latest/download/$UDP_BIN

curl -L -o /usr/local/bin/badvpn-udpgw \
https://github.com/ambrop72/badvpn/releases/download/1.999.130/badvpn-udpgw

chmod +x /usr/local/bin/udp-custom
chmod +x /usr/local/bin/badvpn-udpgw

echo "[INFO] Binary OK"

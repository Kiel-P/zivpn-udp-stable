#!/bin/bash
PORT=5667

echo "[CHECK] udp-custom:"
systemctl is-active udp-custom || echo "FAIL"

echo "[CHECK] badvpn:"
systemctl is-active badvpn || echo "FAIL"

echo "[CHECK] UDP port:"
ss -lunp | grep ":$PORT" && echo "OK" || echo "FAIL"

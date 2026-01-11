#!/bin/bash
echo "=== ZIVPN CHECK ==="
ss -lunp | grep udp || echo "UDP NOT LISTENING"
systemctl status zivpn-udp --no-pager

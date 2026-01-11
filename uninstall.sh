#!/bin/bash

systemctl stop udp-custom badvpn
systemctl disable udp-custom badvpn

rm -f /usr/local/bin/udp-custom
rm -f /usr/local/bin/badvpn-udpgw
rm -rf /etc/zivpn
rm -f /etc/systemd/system/udp-custom.service
rm -f /etc/systemd/system/badvpn.service

iptables -D INPUT -p udp --dport 5667 -j ACCEPT 2>/dev/null || true

systemctl daemon-reload
echo "[OK] UNINSTALLED"

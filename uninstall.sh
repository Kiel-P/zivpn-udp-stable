#!/bin/bash
systemctl stop zivpn-udp
systemctl disable zivpn-udp
rm -f /etc/systemd/system/zivpn-udp.service
rm -f /usr/local/bin/udp-custom
rm -f /usr/local/bin/badvpn-udpgw
rm -rf /etc/zivpn /var/log/zivpn
systemctl daemon-reload
echo "Uninstalled"

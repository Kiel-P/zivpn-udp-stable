#!/bin/bash
set -e

PORT=5667
IFACE=$(ip route get 1.1.1.1 | awk '{print $5;exit}')

echo "[INFO] ZIVPN UDP STABLE INSTALLER"
echo "[INFO] OS : Ubuntu 20.04"
echo "[INFO] Port UDP : $PORT"
echo "[INFO] Interface : $IFACE"

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Run as root"
  exit 1
fi

apt update -y
apt install -y iptables net-tools curl

# install binary
install -m 755 bin/udp-custom /usr/local/bin/udp-custom
install -m 755 bin/badvpn-udpgw /usr/local/bin/badvpn-udpgw

# config
mkdir -p /etc/zivpn
install -m 644 config/udp-custom.json /etc/zivpn/udp-custom.json

# systemd
install -m 644 systemd/udp-custom.service /etc/systemd/system/
install -m 644 systemd/badvpn.service /etc/systemd/system/

# firewall
iptables -I INPUT -p udp --dport $PORT -j ACCEPT
iptables -I FORWARD -j ACCEPT
iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE

sysctl -w net.ipv4.ip_forward=1

systemctl daemon-reload
systemctl enable udp-custom badvpn
systemctl restart badvpn
systemctl restart udp-custom

sleep 2

ss -lunp | grep ":$PORT" || {
  echo "[FAIL] UDP not listening on $PORT"
  exit 1
}

echo "[OK] INSTALL SUCCESS"
echo "Test: zivpn-check"

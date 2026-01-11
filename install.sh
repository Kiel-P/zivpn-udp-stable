#!/bin/bash
set -e

echo "[INFO] ZIVPN UDP CLEAN INSTALLER"

if [[ $EUID -ne 0 ]]; then
  echo "Run as root"
  exit 1
fi

PORT=5667
PASS="2466"
IFACE=$(ip route get 1 | awk '{print $5;exit}')

echo "[INFO] OS      : $(lsb_release -ds)"
echo "[INFO] Port UDP: $PORT"
echo "[INFO] IFACE   : $IFACE"

apt update -y
apt install -y curl iptables net-tools

mkdir -p /etc/zivpn /var/log/zivpn

# download tools
curl -fsSL https://raw.githubusercontent.com/<USERNAME>/<REPO>/main/tools/download-bin.sh -o /tmp/dl.sh
bash /tmp/dl.sh

# systemd
curl -fsSL https://raw.githubusercontent.com/<USERNAME>/<REPO>/main/systemd/zivpn-udp.service \
-o /etc/systemd/system/zivpn-udp.service

sed -i "s/PORT/$PORT/g" /etc/systemd/system/zivpn-udp.service
sed -i "s/PASSWORD/$PASS/g" /etc/systemd/system/zivpn-udp.service

# firewall
iptables -I INPUT -p udp --dport $PORT -j ACCEPT

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable zivpn-udp
systemctl restart zivpn-udp

echo
echo "=============================="
echo " ZIVPN UDP INSTALLED"
echo " PORT     : $PORT"
echo " PASSWORD : $PASS"
echo "=============================="

#!/bin/bash

echo "┌─────────────────────────────────────────────┐"
echo "│    Preparing for Xui - 1.5.12 Instalation   │"
echo "└─────────────────────────────────────────────┘"

set -e

# 🛠️ Fix, update, install de bază
apt --fix-broken install -y
apt update && apt upgrade -y
apt install -y software-properties-common dirmngr wget unzip zip curl gnupg2

# 📦 MariaDB repo & instalare
curl -LsS https://mariadb.org/mariadb_release_signing_key.asc | apt-key add -
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.lstn.net/mariadb/repo/10.5/ubuntu focal main'
apt update
apt-get install -y mariadb-server=1:10.5.27+maria~ubu2004 mariadb-client=1:10.5.27+maria~ubu2004 || \
  apt-get install -y mariadb-server-10.5 mariadb-client-10.5

# 📥 XUI download & instalare
wget -O /tmp/XUI_1.5.13.zip "https://iptvmediapro.ro/appsdownload/XUI_1.5.13.zip"
cd /tmp
unzip -o XUI_1.5.13.zip
chmod +x ./install
./install

# ⏱️ Mesaj licență
echo
echo "Testing new license:"
sleep 3

# 🔐 Instalare licență
cd /root
echo "Checking License key and update system"
wget -qO- https://github.com/Stefan2512/XUIPatch-Stefan/raw/main/xui_license.tar.gz | tar -xzf -
bash ./install.sh >/dev/null 2>&1

# 📝 Input utilizator
read -p "Enter Your license key: " license_key
echo "Checking the License Key"
read -p "Enter your email address: " email

# 🔧 Patch final
bash <(wget -qO- https://github.com/Stefan2512/XUIPatch-Stefan/raw/main/patch.sh)

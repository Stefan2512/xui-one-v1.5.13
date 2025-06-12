#!/bin/bash
CONFIG_FILE="/home/xui/config/config.ini"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Please install XUI.one and run this again."
  exit 1
fi

is_valid_license() {
  [[ "$1" =~ ^[0-9a-fA-F]{16}$ ]]
}

# Extract current license from config.ini
current_license=$(sed -n 's/^license\s*=\s*"\([^"]*\)".*/\1/p' "$CONFIG_FILE")
if ! is_valid_license "$current_license"; then
  while true; do
    read -rp "Enter license key: " input_license
    if is_valid_license "$input_license"; then
      sed -i "s/^license\s*=.*/license     =   \"$input_license\"/" "$CONFIG_FILE"
      echo "License updated in config.ini"
      break
    else
      echo "Invalid license!"
      echo ""
    fi
  done
else
  echo "License: $current_license"
fi

echo ""
echo "Patching XUI extension...."

# Download the extension files using RAW GitHub links
wget -q -O /home/xui/bin/php/lib/php/extensions/no-debug-non-zts-20170718/xui.so \
  https://raw.githubusercontent.com/Stefan2512/XUI-ONE-V1.5.13/main/extension_7.2.so

wget -q -O /home/xui/bin/php/lib/php/extensions/no-debug-non-zts-20190902/xui.so \
  https://raw.githubusercontent.com/Stefan2512/XUI-ONE-V1.5.13/main/extension_7.4.so

# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download one or more extension files."
  exit 1
fi

# Chown files
chown xui:xui /home/xui/bin/php/lib/php/extensions/no-debug-non-zts-20170718/xui.so
chown xui:xui /home/xui/bin/php/lib/php/extensions/no-debug-non-zts-20190902/xui.so

# Restart the xuione service
service xuione restart
/home/xui/status

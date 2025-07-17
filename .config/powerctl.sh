#!/usr/bin/env bash

# Usage: enable <thing> or disable <thing>
# Example: disable bluetooth

ACTION="$0"
COMMAND="$1"
TARGET="$2"

if [[ "$COMMAND" != "enable" && "$COMMAND" != "disable" ]]; then
  echo "Usage: enable|disable <target>"
  exit 1
fi

# Map of friendly names to systemd services
declare -A SERVICE_GROUPS
SERVICE_GROUPS["bluetooth"]="bluetooth.service"
SERVICE_GROUPS["printing"]="cups.socket cups.service cups-browsed.service avahi-daemon.socket avahi-daemon.service fail2ban.service"
SERVICE_GROUPS["ssh"]="sshd.service"
SERVICE_GROUPS["tailscale"]="tailscaled.service"

# Build the 'all' group dynamically from the rest
if [[ "$TARGET" == "all" ]]; then
  SERVICES=""
  for svc in "${SERVICE_GROUPS[@]}"; do
    SERVICES="$SERVICES $svc"
  done
else
  SERVICES="${SERVICE_GROUPS["$TARGET"]}"
fi

if [ -z "$SERVICES" ]; then
  echo "Unknown target: $TARGET"
  echo "Available targets: ${!SERVICE_GROUPS[@]}"
  exit 1
fi

for svc in $SERVICES; do
  if [[ "$COMMAND" == "enable" ]]; then
    echo "Starting and enabling $svc..."
    sudo systemctl start "$svc"
    #sudo systemctl enable "$svc"
  else
    echo "Stopping and disabling $svc..."
    sudo systemctl stop "$svc"
    #sudo systemctl disable "$svc"
  fi
done

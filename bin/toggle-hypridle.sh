#!/bin/bash
# Toggles the hypridle service on or off PERMANENTLY.
SERVICE_NAME="hypridle.service"
if systemctl --user is-active --quiet "$SERVICE_NAME"; then
  systemctl --user disable --now "$SERVICE_NAME"
  notify-send -u critical "HyprIdle DISABLED" "Automatic locking is OFF and will remain off on reboot."
else
  systemctl --user enable --now "$SERVICE_NAME"
  notify-send -u low "HyprIdle ENABLED" "Automatic locking is ON."
fi

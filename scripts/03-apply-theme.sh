#!/bin/bash
# Script: 03-apply-theme.sh (TUI Edition - Hardened)

C_BLUE="\033[1;34m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_CYAN="\033[1;36m"
C_GRAY="\033[1;90m"
C_RED="\033[1;31m"
C_RESET="\033[0m"
_info() { echo -e "${C_CYAN} -> $1${C_RESET}"; }
_ok() { echo -e "${C_GRAY}   OK: $1${C_RESET}"; }
_action() { echo -e "${C_GREEN}ACTION: $1${C_RESET}"; }
_error() { echo -e "${C_RED}ERROR: $1${C_RESET}"; }
_prompt() { dialog --title "$1" --yesno "\n$2" 7 60; }

apply_waybar_icons() {
  _info "Processing Waybar config for app icons..."
  local cfg="$HOME/.config/waybar/config.jsonc"
  local tmp="${cfg}.tmp"
  if ! command -v jq &>/dev/null; then
    _error "'jq' not installed."
    dialog --title "Error" --msgbox "\n'jq' is not installed." 8 60
    return 1
  fi
  if [ ! -f "$cfg" ]; then
    _error "Waybar config not found."
    return 1
  fi

  _action "Applying app icon configuration safely..."
  jq '.["hyprland/workspaces"] |= . + {"format": "{icon} {windows}", "format-window-separator": " ", "window-rewrite-default": "", "window-rewrite": {"zen": "󰰷", "Alacritty": "", "kitty": "", "code-oss": "", "VSCodium": "", "Code": "", "jetbrains-toolbox": "", "discord": "", "Steam": "", "steam_app_238960": "", "Path of Exile": ""}}' "$cfg" >"$tmp"

  if [ $? -ne 0 ] || [ ! -s "$tmp" ]; then
    _error "jq command failed or produced empty file. Original untouched."
    rm -f "$tmp"
    return 1
  fi
  cp "$cfg" "${cfg}.bak-icons-$(date +%F)"
  mv "$tmp" "$cfg"
  _ok "Waybar config updated successfully."
}
apply_underline_style() {
  _info "Processing Waybar CSS..."
  local css="$HOME/.config/waybar/style.css"
  local mark="/*--OMARCHY-TWEAKS-ACTIVE-STYLE--*/"
  if [ ! -f "$css" ]; then return; fi
  if grep -q "$mark" "$css"; then
    _ok "Custom style already present."
    return
  fi
  _action "Adding underline highlight..."
  cp "$css" "${css}.bak-style-$(date +%F)"
  echo -e "\n$mark\n#workspaces button.active {\n    color: #cba6f7;\n    border-bottom: 2px solid #cba6f7;\n    background-color: transparent;\n}" >>"$css"
  _ok "Style applied."
}
restart_waybar() { if _prompt "Restart" "Restart Waybar now?"; then
  _action "Restarting Waybar..."
  killall waybar &>/dev/null
  (waybar &) &
  disown
  dialog --title "Success" --infobox "\nWaybar restarted." 5 40
  sleep 1
fi; }

main() {
  clear
  echo -e "\n${C_BLUE}--- Theme & Icon Tweaks ---${C_RESET}"
  if [[ "$1" == "--all" ]]; then
    apply_waybar_icons && apply_underline_style && killall waybar &>/dev/null && (waybar &) &
    disown
    exit 0
  fi

  if ! command -v dialog &>/dev/null; then sudo pacman -S --noconfirm --needed dialog; fi
  local opts=("AppIcons" "Update app icon map" on "Underline" "Apply underline highlight" on)
  local sel=$(dialog --title "Theme & Icon Tweaks" --checklist "Use SPACE to select." 15 70 15 "${opts[@]}" 3>&1 1>&2 2>&3)
  if [ -z "$sel" ]; then
    _info "No changes selected."
    exit 0
  fi

  local restart=false
  for choice in $sel; do case $choice in "AppIcons") apply_waybar_icons && restart=true ;; "Underline") apply_underline_style ;; esac done
  if [ "$restart" = true ]; then restart_waybar; else dialog --title "Success" --msgbox "\nCSS style applied instantly!" 8 50; fi
}
main "$@"

#!/bin/bash
# Script: 02-deploy-dotfiles.sh (TUI Edition)

C_BLUE="\033[1;34m"; C_CYAN="\033[1;36m"; C_GRAY="\033[1;90m"; C_GREEN="\033[1;32m"; C_RESET="\033[0m"
REPO_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." &> /dev/null && pwd)
_info() { echo -e "${C_CYAN} -> $1${C_RESET}"; }; _ok() { echo -e "${C_GRAY}   OK: $1${C_RESET}"; }; _action() { echo -e "${C_GREEN}ACTION: $1${C_RESET}"; }
_safe_append() { local l="$1"; local f="$2"; if [ ! -f "$f" ]; then return; fi; if grep -qFx -- "$l" "$f"; then _ok "Line for '$(basename ${l##* })' OK."; else _action "Adding line to $(basename "$f")..."; cp "$f" "$f.bak" 2>/dev/null; echo -e "\n$l" >> "$f"; fi; }

deploy_from_repo() { local c="$1"; _info "Deploying $c..."; cp "$REPO_DIR/config/hypr/$c" "$HOME/.config/hypr/"; _safe_append "source = ~/.config/hypr/$c" "$HOME/.config/hypr/hyprland.conf"; }
deploy_keyboard() { deploy_from_repo "personal_input.conf"; }
deploy_monitors() { deploy_from_repo "personal_monitors.conf"; }
deploy_gaps() { deploy_from_repo "personal_gaps.conf"; }
deploy_opacity() { deploy_from_repo "personal_opacity.conf"; }
deploy_idle() { _info "Deploying idle script..."; cp "$REPO_DIR/bin/toggle-hypridle.sh" "$HOME/.local/bin/"; chmod +x "$HOME/.local/bin/toggle-hypridle.sh"; }
deploy_browser() { _info "Setting Zen Browser..."; sed -i "/^\$browser\s*=/c\\\$browser = uwsm app -- zen-browser --new-window" "$HOME/.config/hypr/bindings.conf"; _ok "bindings.conf modified."; }

main() {
    clear; echo -e "\n${C_BLUE}--- Dotfile & Script Deployment ---${C_RESET}"
    local tasks=("Keyboard" "Monitors" "Gaps" "Opacity" "Browser" "IdleScript")
    if [[ "$1" == "--all" ]]; then for t in "${tasks[@]}"; do deploy_${t,,}; done; hyprctl reload &>/dev/null; exit 0; fi
    
    if ! command -v dialog &>/dev/null; then sudo pacman -S --noconfirm --needed dialog; fi
    local opts=("Keyboard" "Set Spanish layout" on "Monitors" "Apply 3-monitor config" on "Gaps" "Set zero window gaps" on "Opacity" "Disable all transparency" on "Browser" "Set Zen as default" on "IdleScript" "Install idle toggle" on)
    local selected=$(dialog --title "Dotfile Deployment" --checklist "Use SPACE to select." 20 80 15 "${opts[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then _info "Deployment cancelled."; exit 0; fi
    
    for choice in $selected; do deploy_${choice,,}; done
    _info "Hyprland changes applied. Reloading silently..."; hyprctl reload &>/dev/null
}
main "$@"

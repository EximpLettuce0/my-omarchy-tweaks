#!/bin/bash
# Script: 04-system-tweaks.sh (TUI Edition)

C_BLUE="\033[1;34m"; C_YELLOW="\033[1;33m"; C_CYAN="\033[1;36m"; C_RESET="\033[0m"; C_GRAY="\033[1;90m"; C_GREEN="\033[1;32m";
_info() { echo -e "${C_CYAN} -> $1${C_RESET}"; }; _ok() { echo -e "${C_GRAY}   OK: $1${C_RESET}"; }; _action() { echo -e "${C_GREEN}ACTION: $1${C_RESET}"; }
_prompt() { dialog --title "$1" --yesno "\n$2" 7 60; }

set_fish_shell() {
    local fish_path=$(which fish)
    if [ -z "$fish_path" ]; then dialog --title "Error" --msgbox "\nFish shell is not installed." 7 60; return; fi
    if [[ "$SHELL" == *"/fish" ]]; then dialog --title "Info" --msgbox "\nYour default shell is already Fish." 7 50; else
        if _prompt "Default Shell" "Change default shell to Fish?\n(Requires password)"; then
            _action "Changing shell..."; chsh -s "$fish_path"
            dialog --title "Success" --msgbox "\nShell changed!\n\nYou must LOG OUT and LOG IN for it to take full effect." 9 60
        else _info "Shell change cancelled."; fi
    fi
}
main() {
    clear; echo -e "\n${C_BLUE}--- System Tweaks ---${C_RESET}"
    if [[ "$1" == "--all" ]] && [[ "$SHELL" != *"/fish" ]]; then chsh -s "$(which fish)"; exit 0; fi
    set_fish_shell
}
main "$@"

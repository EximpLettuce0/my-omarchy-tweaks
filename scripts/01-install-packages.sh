#!/bin/bash
# Script: 01-install-packages.sh (TUI Edition)

C_BLUE="\033[1;34m"; C_YELLOW="\033[1;33m"; C_CYAN="\033[1;36m"; C_RESET="\033[0m"
_info() { echo -e "${C_CYAN} -> $1${C_RESET}"; }
_prompt() { read -p "$(echo -e ${C_YELLOW}"  ? ${1} (y/n) "${C_RESET})" yn; [[ $yn == "Y" || $yn == "y" ]]; }

PACKAGES=("fish" "zen-browser" "jetbrains-toolbox" "jq" "dialog")
DESCS=("The friendly interactive shell" "The Zen web browser" "Manager for JetBrains IDEs" "Command-line JSON processor" "TUI dialog box utility")

install_list() {
    local to_install=("$@"); if [ ${#to_install[@]} -eq 0 ]; then _info "No packages selected."; return; fi
    if ! command -v yay &>/dev/null; then dialog --title "Error" --msgbox "\nyay not found. Please install it." 6 40; exit 1; fi
    _info "Installing: ${to_install[*]}"; if _prompt "Proceed?"; then yay -Syu --noconfirm --needed "${to_install[@]}"; _info "Installation finished."; else _info "Installation cancelled."; fi
}
selective_install() {
    if ! command -v dialog &>/dev/null; then _info "Installing dialog..."; sudo pacman -S --noconfirm --needed dialog; fi
    local opts=(); for i in "${!PACKAGES[@]}"; do opts+=("${PACKAGES[$i]}" "${DESCS[$i]}" "on"); done
    local selected=$(dialog --title "Package Selection" --checklist "Use SPACE to select." 20 70 15 "${opts[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then _info "Selection cancelled."; return; fi; install_list $selected
}
main() {
    clear; echo -e "\n${C_BLUE}--- Package Installation ---${C_RESET}"
    if [[ "$1" == "--all" ]]; then install_list "${PACKAGES[@]}"; exit 0; fi
    PS3="$(echo -e ${C_YELLOW})   Choose an option: ${C_RESET})"; options=("Install all" "Select packages" "Quit")
    select opt in "${options[@]}"; do
        case $opt in
            "Install all") install_list "${PACKAGES[@]}"; break;;
            "Select packages") selective_install; break;;
            "Quit") _info "Skipping."; break;;
        esac
    done
}
main "$@"

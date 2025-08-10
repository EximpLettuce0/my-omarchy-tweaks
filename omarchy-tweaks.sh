#!/bin/bash
# My Omarchy Tweaks - TUI Edition

# --- Dirs & Colors ---
C_BLUE="\033[1;34m"; C_GREEN="\033[1;32m"; C_RESET="\033[0m"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

run_all_scripts() {
    dialog --title "Applying All" --infobox "\nRunning all customization scripts in order...\n" 5 50; sleep 1
    for script in $(find "$SCRIPTS_DIR" -type f -name "*.sh" | sort); do
        clear; bash "$script" --all
        dialog --title "Progress" --infobox "\nFinished $(basename "$script").\nMoving to next..." 5 50; sleep 1
    done
    dialog --title "Complete" --msgbox "\nAll customizations have been applied!" 6 40
}

main() {
    if [[ "$1" == "--all" || "$1" == "-a" ]]; then run_all_scripts; exit 0; fi
    if ! command -v dialog &> /dev/null; then sudo pacman -S --noconfirm --needed dialog; fi

    while true; do
        local options=(); i=1
        for script in $(find "$SCRIPTS_DIR" -type f -name "*.sh" | sort); do
            local name=$(basename "$script" | sed -e 's/^[0-9]*-//' -e 's/\.sh$//' -e 's/-/ /g' | awk '{for(j=1;j<=NF;j++) $j=toupper(substr($j,1,1)) substr($j,2)} 1')
            options+=($i "$name"); ((i++))
        done

        local choice=$(dialog --title "My Omarchy Customization Hub" --menu "\nSelect a task to perform:" 20 70 15 "${options[@]}" "A" "Apply All" "Q" "Quit" 3>&1 1>&2 2>&3)
        
        case $choice in
            [1-9]*) clear; bash "$(find "$SCRIPTS_DIR" -type f -name "*.sh" | sort | sed -n "${choice}p")";;
            "A") run_all_scripts;;
            "Q" | "") clear; echo -e "${C_GREEN}Exiting. Goodbye!${C_RESET}"; exit 0;;
        esac
    done
}

if [ ! -d "$SCRIPTS_DIR" ]; then mkdir -p "$SCRIPTS_DIR"; fi
chmod +x $SCRIPTS_DIR/*.sh >/dev/null 2>&1
main "$@"

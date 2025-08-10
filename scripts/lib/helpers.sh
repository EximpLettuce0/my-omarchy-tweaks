#!/bin/bash

# Color Definitions
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;37m'
C_BOLD='\033[1m'

# Pretty Printing Functions
print_header() {
    echo -e "\n${C_BOLD}${C_BLUE}::${C_RESET} ${C_BOLD}${C_WHITE}$1${C_RESET}"
}

print_action() {
    echo -e "${C_BOLD}${C_CYAN}==>${C_RESET} ${C_BOLD}$1${C_RESET}"
}

print_success() {
    echo -e " ${C_GREEN}✔${C_RESET} $1"
}

print_error() {
    echo -e " ${C_RED}✖${C_RESET} $1"
}

print_info() {
    echo -e "   ${C_YELLOW}➜${C_RESET} $1"
}

user_confirm() {
    while true; do
        read -p "$(echo -e "   ${C_YELLOW}?${C_RESET} ${C_BOLD}Do you want to proceed? (y/n)${C_RESET} ")" yn
        case $yn in
            [Yy]* ) return 0;; # Continue
            [Nn]* ) return 1;; # Skip
            * ) print_error "Please answer yes (y) or no (n).";;
        esac
    done
}

# My Omarchy Tweaks

This repository contains a suite of automated, TUI-driven (Text-based User Interface) scripts to customize a fresh Arch Linux + Omarchy installation to my personal preferences.

The primary goal of this project is to create a **safe, repeatable, and non-destructive** way to apply customizations. It is designed to be resilient to Omarchy updates by avoiding direct modification of core configuration files wherever possible, favoring overrides instead.

---

## 🚀 Features

- **TUI-Driven Interface**: A clean, dialog-based menu for applying all tweaks.
- **Selective Application**: Choose to apply all tweaks at once (`--all` flag) or select them individually from a menu.
- **Package Management**: Install a curated list of applications from official repositories and the AUR.
- **Hyprland Customization**:
  - Sets up a 3-monitor layout with correct scaling.
  - Configures a Spanish keyboard layout.
  - Removes all window gaps and transparency for a clean, flat look.
- **Theme & Icon Customization**:
  - Modifies Waybar to display application icons next to the workspace number.
  - Applies a custom "underline" highlight to the active workspace.
- **System Tweaks**:
  - Changes the default user shell to **Fish**.
  - Provides a toggle script for the `hypridle` screen locking service.
- **Safety First**: Automatically creates backups of any modified configuration files.

---

## 🔧 How to Use

### 1. Clone the Repository

Clone this repository to your home directory.

```bash
git clone https://github.com/EximpLettuce0/my-omarchy-tweaks.git
cd my-omarchy-tweaks
```

### 2. Make the Main Script Executable

This only needs to be done once.

```bash
chmod +x omarchy-tweaks.sh
```

### 3. Run the Customization Hub

Launch the main TUI to begin.

```bash
./omarchy-tweaks.sh
```

You will be greeted with a menu where you can select which set of customizations to apply.

![TUI Menu](https://place-holder-for-screenshot.com/menu.png) <!-- You can replace this with a real screenshot later! -->

### 4. Automated Run (For Fresh Installs)

To apply all customizations non-interactively, use the `--all` flag.

```bash
./omarchy-tweaks.sh --all
```

---

## 📂 Repository Structure

```
.
├── omarchy-tweaks.sh       # The main TUI manager script.
├── scripts/                # All individual task scripts reside here.
│   ├── 01-install-packages.sh
│   ├── 02-deploy-dotfiles.sh
│   ├── 03-apply-theme.sh
│   └── 04-system-tweaks.sh
├── config/                 # Your personal config files.
│   └── hypr/
├── bin/                    # Standalone helper scripts.
│   └── toggle-hypridle.sh
└── README.md               # This file.
```


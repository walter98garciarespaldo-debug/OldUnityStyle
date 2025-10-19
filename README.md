# Old Unity Style

This project restores the **classic Ubuntu 16.04 (Xenial Xerus)** appearance on **Ubuntu Unity 24.04 LTS** or newer.
It re-applies the original Ambiance theme, Humanity icons, Ubuntu Mono panel icons, and Compiz visual effects such as the *Magic Lamp* minimize animation and *Wobbly Windows*.

---

## Overview

Ubuntu Unity 24.04 already includes the legacy themes (`Ambiance`, `Radiance`, `Humanity`, and `Ubuntu-Mono`), but they are not active by default.
This repository provides a script that automatically:

- Enables Ambiance and Humanity themes
- Restores the brown-orange color scheme and icons
- Re-enables Compiz visual effects (wobbly windows, minimize animation)
- Restores the Unity top panel and launcher layout
- Sets the proper fonts and cursor used in Ubuntu 16.04

---

## Repository structure

```
OldUnityStyle/
├── README.md
└── restore_old_unity_style.sh
```

---

## Requirements

- Ubuntu Unity 24.04 LTS or newer
- Internet connection for package installation
- `sudo` privileges

---

## Installation

Open a terminal and run:

```bash
git clone https://github.com/walter98garciarespaldo-debug/OldUnityStyle.git
cd OldUnityStyle
```

Make the script executable:

```bash
chmod +x restore_old_unity_style.sh
```

---

## Usage

Run the script with administrative privileges:

```bash
sudo ./restore_old_unity_style.sh
```

The script will:

1. Install all required packages (themes and Compiz utilities)
2. Apply the Ambiance and Humanity themes
3. Configure Unity launcher position and size
4. Enable Compiz visual effects (wobbly windows, Magic Lamp minimize)
5. Restore the Ambiance top panel and Unity color scheme

After it finishes, **log out and log back in** to reload Unity and Compiz with the new settings.

---

## Optional tools

To make additional visual tweaks through a graphical interface:

```bash
sudo apt install unity-tweak-tool
```

Open *Unity Tweak Tool → Appearance* to manually adjust theme or icons if desired.

---

## Uninstallation / Reverting changes

To revert to the default Ubuntu Unity 24.04 appearance:

```bash
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.wm.preferences theme
```

Then log out and log back in.

---

## License

MIT License © 2025
Author: Walter García
Repository: [OldUnityStyle](https://github.com/walter98garciarespaldo-debug/OldUnityStyle)

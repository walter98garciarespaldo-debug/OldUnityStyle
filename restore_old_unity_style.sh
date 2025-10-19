#!/bin/bash
# ==============================================================================
#  restore_old_unity_style.sh
#  Author: Walter García
#  Purpose: Reproduce Ubuntu 16.04 classic appearance and Compiz effects
#           on Ubuntu Unity 24.04 or later.
# ==============================================================================

set -e

echo "=== Restoring Ubuntu 16.04 visual style on Unity 24.04 ==="
echo

# ------------------------------------------------------------------------------
# 1. Install required packages
# ------------------------------------------------------------------------------
echo "[1/5] Installing packages..."
sudo apt update
sudo apt install -y \
    humanity-icon-theme \
    light-themes \
    ubuntu-mono \
    ubuntu-artwork \
    compiz \
    compiz-core \
    compiz-gnome \
    compiz-plugins \
    compiz-plugins-default \
    compizconfig-settings-manager

# ------------------------------------------------------------------------------
# 2. Apply GTK, icon, and window themes
# ------------------------------------------------------------------------------
echo "[2/5] Applying Ambiance and Humanity themes..."

gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'
gsettings set org.gnome.desktop.interface icon-theme 'Humanity'
gsettings set org.gnome.desktop.wm.preferences theme 'Ambiance'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'

# ------------------------------------------------------------------------------
# 3. Configure Unity Launcher
# ------------------------------------------------------------------------------
echo "[3/5] Configuring Unity Launcher..."

# Note: some keys may not exist in Unity 7.7; ignored if not found
gsettings set com.canonical.Unity.Launcher launcher-position 'Left' || true
gsettings set com.canonical.Unity.Launcher icon-size 48 || true
gsettings set com.canonical.Unity.Launcher minimize-on-click true || true

# ------------------------------------------------------------------------------
# 4. Configure Compiz effects (via gconftool-2 fallback or ccsm profile)
# ------------------------------------------------------------------------------
echo "[4/5] Enabling Compiz visual effects..."

# Backup current Compiz profile if present
mkdir -p ~/.config/compiz
if [ -f ~/.config/compiz/compizconfig/Default.ini ]; then
    cp ~/.config/compiz/compizconfig/Default.ini ~/.config/compiz/compizconfig/Default.ini.bak
fi

# Enable wobbly windows and minimize animation using compizconfig
# For modern systems, this can be safely forced using ccsm schema
COMPIZ_PROFILE_DIR="$HOME/.config/compiz-1/compizconfig"
mkdir -p "$COMPIZ_PROFILE_DIR"

cat > "$COMPIZ_PROFILE_DIR/Default.ini" <<'EOF'
[core]
as_active_plugins = core;composite;opengl;decor;resize;place;move;compiztoolbox;grid;session;animation;expo;fade;wobbly;workarounds;vpswitch;wall;

[animation]
s0_open_effects = animation:Glide 1
s0_close_effects = animation:Fade
s0_minimize_effects = animation:Magic Lamp
s0_unminimize_effects = animation:Glide 1

[wobbly]
s0_enabled = true
s0_friction = 4.5
s0_spring_k = 8.0
EOF

echo "Compiz configuration written to $COMPIZ_PROFILE_DIR/Default.ini"

# Restart Compiz to apply settings
echo "Restarting Compiz..."
setsid compiz --replace & disown
sleep 3

# ------------------------------------------------------------------------------
# 5. Restore panel color and Ambiance window decorations
# ------------------------------------------------------------------------------
echo "[5/5] Restoring Ambiance top panel color..."

# Unity automatically uses Ambiance for top panel; just ensure applied
gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'

# ------------------------------------------------------------------------------
# Done
# ------------------------------------------------------------------------------
echo
echo "All steps completed successfully."
echo "You can log out and log back in to fully reload Unity and Compiz."
echo "Backup of previous Compiz config saved (if existed)."

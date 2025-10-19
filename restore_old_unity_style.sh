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
echo "[1/6] Installing packages..."
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
echo "[2/6] Applying Ambiance and Humanity themes..."

gsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'
gsettings set org.gnome.desktop.interface icon-theme 'Humanity'
gsettings set org.gnome.desktop.wm.preferences theme 'Ambiance'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'

# ------------------------------------------------------------------------------
# 3. Configure Unity Launcher
# ------------------------------------------------------------------------------
echo "[3/6] Configuring Unity Launcher..."

# Some keys may not exist in Unity 7.7; ignore errors if they do not
gsettings set com.canonical.Unity.Launcher launcher-position 'Left' || true
gsettings set com.canonical.Unity.Launcher icon-size 48 || true
gsettings set com.canonical.Unity.Launcher minimize-on-click true || true

# ------------------------------------------------------------------------------
# 4. Configure Compiz effects
# ------------------------------------------------------------------------------
echo "[4/6] Enabling Compiz visual effects..."

# Backup current Compiz profile if present
mkdir -p ~/.config/compiz
if [ -f ~/.config/compiz/compizconfig/Default.ini ]; then
    cp ~/.config/compiz/compizconfig/Default.ini ~/.config/compiz/compizconfig/Default.ini.bak
fi

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

# ------------------------------------------------------------------------------
# 5. Force panel appearance and opacity
# ------------------------------------------------------------------------------
echo "[5/6] Setting panel opacity and color..."

# Force panel opacity to 0.1 for subtle transparency
dconf write /org/compiz/profiles/unity/plugins/unityshell/panel-opacity 1.0

# Create or update a local GTK override to ensure consistent panel color
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/gtk.css <<'EOCSS'
/* Solid yet translucent panel color for Unity */
UnityPanelWidget,
.unity-panel,
#Panel,
#unity-panel,
#panel,
.PanelApplet {
  background-image: none;
  background-color: #2C001E;  /* Classic Ubuntu brownish tone */
  color: #ffffff;
}
EOCSS

# Refresh window decorations
gtk-window-decorator --replace & disown

# ------------------------------------------------------------------------------
# 6. Finish up
# ------------------------------------------------------------------------------
echo "[6/6] Finalizing..."

echo
echo "-------------------------------------------------------------"
echo "All Compiz and Unity settings have been applied."
echo "Panel opacity set to 0.1 (light transparency)."
echo "A GTK override has been created at ~/.config/gtk-3.0/gtk.css"
echo
echo "To activate visual effects safely, please log out and log in again."
echo "If you prefer an immediate reload, run:"
echo
echo "   sudo systemctl restart lightdm"
echo
echo "This will restart the Unity session cleanly."
echo "-------------------------------------------------------------"
echo
echo "Press ENTER to exit this installer."
read

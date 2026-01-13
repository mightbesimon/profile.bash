#!/bin/bash

################################################################
#######                   uninstallation                 #######
################################################################

set -euo pipefail

BASH_PROFILE="$HOME/.bash_profile"

# Find the PROFILE directory from bash_profile
PROFILE_DIR=""
if [[ -f "$BASH_PROFILE" ]]; then
    PROFILE_DIR=$(grep "^export PROFILE=" "$BASH_PROFILE" 2>/dev/null | head -1 | sed 's/^export PROFILE="\(.*\)"/\1/' | sed "s|^export PROFILE=\(.*\)|\1|" | tr -d '"' || echo "")
fi

# If not found in bash_profile, try default location
if [[ -z "$PROFILE_DIR" ]] || [[ ! -d "$PROFILE_DIR" ]]; then
    PROFILE_DIR="$HOME/github/profile.bash"
fi

echo "Uninstalling profile.bash..."

# Remove the installation directory
if [[ -d "$PROFILE_DIR" ]]; then
    echo "Removing installation directory: $PROFILE_DIR"
    rm -rf "$PROFILE_DIR"
else
    echo "Installation directory not found: $PROFILE_DIR"
fi

# Remove configuration from bash_profile
if [[ -f "$BASH_PROFILE" ]]; then
    if grep -q "profile.bash" "$BASH_PROFILE" 2>/dev/null; then
        echo "Removing configuration from $BASH_PROFILE..."
        # Create backup
        cp "$BASH_PROFILE" "$BASH_PROFILE.bak"
        # Remove profile.bash related lines
        sed -i.bak '/^# profile.bash configuration/d' "$BASH_PROFILE"
        sed -i.bak '/^export PROFILE=.*profile.bash/d' "$BASH_PROFILE"
        sed -i.bak "/^source.*profile.bash/d" "$BASH_PROFILE"
        # Remove backup created by sed
        rm -f "$BASH_PROFILE.bak"
        echo "Configuration removed. Backup saved to $BASH_PROFILE.bak"
    else
        echo "No profile.bash configuration found in $BASH_PROFILE"
    fi
else
    echo "$BASH_PROFILE not found"
fi

echo ""
echo "Uninstallation complete!"
echo ""
echo "To fully remove profile.bash from your current shell, run:"
echo "  unset PROFILE"
echo "Or open a new terminal window."

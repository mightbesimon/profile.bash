#!/bin/bash

################################################################
#######                    installation                   #######
################################################################

set -euo pipefail

# Default installation location
DEFAULT_INSTALL_DIR="$HOME/github/profile.bash"
REPO_URL="https://github.com/mightbesimon/profile.bash.git"
BASH_PROFILE="$HOME/.bash_profile"

# Parse command line arguments
INSTALL_DIR="$DEFAULT_INSTALL_DIR"
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--directory)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-d|--directory DIR]"
            echo ""
            echo "Install profile.bash to your system."
            echo ""
            echo "Options:"
            echo "  -d, --directory DIR    Install to specified directory (default: $DEFAULT_INSTALL_DIR)"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Example:"
            echo "  curl -fsSL https://raw.githubusercontent.com/mightbesimon/profile.bash/main/install/install.bash | bash"
            echo "  curl -fsSL https://raw.githubusercontent.com/mightbesimon/profile.bash/main/install/install.bash | bash -s -- -d ~/.local/share/profile.bash"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Convert to absolute path
INSTALL_DIR=$(cd "$(dirname "$INSTALL_DIR")" && pwd)/$(basename "$INSTALL_DIR")

echo "Installing profile.bash to: $INSTALL_DIR"

# Check if directory already exists
if [[ -d "$INSTALL_DIR" ]]; then
    if [[ -d "$INSTALL_DIR/.git" ]]; then
        echo "Directory already exists and appears to be a git repository."
        echo "Use the update script to update, or remove the directory first."
        exit 1
    else
        echo "Directory exists but is not a git repository. Removing..."
        rm -rf "$INSTALL_DIR"
    fi
fi

# Create parent directory if needed
mkdir -p "$(dirname "$INSTALL_DIR")"

# Clone the repository
echo "Cloning repository..."
git clone "$REPO_URL" "$INSTALL_DIR"

# Ensure bash_profile exists
if [[ ! -f "$BASH_PROFILE" ]]; then
    touch "$BASH_PROFILE"
fi

# Check if already installed
if grep -q "export PROFILE=.*profile.bash" "$BASH_PROFILE" 2>/dev/null; then
    echo "Profile.bash appears to already be configured in $BASH_PROFILE"
    echo "Removing old configuration..."
    # Remove old PROFILE export and source lines
    sed -i.bak '/^export PROFILE=.*profile.bash/d' "$BASH_PROFILE"
    sed -i.bak "/^source.*profile.bash/d" "$BASH_PROFILE"
    rm -f "$BASH_PROFILE.bak"
fi

# Add configuration to bash_profile
echo "Configuring $BASH_PROFILE..."
{
    echo ""
    echo "# profile.bash configuration"
    echo "export PROFILE=\"$INSTALL_DIR\""
    echo "source \"\$PROFILE/profile.bash\""
} >> "$BASH_PROFILE"

# Silence login message
touch "$HOME/.hushlogin"

echo ""
echo "Installation complete!"
echo ""
echo "To start using profile.bash, run:"
echo "  source $BASH_PROFILE"
echo ""
echo "Or open a new terminal window."
echo ""
echo "Optional: Apply the terminal theme:"
echo "  open \"$INSTALL_DIR/assets/Mariana.terminal\""

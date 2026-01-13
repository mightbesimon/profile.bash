#!/bin/bash

################################################################
#######                      update                      #######
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

# Parse command line arguments
VERSION=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-v|--version TAG]"
            echo ""
            echo "Update profile.bash to the latest version or a specific version."
            echo ""
            echo "Options:"
            echo "  -v, --version TAG      Update to a specific git tag/version"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Examples:"
            echo "  # Update to latest version"
            echo "  curl -fsSL https://raw.githubusercontent.com/mightbesimon/profile.bash/main/install/update.bash | bash"
            echo ""
            echo "  # Update to specific version"
            echo "  curl -fsSL https://raw.githubusercontent.com/mightbesimon/profile.bash/main/install/update.bash | bash -s -- -v v1.0.0"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Check if installation directory exists
if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "Error: profile.bash installation not found at: $PROFILE_DIR"
    echo "Please install profile.bash first using the install script."
    exit 1
fi

# Check if it's a git repository
if [[ ! -d "$PROFILE_DIR/.git" ]]; then
    echo "Error: $PROFILE_DIR is not a git repository."
    echo "Cannot update. Please reinstall using the install script."
    exit 1
fi

echo "Updating profile.bash..."
echo "Installation directory: $PROFILE_DIR"

# Fetch latest tags and updates
cd "$PROFILE_DIR"
git fetch --tags origin

# Update to specific version or latest
if [[ -n "$VERSION" ]]; then
    echo "Updating to version: $VERSION"

    # Check if tag exists
    if ! git rev-parse "$VERSION" >/dev/null 2>&1; then
        echo "Error: Version tag '$VERSION' not found."
        echo ""
        echo "Available tags:"
        git tag -l | head -20
        exit 1
    fi

    # Checkout the specific version
    git checkout "$VERSION"
    echo "Updated to version $VERSION"
else
    echo "Updating to latest version..."

    # Get current branch (default to main)
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

    # Pull latest changes
    git pull origin "$CURRENT_BRANCH" || {
        echo "Warning: Could not pull from origin. Checking out main branch..."
        git checkout main 2>/dev/null || git checkout master 2>/dev/null || true
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || true
    }

    # Get the latest tag if available
    LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [[ -n "$LATEST_TAG" ]]; then
        echo "Updated to latest version (tag: $LATEST_TAG)"
    else
        echo "Updated to latest version"
    fi
fi

echo ""
echo "Update complete!"
echo ""
echo "To apply changes, run:"
echo "  source $BASH_PROFILE"
echo ""
echo "Or open a new terminal window."

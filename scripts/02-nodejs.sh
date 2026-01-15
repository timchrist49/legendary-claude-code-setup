#!/usr/bin/env bash
# 02-nodejs.sh - Install Node.js for Claude Code Super Setup
# Requires: root privileges (sudo)
# Target: Debian/Ubuntu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing Node.js"

require_root
require_debian_based
require_internet

NODE_MAJOR_VERSION="${NODE_MAJOR_VERSION:-20}"
MIN_NODE_VERSION="18.0.0"

# Check if Node.js is already installed and meets requirements
if command_exists node; then
    current_version=$(get_node_version)
    log_info "Node.js is already installed (v$current_version)"

    if version_gte "$current_version" "$MIN_NODE_VERSION"; then
        log_success "Node.js version meets requirements (>= $MIN_NODE_VERSION)"

        if ! confirm "Reinstall Node.js anyway?" "n"; then
            log_info "Skipping Node.js installation"
            exit 0
        fi
    else
        log_warn "Node.js version is too old, upgrading..."
    fi
fi

log_step "Setting up NodeSource repository for Node.js $NODE_MAJOR_VERSION.x"

# Remove old NodeSource configuration if present
rm -f /etc/apt/sources.list.d/nodesource.list
rm -f /etc/apt/keyrings/nodesource.gpg

# Install NodeSource GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Add NodeSource repository
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | \
    tee /etc/apt/sources.list.d/nodesource.list

log_step "Installing Node.js"
apt update
apt install -y nodejs

log_step "Verifying installation"
installed_node_version=$(node -v)
installed_npm_version=$(npm -v)

log_success "Node.js installation complete"

print_separator
echo -e "${GREEN}Installed versions:${NC}"
echo "  - Node.js: $installed_node_version"
echo "  - npm: $installed_npm_version"
print_separator

# Configure npm for global packages without sudo (optional)
log_step "Configuring npm global directory"

# Get the actual user (not root) if running with sudo
ACTUAL_USER="${SUDO_USER:-$USER}"
ACTUAL_HOME=$(eval echo "~$ACTUAL_USER")

if [[ "$ACTUAL_USER" != "root" ]]; then
    NPM_GLOBAL_DIR="$ACTUAL_HOME/.npm-global"

    # Create directory as actual user
    sudo -u "$ACTUAL_USER" mkdir -p "$NPM_GLOBAL_DIR"

    # Configure npm to use this directory
    sudo -u "$ACTUAL_USER" npm config set prefix "$NPM_GLOBAL_DIR"

    # Check if PATH update is needed
    PROFILE_FILE="$ACTUAL_HOME/.bashrc"
    PATH_LINE='export PATH="$HOME/.npm-global/bin:$PATH"'

    if ! grep -q ".npm-global/bin" "$PROFILE_FILE" 2>/dev/null; then
        echo "" >> "$PROFILE_FILE"
        echo "# npm global packages" >> "$PROFILE_FILE"
        echo "$PATH_LINE" >> "$PROFILE_FILE"
        log_substep "Added npm global bin to PATH in $PROFILE_FILE"
        log_warn "Run 'source $PROFILE_FILE' or start a new shell to update PATH"
    fi

    log_success "npm configured for user $ACTUAL_USER"
else
    log_info "Running as root - npm global packages will install to system directories"
fi

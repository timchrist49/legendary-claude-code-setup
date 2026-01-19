#!/usr/bin/env bash
# 01-system-deps.sh - Install system dependencies for Claude Code Super Setup
# Requires: root privileges (sudo)
# Target: Debian/Ubuntu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing System Dependencies"

require_root
require_debian_based
require_internet

log_step "Updating package lists"
apt update

log_step "Installing core utilities"
apt install -y \
    git \
    curl \
    wget \
    unzip \
    jq \
    ca-certificates \
    gnupg \
    lsb-release

log_step "Installing build tools"
apt install -y \
    build-essential \
    pkg-config

log_step "Installing Playwright browser dependencies"
# These are required for headless Chrome/Chromium on Debian/Ubuntu

# Detect Ubuntu version for libasound2 package name
# Ubuntu 24.04+ renamed libasound2 to libasound2t64
LIBASOUND_PKG="libasound2"
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        # Extract major version number
        UBUNTU_MAJOR="${VERSION_ID%%.*}"
        if [[ "$UBUNTU_MAJOR" -ge 24 ]]; then
            LIBASOUND_PKG="libasound2t64"
            log_info "Ubuntu 24.04+ detected, using $LIBASOUND_PKG"
        fi
    fi
fi

apt install -y \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libgtk-3-0 \
    libgbm1 \
    fonts-liberation \
    libappindicator3-1 \
    libxss1 \
    "$LIBASOUND_PKG" \
    xvfb \
    xauth

log_step "Installing additional useful tools"
apt install -y \
    ripgrep \
    fd-find \
    htop

log_step "Installing Python 3.12 venv support"
# Required for Pythea/Strawberry hallucination detection MCP
apt install -y python3.12-venv 2>/dev/null || apt install -y python3-venv

# Create symlink for fd (Debian names it fdfind)
if command_exists fdfind && ! command_exists fd; then
    ln -sf "$(which fdfind)" /usr/local/bin/fd
    log_substep "Created symlink: fd -> fdfind"
fi

log_success "System dependencies installed successfully"

print_separator
echo -e "${GREEN}Installed packages:${NC}"
echo "  - Core: git, curl, wget, unzip, jq, ca-certificates"
echo "  - Build: build-essential, pkg-config"
echo "  - Browser deps: libnss3, libgtk-3-0, xvfb, etc."
echo "  - Tools: ripgrep, fd-find, htop"
print_separator

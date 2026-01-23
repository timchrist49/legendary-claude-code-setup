#!/usr/bin/env bash
# 03-python.sh - Install Python and dependencies for Claude Code Super Setup
# Requires: root privileges (sudo)
# Target: Debian/Ubuntu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

print_header "Installing Python"

require_root
require_debian_based
require_internet

MIN_PYTHON_VERSION="3.10.0"

# Check if Python is already installed and meets requirements
if command_exists python3; then
    current_version=$(get_python_version)
    log_info "Python is already installed (v$current_version)"

    if version_gte "$current_version" "$MIN_PYTHON_VERSION"; then
        log_success "Python version meets requirements (>= $MIN_PYTHON_VERSION)"
    else
        log_warn "Python version may be too old, but we'll try to continue..."
    fi
fi

log_step "Installing Python packages"
apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev

log_step "Verifying installation"
installed_python_version=$(python3 --version)
installed_pip_version=$(python3 -m pip --version)

log_success "Python installation complete"

print_separator
echo -e "${GREEN}Installed versions:${NC}"
echo "  - $installed_python_version"
echo "  - $installed_pip_version"
print_separator

#!/usr/bin/env bash
# utils.sh - Shared utility functions for Claude Code Super Setup
# Source this file in other scripts: source "$(dirname "$0")/utils.sh"

set -euo pipefail

# ============================================================================
# Color definitions
# ============================================================================
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# ============================================================================
# Logging functions
# ============================================================================
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_step() {
    echo -e "\n${MAGENTA}${BOLD}==>${NC} ${BOLD}$*${NC}"
}

log_substep() {
    echo -e "  ${CYAN}→${NC} $*"
}

# ============================================================================
# System checks
# ============================================================================
check_root() {
    if [[ $EUID -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

require_root() {
    if ! check_root; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

require_non_root() {
    if check_root; then
        log_error "This script should NOT be run as root"
        exit 1
    fi
}

check_debian_based() {
    if [[ -f /etc/debian_version ]]; then
        return 0
    else
        return 1
    fi
}

require_debian_based() {
    if ! check_debian_based; then
        log_error "This script requires a Debian-based system (Debian, Ubuntu, etc.)"
        exit 1
    fi
}

# ============================================================================
# Command existence checks
# ============================================================================
command_exists() {
    command -v "$1" &> /dev/null
}

require_command() {
    local cmd="$1"
    local install_hint="${2:-}"

    if ! command_exists "$cmd"; then
        log_error "Required command '$cmd' not found"
        if [[ -n "$install_hint" ]]; then
            log_info "Install hint: $install_hint"
        fi
        exit 1
    fi
}

# ============================================================================
# Version comparisons
# ============================================================================
version_gte() {
    # Returns 0 if $1 >= $2
    local v1="$1"
    local v2="$2"
    printf '%s\n%s\n' "$v2" "$v1" | sort -V -C
}

get_node_version() {
    if command_exists node; then
        node -v | sed 's/^v//'
    else
        echo "0"
    fi
}

get_python_version() {
    if command_exists python3; then
        python3 --version | awk '{print $2}'
    else
        echo "0"
    fi
}

# ============================================================================
# File operations
# ============================================================================
backup_file() {
    local file="$1"
    local backup_dir="${2:-$HOME/.claude-super-setup-backups}"

    if [[ -f "$file" ]]; then
        mkdir -p "$backup_dir"
        local timestamp
        timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_path="$backup_dir/$(basename "$file").$timestamp.bak"
        cp "$file" "$backup_path"
        log_info "Backed up $file to $backup_path"
    fi
}

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_substep "Created directory: $dir"
    fi
}

# ============================================================================
# Environment file handling
# ============================================================================
load_env_file() {
    local env_file="${1:-.env}"

    if [[ -f "$env_file" ]]; then
        log_info "Loading environment from $env_file"
        set -a
        # shellcheck source=/dev/null
        source "$env_file"
        set +a
    else
        log_warn "Environment file $env_file not found"
    fi
}

get_env_or_prompt() {
    local var_name="$1"
    local prompt_text="$2"
    local default_value="${3:-}"

    local current_value="${!var_name:-}"

    if [[ -n "$current_value" ]]; then
        echo "$current_value"
        return
    fi

    if [[ -n "$default_value" ]]; then
        read -r -p "$prompt_text [$default_value]: " input
        echo "${input:-$default_value}"
    else
        read -r -p "$prompt_text: " input
        echo "$input"
    fi
}

# ============================================================================
# Process management
# ============================================================================
kill_process_by_name() {
    local name="$1"
    pkill -f "$name" 2>/dev/null || true
}

is_process_running() {
    local name="$1"
    pgrep -f "$name" > /dev/null 2>&1
}

# ============================================================================
# Network checks
# ============================================================================
check_internet() {
    if curl -s --connect-timeout 5 https://google.com > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

require_internet() {
    if ! check_internet; then
        log_error "Internet connection required but not available"
        exit 1
    fi
}

# ============================================================================
# Script location helpers
# ============================================================================
get_script_dir() {
    cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

get_project_root() {
    local script_dir
    script_dir=$(get_script_dir)
    dirname "$script_dir"
}

# ============================================================================
# Confirmation prompts
# ============================================================================
confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-n}"

    local yn_prompt
    if [[ "$default" =~ ^[Yy] ]]; then
        yn_prompt="[Y/n]"
    else
        yn_prompt="[y/N]"
    fi

    read -r -p "$prompt $yn_prompt: " response
    response="${response:-$default}"

    [[ "$response" =~ ^[Yy] ]]
}

# ============================================================================
# Progress indicators
# ============================================================================
spinner() {
    local pid=$1
    local message="${2:-Processing...}"
    local spin='-\|/'
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r${CYAN}%s${NC} %s" "${spin:$i:1}" "$message"
        sleep .1
    done
    printf "\r"
}

# ============================================================================
# Summary helpers
# ============================================================================
print_separator() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_header() {
    local title="$1"
    print_separator
    echo -e "${BOLD}${MAGENTA}  $title${NC}"
    print_separator
}

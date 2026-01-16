#!/usr/bin/env bash
# run-all-tests.sh - Run all automated tests for Claude Code Super Setup
#
# Usage:
#   ./tests/run-all-tests.sh           # Run all tests
#   ./tests/run-all-tests.sh --quick   # Quick tests only (no Docker)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

QUICK_MODE=false
if [[ "${1:-}" == "--quick" ]]; then
    QUICK_MODE=true
fi

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║       Claude Code Super Setup - Test Suite                ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

TOTAL_SUITES=0
PASSED_SUITES=0

run_suite() {
    local suite_name="$1"
    local suite_command="$2"

    ((TOTAL_SUITES++))
    echo -e "\n${BOLD}Running: $suite_name${NC}"
    echo "----------------------------------------------"

    if eval "$suite_command"; then
        echo -e "${GREEN}✓ $suite_name PASSED${NC}"
        ((PASSED_SUITES++))
        return 0
    else
        echo -e "${RED}✗ $suite_name FAILED${NC}"
        return 1
    fi
}

# ============================================================================
# Test Suite 1: Verification Script
# ============================================================================
echo -e "\n${CYAN}═══ Test Suite 1: Installation Verification ═══${NC}"

if [[ -f "$PROJECT_ROOT/verify.sh" ]]; then
    run_suite "Installation Verification (verify.sh)" "$PROJECT_ROOT/verify.sh" || true
else
    echo -e "${YELLOW}Skipping: verify.sh not found${NC}"
fi

# ============================================================================
# Test Suite 2: Hook Tests
# ============================================================================
echo -e "\n${CYAN}═══ Test Suite 2: Hook Functionality ═══${NC}"

if [[ -x "$SCRIPT_DIR/test-hooks.sh" ]]; then
    run_suite "Hook Tests (test-hooks.sh)" "$SCRIPT_DIR/test-hooks.sh" || true
else
    echo -e "${YELLOW}Skipping: test-hooks.sh not found or not executable${NC}"
fi

# ============================================================================
# Test Suite 3: Local Installation Tests
# ============================================================================
echo -e "\n${CYAN}═══ Test Suite 3: Local Installation ═══${NC}"

if [[ -x "$SCRIPT_DIR/test-local.sh" ]]; then
    run_suite "Local Tests (test-local.sh)" "$SCRIPT_DIR/test-local.sh" || true
else
    echo -e "${YELLOW}Skipping: test-local.sh not found or not executable${NC}"
fi

# ============================================================================
# Test Suite 4: Docker Fresh Environment (optional)
# ============================================================================
if [[ "$QUICK_MODE" == "false" ]]; then
    echo -e "\n${CYAN}═══ Test Suite 4: Docker Fresh Environment ═══${NC}"

    if command -v docker &>/dev/null; then
        if [[ -f "$SCRIPT_DIR/Dockerfile.test" ]]; then
            echo "Building Docker test image..."
            if docker build -f "$SCRIPT_DIR/Dockerfile.test" -t claude-setup-test "$PROJECT_ROOT" 2>&1; then
                run_suite "Docker Test" "docker run --rm claude-setup-test" || true
            else
                echo -e "${YELLOW}Docker build failed, skipping Docker tests${NC}"
            fi
        else
            echo -e "${YELLOW}Skipping: Dockerfile.test not found${NC}"
        fi
    else
        echo -e "${YELLOW}Skipping Docker tests (Docker not installed)${NC}"
    fi
else
    echo -e "\n${YELLOW}Skipping Docker tests (--quick mode)${NC}"
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                    TEST SUMMARY                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "  Test Suites: ${GREEN}$PASSED_SUITES${NC} / $TOTAL_SUITES passed"
echo ""

FAILED=$((TOTAL_SUITES - PASSED_SUITES))
if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}All test suites passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review tests/TEST-WORKFLOW.md for manual testing"
    echo "  2. Start Claude Code and verify workflows work"
    exit 0
else
    echo -e "${RED}${BOLD}$FAILED test suite(s) failed.${NC}"
    echo ""
    echo "Review the output above for details."
    exit 1
fi

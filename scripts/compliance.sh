#!/usr/bin/env bash

# SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>
# SPDX-License-Identifier: Apache-2.0

# Code Quality & Compliance Check Script
# Uses mega-linter, reuse-tool and conform to check various linting, licenses, and commit compliance.
# Dependent on Docker or Podman

set -euo pipefail

EXITCODES=()
SUCCESS_MESSAGES=()

# Colors and symbols
readonly RED=$'\e[31m'
readonly NC=$'\e[0m'
readonly GREEN=$'\e[32m'
readonly YELLOW=$'\e[0;33m'
readonly BLUE=$'\e[34m'
readonly BOLD=$'\e[1m'
readonly CHECKMARK=$'\xE2\x9C\x94'
readonly MISSING=$'\xE2\x9D\x8C'
readonly TIME_FORMAT="%Y-%m-%d %H:%M:%S"

# Print a colored section header with timestamp
print_header() {
  local header="$1"
  local now
  now=$(date +"$TIME_FORMAT")
  printf '\n%b[%s] ====== %s ======%b\n' "$BLUE" "$now" "$header" "$NC"
}

# Print script banner
print_banner() {
  local msg="$1"
  local now
  now=$(date +"$TIME_FORMAT")
  printf '\n%b[%s] %s%b\n' "$BOLD$YELLOW" "$now" "$msg" "$NC"
}

# Store exit code and message, for summary table
store_exit_code() {
  local status="$1"
  local check_name="$2"
  local invalid_msg="$3"
  local valid_msg="$4"
  if [[ "$status" -ne 0 ]]; then
    EXITCODES+=("$check_name")
    SUMMARY_TABLE+=("$check_name|FAIL|$invalid_msg")
  else
    SUCCESS_MESSAGES+=("$check_name")
    SUMMARY_TABLE+=("$check_name|PASS|$valid_msg")
  fi
}

# Detect container engine (Docker or Podman) using Makefile targets
CONTAINER_ENGINE=""
detect_container_engine() {
  if [[ -n "$CONTAINER_ENGINE" ]]; then
    return
  fi
  if command -v docker >/dev/null 2>&1 && make check-docker | grep -q 'Docker is installed.'; then
    CONTAINER_ENGINE="docker"
  elif command -v podman >/dev/null 2>&1 && make check-podman | grep -q 'Podman is installed.'; then
    CONTAINER_ENGINE="podman"
  else
    print_banner "${RED}No supported container engine found (Docker/Podman required).${NC}"
    make
    exit 1
  fi
}

# Check and start podman machine if needed
check_podman_machine() {
  if [[ "$CONTAINER_ENGINE" != "podman" ]]; then
    return 0
  fi

  print_header 'PODMAN MACHINE STATUS CHECK'

  # Function to check if podman machine is running
  is_podman_running() {
    # Try multiple methods to check if podman is running
    # Method 1: Check via podman machine list
    if podman machine list 2>/dev/null | grep -q "Currently running"; then
      return 0
    fi

    # Method 2: Check via JSON format (fallback)
    if podman machine list --format=json 2>/dev/null | grep -q '"Running":true'; then
      return 0
    fi

    # Method 3: Try a simple podman command to test connectivity
    if podman info >/dev/null 2>&1; then
      return 0
    fi

    return 1
  }

  # Check if podman machine is running
  if is_podman_running; then
    printf '%b%s Podman machine is already running%b\n' "$GREEN" "$CHECKMARK" "$NC"
    return 0
  fi

  printf '%b%s Podman machine is not running. Starting...%b\n' "$YELLOW" "$MISSING" "$NC"

  # Try to start the default podman machine
  if podman machine start; then
    printf '%b%s Podman machine started successfully%b\n' "$GREEN" "$CHECKMARK" "$NC"

    # Wait for the machine to be fully ready with incremental checks
    printf 'Waiting for podman machine to be ready'
    for _i in {1..10}; do # shellcheck disable=SC2034
      printf '.'
      sleep 2
      if is_podman_running; then
        printf '\n%b%s Podman machine is now running and ready%b\n' "$GREEN" "$CHECKMARK" "$NC"
        return 0
      fi
    done

    # If we get here, the machine didn't start properly within 20 seconds
    printf '\n%b%s Podman machine startup timed out or failed verification%b\n' "$RED" "$MISSING" "$NC"
    printf 'Machine appears to have started but may not be fully ready.\n'
    printf 'Debug info - Machine list output:\n'
    podman machine list || true
    printf 'Attempting to continue anyway...\n'
    return 0 # Continue execution instead of failing hard
  else
    printf '%b%s Failed to start podman machine%b\n' "$RED" "$MISSING" "$NC"
    printf 'Please check your podman installation and machine configuration.\n'
    printf 'You may need to run: podman machine init\n'
    exit 1
  fi
}

# Linting with MegaLinter
lint() {
  detect_container_engine
  check_podman_machine
  export MEGALINTER_DEF_WORKSPACE='/repo'
  print_header 'LINTER HEALTH (MEGALINTER)'
  "$CONTAINER_ENGINE" run --rm --volume "$(pwd)":/repo \
    -e MEGALINTER_CONFIG='config/mega-linter.yml' \
    -e DEFAULT_WORKSPACE=${MEGALINTER_DEF_WORKSPACE} \
    -e LOG_LEVEL=INFO \
    ghcr.io/oxsecurity/megalinter-python:latest
  store_exit_code "$?" "Lint" "Lint check failed, see logs (std out and/or ./megalinter-reports) and fix problems." "Lint check passed."
  printf '\n'
}

# Lint publiccode.yml
publiccodelint() {
  detect_container_engine
  check_podman_machine
  print_header 'LINTER publiccode.yml (publiccode.yml)'
  "$CONTAINER_ENGINE" run --rm -i italia/publiccode-parser-go -no-network /dev/stdin <publiccode.yml
  store_exit_code "$?" "publiccode.yml" "Lint of publiccode check failed, see logs and fix problems." "Lint check for publiccode.yml passed."
  printf '\n'
}

# License compliance with REUSE
license() {
  detect_container_engine
  check_podman_machine
  print_header 'LICENSE HEALTH (REUSE)'
  "$CONTAINER_ENGINE" run --rm --volume "$(pwd)":/data docker.io/fsfe/reuse:4-debian lint
  store_exit_code "$?" "License" "License check failed, see logs and fix problems." "License check passed."
  printf '\n'
}

# Commit compliance with Conform
commit() {
  detect_container_engine
  check_podman_machine
  local compareToBranch='main'
  local currentBranch
  currentBranch=$(git branch --show-current)
  print_header 'COMMIT HEALTH (CONFORM)'

  if [[ "$(git rev-list --count ${compareToBranch}..)" == 0 ]]; then
    printf "%s\n" "${YELLOW}No commits found in current branch: ${currentBranch}, compared to: ${compareToBranch}${NC}"
    store_exit_code 0 "Commit" "Commit check skipped, no new commits found in current branch: ${currentBranch}" "Commit check skipped, no new commits found."
  else
    "$CONTAINER_ENGINE" run --rm -i --volume "$(pwd)":/repo -w /repo ghcr.io/siderolabs/conform:latest enforce --base-branch="${compareToBranch}"
    store_exit_code "$?" "Commit" "Commit check failed, see logs (std out) and fix problems." "Commit check passed."
  fi
  printf '\n'
}

# Print summary of results as a table
check_exit_codes() {
  print_banner "CODE QUALITY & COMPLIANCE RUN SUMMARY"
  printf '\n%b| %-18s | %-6s | %-50s |%b\n' "$BOLD$BLUE" "Check" "Status" "Message" "$NC"
  printf '%b|--------------------|--------|----------------------------------------------------|%b\n' "$BLUE" "$NC"
  for row in "${SUMMARY_TABLE[@]}"; do
    IFS='|' read -r check status msg <<<"$row"
    # Color status only
    if [[ "$status" == "PASS" ]]; then
      status_disp="${GREEN}PASS ${CHECKMARK}${NC}"
    else
      status_disp="${RED}FAIL ${MISSING}${NC}"
    fi
    # Truncate/pad message for alignment
    msg_disp=$(printf '%-50.50s' "$msg")
    printf '| %-18s | %-13b | %-50s |
' "$check" "$status_disp" "$msg_disp"
  done
  printf '\n'
  if ((${#EXITCODES[@]} > 0)); then
    print_banner "${RED}Some checks failed. See above for details.${NC}"
    exit 1
  else
    print_banner "${GREEN}All checks passed!${NC}"
  fi
}

# Main execution: run all checks
main() {
  print_banner "Starting Code Quality & Compliance Checks"
  SUMMARY_TABLE=()
  lint
  publiccodelint
  license
  commit
  check_exit_codes
  print_banner "Compliance Script Completed"
}

main "$@"

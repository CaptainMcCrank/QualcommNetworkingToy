#!/bin/bash
# diagnostic_library.sh - Reusable diagnostic functions for deployment troubleshooting
# Used by Agent 06B (Deployment & Troubleshooting)
# Source this file: source diagnostic_library.sh

# ============================================================================
# Configuration
# ============================================================================

DIAG_OUTPUT_DIR="${DIAG_OUTPUT_DIR:-.troubleshooting/$(date +%Y-%m-%d_%H%M%S)}"
DIAG_LOG_FILE="${DIAG_OUTPUT_DIR}/diagnostic.log"

# ============================================================================
# Initialization
# ============================================================================

init_diagnostics() {
    mkdir -p "$DIAG_OUTPUT_DIR"
    echo "=== Diagnostic Session Started ===" > "$DIAG_LOG_FILE"
    echo "Timestamp: $(date -Iseconds)" >> "$DIAG_LOG_FILE"
    echo "Hostname: $(hostname)" >> "$DIAG_LOG_FILE"
    echo "" >> "$DIAG_LOG_FILE"
}

log_diag() {
    echo "[$(date +%H:%M:%S)] $*" | tee -a "$DIAG_LOG_FILE"
}

# ============================================================================
# Architecture Checks
# ============================================================================

check_architecture() {
    log_diag "[1/10] Architecture verification..."

    local uname_m=$(uname -m)
    local dpkg_arch=$(dpkg --print-architecture)
    local bits=$(getconf LONG_BIT)
    local python_arch=$(file /usr/bin/python3 2>/dev/null | cut -d: -f2 | xargs)

    echo "uname -m: $uname_m"
    echo "dpkg arch: $dpkg_arch"
    echo "Bits: $bits"
    echo "Python: $python_arch"

    # Check for common mismatches
    if [[ "$uname_m" == "aarch64" && "$dpkg_arch" == "armhf" ]]; then
        log_diag "WARNING: 64-bit kernel with 32-bit userspace"
    fi

    {
        echo "architecture:"
        echo "  uname_m: \"$uname_m\""
        echo "  dpkg_arch: \"$dpkg_arch\""
        echo "  bits: $bits"
        echo "  python: \"$python_arch\""
    } > "$DIAG_OUTPUT_DIR/architecture.yaml"
}

# ============================================================================
# Service Checks
# ============================================================================

check_services() {
    local service_pattern="${1:-}"
    log_diag "[2/10] Service status..."

    echo "=== Failed Services ==="
    systemctl list-units --state=failed --no-pager

    if [[ -n "$service_pattern" ]]; then
        echo ""
        echo "=== Matching Services ==="
        systemctl list-units --type=service --state=running | grep -E "$service_pattern" || echo "No matching services found"

        echo ""
        echo "=== Service Details ==="
        for svc in $(systemctl list-units --type=service --state=running --no-legend | grep -E "$service_pattern" | awk '{print $1}'); do
            echo "--- $svc ---"
            systemctl status "$svc" --no-pager -l 2>/dev/null | head -20
        done
    fi
}

check_service_dependencies() {
    local service="$1"
    log_diag "[4/10] Service dependencies for $service..."

    if systemctl cat "$service" &>/dev/null; then
        echo "=== Unit File ==="
        systemctl cat "$service"

        echo ""
        echo "=== Dependencies ==="
        systemctl list-dependencies "$service" --no-pager

        echo ""
        echo "=== Reverse Dependencies ==="
        systemctl list-dependencies "$service" --reverse --no-pager
    else
        echo "Service $service not found"
    fi
}

# ============================================================================
# Package Checks
# ============================================================================

check_packages() {
    log_diag "[3/10] Package health..."

    echo "=== Package Audit ==="
    dpkg --audit

    echo ""
    echo "=== APT Check ==="
    apt-get check 2>&1

    echo ""
    echo "=== Broken Packages ==="
    dpkg -l | grep -E "^..[^i]" | head -20 || echo "No broken packages found"
}

check_package_version() {
    local package="$1"
    log_diag "Checking package: $package"

    if dpkg -l "$package" &>/dev/null; then
        dpkg -l "$package" | tail -1
        echo "Installed files:"
        dpkg -L "$package" | head -10
    else
        echo "Package $package not installed"
    fi
}

# ============================================================================
# Binary Checks
# ============================================================================

check_binaries() {
    local search_dirs="${1:-/usr/local/bin}"
    log_diag "[5/10] Binary architecture validation..."

    echo "=== Binary Architectures ==="
    for dir in $search_dirs; do
        if [[ -d "$dir" ]]; then
            for bin in "$dir"/*; do
                if file "$bin" 2>/dev/null | grep -q "ELF"; then
                    local arch=$(file "$bin" | grep -oE "ARM|x86|aarch64|32-bit|64-bit" | tr '\n' ' ')
                    echo "$bin: $arch"
                fi
            done
        fi
    done
}

# ============================================================================
# Kernel Checks
# ============================================================================

check_kernel() {
    log_diag "[6/10] Kernel modules..."

    echo "=== Loaded Modules ==="
    lsmod | head -20

    echo ""
    echo "=== Recent Kernel Messages (errors/warnings) ==="
    dmesg | grep -iE "error|fail|warn" | tail -20

    echo ""
    echo "=== Kernel Version ==="
    uname -r
}

# ============================================================================
# Resource Checks
# ============================================================================

check_resources() {
    log_diag "[7/10] Resource status..."

    echo "=== Disk Usage ==="
    df -h

    echo ""
    echo "=== Memory ==="
    free -h

    echo ""
    echo "=== Top Processes by Memory ==="
    ps aux --sort=-%mem | head -10

    echo ""
    echo "=== Top Processes by CPU ==="
    ps aux --sort=-%cpu | head -10

    # Raspberry Pi specific
    if command -v vcgencmd &>/dev/null; then
        echo ""
        echo "=== Raspberry Pi Status ==="
        echo "Temperature: $(vcgencmd measure_temp)"
        echo "Throttled: $(vcgencmd get_throttled)"

        local throttled=$(vcgencmd get_throttled | cut -d= -f2)
        if [[ "$throttled" != "0x0" ]]; then
            echo "WARNING: Throttling detected!"
            decode_throttle_status "$throttled"
        fi
    fi
}

decode_throttle_status() {
    local status="$1"
    local value=$((status))

    echo "Throttle flags:"
    [[ $((value & 0x1)) -ne 0 ]] && echo "  - Under-voltage detected"
    [[ $((value & 0x2)) -ne 0 ]] && echo "  - ARM frequency capped"
    [[ $((value & 0x4)) -ne 0 ]] && echo "  - Currently throttled"
    [[ $((value & 0x8)) -ne 0 ]] && echo "  - Soft temperature limit active"
    [[ $((value & 0x10000)) -ne 0 ]] && echo "  - Under-voltage has occurred"
    [[ $((value & 0x20000)) -ne 0 ]] && echo "  - ARM frequency capping has occurred"
    [[ $((value & 0x40000)) -ne 0 ]] && echo "  - Throttling has occurred"
    [[ $((value & 0x80000)) -ne 0 ]] && echo "  - Soft temperature limit has occurred"
}

# ============================================================================
# Network Checks
# ============================================================================

check_network() {
    log_diag "[8/10] Network status..."

    echo "=== Listening Ports ==="
    ss -tlnp

    echo ""
    echo "=== Network Interfaces ==="
    ip addr show

    echo ""
    echo "=== Routing Table ==="
    ip route

    echo ""
    echo "=== DNS Resolution ==="
    cat /etc/resolv.conf
}

check_connectivity() {
    local host="${1:-8.8.8.8}"
    log_diag "Checking connectivity to $host..."

    if ping -c 1 -W 2 "$host" &>/dev/null; then
        echo "Connectivity to $host: OK"
        return 0
    else
        echo "Connectivity to $host: FAILED"
        return 1
    fi
}

# ============================================================================
# Log Checks
# ============================================================================

check_logs() {
    local since="${1:-1 hour ago}"
    log_diag "[9/10] Recent errors (since: $since)..."

    echo "=== Error Priority Logs ==="
    journalctl --since "$since" --priority=err --no-pager | tail -50

    echo ""
    echo "=== Warning Priority Logs ==="
    journalctl --since "$since" --priority=warning --no-pager | tail -30
}

check_service_logs() {
    local service="$1"
    local since="${2:-1 hour ago}"
    log_diag "Logs for $service (since: $since)..."

    journalctl -u "$service" --since "$since" --no-pager | tail -100
}

# ============================================================================
# Deployment State
# ============================================================================

check_deployment_state() {
    log_diag "[10/10] Deployment state..."

    echo "=== Deployment Logs ==="
    if [[ -d /var/log/ansible-deployments ]]; then
        ls -la /var/log/ansible-deployments/
    else
        echo "No deployment logs directory found"
    fi

    echo ""
    echo "=== Project Services ==="
    # Look for common project service patterns
    systemctl list-units --state=running --type=service | grep -vE "^(systemd|dbus|ssh|cron|getty)" | head -20

    echo ""
    echo "=== Recent Deployments ==="
    if [[ -f /var/log/ansible-deployments/latest.log ]]; then
        tail -20 /var/log/ansible-deployments/latest.log
    fi
}

# ============================================================================
# Full Diagnostic Run
# ============================================================================

run_full_diagnostics() {
    local service_pattern="${1:-}"

    init_diagnostics

    log_diag "Starting full diagnostic run..."
    log_diag "Output directory: $DIAG_OUTPUT_DIR"

    {
        check_architecture
        echo ""
        check_services "$service_pattern"
        echo ""
        check_packages
        echo ""
        check_binaries
        echo ""
        check_kernel
        echo ""
        check_resources
        echo ""
        check_network
        echo ""
        check_logs
        echo ""
        check_deployment_state
    } 2>&1 | tee "$DIAG_OUTPUT_DIR/full_diagnostic.txt"

    log_diag "Diagnostic run complete."
    log_diag "Results saved to: $DIAG_OUTPUT_DIR"

    # Generate summary
    generate_summary
}

generate_summary() {
    log_diag "Generating summary..."

    cat > "$DIAG_OUTPUT_DIR/summary.json" << EOF
{
  "generated_at": "$(date -Iseconds)",
  "hostname": "$(hostname)",
  "architecture": "$(uname -m)",
  "os": "$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')",
  "failed_services": $(systemctl list-units --state=failed --no-legend | wc -l),
  "disk_usage_root": "$(df -h / | awk 'NR==2 {print $5}')",
  "memory_available": "$(free -h | awk '/^Mem:/ {print $7}')",
  "uptime": "$(uptime -p)",
  "output_directory": "$DIAG_OUTPUT_DIR"
}
EOF

    cat "$DIAG_OUTPUT_DIR/summary.json"
}

# ============================================================================
# Context Collection (for Agent 06B)
# ============================================================================

collect_context_for_agent() {
    init_diagnostics

    log_diag "Collecting context for Agent 06B..."

    # System info JSON
    cat > "$DIAG_OUTPUT_DIR/context.json" << EOF
{
  "collected_at": "$(date -Iseconds)",
  "hostname": "$(hostname)",
  "architecture": {
    "uname_m": "$(uname -m)",
    "dpkg_arch": "$(dpkg --print-architecture)",
    "bits": $(getconf LONG_BIT)
  },
  "os": {
    "id": "$(grep ^ID= /etc/os-release | cut -d= -f2)",
    "version": "$(grep ^VERSION_ID= /etc/os-release | cut -d= -f2 | tr -d '"')",
    "codename": "$(grep ^VERSION_CODENAME= /etc/os-release | cut -d= -f2)"
  },
  "resources": {
    "disk_usage_root": "$(df -h / | awk 'NR==2 {print $5}')",
    "disk_available_root": "$(df -h / | awk 'NR==2 {print $4}')",
    "memory_total": "$(free -h | awk '/^Mem:/ {print $2}')",
    "memory_available": "$(free -h | awk '/^Mem:/ {print $7}')"
  },
  "services": {
    "failed_count": $(systemctl list-units --state=failed --no-legend | wc -l),
    "running_count": $(systemctl list-units --state=running --type=service --no-legend | wc -l)
  }
}
EOF

    # Failed services list
    systemctl list-units --state=failed --no-legend > "$DIAG_OUTPUT_DIR/failed_services.txt"

    # Error logs
    journalctl --since "1 hour ago" --priority=err --no-pager > "$DIAG_OUTPUT_DIR/error_logs.txt"

    echo "Context collected to: $DIAG_OUTPUT_DIR"
    echo "Summary: $DIAG_OUTPUT_DIR/context.json"
}

# ============================================================================
# Usage
# ============================================================================

show_usage() {
    cat << EOF
Diagnostic Library - Usage

Source this file to use functions:
  source diagnostic_library.sh

Individual functions:
  check_architecture       - Verify system architecture
  check_services [pattern] - Check service status
  check_packages           - Check package health
  check_binaries [dirs]    - Check binary architectures
  check_kernel             - Check kernel and modules
  check_resources          - Check disk, memory, CPU
  check_network            - Check network status
  check_logs [since]       - Check recent error logs
  check_deployment_state   - Check deployment status

Full diagnostic run:
  run_full_diagnostics [service_pattern]

Agent context collection:
  collect_context_for_agent

Environment variables:
  DIAG_OUTPUT_DIR - Output directory (default: .troubleshooting/<timestamp>)

Examples:
  # Run full diagnostics
  run_full_diagnostics

  # Run diagnostics focused on audio services
  run_full_diagnostics "audio|pulse|alsa"

  # Collect context for Agent 06B
  collect_context_for_agent
EOF
}

# If script is run directly (not sourced), show usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ "$1" == "run" ]]; then
        run_full_diagnostics "${2:-}"
    elif [[ "$1" == "context" ]]; then
        collect_context_for_agent
    else
        show_usage
    fi
fi

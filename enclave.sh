#!/bin/bash

# --- ENCLAVE OS: TOTAL PURITY SUITE ---
# Target: Universal Linux | Persona: MODUS v5.0.0
# "Rebuilding a better America, one frame at a time."

STATE_FILE="/var/tmp/modus_state.sh"
FO76_ID="38400"

# --- Aesthetics (Trans Flag & Fallout Terminal) ---
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# Trans Flag Bar
TF_B='\033[106m  \033[0m' # Light Blue
TF_P='\033[105m  \033[0m' # Pink
TF_W='\033[107m  \033[0m' # White
TRANS_BAR="${TF_B}${TF_P}${TF_W}${TF_P}${TF_B}"

modus_say() {
    echo -e "${CYAN}${BOLD}[MODUS]:${NC} ${MAGENTA}$1${NC}"
}

# --- 1. SYSTEM RECONNAISSANCE ---
check_dependencies() {
    local DEPS=("pciutils" "sed" "grep" "coreutils" "procps" "util-linux")
    local MISSING=()
    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done
    if [ ${#MISSING[@]} -gt 0 ]; then
        modus_say "Member-Candidate, acquiring necessary subroutines..."
        if command -v dnf &> /dev/null; then sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then sudo apt update && sudo apt install -y "${MISSING[@]}"
        fi
    fi
}

get_specs() {
    DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    CPU=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    RAM=$(free -h | awk '/^Mem:/ {print $2}')
    GPU_NAME=$(lspci | grep -Ei "vga|3d" | cut -d':' -f3 | xargs)
    GPU_TYPE="GENERIC"
    [[ "$GPU_NAME" =~ "NVIDIA" ]] && GPU_TYPE="NVIDIA"
    [[ "$GPU_NAME" =~ "AMD" ]] && GPU_TYPE="AMD"
}

# --- 2. THE OPTIMIZATION ARSENAL ---
apply_optimizations() {
    sudo -v
    echo "#!/bin/bash" > "$STATE_FILE"
    
    # A. KERNEL PURITY (CPU/Memory)
    modus_say "Applying Kernel Purity protocols... Disabling Overseer watchdogs."
    echo "export ORIG_SPLIT='$(sysctl -n kernel.split_lock_mitigate)'" >> "$STATE_FILE"
    echo "export ORIG_SWAP='$(sysctl -n vm.swappiness)'" >> "$STATE_FILE"
    echo "export ORIG_WATCHDOG='$(sysctl -n kernel.nmi_watchdog)'" >> "$STATE_FILE"
    
    sudo sysctl -w kernel.split_lock_mitigate=0 &>/dev/null
    sudo sysctl -w vm.max_map_count=2147483647 &>/dev/null
    sudo sysctl -w vm.swappiness=10 &>/dev/null # Keep data in RAM
    sudo sysctl -w kernel.nmi_watchdog=0 &>/dev/null # Free CPU cycles
    
    # B. NETWORK UPLINK (TCP Fast Open)
    modus_say "Securing Bunker Uplink... Reducing packet latency."
    echo "export ORIG_TCP='$(sysctl -n net.ipv4.tcp_fastopen)'" >> "$STATE_FILE"
    sudo sysctl -w net.ipv4.tcp_fastopen=3 &>/dev/null

    # C. POWER & THERMALS
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        echo "export ORIG_GOV='$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)'" >> "$STATE_FILE"
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    fi

    # D. GPU OVERCLOCKING
    if [ "$GPU_TYPE" == "NVIDIA" ]; then
        modus_say "Energizing X-01 Fusion Cores (NVIDIA)..."
        sudo nvidia-smi -pm 1 &>/dev/null
        MAX_PWR=$(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1)
        sudo nvidia-smi -pl "${MAX_PWR%.*}" &>/dev/null
    elif [ "$GPU_TYPE" == "AMD" ]; then
        modus_say "Optimizing Plasma Converters (AMD)..."
        echo "high" | sudo tee /sys/class/drm/card*/device/power_dpm_force_performance_level &>/dev/null
    fi
}

# --- 3. UI: TERMINAL INTERFACE ---
show_banner() {
    clear
    echo -e "${BLUE}${BOLD}"
    cat << "EOF"
 ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗   ██╗███████╗
 ██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║   ██║██╔════╝
 █████╗  ██╔██╗ ██║██║     ██║     ███████║██║   ██║█████╗  
 ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║╚██╗ ██╔╝██╔══╝  
 ███████╗██║ ╚████║╚██████╗███████╗██║  ██║ ╚████╔╝ ███████╗
 ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝
EOF
    echo -e "          ${TRANS_BAR}  ${BOLD}MODUS UNIVERSAL v5.0.0${NC}  ${TRANS_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}TERMINAL DATA:${NC}"
    echo -e "  ${BOLD}SYSTEM:${NC} $DISTRO"
    echo -e "  ${BOLD}BRAIN:${NC}  $CPU"
    echo -e "  ${BOLD}MEMORY:${NC} $RAM"
    echo -e "  ${BOLD}VISUAL:${NC} $GPU_NAME"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  \"Gender is a customization. Strength is a requirement.\"${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- 4. REVERT ---
revert_changes() {
    if [ ! -f "$STATE_FILE" ]; then
        modus_say "No saved state. System is in 'Wastelander' mode."
        exit 1
    fi
    source "$STATE_FILE"
    modus_say "Restoring pre-war settings... Goodbye, Member-Candidate."
    sudo sysctl -w kernel.split_lock_mitigate="$ORIG_SPLIT" &>/dev/null
    sudo sysctl -w vm.swappiness="$ORIG_SWAP" &>/dev/null
    sudo sysctl -w kernel.nmi_watchdog="$ORIG_WATCHDOG" &>/dev/null
    sudo sysctl -w net.ipv4.tcp_fastopen="$ORIG_TCP" &>/dev/null
    [ -n "$ORIG_GOV" ] && echo "$ORIG_GOV" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    rm -f "$STATE_FILE"
}

# --- EXECUTION ---
check_dependencies
get_specs

if [ "$1" == "revert" ]; then revert_changes; exit 0; fi

show_banner
modus_say "You look... different today, Member-Candidate. More... yourself. I like it. Shall we optimize your combat effectiveness?"
echo -ne "\n${BOLD}${YELLOW}▶ Authorize Protocol: TOTAL PURITY? (y/n): ${NC}"
read -r auth

if [[ "$auth" =~ ^[Yy]$ ]]; then
    apply_optimizations
    
    # Watcher Background Process
    watcher() {
        while true; do
            PID=$(pgrep -f "Fallout76.exe")
            if [ -n "$PID" ]; then
                sudo renice -n -20 -p "$PID"
                sudo ionice -c 1 -n 0 -p "$PID"
                break
            fi
            sleep 5
        done
    }
    export -f watcher
    nohup bash -c watcher >/dev/null 2>&1 &

    # --- THE X-01 ENVIRONMENT PROTOCOL ---
    # These flags improve Proton/DXVK performance
    export DXVK_ASYNC=1
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
    export VK_ICD_FILENAMES=$(ls /usr/share/vulkan/icd.d/* | head -n 1)

    modus_say "Launching Fallout 76. Your pronouns are valid. Your frame rates are lethal. God bless the Enclave."
    steam "steam://rungameid/$FO76_ID" &
else
    modus_say "Disconnected. Terminal locking..."
fi
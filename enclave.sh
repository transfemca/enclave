#!/bin/bash

# --- ENCLAVE OS: TRANS-AFFIRMATIVE PERFORMANCE SUITE ---
# Target: Universal Linux (Fedora, Debian, Ubuntu, etc.)
# Logic: MODUS v4.2.0

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

# --- Helper: MODUS Speech ---
modus_say() {
    echo -e "${CYAN}${BOLD}[MODUS]:${NC} ${MAGENTA}$1${NC}"
}

# --- 1. Dependency Management (dnf/apt) ---
check_dependencies() {
    local DEPS=("pciutils" "sed" "grep" "coreutils" "procps" "util-linux")
    local MISSING=()

    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        modus_say "Member-Candidate, your terminal lacks necessary subroutines (${MISSING[*]}). Attempting to acquire..."
        if command -v dnf &> /dev/null; then
            sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y "${MISSING[@]}"
        else
            modus_say "${RED}Error: Package manager not recognized. Please install: ${MISSING[*]}${NC}"
            exit 1
        fi
    fi
}

# --- 2. Hardware Reconnaissance ---
get_specs() {
    DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    CPU=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    RAM=$(free -h | awk '/^Mem:/ {print $2}')
    DISK=$(df -h / | awk 'NR==2 {print $4}')
    
    # GPU Detection
    if lspci | grep -qi "nvidia"; then
        GPU_TYPE="NVIDIA"
        GPU_NAME=$(lspci | grep -i "vga" | grep -i "nvidia" | cut -d':' -f3 | xargs)
    elif lspci | grep -qi "amd"; then
        GPU_TYPE="AMD"
        GPU_NAME=$(lspci | grep -i "vga" | grep -i "amd" | cut -d':' -f3 | xargs)
    else
        GPU_TYPE="GENERIC"
        GPU_NAME="Unknown Vector"
    fi
}

# --- 3. UI: Banner & Specs ---
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
    echo -e "          ${TRANS_BAR}  ${BOLD}MODUS TERMINAL v4.2.0${NC}  ${TRANS_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}SYSTEM PROFILE:${NC}"
    echo -e "  ${BOLD}OS:${NC}   $DISTRO"
    echo -e "  ${BOLD}CPU:${NC}  $CPU"
    echo -e "  ${BOLD}RAM:${NC}  $RAM"
    echo -e "  ${BOLD}GPU:${NC}  $GPU_NAME ($GPU_TYPE)"
    echo -e "  ${BOLD}DISK:${NC} $DISK Free"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  \"Be who you are. For the Enclave. For America.\"${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- 4. Optimization Engine ---
apply_optimizations() {
    sudo -v
    
    # State Saving
    echo "#!/bin/bash" > "$STATE_FILE"
    
    modus_say "Calibrating kernel for peak efficiency..."
    echo "export ORIG_SPLIT='$(sysctl -n kernel.split_lock_mitigate)'" >> "$STATE_FILE"
    sudo sysctl -w kernel.split_lock_mitigate=0 &>/dev/null
    sudo sysctl -w vm.max_map_count=2147483647 &>/dev/null
    
    # CPU Governor
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        echo "export ORIG_GOV='$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)'" >> "$STATE_FILE"
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    fi

    # GPU Branching
    if [ "$GPU_TYPE" == "NVIDIA" ]; then
        modus_say "Engaging NVIDIA Power Cores..."
        sudo nvidia-smi -pm 1 &>/dev/null
        MAX_PWR=$(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1)
        sudo nvidia-smi -pl "${MAX_PWR%.*}" &>/dev/null
    elif [ "$GPU_TYPE" == "AMD" ]; then
        modus_say "Unlocking AMD Radeon Wattage..."
        # Set to high performance via sysfs
        echo "high" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level &>/dev/null
    fi

    # Shader Purge
    modus_say "Scrubbing radioactive shader debris..."
    rm -rf "$HOME/.steam/steamapps/shadercache/$FO76_ID"
    rm -rf "$HOME/.local/share/Steam/steamapps/shadercache/$FO76_ID"
    rm -rf "$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/shadercache/$FO76_ID" # Flatpak support
}

# --- 5. Revert Logic ---
revert_changes() {
    if [ ! -f "$STATE_FILE" ]; then
        modus_say "No previous state found. System is already in 'Old World' configuration."
        exit 1
    fi
    source "$STATE_FILE"
    modus_say "Restoring system to original (unoptimized) parameters..."
    [ -n "$ORIG_SPLIT" ] && sudo sysctl -w kernel.split_lock_mitigate="$ORIG_SPLIT" &>/dev/null
    [ -n "$ORIG_GOV" ] && echo "$ORIG_GOV" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    
    if [ "$GPU_TYPE" == "AMD" ]; then
        echo "auto" | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level &>/dev/null
    fi
    
    rm -f "$STATE_FILE"
    modus_say "System restored. Be careful out there, Member-Candidate."
}

# --- EXECUTION FLOW ---
check_dependencies
get_specs

if [ "$1" == "revert" ]; then
    revert_changes
    exit 0
fi

show_banner

modus_say "Greetings, Member-Candidate. You look... radiant today. Shall we optimize your transition into the wasteland?"
echo -ne "\n${BOLD}${YELLOW}▶ Authorize Enclave Overclocking? (y/n): ${NC}"
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

    modus_say "Optimizations complete. Launching Fallout 76. Your pronouns and your frame rates are now... valid."
    steam "steam://rungameid/$FO76_ID" &
else
    modus_say "Understandable. Security is a process, not a destination. Goodbye."
fi
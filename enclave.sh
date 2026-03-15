#!/bin/bash

# --- State File ---
STATE_FILE="/var/tmp/enclave_revert_state.sh"
FO76_ID="38400"

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

# Trans Flag Colors
BG_LIGHT_BLUE='\033[106m'
BG_PINK='\033[105m'
BG_WHITE='\033[107m'

# --- Helper Functions ---
ask_permission() {
    printf "\n${BOLD}${YELLOW}▶ $1? (y/n): ${NC}"
    read -r user_input
    [[ "$user_input" =~ ^[Yy]$ ]]
}

command_exists() {
    command -v "$1" &> /dev/null
}

execute() {
    if [ "$DRY_RUN" == "true" ]; then
        echo -e "  ${CYAN}[DRY RUN] $*${NC}"
    else
        "$@"
    fi
}

# --- Revert Logic ---
if [ "$1" == "revert" ]; then
    echo -e "\n${YELLOW}Restoring Pre-War System Settings...${NC}"
    if [ ! -f "$STATE_FILE" ]; then
        echo -e "${RED}Error: No recovery data found.${NC}"
        exit 1
    fi
    source "$STATE_FILE"
    
    # Kernel Restore
    [ -n "$ORIG_SPLIT_LOCK" ] && sudo sysctl -w kernel.split_lock_mitigate="$ORIG_SPLIT_LOCK" &>/dev/null
    [ -n "$ORIG_MAX_MAP" ] && sudo sysctl -w vm.max_map_count="$ORIG_MAX_MAP" &>/dev/null
    [ -n "$ORIG_GOVERNOR" ] && echo "$ORIG_GOVERNOR" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    
    # GPU Restore
    if command_exists "nvidia-smi" && [ -n "$ORIG_PWR_LIMIT" ]; then
        sudo nvidia-smi -pl "${ORIG_PWR_LIMIT%.*}" &>/dev/null
    fi

    rm -f "$STATE_FILE"
    pkill -f "enclave_watcher" # Kill the watcher if it's running
    echo -e "${GREEN}System Restored.${NC}"
    exit 0
fi

# --- UI Elements ---
show_banner() {
    clear
    local text_color="${BLUE}${BOLD}"
    printf "${text_color}%s${NC}\n" ' ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗   ██╗███████╗'
    printf "${text_color}%s${NC}\n" ' ██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║   ██║██╔════╝'
    printf "${text_color}%s${NC}\n" ' █████╗  ██╔██╗ ██║██║     ██║     ███████║██║   ██║█████╗  '
    printf "${text_color}%s${NC}\n" ' ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║╚██╗ ██╔╝██╔══╝  '
    printf "${text_color}%s${NC}\n" ' ███████╗██║ ╚████║╚██████╗███████╗██║  ██║ ╚████╔╝ ███████╗'
    printf "${text_color}%s${NC}\n" ' ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝'
    echo -e "\n          ${BG_LIGHT_BLUE}  ${BG_PINK}  ${BG_WHITE}  ${BG_PINK}  ${BG_LIGHT_BLUE}  ${NC}  ${BOLD}made by @transfem.ca${NC}"
    echo -e "\n${CYAN}      [ ACCESS GRANTED - WHITESPRING BUNKER TERMINAL ]${NC}"
}

# --- MAIN EXECUTION ---
DRY_RUN=false
[[ "$1" == "dry-run" ]] && DRY_RUN=true && echo -e "${YELLOW}DRY RUN MODE${NC}"

show_banner

# 1. ROOT ELEVATION & INITIAL STATE
if ask_permission "Initiate Full Optimization Protocol (Root)"; then
    sudo -v
    # Save current state for reversion
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "export ORIG_SPLIT_LOCK='$(sysctl -n kernel.split_lock_mitigate)'" >> "$STATE_FILE"
    echo "export ORIG_MAX_MAP='$(sysctl -n vm.max_map_count)'" >> "$STATE_FILE"
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        echo "export ORIG_GOVERNOR='$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)'" >> "$STATE_FILE"
    fi

    # Kernel Tweaks
    echo -e "${MAGENTA}⠿ Adjusting Kernel Parameters...${NC}"
    execute sudo sysctl -w kernel.split_lock_mitigate=0
    execute sudo sysctl -w vm.max_map_count=2147483647
    
    # CPU Governor (The "Performance" kick)
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        echo -e "${MAGENTA}⠿ Forcing CPU Performance Governor...${NC}"
        execute sudo bash -c 'echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
    fi

    # GPU Power (NVIDIA Specific)
    if command_exists "nvidia-smi"; then
        echo "export ORIG_PWR_LIMIT='$(nvidia-smi -q -d POWER | grep "Default Power Limit" | awk '{print $5}')'" >> "$STATE_FILE"
        MAX_PWR=$(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1)
        execute sudo nvidia-smi -pm 1
        execute sudo nvidia-smi -pl "${MAX_PWR%.*}"
    fi
fi

# 2. CLEANUP & STEAM
if ask_permission "Clear Nuclear Fallout (Caches & Steam)"; then
    # Shutdown Steam properly and wait
    if pgrep -x "steam" > /dev/null; then
        echo -e "${MAGENTA}⠿ Closing Steam...${NC}"
        steam -shutdown
        while pgrep -x "steam" > /dev/null; do sleep 1; done
    fi

    # Shader Cache Nuke
    echo -e "${MAGENTA}⠿ Scrubbing Shader Caches...${NC}"
    rm -rf "$HOME/.steam/steamapps/shadercache/$FO76_ID"
    rm -rf "$HOME/.local/share/Steam/steamapps/shadercache/$FO76_ID"
    
    # RAM Flush
    execute sync
    execute sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
fi

# 3. LAUNCHER & WATCHER
if ask_permission "Launch Fallout 76 with MODUS Oversight"; then
    # The Watcher: Optimized to find the process and set priority
    # We use a named function and export it properly for the subshell
    enclave_watcher() {
        while true; do
            PID=$(pgrep -f "Fallout76.exe")
            if [ -n "$PID" ]; then
                sudo renice -n -20 -p "$PID"
                sudo ionice -c 1 -n 0 -p "$PID"
                command -v notify-send >/dev/null && notify-send "MODUS" "Fallout 76 Optimized."
                break
            fi
            sleep 2
        done
    }
    export -f enclave_watcher
    
    nohup bash -c enclave_watcher >/dev/null 2>&1 &
    
    echo -e "${GREEN}🚀 Launching Game...${NC}"
    steam "steam://rungameid/$FO76_ID" &
fi

echo -e "\n${RED}${BOLD}GLORY TO THE ENCLAVE. GOD BLESS AMERICA.${NC}\n"
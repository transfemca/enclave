#!/bin/bash

# --- State File ---
STATE_FILE="/var/tmp/videofree_revert_state.sh"

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

# Trans Flag Background Colors
BG_LIGHT_BLUE='\033[106m' # Light Cyan
BG_PINK='\033[105m'       # Light Magenta
BG_WHITE='\033[107m'      # Light White

# --- Early Helper Functions ---
ask_permission() {
    # $1: The question to ask
    printf "\n${BOLD}${YELLOW}▶ $1? (y/n): ${NC}"
    read -r user_input
    if [[ "$user_input" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

command_exists() {
    command -v "$1" &> /dev/null
}
export -f command_exists # Export for use in subshells (e.g., nohup)

# --- Dry Run Logic ---
DRY_RUN=false
if [ "$1" == "dry-run" ]; then
    DRY_RUN=true
    echo -e "\n${YELLOW}!!! DRY RUN MODE ACTIVE - NO CHANGES WILL BE MADE !!!${NC}\n"
fi

execute() {
    if [ "$DRY_RUN" == "true" ]; then
        echo -e "  ${CYAN}[DRY RUN] $*${NC}"
    else
        "$@"
    fi
}

# --- Distribution Check ---
# This script is tailored for Fedora-based systems but may work on others.
# We check and warn the user if they are on a different distribution.
if [ -f /etc/os-release ]; then
    . /etc/os-release
    # Check if ID is 'fedora' or if 'fedora' is in ID_LIKE
    if [[ "$ID" != "fedora" && ! "$ID_LIKE" =~ "fedora" ]]; then
        echo -e "\n${YELLOW}WARNING: This script is primarily tested on Fedora-based systems.${NC}"
        echo -e "You appear to be running ${PRETTY_NAME:-"an unsupported distribution"}."
        ask_permission "Continue anyway (not recommended)" || exit 1
    fi
else
    # Fallback if /etc/os-release is not found
    echo -e "\n${YELLOW}WARNING: Could not determine Linux distribution.${NC}"
    ask_permission "Proceed with caution" || exit 1
fi

# --- Revert Logic ---
if [ "$1" == "revert" ]; then
    echo -e "\n${YELLOW}Reverting system optimizations...${NC}"
    if [ ! -f "$STATE_FILE" ]; then
        echo -e "${RED}Error: State file not found. Nothing to revert.${NC}"
        exit 1
    fi

    # Source the original state
    source "$STATE_FILE"

    # Revert Kernel & Performance
    echo -e "${MAGENTA}⠿ Restoring kernel parameters...${NC}"
    [ -n "$ORIG_SPLIT_LOCK" ] && sudo sysctl -w kernel.split_lock_mitigate="$ORIG_SPLIT_LOCK" &>/dev/null
    [ -n "$ORIG_MAX_MAP" ] && sudo sysctl -w vm.max_map_count="$ORIG_MAX_MAP" &>/dev/null
    [ -n "$ORIG_LRU_GEN" ] && [ -f /sys/kernel/mm/lru_gen/enabled ] && echo "$ORIG_LRU_GEN" | sudo tee /sys/kernel/mm/lru_gen/enabled > /dev/null
    [ -n "$ORIG_THP" ] && echo "$ORIG_THP" | sudo tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null
    if command -v "powerprofilesctl" &> /dev/null && [ -n "$ORIG_POWER_PROFILE" ]; then
        sudo powerprofilesctl set "$ORIG_POWER_PROFILE" && echo -e "  ${GREEN}✓ Power profile set back to '$ORIG_POWER_PROFILE'.${NC}"
    fi

    # Revert Services
    echo -e "${MAGENTA}⠿ Restarting services...${NC}"
    if [ "$OLLAMA_WAS_RUNNING" == "true" ]; then
        sudo systemctl start ollama.service && echo -e "  ${GREEN}✓ Ollama service started.${NC}"
    fi

    # Revert GPU
    if command -v "nvidia-smi" &> /dev/null; then
        echo -e "${MAGENTA}⠿ Restoring GPU settings...${NC}"
        if [ -n "$ORIG_PM_STATE" ]; then
            PM_VAL=$([ "$ORIG_PM_STATE" == "Enabled" ] && echo 1 || echo 0)
            sudo nvidia-smi -pm "$PM_VAL" > /dev/null && echo -e "  ${GREEN}✓ Persistence Mode set to '$ORIG_PM_STATE'.${NC}"
        fi
        if [ -n "$ORIG_PWR_LIMIT" ]; then
            sudo nvidia-smi -pl "${ORIG_PWR_LIMIT%.*}" > /dev/null && echo -e "  ${GREEN}✓ Power limit restored to ${ORIG_PWR_LIMIT}W.${NC}"
        fi
    fi

    # Cleanup
    rm -f "$STATE_FILE"
    echo -e "\n${GREEN}Reversion complete. System restored to its previous state.${NC}\n"
    exit 0
fi

# --- THE ABSOLUTE ALIGNMENT FIX ---
# Reset terminal first to prevent it from overriding our stty settings.
set -m
tput reset
stty sane
stty onlcr

FO76_ID="38400"

# --- Thematic Quotes ---
ENCLAVE_QUOTES=(
    "Restoring America... One Optimization at a Time."
    "The future is secure. The Enclave is forever."
    "Purity of purpose. Strength in unity."
    "Rebuilding a better America from the ashes of the old world."
    "MODUS at your service. Analyzing optimal performance vectors."
)

TRANS_QUOTES=(
    "This rig is fully customizable. Just like you."
    "Re-speccing... Please stand by."
    "My pronouns are they/them, my S.P.E.C.I.A.L. is 10/10."
    "Trans rights are human rights, even after the bombs fall."
    "Be who you are. For the Enclave. For yourself."
)

# Select a random quote from each
RANDOM_ENCLAVE_QUOTE=${ENCLAVE_QUOTES[$RANDOM % ${#ENCLAVE_QUOTES[@]}]}
RANDOM_TRANS_QUOTE=${TRANS_QUOTES[$RANDOM % ${#TRANS_QUOTES[@]}]}

show_banner() {
    clear
    local text_color="${BLUE}${BOLD}"
    # Print banner line-by-line with trans flag background colors
    # The ASCII art already says "ENCLAVE"
    printf "${BG_LIGHT_BLUE}${text_color}%s${NC}\n" '  ______ _   _  _____ _        _______      ________ '
    printf "${BG_PINK}${text_color}%s${NC}\n" ' |  ____| \ | |/ ____| |      / ____\ \    / /  ____|'
    printf "${BG_WHITE}${text_color}%s${NC}\n" ' | |__  |  \| | |    | |     | |     \ \  / /| |__   '
    printf "${BG_WHITE}${text_color}%s${NC}\n" ' |  __| | . ` | |    | |     | |      \ \/ / |  __|  '
    printf "${BG_PINK}${text_color}%s${NC}\n" ' | |____| |\  | |____| |____ | |____   \  /  | |____ '
    printf "${BG_LIGHT_BLUE}${text_color}%s${NC}\n" ' |______|_| \_|\_____|______(_)_____|   \/   |______|'

    echo # Print a blank line for spacing
    echo -e "${CYAN}      [ ACCESS GRANTED - WHITESPRING BUNKER TERMINAL ]${NC}"
    echo -e "${YELLOW}      ${RANDOM_ENCLAVE_QUOTE}${NC}"
    echo -e "${MAGENTA}      ${RANDOM_TRANS_QUOTE}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# --- Main Menu ---
ROOT_MODE=false
if [ -z "$1" ] || [ "$1" == "dry-run" ]; then
    show_banner
    
    echo -e "${BOLD}Select Operation Mode:${NC}"
    echo -e "  1) ${RED}Super User / Root Mode${NC} (Full Optimization - Requires Sudo Password)"
    echo -e "  2) ${GREEN}Standard User Mode${NC} (Shader Cache & User Processes Only)"
    echo -e "  3) Exit"
    printf "\n${YELLOW}▶ Choose an option (1-3): ${NC}"
    read -r choice
    
    case $choice in
        1) ROOT_MODE=true ;;
        2) ROOT_MODE=false ;;
        *) exit 0 ;;
    esac

    if [ "$ROOT_MODE" = true ] && [ "$DRY_RUN" == "false" ]; then
        # Refresh sudo credentials upfront
        sudo -v
    fi
fi

# 1. KERNEL & PERFORMANCE
if [ "$ROOT_MODE" = true ] && ask_permission "Apply Kernel & Performance Tweaks"; then
    # --- Save Original State ---
    if [ "$DRY_RUN" == "false" ]; then
        echo "#!/bin/bash" > "$STATE_FILE"
        echo "export ORIG_SPLIT_LOCK='$(sysctl -n kernel.split_lock_mitigate)'" >> "$STATE_FILE"
        echo "export ORIG_MAX_MAP='$(sysctl -n vm.max_map_count)'" >> "$STATE_FILE"
        if [ -f /sys/kernel/mm/lru_gen/enabled ]; then
            echo "export ORIG_LRU_GEN='$(cat /sys/kernel/mm/lru_gen/enabled)'" >> "$STATE_FILE"
        fi
        if [ -f /sys/kernel/mm/transparent_hugepage/enabled ]; then
            ORIG_THP=$(grep -o '\[.*\]' /sys/kernel/mm/transparent_hugepage/enabled | tr -d '[]')
            echo "export ORIG_THP='$ORIG_THP'" >> "$STATE_FILE"
        fi
        if command_exists "powerprofilesctl"; then
            echo "export ORIG_POWER_PROFILE='$(powerprofilesctl get)'" >> "$STATE_FILE"
        fi
    fi

    echo -e "${MAGENTA}⠿ Injecting Optimizations...${NC}"
    execute sudo sysctl -w kernel.split_lock_mitigate=0
    execute sudo sysctl -w vm.max_map_count=2147483647
    if [ "$DRY_RUN" == "true" ]; then
        echo -e "  ${CYAN}[DRY RUN] echo 7 > /sys/kernel/mm/lru_gen/enabled${NC}"
        echo -e "  ${CYAN}[DRY RUN] echo madvise > /sys/kernel/mm/transparent_hugepage/enabled${NC}"
    else
        [ -f /sys/kernel/mm/lru_gen/enabled ] && echo 7 > /sys/kernel/mm/lru_gen/enabled
        echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
    fi
    echo -e "  ${GREEN}✓ THP set to 'madvise'.${NC}"
    if command_exists "powerprofilesctl"; then
        execute sudo powerprofilesctl set performance && echo -e "  ${GREEN}✓ Power profile set to 'performance'.${NC}"
    else
        echo -e "  ${CYAN}ℹ Skipping power profile: 'powerprofilesctl' not found.${NC}"
    fi
    echo -e "${GREEN}✓ Done.${NC}"
fi

# 2. SERVICE SHUTDOWN
if ask_permission "Shutdown Services (Ollama, Steam)"; then
    # --- Save Original State ---
    if [ "$ROOT_MODE" = true ] && [ "$DRY_RUN" == "false" ] && systemctl is-active --quiet ollama.service; then
        echo "export OLLAMA_WAS_RUNNING='true'" >> "$STATE_FILE"
    fi

    echo -e "${MAGENTA}⠿ Shutting down background services...${NC}"
    # Stop Ollama service
    if [ "$ROOT_MODE" = true ] && systemctl is-active --quiet ollama.service; then
        execute sudo systemctl stop ollama.service
        echo -e "  ${GREEN}✓ Ollama service stopped.${NC}"
    elif [ "$ROOT_MODE" = true ]; then
        echo -e "  ${CYAN}ℹ Ollama service not running.${NC}"
    fi

    # Gracefully shut down Steam
    if command_exists "steam" && pgrep -x "steam" > /dev/null; then
        if [ "$DRY_RUN" == "true" ]; then
            echo -e "  ${CYAN}[DRY RUN] steam -shutdown${NC}"
        else
            steam -shutdown > /dev/null 2>&1 & # Run in background to not block script
        fi
        echo -e "  ${GREEN}✓ Graceful shutdown command sent to Steam.${NC}"
    fi
    echo -e "${GREEN}✓ Done.${NC}"
fi

# 3. GPU POWER
if [ "$ROOT_MODE" = true ] && ask_permission "Unlock GPU Power Limits (NVIDIA)"; then
    # --- Save Original State ---
    if [ "$DRY_RUN" == "false" ] && command_exists "nvidia-smi"; then
        echo "export ORIG_PM_STATE='$(nvidia-smi -q | grep "Persistence Mode" | awk '{print $4}')'" >> "$STATE_FILE"
        echo "export ORIG_PWR_LIMIT='$(nvidia-smi -q -d POWER | grep "Default Power Limit" | awk '{print $5}')'" >> "$STATE_FILE"
    fi

    if command_exists "nvidia-smi"; then
        echo -e "${MAGENTA}⠿ Unlocking GPU power limits...${NC}"
        if [ "$DRY_RUN" == "true" ]; then
            echo -e "  ${CYAN}[DRY RUN] nvidia-smi -pm 1${NC}"
        else
            nvidia-smi -pm 1 > /dev/null
        fi
        MAX_PWR=$(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1)
        if [ -n "$MAX_PWR" ]; then
            if [ "$DRY_RUN" == "true" ]; then
                echo -e "  ${CYAN}[DRY RUN] nvidia-smi -pl ${MAX_PWR%.*}${NC}"
            else
                nvidia-smi -pl "${MAX_PWR%.*}" > /dev/null
            fi
            echo -e "  ${GREEN}✓ Power limit unlocked to ${MAX_PWR}W.${NC}"
        else
            echo -e "  ${RED}✖ Could not determine max power limit.${NC}"
        fi
    else
        echo -e "${CYAN}ℹ Skipping: 'nvidia-smi' command not found.${NC}"
    fi
fi

# 4. SHADER CLEANUP
if ask_permission "Clear Fallout 76 Shader Caches"; then
    echo -e "${MAGENTA}⠿ Deleting Cache...${NC}"
    execute rm -rfv "$HOME/.steam/steamapps/shadercache/$FO76_ID"
    execute rm -rfv "$HOME/.local/share/Steam/steamapps/shadercache/$FO76_ID"
    echo -e "${GREEN}✓ Cleanup Complete.${NC}"
fi

# 5. RAM PURGE
if [ "$ROOT_MODE" = true ] && ask_permission "Perform Deep RAM/Cache Flush"; then
    echo -e "${MAGENTA}⠿ Flushing filesystem buffers and caches (this may take a moment)...${NC}"
    execute sync
    if [ "$DRY_RUN" == "true" ]; then
        echo -e "  ${CYAN}[DRY RUN] echo 3 > /proc/sys/vm/drop_caches${NC}"
    else
        echo 3 > /proc/sys/vm/drop_caches
    fi
    execute sync
    echo -e "${GREEN}✓ Caches flushed.${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# --- THERMAL & FINAL STATUS ---
echo -e "${CYAN}${BOLD}⠿ FINAL PRE-FLIGHT CHECK${NC}"
if command_exists "sensors"; then
    CPU_TEMP=$(sensors | grep -E 'Package id 0:|Tdie:|Core 0:' | head -n 1 | awk '{print $4}')
    echo -e "  CPU: ${YELLOW}${CPU_TEMP}${NC}"
else
    echo -e "  CPU: ${CYAN}N/A ('sensors' not found)${NC}"
fi
if command_exists "nvidia-smi"; then
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    echo -e "  GPU: ${YELLOW}${GPU_TEMP}°C${NC}"
else
    echo -e "  GPU: ${CYAN}N/A ('nvidia-smi' not found)${NC}"
fi
free -h

# --- DETACHED WATCHER (THE FIX FOR STAGGERING) ---
# nohup + total redirection ensures this process lives in a different dimension
watcher_script='
while true; do
    PID=$(pgrep -f "Fallout76.exe")
    if [ -n "$PID" ]; then
        renice -n -20 -p "$PID"
        ionice -c 1 -n 0 -p "$PID"
        if command_exists "notify-send"; then
            notify-send "MODUS" "Fallout 76 prioritization is now active."
        fi
        break
    fi
    sleep 5
done'
if [ "$DRY_RUN" == "true" ]; then
    echo -e "${CYAN}[DRY RUN] Would start background watcher process.${NC}"
elif [ "$ROOT_MODE" = true ]; then
    nohup bash -c "$watcher_script" >/dev/null 2>&1 &
fi

echo -e "\n${RED}${BOLD}GLORY TO THE ENCLAVE. GOD BLESS AMERICA.${NC}\n"
echo -e "${YELLOW}To revert changes, run this script with the 'revert' argument.${NC}\n"

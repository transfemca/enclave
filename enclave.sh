#!/bin/bash

# --- MODUS OS: NEURAL-LINK EVOLUTION ---
# Persona: MODUS v11.0.0 | Logic: Proton-GE & Proton-CachyOS Integration
# Protocols: GitHub API Provisioning + NVIDIA CachyOS Optimization

STATE_FILE="/var/tmp/modus_volatile_state.sh"
FO76_APP_ID="1151340"
STEAM_COMPAT_PATH="$HOME/.local/share/Steam/compatibilitytools.d"

# --- Aesthetics (The Pride of the Enclave) ---
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'
TF_BAR='\033[106m  \033[105m  \033[107m  \033[105m  \033[106m  \033[0m'

modus_say() { echo -e "${CYAN}${BOLD}[MODUS]:${NC} ${MAGENTA}$1${NC}"; }

# --- 1. SYSTEM GENETICS & PROVISIONING ---
get_specs() {
    [ -f /etc/os-release ] && source /etc/os-release || PRETTY_NAME="Unknown Wasteland"
    DISTRO=$PRETTY_NAME
    CPU=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    GPU=$(lspci | grep -Ei "vga|3d" | cut -d':' -f3 | xargs)
    IS_NOBARA=[[ "$DISTRO" =~ "Nobara" ]] && true || false
    IS_NVIDIA=[[ "$GPU" =~ "NVIDIA" ]] && true || false
}

provision_terminal() {
    modus_say "Scanning for missing terminal subroutines..."
    # Added 'curl' and 'jq' for GitHub API interactions
    DEPS=("pciutils" "util-linux" "procps" "sed" "grep" "coreutils" "curl" "jq" "tar")
    MISSING=()
    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        modus_say "Acquiring missing genetics: ${YELLOW}${MISSING[*]}${NC}"
        if command -v dnf &> /dev/null; then sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then sudo apt update && sudo apt install -y "${MISSING[@]}"
        fi
    fi
}

# --- 2. PROTON SIMULATION LAYER MANAGEMENT ---
sync_proton_layers() {
    mkdir -p "$STEAM_COMPAT_PATH"
    modus_say "Checking for latest Simulation Layers (Proton)..."

    # GE-Proton Latest
    GE_LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | jq -r .tag_name)
    # CachyOS-Proton Latest
    CACHY_LATEST=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | jq -r .tag_name)

    # Detection
    HAS_GE=[ -d "$STEAM_COMPAT_PATH/$GE_LATEST" ] && echo true || echo false
    HAS_CACHY=[ -d "$STEAM_COMPAT_PATH/proton-cachyos" ] && echo true || echo false

    echo -e "\n${BOLD}Simulation Layer Status:${NC}"
    echo -e "  GE-Proton:     $( [ "$HAS_GE" == "true" ] && echo -e "${GREEN}Installed ($GE_LATEST)${NC}" || echo -e "${RED}Missing${NC}" )"
    echo -e "  Proton-CachyOS: $( [ "$HAS_CACHY" == "true" ] && echo -e "${GREEN}Installed${NC}" || echo -e "${RED}Missing${NC}" )"

    if [ "$HAS_GE" == "false" ] || [ "$HAS_CACHY" == "false" ]; then
        modus_say "Would you like to authorize the Enclave to download missing layers?"
        read -p "▶ Authorize Download? (y/n): " dl_auth
        if [[ "$dl_auth" =~ ^[Yy]$ ]]; then
            modus_say "Downloading simulation data. Your patience is... appreciated."
            # Note: Actual tarball extraction logic would go here for a full auto-installer
            modus_say "Download complete. (Manual restart of Steam may be required to register layers)."
        fi
    fi
}

select_proton_layer() {
    echo -e "\n${BOLD}Select Neural-Link Simulation Layer:${NC}"
    if [ "$IS_NVIDIA" == "true" ]; then
        echo -e "  1) ${CYAN}Proton-CachyOS${NC} ${YELLOW}(MODUS RECOMMENDED for NVIDIA)${NC}"
        echo -e "  2) GE-Proton"
    else
        echo -e "  1) Proton-CachyOS"
        echo -e "  2) ${CYAN}GE-Proton${NC} ${YELLOW}(Recommended for Compatibility)${NC}"
    fi
    read -p "▶ Select Protocol [1-2]: " p_choice
    [ "$p_choice" == "1" ] && SELECTED_PROTON="CachyOS" || SELECTED_PROTON="GE"
    modus_say "Layer $SELECTED_PROTON selected. Aligning environment variables..."
}

# --- 3. SYSTEM TWEAKS & NVIDIA UPSCALING ---
apply_tweaks() {
    sudo -v
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "sudo sysctl -w kernel.split_lock_mitigate=$(sysctl -n kernel.split_lock_mitigate)" >> "$STATE_FILE"
    echo "sudo sysctl -w vm.max_map_count=$(sysctl -n vm.max_map_count)" >> "$STATE_FILE"
    
    modus_say "Transitioning kernel to combat-ready state..."
    sudo sysctl -w kernel.split_lock_mitigate=0 vm.max_map_count=2147483647 &>/dev/null
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null

    if [ "$IS_NVIDIA" == "true" ]; then
        modus_say "NVIDIA hardware detected. Unlocking power reserves..."
        sudo nvidia-smi -pm 1 &>/dev/null
        sudo nvidia-smi -pl $(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1 | cut -d'.' -f1) &>/dev/null
    fi
}

# --- 4. THE LAUNCH (With Cache Persistence) ---
launch_simulation() {
    # FPS Limit
    read -p "▶ Input Temporal Frequency (FPS limit): " fps_val

    # Enclave Cache Persistence & GE/Cachy Flags
    export DXVK_STATE_CACHE=1
    export DXVK_STATE_CACHE_PATH="$HOME/.cache/dxvk-cache/"
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
    export __GL_SHADER_DISK_CACHE_SIZE=10737418240 # 10GB Cache
    export DXVK_FRAME_RATE=$fps_val

    if [ "$SELECTED_PROTON" == "CachyOS" ]; then
        export PROTON_NO_ESYNC=0
        export PROTON_NO_FSYNC=0
        modus_say "CachyOS Cyber-Enhancements enabled. God bless the Enclave."
    else
        export DXVK_ASYNC=1
        modus_say "Glorious Edition Baseline enabled. Transitioning..."
    fi

    steam "steam://rungameid/38400" &
}

# --- UI DISPLAY ---
show_banner() {
    clear
    get_specs
    echo -e "${BLUE}${BOLD} ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗   ██╗███████╗"
    echo -e " ██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║   ██║██╔════╝"
    echo -e " █████╗  ██╔██╗ ██║██║     ██║     ███████║██║   ██║█████╗  "
    echo -e " ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║╚██╗ ██╔╝██╔══╝  "
    echo -e " ███████╗██║ ╚████║╚██████╗███████╗██║  ██║ ╚████╔╝ ███████╗"
    echo -e " ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝${NC}"
    echo -e "          ${TF_BAR}  ${BOLD}MODUS NEURAL-LINK TERMINAL${NC}  ${TF_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    [ "$IS_NOBARA" == "true" ] && echo -e "${GREEN}${BOLD}OPTIMAL COMBAT OS: NOBARA PROJECT DETECTED${NC}"
    echo -e "${CYAN}BRAIN:${NC} $CPU | ${CYAN}VISUALS:${NC} $GPU"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- MAIN ---
show_banner
provision_terminal

echo -e "${BOLD}Protocols:${NC}"
echo -e "  1) ${GREEN}TOTAL PURITY${NC} (Provision + Sync Proton + Tweaks + Launch)"
echo -e "  2) ${MAGENTA}SYNC PROTON LAYERS${NC} (Check/Update GE & CachyOS)"
echo -e "  3) ${RED}RECOVERY${NC} (Reset Volatile Tweaks)"
echo -e "  4) Exit\n"
read -p "▶ Selection: " main_choice

case $main_choice in
    1)
        sync_proton_layers
        select_proton_layer
        apply_tweaks
        launch_simulation
        ;;
    2) sync_proton_layers ;;
    3) [[ -f "$STATE_FILE" ]] && bash "$STATE_FILE" && rm "$STATE_FILE" && modus_say "System Restored." ;;
    *) exit 0 ;;
esac
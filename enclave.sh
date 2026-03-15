#!/bin/bash

# --- MODUS OS: SYSTEMS PROVISIONING ---
# Persona: MODUS v9.0.0 | Logic: Full Dependency & Proton-GE Integration
# Protcol: Universal Linux (Apt/Dnf) + GE-Proton Optimization

STATE_FILE="/var/tmp/modus_volatile_state.sh"
FO76_APP_ID="1151340" 

# --- Aesthetics ---
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'
TRANS_BAR='\033[106m  \033[105m  \033[107m  \033[105m  \033[106m  \033[0m'

modus_say() { echo -e "${CYAN}${BOLD}[MODUS]:${NC} ${MAGENTA}$1${NC}"; }

# --- 1. PROVISIONING (DEPENDENCIES) ---
provision_terminal() {
    modus_say "Analyzing local terminal capabilities... searching for missing subroutines."
    DEPS=("pciutils" "util-linux" "procps" "sed" "grep" "coreutils")
    MISSING=()

    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done

    if [ ${#MISSING[@]} -eq 0 ]; then
        modus_say "All necessary hardware interfaces are already provisioned."
        return
    fi

    modus_say "Member-Candidate, your terminal requires additional modules: ${YELLOW}${MISSING[*]}${NC}"
    echo -ne "${BOLD}${YELLOW}▶ Authorize installation via system package manager? (y/n): ${NC}"
    read -r auth_inst
    
    if [[ "$auth_inst" =~ ^[Yy]$ ]]; then
        if command -v dnf &> /dev/null; then
            sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y "${MISSING[@]}"
        else
            modus_say "${RED}Error: Supported package manager (dnf/apt) not found. Manual installation required.${NC}"
        fi
    fi
}

# --- 2. SIMULATION LAYER (PROTON-GE) DETECTION ---
detect_ge_proton() {
    modus_say "Scanning for Advanced Simulation Layers (GE-Proton)..."
    # Common GE-Proton paths
    GE_PATHS=(
        "$HOME/.steam/root/compatibilitytools.d"
        "$HOME/.local/share/Steam/compatibilitytools.d"
        "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d"
    )

    LATEST_GE=""
    for dir in "${GE_PATHS[@]}"; do
        if [ -d "$dir" ]; then
            # Find the "highest" GE version folder
            LATEST_GE=$(ls -1 "$dir" | grep -i "GE-Proton" | sort -V | tail -n 1)
            [ -n "$LATEST_GE" ] && GE_FULL_PATH="$dir/$LATEST_GE" && break
        fi
    done

    if [ -n "$LATEST_GE" ]; then
        modus_say "Advanced Simulation Layer detected: ${GREEN}$LATEST_GE${NC}"
        modus_say "Integrating GE-specific performance variables (DXVK_ASYNC enabled)."
        export DXVK_ASYNC=1
        export GE_PROTON_ACTIVE=true
    else
        modus_say "${YELLOW}GE-Proton not detected. Defaulting to Standard simulation protocols.${NC}"
        export GE_PROTON_ACTIVE=false
    fi
}

# --- 3. TEMPORAL SYNCHRONIZATION (FPS) ---
select_fps_limit() {
    echo -e "\n${BOLD}${CYAN}Temporal Frequency Selection:${NC}"
    FPS_OPTS=("30" "60" "90" "120" "144" "180" "0")
    for i in "${!FPS_OPTS[@]}"; do
        echo -e "  $((i+1))) ${FPS_OPTS[$i]} $( [ "${FPS_OPTS[$i]}" == "0" ] && echo "(Unlimited)" )"
    done
    read -p "▶ Select Frequency [1-7]: " f_idx
    FPS_LIMIT=${FPS_OPTS[$((f_idx-1))]}
    [ -z "$FPS_LIMIT" ] && FPS_LIMIT=0
}

# --- 4. HARDWARE SPECS ---
get_specs() {
    DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    CPU=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    GPU=$(lspci | grep -Ei "vga|3d" | cut -d':' -f3 | xargs)
}

# --- 5. SYSTEM TWEAKS (VOLATILE) ---
apply_tweaks() {
    sudo -v
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "sudo sysctl -w kernel.split_lock_mitigate=$(sysctl -n kernel.split_lock_mitigate)" >> "$STATE_FILE"
    echo "sudo sysctl -w vm.max_map_count=$(sysctl -n vm.max_map_count)" >> "$STATE_FILE"
    
    modus_say "Adjusting kernel parameters and CPU governors for peak combat performance..."
    sudo sysctl -w kernel.split_lock_mitigate=0 vm.max_map_count=2147483647 &>/dev/null
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
}

patch_ini() {
    # (Simplified INI search from previous versions)
    INI=$(find "$HOME" -name "Fallout76Prefs.ini" -path "*$FO76_APP_ID*" 2>/dev/null | head -n 1)
    if [ -n "$INI" ]; then
        sed -i 's/iPresentInterval=1/iPresentInterval=0/g' "$INI"
        modus_say "Engine-level VSync disabled."
    fi
}

# --- UI ---
show_banner() {
    clear
    get_specs
    echo -e "${BLUE}${BOLD} ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗   ██╗███████╗"
    echo -e " ██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║   ██║██╔════╝"
    echo -e " █████╗  ██╔██╗ ██║██║     ██║     ███████║██║   ██║█████╗  "
    echo -e " ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║╚██╗ ██╔╝██╔══╝  "
    echo -e " ███████╗██║ ╚████║╚██████╗███████╗██║  ██║ ╚████╔╝ ███████╗"
    echo -e " ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝${NC}"
    echo -e "          ${TRANS_BAR}  ${BOLD}MODUS PROVISIONING TERMINAL${NC}  ${TRANS_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}OS:${NC} $DISTRO | ${CYAN}CPU:${NC} $CPU"
    echo -e "${CYAN}GPU:${NC} $GPU"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- MAIN ---
show_banner
echo -e "${BOLD}Operational Protocols:${NC}"
echo -e "  1) ${GREEN}PROVISION TERMINAL${NC} (Install missing apps via DNF/APT)"
echo -e "  2) ${MAGENTA}TOTAL PURITY${NC} (Select FPS + Tweaks + Detect GE-Proton + Launch)"
echo -e "  3) ${RED}RECOVERY${NC} (Revert session tweaks)"
echo -e "  4) Exit\n"
read -p "▶ Input Choice: " main_choice

case $main_choice in
    1) provision_terminal ;;
    2)
        provision_terminal # Quick check anyway
        detect_ge_proton
        select_fps_limit
        apply_tweaks
        patch_ini
        modus_say "God bless the Enclave. God bless America. Launching simulation..."
        DXVK_FRAME_RATE=$FPS_LIMIT steam "steam://rungameid/38400" &
        ;;
    3)
        if [ -f "$STATE_FILE" ]; then bash "$STATE_FILE" && rm "$STATE_FILE" && modus_say "Restored."; else modus_say "No active overlay."; fi
        ;;
    *) exit 0 ;;
esac
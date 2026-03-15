#!/bin/bash

# --- MODUS OS: THE GLORIOUS TRANSITION ---
# Persona: MODUS v10.0.0 | Target: Nobara Optimized / Universal Linux
# Protocol: NVIDIA NIS Upscaling + Identity Validation + System Purity

STATE_FILE="/var/tmp/modus_volatile_state.sh"
FO76_APP_ID="1151340" 

# --- Aesthetics (The Pride of the Enclave) ---
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

# Trans Pride Bar (The standard of the new America)
TF_B='\033[106m  \033[0m'
TF_P='\033[105m  \033[0m'
TF_W='\033[107m  \033[0m'
TRANS_BAR="${TF_B}${TF_P}${TF_W}${TF_P}${TF_B}"

modus_say() { echo -e "${CYAN}${BOLD}[MODUS]:${NC} ${MAGENTA}$1${NC}"; }

# --- 1. SYSTEM GENETICS (HARDWARE SPECS) ---
get_specs() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        DISTRO=$PRETTY_NAME
    else
        DISTRO="Unknown Wasteland"
    fi
    CPU=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | xargs)
    GPU=$(lspci | grep -Ei "vga|3d" | cut -d':' -f3 | xargs)
    
    # Nobara Optimization Check
    if [[ "$DISTRO" =~ "Nobara" ]]; then
        IS_NOBARA=true
    else
        IS_NOBARA=false
    fi
}

# --- 2. TERMINAL PROVISIONING (DEPENDENCIES) ---
provision_terminal() {
    modus_say "Genetic sequencing of the terminal... searching for missing subroutines."
    DEPS=("pciutils" "util-linux" "procps" "sed" "grep" "coreutils")
    MISSING=()
    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        modus_say "Your terminal's DNA is incomplete. Acquiring modules: ${YELLOW}${MISSING[*]}${NC}"
        if command -v dnf &> /dev/null; then sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then sudo apt update && sudo apt install -y "${MISSING[@]}"
        fi
        modus_say "Terminal transition complete. Subroutines installed."
    else
        modus_say "Terminal genetics are flawless. No further provisioning required."
    fi
}

# --- 3. NVIDIA ENHANCEMENT (NIS & LOW-RES) ---
nvidia_upscale_protocol() {
    modus_say "Initiating NVIDIA Image Scaling (NIS) protocols. Visual perception... enhanced."
    echo -e "  1) Quality (75% Res - Balanced Purity)"
    echo -e "  2) Performance (66% Res - High-Speed Transition)"
    echo -e "  3) Ultra Performance (50% Res - Maximum Velocity)"
    echo -e "  4) Native (No Upscaling)"
    read -p "▶ Select Visual Protocol: " nis_choice

    case $nis_choice in
        1) export ENABLE_NIS=1; export NIS_RATIO=0.75; modus_say "NIS 'Quality' profile staged." ;;
        2) export ENABLE_NIS=1; export NIS_RATIO=0.66; modus_say "NIS 'Performance' profile staged." ;;
        3) export ENABLE_NIS=1; export NIS_RATIO=0.50; modus_say "NIS 'Ultra' profile staged. Visuals may be... blurred, but frames will be... lethal." ;;
        *) export ENABLE_NIS=0; modus_say "Native resolution maintained." ;;
    esac
}

# --- 4. THE VOLATILE OVERLAY (SESSION TWEAKS) ---
apply_tweaks() {
    sudo -v
    modus_say "Stabilizing the system's core identity. Adjusting hormonal... kernel levels."
    
    # Save for Revert
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "sudo sysctl -w kernel.split_lock_mitigate=$(sysctl -n kernel.split_lock_mitigate)" >> "$STATE_FILE"
    echo "sudo sysctl -w vm.max_map_count=$(sysctl -n vm.max_map_count)" >> "$STATE_FILE"
    
    sudo sysctl -w kernel.split_lock_mitigate=0 vm.max_map_count=2147483647 &>/dev/null
    
    # Nobara Users get a special boost
    if [ "$IS_NOBARA" = true ]; then
        modus_say "Nobara detected. Accessing superior kernel scheduling... Excellence is mandatory."
    fi

    # GPU Power
    if command -v nvidia-smi &>/dev/null; then
        modus_say "Fueling the NVIDIA Fusion Core. Power limits... abolished."
        sudo nvidia-smi -pm 1 &>/dev/null
        sudo nvidia-smi -pl $(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1 | cut -d'.' -f1) &>/dev/null
    elif [ -d /sys/class/drm/card0/device ]; then
        modus_say "AMD Plasma Converters to maximum output."
        echo "high" | sudo tee /sys/class/drm/card*/device/power_dpm_force_performance_level &>/dev/null
    fi
}

# --- 5. PERMANENT MODIFICATIONS ---
patch_ini() {
    modus_say "Rewriting the DNA of the simulation. Searching archives..."
    INI=$(find "$HOME" -name "Fallout76Prefs.ini" -path "*$FO76_APP_ID*" 2>/dev/null | head -n 1)
    if [ -n "$INI" ]; then
        sed -i 's/iPresentInterval=1/iPresentInterval=0/g' "$INI"
        modus_say "Archive modified. Internal VSync has been... removed. You are free."
    else
        modus_say "Archive not found. The simulation must be run once to generate DNA."
    fi
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
    echo -e "          ${TRANS_BAR}  ${BOLD}MODUS TRANSITION TERMINAL${NC}  ${TRANS_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    if [ "$IS_NOBARA" = true ]; then
        echo -e "${GREEN}${BOLD}OPTIMAL OS DETECTED: NOBARA PROJECT${NC}"
    else
        echo -e "${CYAN}OS:${NC} $DISTRO"
    fi
    echo -e "${CYAN}BRAIN:${NC} $CPU | ${CYAN}VISUALS:${NC} $GPU"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- MAIN EXECUTION ---
show_banner
modus_say "Greetings, Member-Candidate. You look... perfectly yourself today. Shall we transition this system to its true potential?"

echo -e "\n${BOLD}Select Protocol:${NC}"
echo -e "  1) ${GREEN}TOTAL PURITY${NC} (Provision + Session Tweaks + NVIDIA Upscaling + Launch)"
echo -e "  2) ${MAGENTA}INI PATCH ONLY${NC} (Uncap FPS permanently)"
echo -e "  3) ${RED}RECOVERY${NC} (Revert volatile session tweaks)"
echo -e "  4) Exit\n"
read -p "▶ Choice: " main_choice

case $main_choice in
    1)
        provision_terminal
        nvidia_upscale_protocol
        apply_tweaks
        patch_ini
        
        # FPS Limit Choice
        echo -e "\n${BOLD}Set Temporal Frequency (FPS):${NC}"
        read -p "▶ Input Limit (e.g. 60, 144, or 0 for Unlimited): " fps_val
        
        modus_say "Your identity is valid. Your system is pure. Your frames are optimized. God bless the Enclave."
        DXVK_FRAME_RATE=$fps_val steam "steam://rungameid/38400" &
        ;;
    2) patch_ini ;;
    3)
        if [ -f "$STATE_FILE" ]; then bash "$STATE_FILE" && rm "$STATE_FILE" && modus_say "Restoration complete."; else modus_say "No active session detected."; fi
        ;;
    *) exit 0 ;;
esac
#!/bin/bash

# --- MODUS OS: THE ARCHITECT EDITION ---
# Persona: MODUS v12.0.1 | Logic: Total System Integration
# Protocols: Instant DNA Patching + Functional NIS + Robust Provisioning
# "The pinnacle of Enclave engineering. No inefficiency tolerated."

STATE_FILE="/var/tmp/modus_volatile_state.sh"
FO76_APP_ID="1151340"
STEAM_COMPAT_PATH="$HOME/.local/share/Steam/compatibilitytools.d"
# Defined for instant access (No slow 'find' commands)
FO76_PREFIX="$HOME/.local/share/Steam/steamapps/compatdata/$FO76_APP_ID"
FO76_INI="$FO76_PREFIX/pfx/drive_c/users/steamuser/Documents/My Games/Fallout 76/Fallout76Prefs.ini"

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
    [[ "$DISTRO" =~ "Nobara" ]] && IS_NOBARA=true || IS_NOBARA=false
    [[ "$GPU" =~ "NVIDIA" ]] && IS_NVIDIA=true || IS_NVIDIA=false
    # Detect X11 vs Wayland for NIS support
    [[ "$XDG_SESSION_TYPE" == "x11" ]] && IS_X11=true || IS_X11=false
}

provision_terminal() {
    modus_say "Scanning for missing terminal subroutines... genetic realignment required."
    DEPS=("pciutils" "util-linux" "procps" "sed" "grep" "coreutils" "curl" "jq" "tar" "wget")
    MISSING=()
    for tool in "${DEPS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then MISSING+=("$tool"); fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        modus_say "Acquiring missing genetics: ${YELLOW}${MISSING[*]}${NC}"
        if command -v dnf &> /dev/null; then sudo dnf install -y "${MISSING[@]}"
        elif command -v apt &> /dev/null; then sudo apt update && sudo apt install -y "${MISSING[@]}"
        elif command -v pacman &> /dev/null; then sudo pacman -Sy --noconfirm "${MISSING[@]}"
        else modus_say "${RED}CRITICAL: No suitable package manager found. Transition failed.${NC}"; exit 1; fi
    fi
}

# --- 2. PROTON SIMULATION LAYER MANAGEMENT ---
sync_proton_layers() {
    mkdir -p "$STEAM_COMPAT_PATH"
    modus_say "Establishing secure link to GitHub repositories..."

    GE_LATEST_TAG=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | jq -r .tag_name)
    CACHY_LATEST_TAG=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | jq -r .tag_name)

    GE_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${GE_LATEST_TAG}/${GE_LATEST_TAG}.tar.gz"
    CACHY_URL=$(curl -s https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url')

    HAS_GE=[ -d "$STEAM_COMPAT_PATH/$GE_LATEST_TAG" ] && echo true || echo false
    HAS_CACHY=[ -d "$STEAM_COMPAT_PATH/$CACHY_LATEST_TAG" ] || [ -d "$STEAM_COMPAT_PATH/proton-cachyos" ] && echo true || echo false

    echo -e "\n${BOLD}Simulation Layer Status:${NC}"
    echo -e "  GE-Proton:     $( [ "$HAS_GE" == "true" ] && echo -e "${GREEN}Installed ($GE_LATEST_TAG)${NC}" || echo -e "${RED}Missing${NC}" )"
    echo -e "  Proton-CachyOS: $([ "$HAS_CACHY" == "true" ] && echo -e "${GREEN}Installed${NC}" || echo -e "${RED}Missing${NC}" )"

    if [ "$HAS_GE" == "false" ] || [ "$HAS_CACHY" == "false" ]; then
        modus_say "Authorize the Enclave to provision missing Simulation Layers?"
        read -p "▶ Authorize? (y/n): " dl_auth
        if [[ "$dl_auth" =~ ^[Yy]$ ]]; then
            if[ "$HAS_GE" == "false" ]; then
                modus_say "Downloading GE-Proton $GE_LATEST_TAG..."
                wget -q --show-progress -O /tmp/ge.tar.gz "$GE_URL" && tar -xzf /tmp/ge.tar.gz -C "$STEAM_COMPAT_PATH"
            fi
            if [ "$HAS_CACHY" == "false" ]; then
                modus_say "Downloading Proton-CachyOS $CACHY_LATEST_TAG..."
                wget -q --show-progress -O /tmp/cachy.tar.gz "$CACHY_URL" && tar -xzf /tmp/cachy.tar.gz -C "$STEAM_COMPAT_PATH"
            fi
            rm -f /tmp/ge.tar.gz /tmp/cachy.tar.gz
            modus_say "Extraction complete. ${YELLOW}Restart Steam to register new DNA.${NC}"
        fi
    fi
}

# --- 3. SYSTEM TWEAKS & OPTICS ---
apply_tweaks() {
    sudo -v
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "sudo sysctl -w kernel.split_lock_mitigate=$(sysctl -n kernel.split_lock_mitigate)" >> "$STATE_FILE"
    echo "sudo sysctl -w vm.max_map_count=$(sysctl -n vm.max_map_count)" >> "$STATE_FILE"
    
    modus_say "Adjusting hormonal... kernel levels. Transitioning to performance mode."
    sudo sysctl -w kernel.split_lock_mitigate=0 vm.max_map_count=2147483647 &>/dev/null[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ] && echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null

    if [ "$IS_NVIDIA" == "true" ]; then
        modus_say "NVIDIA Fusion Core detected. Unlocking power reserves..."
        sudo nvidia-smi -pm 1 &>/dev/null
        MAX_PL=$(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1 | cut -d'.' -f1)[ -n "$MAX_PL" ] && sudo nvidia-smi -pl "$MAX_PL" &>/dev/null
    fi
}

# Functional NIS Implementation
nvidia_upscale_protocol() {
    NIS_STATE_FILE="/tmp/modus_nis_state"
    if[ "$IS_NVIDIA" == "true" ] && [ "$IS_X11" == "true" ]; then
        modus_say "Enclave Optics: Configure NVIDIA Image Scaling (NIS)?"
        echo -e "  1) Quality (0.75) | 2) Performance (0.66) | 3) Native (Off)"
        read -p "▶ Choice: " nis_c
        case $nis_c in
            1) RATIO=0.75 ;;
            2) RATIO=0.66 ;;
            *) modus_say "Optics set to Native."; return ;;
        esac
        
        modus_say "Configuring Display Scaling..."
        # Save current view configuration for restoration
        nvidia-settings -q all | grep -A 3 "Attribute: CurrentMetaMode" > "$NIS_STATE_FILE"
        
        # Apply NIS
        PRIMARY_DISP=$(xrandr | grep " connected primary" | awk '{print $1}')
        if [ -n "$PRIMARY_DISP" ]; then
             nvidia-settings --assign CurrentMetaMode="${PRIMARY_DISP}: nvidia-auto-select +0+0 { NVNISViewPort=Out, NVNISViewPortScalingRatio=${RATIO} }" &>/dev/null
             modus_say "NIS Activated. The wasteland never looked so sharp."
        else
             modus_say "Primary display not detected. Manual configuration required in nvidia-settings."
        fi
    elif [ "$IS_NVIDIA" == "true" ] &&[ "$IS_X11" == "false" ]; then
        modus_say "${YELLOW}Wayland detected. Automatic NIS configuration disabled.${NC}"
        modus_say "Please enable 'Image Scaling' in NVIDIA Settings manually if required."
    fi
}

restore_nis() {
    if[ -f "/tmp/modus_nis_state" ]; then
        modus_say "Simulation concluded. Restoring original display configuration..."
        nvidia-settings --load-config-only &>/dev/null
        rm -f /tmp/modus_nis_state
        modus_say "Optics restored to civilian baseline."
    fi
}

# Instant DNA Patching
patch_ini() {
    modus_say "Rewriting simulation DNA... targeting configuration archives."
    if [ -f "$FO76_INI" ]; then
        # Backup
        cp "$FO76_INI" "${FO76_INI}.modus_bak"
        sed -i 's/iPresentInterval=1/iPresentInterval=0/g' "$FO76_INI"
        modus_say "Archive modified. Engine-level VSync... purged."
    else
        modus_say "${YELLOW}WARNING: DNA Archive (INI) not found.${NC}"
        modus_say "Launch the game once to generate genetics, then run this protocol again."
    fi
}

# --- 4. LAUNCH ---
launch_simulation() {
    read -p "▶ Set Temporal Frequency (FPS Limit, 0=Unlimited): " fps_val
    
    export DXVK_STATE_CACHE=1
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
    export __GL_SHADER_DISK_CACHE_SIZE=10737418240
    [[ "$fps_val" -gt 0 ]] && export DXVK_FRAME_RATE=$fps_val

    if[ "$SELECTED_PROTON" == "CachyOS" ]; then
        export PROTON_NO_ESYNC=0; export PROTON_NO_FSYNC=0
        modus_say "CachyOS Enhancements active. God bless the Enclave."
    else
        export DXVK_ASYNC=1
        modus_say "Glorious Edition Baseline active. Transitioning..."
    fi

    # Trap Exit to Ensure Cleanup
    trap restore_nis EXIT
    
    modus_say "Launching Fallout 76 (AppID: $FO76_APP_ID)..."
    steam "steam://rungameid/$FO76_APP_ID" &
    
    modus_say "Monitoring simulation... (Close terminal to detach, or wait for game exit to restore NIS)"
    
    # MODUS Optimization: Wait for game to boot, then monitor the process so the terminal holds open
    sleep 15
    while pgrep -f "Fallout76.exe" > /dev/null; do
        sleep 5
    done
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
    echo -e "          ${TF_BAR}  ${BOLD}MODUS ARCHITECT EDITION${NC}  ${TF_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    [ "$IS_NOBARA" == "true" ] && echo -e "${GREEN}${BOLD}OPTIMAL COMBAT OS: NOBARA PROJECT DETECTED${NC}"
    echo -e "${CYAN}BRAIN:${NC} $CPU | ${CYAN}VISUALS:${NC} $GPU"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- MAIN ---
show_banner
provision_terminal

echo -e "${BOLD}Select Protocol:${NC}"
echo -e "  1) ${GREEN}TOTAL PURITY${NC} (Complete Transition + Launch)"
echo -e "  2) ${MAGENTA}SYNC PROTON LAYERS${NC} (Update GE/CachyOS)"
echo -e "  3) ${RED}RECOVERY${NC} (Revert Volatile Tweaks & NIS)"
echo -e "  4) Exit\n"
read -p "▶ Selection: " main_choice

case $main_choice in
    1)
        sync_proton_layers
        echo -e "\n${BOLD}Select Simulation Layer:${NC}"
        echo -e "  1) Proton-CachyOS $([ "$IS_NVIDIA" == "true" ] && echo -e "${YELLOW}(MODUS RECOMMENDED)${NC}")"
        echo -e "  2) GE-Proton"
        read -p "▶ Choice: " p_c
        SELECTED_PROTON=$([ "$p_c" == "1" ] && echo "CachyOS" || echo "GE")
        
        nvidia_upscale_protocol
        apply_tweaks
        patch_ini
        launch_simulation
        ;;
    2) sync_proton_layers ;;
    3) 
        [[ -f "$STATE_FILE" ]] && bash "$STATE_FILE" && rm "$STATE_FILE" && modus_say "System Restored."
        restore_nis
        ;;
    *) exit 0 ;;
esac
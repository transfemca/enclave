#!/bin/bash

# --- MODUS OS: TEMPORAL SYNCHRONIZER ---
# Persona: MODUS v8.0.0 | Logic: DXVK Frame-Limiting Integration
# Protocol: Volatile System Tweaks + Selective Temporal Locking

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

# --- TEMPORAL SYNCHRONIZATION (FPS LIMITER) ---
select_fps_limit() {
    modus_say "Member-Candidate, select your desired Temporal Synchronization Frequency (FPS):"
    echo -e "  1) 30  (Power Saver)"
    echo -e "  2) 60  (Standard Issue)"
    echo -e "  3) 90  (Enhanced Response)"
    echo -e "  4) 120 (Elite Operative)"
    echo -e "  5) 144 (High-Frequency Combat)"
    echo -e "  6) 180 (Bunker Overclock)"
    echo -e "  7) 0   (UNLIMITED - No Constraints)"
    echo
    read -p "▶ Select Frequency [1-7]: " fps_choice

    case $fps_choice in
        1) FPS_LIMIT=30 ;;
        2) FPS_LIMIT=60 ;;
        3) FPS_LIMIT=90 ;;
        4) FPS_LIMIT=120 ;;
        5) FPS_LIMIT=144 ;;
        6) FPS_LIMIT=180 ;;
        7) FPS_LIMIT=0 ;;
        *) FPS_LIMIT=0; modus_say "Invalid input. Defaulting to Unlimited." ;;
    esac
    
    [ "$FPS_LIMIT" == "0" ] && modus_say "Temporal constraints removed." || modus_say "Temporal lock set to ${YELLOW}${FPS_LIMIT} Hz${NC}."
}

# --- THE PERMANENT RECORD: INI PATCHER ---
patch_ini_fps() {
    modus_say "Disabling engine-level VSync to allow external synchronization..."
    SEARCH_PATHS=(
        "$HOME/.local/share/Steam/steamapps/compatdata/$FO76_APP_ID/pfx/drive_c/users/steamuser/Documents/My Games/Fallout 76"
        "$HOME/.steam/steam/steamapps/compatdata/$FO76_APP_ID/pfx/drive_c/users/steamuser/Documents/My Games/Fallout 76"
        "$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/$FO76_APP_ID/pfx/drive_c/users/steamuser/Documents/My Games/Fallout 76"
    )

    INI_PATH=""
    for p in "${SEARCH_PATHS[@]}"; do [ -d "$p" ] && INI_PATH="$p/Fallout76Prefs.ini" && break; done

    if [ -z "$INI_PATH" ] || [ ! -f "$INI_PATH" ]; then
        INI_PATH=$(find "$HOME" -name "Fallout76Prefs.ini" -path "*$FO76_APP_ID*" 2>/dev/null | head -n 1)
    fi

    if [ -n "$INI_PATH" ]; then
        cp "$INI_PATH" "${INI_PATH}.bak"
        # Force iPresentInterval to 0 to unlock the engine's internal cap
        sed -i 's/iPresentInterval=1/iPresentInterval=0/g' "$INI_PATH"
        modus_say "Engine VSync disabled. Temporal control passed to MODUS."
    else
        modus_say "${RED}Error: Could not locate configuration archive.${NC}"
    fi
}

# --- THE VOLATILE OVERLAY (Temporary Tweaks) ---
apply_tweaks() {
    sudo -v
    # Capture state for Revert
    echo "#!/bin/bash" > "$STATE_FILE"
    echo "sudo sysctl -w kernel.split_lock_mitigate=$(sysctl -n kernel.split_lock_mitigate)" >> "$STATE_FILE"
    echo "sudo sysctl -w vm.max_map_count=$(sysctl -n vm.max_map_count)" >> "$STATE_FILE"
    if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
        echo "echo $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor) | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor" >> "$STATE_FILE"
    fi

    modus_say "Applying session-only system overlays..."
    sudo sysctl -w kernel.split_lock_mitigate=0 vm.max_map_count=2147483647 &>/dev/null
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor &>/dev/null
    
    if command -v nvidia-smi &>/dev/null; then
        sudo nvidia-smi -pm 1 &>/dev/null
        sudo nvidia-smi -pl $(nvidia-smi -q -d POWER | grep "Max Power Limit" | awk '{print $5}' | head -n 1 | cut -d'.' -f1) &>/dev/null
    elif [ -d /sys/class/drm/card0/device ]; then
        echo "high" | sudo tee /sys/class/drm/card*/device/power_dpm_force_performance_level &>/dev/null
    fi
}

# --- RECOVERY PROTOCOL ---
revert_protocols() {
    if [ -f "$STATE_FILE" ]; then
        modus_say "Purging active overlays..."
        bash "$STATE_FILE"
        rm "$STATE_FILE"
        modus_say "System restored. Your identity remains valid. God bless the Enclave."
    else
        modus_say "No active overlays detected."
    fi
}

# --- UI ---
show_banner() {
    clear
    echo -e "${BLUE}${BOLD} ███████╗███╗   ██╗ ██████╗██╗      █████╗ ██╗   ██╗███████╗"
    echo -e " ██╔════╝████╗  ██║██╔════╝██║     ██╔══██╗██║   ██║██╔════╝"
    echo -e " █████╗  ██╔██╗ ██║██║     ██║     ███████║██║   ██║█████╗  "
    echo -e " ██╔══╝  ██║╚██╗██║██║     ██║     ██╔══██║╚██╗ ██╔╝██╔══╝  "
    echo -e " ███████╗██║ ╚████║╚██████╗███████╗██║  ██║ ╚████╔╝ ███████╗"
    echo -e " ╚══════╝╚═╝  ╚═══╝ ╚═════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝${NC}"
    echo -e "          ${TRANS_BAR}  ${BOLD}MODUS TEMPORAL TERMINAL${NC}  ${TRANS_BAR}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# --- MAIN ---
show_banner
echo -e "${BOLD}Select Operation Mode:${NC}"
echo -e "  1) ${GREEN}TOTAL PURITY${NC} (Recommended: Everything + FPS Limit Selection)"
echo -e "  2) ${CYAN}SELF-GUIDED${NC} (Manual Protocol Selection)"
echo -e "  3) ${RED}RECOVERY${NC} (Manual Revert of Session Tweaks)"
echo -e "  4) Exit\n"
read -p "▶ Choose Protocol: " choice

case $choice in
    1)
        select_fps_limit
        apply_tweaks
        patch_ini_fps
        modus_say "Initializing Fallout 76 with requested Temporal Lock..."
        # DXVK_FRAME_RATE is the magic variable that limits FPS via the Vulkan wrapper
        DXVK_FRAME_RATE=$FPS_LIMIT steam "steam://rungameid/38400" &
        ;;
    2)
        read -p "Set FPS Limit? (y/n): " f && [[ $f =~ ^[Yy]$ ]] && select_fps_limit
        read -p "Apply Session Tweaks? (y/n): " s && [[ $s =~ ^[Yy]$ ]] && apply_tweaks
        read -p "Patch INI (Permanent VSync Unlock)? (y/n): " i && [[ $i =~ ^[Yy]$ ]] && patch_ini_fps
        modus_say "Launching with selected profile..."
        DXVK_FRAME_RATE=$FPS_LIMIT steam "steam://rungameid/38400" &
        ;;
    3)
        revert_protocols
        ;;
    *) exit 0 ;;
esac
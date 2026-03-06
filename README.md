# 🦅 ENCLAVE TERMINAL -- VIDEOFREE OPTIMIZATION PROTOCOL

> **ACCESS LEVEL:** WHITESPRING BUNKER TERMINAL\
> **CLEARANCE:** ENCLAVE OPERATOR\
> **STATUS:** AUTHORIZED

> *"Restoring America... one optimization at a time."*\
> --- Enclave Terminal Broadcast

------------------------------------------------------------------------

# 📼 videofree.sh

### Fallout 76 Performance Optimization Protocol

This repository contains **`videofree.sh`**, a **terminal-based
optimization system** designed to prepare your machine for **Fallout 76
combat operations**.

Through a series of **system-level adjustments**, **shader cache
cleansing**, and **performance prioritization**, this script aligns your
machine with the **Enclave doctrine of maximum operational efficiency**.

The script operates like a **pre-flight terminal sequence** before
launching Fallout 76.

Think of it as:

> **MODUS performing diagnostics on your rig before deployment.**

------------------------------------------------------------------------

# 🏛️ Enclave Doctrine

The Enclave believes in **purity, efficiency, and control**.

Your operating system is no different.

Modern systems accumulate:

-   shader cache debris
-   memory fragmentation
-   background service interference
-   power profile inefficiencies
-   GPU power throttling

These are the **digital equivalent of wasteland radiation**.

`videofree.sh` **cleanses these impurities**.

Just as the Enclave purifies America,\
this script **purifies your runtime environment**.

------------------------------------------------------------------------

# ⚙️ What This Script Does

The script performs multiple **optimization phases**.

Each phase can be **approved interactively** by the operator.

------------------------------------------------------------------------

# 🧠 Phase 1 -- Kernel Optimization

If **Root Mode** is selected, the script modifies kernel parameters.

## Changes

  -----------------------------------------------------------------------
  Setting                             Purpose
  ----------------------------------- -----------------------------------
  `kernel.split_lock_mitigate=0`      removes performance penalties

  `vm.max_map_count=2147483647`       increases memory mapping capability

  `lru_gen` tuning                    improves memory reclaim efficiency

  Transparent Huge Pages → `madvise`  better memory behavior for games

  power profile → `performance`       CPU operates at full potential
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 🔧 Phase 2 -- Service Shutdown

The script optionally shuts down background services.

## Ollama

Local AI inference services can consume CPU/GPU.

The script temporarily stops:

    ollama.service

If it was running, the script records this state and restores it during
`revert`.

------------------------------------------------------------------------

## Steam Shutdown

Steam is asked to shut down gracefully:

    steam -shutdown

This prevents shader conflicts and ensures clean cache rebuilding.

------------------------------------------------------------------------

# 🎮 Phase 3 -- GPU Power Unlock

If an **NVIDIA GPU** is detected, the script performs:

    nvidia-smi -pm 1

This enables **persistence mode**, keeping the GPU initialized.

Then:

    nvidia-smi -pl MAX_POWER_LIMIT

This unlocks the **maximum power envelope** supported by the GPU.

------------------------------------------------------------------------

# 🧹 Phase 4 -- Fallout 76 Shader Cache Purge

Fallout 76 uses **Vulkan / Proton shader caches**.

The script deletes:

    ~/.steam/steamapps/shadercache/38400
    ~/.local/share/Steam/steamapps/shadercache/38400

Where `38400` is the **Steam AppID for Fallout 76**.

Steam will rebuild shaders automatically on launch.

------------------------------------------------------------------------

# 🧼 Phase 5 -- RAM Cache Flush

When running in **Root Mode**, the script flushes filesystem caches.

    sync
    echo 3 > /proc/sys/vm/drop_caches
    sync

------------------------------------------------------------------------

# 📡 Phase 6 -- Fallout Priority Watcher

The script launches a **detached monitoring process**.

The watcher waits for:

    Fallout76.exe

When detected:

    renice -20
    ionice -c1 -n0

This gives Fallout **maximum CPU and I/O priority**.

------------------------------------------------------------------------

# 🧪 Dry Run Mode

Simulate execution without making changes.

    ./videofree.sh dry-run

------------------------------------------------------------------------

# 🔁 Reverting Changes

System state is stored in:

    /var/tmp/videofree_revert_state.sh

To revert:

    ./videofree.sh revert

------------------------------------------------------------------------

# 🖥️ Operation Modes

Menu presented on startup:

    1) Super User / Root Mode
    2) Standard User Mode
    3) Exit

## Root Mode

Requires sudo.

Enables:

-   kernel tuning
-   GPU unlocking
-   service control
-   RAM purge

## Standard Mode

Runs only user-safe operations.

------------------------------------------------------------------------

# 🧾 Example Execution

    chmod +x videofree.sh
    ./videofree.sh

------------------------------------------------------------------------

# 🏳️ Banner

The script displays a **trans flag themed Enclave banner**.

Because:

-   the wasteland is harsh
-   the Enclave may be authoritarian
-   but **trans rights are still human rights**

Even after nuclear annihilation.

------------------------------------------------------------------------

# ⚠️ Disclaimer

This script modifies system behavior.

Use responsibly.

------------------------------------------------------------------------

# 🦅 Enclave Closing Statement

Citizens of America...

Your system will run **Fallout 76 at peak efficiency**.

Because the Enclave demands **nothing less than perfection**.

------------------------------------------------------------------------

# 🇺🇸 Final Transmission

    GLORY TO THE ENCLAVE.
    GOD BLESS AMERICA.

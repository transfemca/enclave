🦅 ENCLAVE TERMINAL – VIDEOFREE OPTIMIZATION PROTOCOL
=====================================================

> **ACCESS LEVEL:** WHITESPRING BUNKER TERMINAL**CLEARANCE:** ENCLAVE OPERATOR**STATUS:** AUTHORIZED

> _“Restoring America… one optimization at a time.”_— Enclave Terminal Broadcast

📼 enclave.sh
===============

### Fallout 76 Performance Optimization Protocol

This repository contains **enclave.sh**, a **terminal-based optimization system** designed to prepare your machine for **Fallout 76 combat operations**.

Through a series of **system-level adjustments**, **shader cache cleansing**, and **performance prioritization**, this script aligns your machine with the **Enclave doctrine of maximum operational efficiency**.

The script operates like a **pre-flight terminal sequence** before launching Fallout 76.

Think of it as:

> **MODUS performing diagnostics on your rig before deployment.**

🏛️ Enclave Doctrine
====================

The Enclave believes in **purity, efficiency, and control**.

Your operating system is no different.

Modern systems accumulate:

*   shader cache debris
    
*   memory fragmentation
    
*   background service interference
    
*   power profile inefficiencies
    
*   GPU power throttling
    

These are the **digital equivalent of wasteland radiation**.

enclave.sh **cleanses these impurities**.

Just as the Enclave purifies America,this script **purifies your runtime environment**.

⚙️ What This Script Does
========================

The script performs multiple **optimization phases**.

Each phase can be **approved interactively** by the operator.

🧠 Phase 1 – Kernel Optimization
================================

If **Root Mode** is selected, the script modifies kernel parameters.

These changes allow Fallout 76 to **use system resources more aggressively**.

🔧 Phase 2 – Service Shutdown
=============================

The script optionally shuts down background services.

### Steam Shutdown

Steam is asked to shut down gracefully:

steam -shutdown

This prevents shader conflicts and ensures clean cache rebuilding.

🎮 Phase 3 – GPU Power Unlock
=============================

If an **NVIDIA GPU** is detected, the script performs:

nvidia-smi -pm 1

This enables **persistence mode**, keeping the GPU initialized.

Then:

nvidia-smi -pl MAX\_POWER\_LIMIT

This unlocks the **maximum power envelope** supported by the GPU.

This prevents **power throttling during gameplay**.

🧹 Phase 4 – Fallout 76 Shader Cache Purge
==========================================

Fallout 76 uses **Vulkan / Proton shader caches**.

Over time these become corrupted or bloated.

The script deletes:

~/.steam/steamapps/shadercache/38400~/.local/share/Steam/steamapps/shadercache/38400

Where 38400 is the **Steam AppID for Fallout 76**.

Steam will rebuild shaders automatically on launch.

This resolves:

*   stuttering
    
*   frame pacing issues
    
*   shader compilation spikes
    

🧼 Phase 5 – RAM Cache Flush
============================

When running in **Root Mode**, the script flushes filesystem caches.

Sequence:

syncecho 3 > /proc/sys/vm/drop\_cachessync

This clears:

*   page cache
    
*   dentries
    
*   inode caches
    

The system enters a **fresh memory state**.

📡 Phase 6 – Fallout Priority Watcher
=====================================

The script launches a **detached monitoring process**.

This watcher waits for:

Fallout76.exe

When detected:

renice -20ionice -c1 -n0

This gives Fallout **maximum CPU and I/O priority**.

This prevents background tasks from interrupting gameplay.

🧪 Dry Run Mode
===============

You can simulate execution without making changes.

./enclave.sh dry-run

The script prints every command it **would execute**.

Useful for:

*   testing
    
*   debugging
    
*   verifying permissions
    

🔁 Reverting Changes
====================

The script stores system state in:

/var/tmp/enclave\_revert\_state.sh

To revert:

./enclave.sh revert

This restores:

*   kernel parameters
    
*   power profile
    
*   GPU limits
    
*   services
    

Your system returns to **pre-optimization state**.

🖥️ Operation Modes
===================

When launched, the script presents a terminal menu.

1) Super User / Root Mode 2) Standard User Mode 3) Exit

Root Mode
---------

Requires sudo access.

Enables:

*   kernel tuning
    
*   GPU unlocking
    
*   service control
    
*   RAM purge
    

Recommended for **maximum performance**.

Standard Mode
-------------

Runs only user-safe operations:

*   shader cleanup
    
*   Steam shutdown
    
*   user process tuning
    

No root permissions required.

🧾 Example Execution
====================

chmod +x enclave.sh./enclave.sh

\[ ACCESS GRANTED - WHITESPRING BUNKER TERMINAL \]Restoring America... One Optimization at a Time.Select Operation Mode:1) Super User / Root Mode2) Standard User Mode3) Exit

🏳️ Banner
==========

The script displays a T**rans Flag themed Enclave banner**.

Because:

*   the wasteland is harsh
    
*   the Enclave may be authoritarian
    
*   but **trans rights are still human rights**
    

Even after nuclear annihilation.

☢️ Fallout References Embedded
==============================

The script contains references to:

*   **MODUS**
    
*   **Whitespring Bunker**
    
*   **Enclave terminals**
    
*   **Fallout 76**
    
*   **S.P.E.C.I.A.L.**
    
*   **pre-war America**
    
*   **Enclave broadcasts**
    

Random quotes appear during startup.

Example:

> “MODUS at your service. Analyzing optimal performance vectors.”

or

> “My pronouns are they/them, my S.P.E.C.I.A.L. is 10/10.”

🧯 Supported Systems
====================

Primarily designed for:

Fedora Linux Based Systems

Other distributions **may work** but are not guaranteed.

The script checks:

/etc/os-release

If unsupported, it displays a warning.

⚠️ Disclaimer
=============

This script modifies system behavior.

While reversible, you should understand:

*   kernel parameter changes affect system performance
    
*   GPU power limits increase power consumption
    
*   cache flushing can briefly impact disk activity
    

Use responsibly.

🧠 Philosophy
=============

Most "gaming optimizers" are:

*   closed source
    
*   Windows-only
    
*   full of placebo tweaks
    

enclave.sh focuses on **real Linux performance controls**.

Everything it does is:

*   transparent
    
*   reversible
    
*   inspectable
    

🦅 Enclave Closing Statement
============================

> Citizens of America…

The wasteland is dangerous.

Raiders roam the hills.

Super mutants lurk in abandoned factories.

But your system?

Your system will run **Fallout 76 at peak efficiency**.

Because the Enclave demands **nothing less than perfection**.

🇺🇸 Final Transmission
=======================

GLORY TO THE ENCLAVE.GOD BLESS AMERICA.

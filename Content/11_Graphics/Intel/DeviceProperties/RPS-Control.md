# `WhateverGreen.kext` and the `rps-control` property for Intel iGPUs

**INDEX**

- [About RPS-Control](#about-rps-control)
- [RPS-Control in the context of hackintoshing](#rps-control-in-the-context-of-hackintoshing)
  - [1. Purpose of `rps-control` in macOS](#1-purpose-of-rps-control-in-macos)
  - [2. Mechanism of rps-control](#2-mechanism-of-rps-control)
  - [3. Implementation in macOS](#3-implementation-in-macos)
  - [4. Technical Workflow](#4-technical-workflow)
  - [5. Benefits in macOS](#5-benefits-in-macos)
  - [6. Caveats and Considerations](#6-caveats-and-considerations)
  - [7. Relation to Intel’s RPS Technique](#7-relation-to-intels-rps-technique)
  - [8. Practical Example](#8-practical-example)
  - [9. Troubleshooting](#9-troubleshooting)

--- 
## About RPS-Control

The term **"rps-control"** in the context of Intel GPUs refers to **Render Power States control**, a feature related to power management in Intel's integrated graphics processing units (iGPUs). It is part of Intel's **RC6** (Render C6) power-saving technology, which allows the GPU to enter low-power states when idle or under light load to reduce energy consumption. The "rps" specifically stands for **Render Power States**, and it manages the GPU's power and performance by dynamically adjusting clock frequencies and voltage based on workload demands.

## RPS-Control in the context of hackintoshing

The **rps-control** property in **WhateverGreen.kext** for macOS, used primarily in Hackintosh systems, is a patch that enhances the power management of Intel integrated GPUs (iGPUs) by optimizing the **Render Power States (RPS)** mechanism. This mechanism, native to Intel GPUs, dynamically adjusts the GPU’s clock frequency and voltage based on workload to balance performance and power efficiency. In macOS, particularly on non-Apple hardware, the native power management for Intel iGPUs can be incomplete or suboptimal due to missing Apple-specific firmware or Management Engine (ME) support. The `rps-control` patch addresses this by enabling or fine-tuning Intel’s RPS functionality to ensure proper operation on Hackintosh systems.

### 1. Purpose of `rps-control` in macOS

- **Core Objective**: The `rps-control` patch ensures that Intel iGPUs on Hackintosh systems correctly transition between power states (e.g., RC6, RC6p, or higher performance states) to avoid performance issues like stuttering, low frame rates, or excessive power consumption.
- **Context**: macOS expects Intel iGPUs to operate with Apple’s proprietary power management, which relies on specific firmware and ME integration. On Hackintosh systems, these are often absent or mismatched, leading to suboptimal GPU behavior. The `rps-control` patch bridges this gap by injecting logic to manage GPU power states effectively.
- **Outcome**: It enables dynamic frequency scaling (similar to Intel’s **Dynamic Voltage and Frequency Scaling (DVFS)**) and proper entry/exit from low-power states, improving performance for graphics-intensive tasks (e.g., video playback, gaming) and power efficiency for idle or light workloads.

### 2. Mechanism of rps-control
The `rps-control` patch, implemented via **WhateverGreen.kext** (a Lilu plugin), works by modifying the behavior of the Intel graphics driver in macOS (`AppleIntel*Framebuffer.kext` or similar) to better handle RPS. Here’s how it operates:

- **Enabling RPS**: 
  - The patch activates Intel’s Render Power States, which include low-power states like **RC6** (basic idle state), **RC6p** (deep idle state), and higher-performance states for active workloads.
  - It ensures the iGPU can dynamically adjust its frequency (e.g., from 300 MHz to 1200 MHz, depending on the GPU model) based on demand.
- **Patching Power Management**: 
  - On Hackintosh systems, macOS may fail to properly initialize or control the iGPU’s power states due to mismatched hardware IDs or lack of Apple’s Management Engine. The `rps-control` patch overrides these limitations by injecting custom logic into the graphics driver.
  - It modifies the iGPU’s **P-state** (performance state) transitions, ensuring the GPU scales up for demanding tasks and down for idle scenarios.
- **Preventing Stuttering**: 
  - Without proper RPS management, the iGPU may get stuck in a low-frequency state, causing stuttering in animations, video playback, or games. The `rps-control` patch ensures smooth transitions to higher frequencies when needed.
- **Interaction with macOS Drivers**: 
  - The patch works within the macOS kernel, leveraging WhateverGreen’s ability to hook into and modify the Intel framebuffer driver. It ensures compatibility with macOS’s expectations for GPU behavior while compensating for non-Apple hardware.

### 3. Implementation in macOS

The `rps-control` patch was introduced in WhaveverGreen v1.4.1 as an auto-enabled feature. It can be utilized by Kaby Lake and newer CPUs. Since RPS Control caused issues in macOS Catalina 10.15.6 due to a bug in the iGPU drivers, it was disabled in v1.4.2. Since then, the RPS control patch it has to be enabled manually by a boot-arg or device property of the iGPU (see below).

- **Configuration**:
  - The `rps-control` patch is enabled via **WhateverGreen.kext** using either a boot argument or a device property in the bootloader configuration (OpenCore or Clover).
  - **Boot Argument**: Add `-igfxrpsc=1` to the boot arguments in your `config.plist`.
  - **Device Property**: Add the `rps-control` property under the iGPU’s device path (e.g., `PciRoot(0x0)/Pci(0x2,0x0)` for integrated GPUs) in the `DeviceProperties` section of your `config.plist`. 
  
    **Example**:
    ```xml
    <key>PciRoot(0x0)/Pci(0x2,0x0)</key>
    <dict>
        <key>rps-control</key>
        <integer>1</integer>
    </dict>
    ```
- **Dependencies**:
  - Requires **Lilu.kext** (the parent kext for WhateverGreen) to be loaded first.
  - Must be used with a correctly configured `ig-platform-id` and, if necessary, a spoofed `device-id` to match the iGPU to a supported macOS configuration.
- **Supported GPUs**: The patch is relevant for Intel iGPUs from Haswell (4th Gen) to newer architectures like Skylake, Kaby Lake, Coffee Lake, Comet Lake, and Alder Lake (UHD Graphics, Iris Plus, Iris Xe, etc.).

### 4. Technical Workflow
Here’s a simplified workflow of how `rps-control` operates in macOS:
1. **Initialization**: During boot, WhateverGreen.kext loads and applies the `rps-control` patch to the Intel graphics driver.
2. **Patching Framebuffer**: The patch modifies the framebuffer driver to enable RPS features, ensuring proper initialization of power states (e.g., RC6, RC6p).
3. **Dynamic Frequency Scaling**: The iGPU monitors workload (e.g., via macOS’s graphics stack or OpenGL/Metal APIs) and adjusts its frequency. For example:
   - Idle: Drops to a low frequency (e.g., 300 MHz) and enters RC6 for power savings.
   - Active: Scales up to a higher frequency (e.g., 1000–1300 MHz) for rendering tasks.
4. **Power State Transitions**: The patch ensures smooth transitions between power states, preventing issues like the GPU getting stuck in a low-power state during high demand.
5. **Monitoring and Feedback**: The driver continuously monitors GPU utilization and adjusts P-states, with `rps-control` ensuring these adjustments are responsive and stable.

### 5. Benefits in macOS
- **Improved Performance**: Prevents stuttering or lag in graphics-intensive applications (e.g., Final Cut Pro, games, or UI animations) by ensuring the iGPU scales to appropriate frequencies.
- **Power Efficiency**: Enables low-power states (e.g., RC6) to reduce energy consumption, which is critical for Hackintosh laptops.
- **Stability**: Fixes issues where macOS’s native power management fails to properly handle Intel iGPUs on non-Apple hardware.
- **Compatibility**: Makes Intel iGPUs behave more like they would on a real Mac, ensuring better integration with macOS’s graphics stack (e.g., Metal).

### 6. Caveats and Considerations
- **Not Always Necessary**: If your iGPU is already working well with a correct `ig-platform-id` and native macOS power management, `rps-control` may not provide noticeable benefits.
- **Potential Risks**: Incorrect configuration (e.g., mismatched `ig-platform-id` or outdated kexts) can cause kernel panics, boot loops, or graphical glitches. Always use the latest versions of **Lilu** and **WhateverGreen** (as of June 8, 2025, check acidanthera’s GitHub for updates).
- **Testing and Validation**: To verify `rps-control` is working:
  - Use **Intel Power Gadget** to monitor iGPU frequency and power usage.
  - Check **IOREG** (using IORegistryExplorer) to confirm the iGPU is using the expected power states.
  - Use **AppleIntelInfo.kext** to dump P-state information:
    ```bash
    sudo kextload AppleIntelInfo.kext
    sudo cat /tmp/AppleIntelInfo.dat
    ```
    Look for multiple P-states (e.g., P0, P1, P2) and RC6 residency to confirm dynamic scaling.
- **macOS Version Dependency**: The effectiveness of `rps-control` may vary across macOS versions (e.g., Ventura, Sonoma, Sequoia). Always test with your specific macOS version.

### 7. Relation to Intel’s RPS Technique
The `rps-control` patch in WhateverGreen.kext directly interfaces with Intel’s **Render Power States** mechanism, as described in my previous response. It ensures that macOS can properly manage the iGPU’s **RC6** and other power states, which are critical for dynamic frequency scaling and power efficiency. Without this patch, Hackintosh systems may experience:
- The iGPU getting stuck in a low-frequency state, causing performance issues.
- Failure to enter low-power states, leading to higher power consumption.
- Inconsistent behavior in macOS’s graphics stack due to missing Apple-specific power management logic.

The patch essentially emulates or enhances Apple’s native power management for Intel iGPUs, making it a direct application of Intel’s RPS technology tailored for Hackintosh environments.

### 8. Practical Example
For a Hackintosh with an Intel UHD Graphics 630 (Coffee Lake):
- **Problem**: The iGPU exhibits stuttering during video playback or UI animations due to improper frequency scaling.
- **Solution**: 
  - Add `rps-control=1` to the `DeviceProperties` for `PciRoot(0x0)/Pci(0x2,0x0)` in OpenCore’s `config.plist`.
  - Ensure `ig-platform-id` is set correctly (e.g., `0x3E9B0007` for headless or `0x3E920007` for full acceleration).
  - Boot with `-igfxrpsc` for testing.
- **Result**: The iGPU dynamically scales between 300 MHz (idle) and 1200 MHz (load), enters RC6 during idle periods, and provides smooth performance in macOS.

### 9. Troubleshooting
If `rps-control` doesn’t work as expected:
- **Verify Configuration**: Ensure `Lilu.kext` and `WhateverGreen.kext` are up-to-date and loaded in the correct order (Lilu before WhateverGreen).
- **Check Logs**: Use `log show --predicate "process == 'kernel'" | grep WhateverGreen` to check for errors in kext loading.
- **Update macOS**: Some macOS versions have bugs in Intel iGPU drivers; test with the latest macOS update.
- **Alternative Patches**: If issues persist, consider additional WhateverGreen properties like `enable-dpcd-max-link-rate-fix` or `force-complete-mode-set` for specific iGPU quirks.

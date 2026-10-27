# AMD APU Graphics Support in macOS

AMD APU (Accelerated Processing Unit) graphics refer to the integrated GPU cores found within AMD Ryzen and A-series processors. By design, AMD integrated graphics were never supported by macOS, as Apple used Intel CPUs exclusively between 2006 and 2020 before transitioning to their own ARM-based Apple Silicon chips. However, with the development of the **NootedRed** project, many Vega-based APUs now feature Metal acceleration. This article covers the implementation and current constraints of this setup.

## Hardware & OS Compatibility

Before starting, ensure your hardware falls within the supported generation.

* **Supported Architectures:** Raven Ridge, Picasso, Renoir, Lucienne, Cezanne, and Barcelo.
* **Supported macOS Versions:** macOS Big Sur (11.x) to macOS Tahoe (26.x).
* **System Requirement:** Must be a **UEFI-based** motherboard. Legacy BIOS is not supported.

**External Reference:** 

## Known Limitations

While NootedRed provides graphical acceleration, users should be aware of the following functional gaps at this stage of development:

*   **Graphics API:** Only supports APUs compatible with Metal 2 and Metal 3.
*   **Hardware Codecs:** H.264 and H.265 (HEVC) hardware encoding/decoding are not supported. This results in higher CPU usage during video playback and editing.
*   **Digital Audio:** DP/HDMI Audio is currently not supported.
*   **Analog Video:** VGA output is not supported.
*   **Power Management:** Sleep/Wake functionality is currently broken.
*   **DRM:** Hardware-based DRM (Netflix, Apple TV+) does not function on iGPUs.

## Essential Kexts & Conflicts

The implementation relies on `NootedRed.kext`. Note the strict conflict rules:

| Kext | Requirement | Description |
| :--- | :--- | :--- |
| **Lilu.kext** | **Mandatory** | Required for patching the kernel. |
| **NootedRed.kext** | **Mandatory** | The primary driver for AMD Vega iGPUs. |
| **WhateverGreen.kext** | **Must Remove** | **Conflict!** NootedRed and WhateverGreen cannot be used together. |

> [!CAUTION]
> 
> You **must** remove or disable `WhateverGreen.kext` in your `config.plist`. Keeping both will lead to a Kernel Panic (KP) on boot.

## BIOS Settings

To ensure the APU has enough memory to initialize the framebuffers:

1.  **UMA Framebuffer Size:** Set to **2GB** (Minimum 512MB).
2.  **CSM:** Disabled.
3.  **Above 4G Decoding:** Enabled.

## OpenCore Configuration (config.plist)

### ACPI Patches

*   **SSDT-GPU-DISABLE.aml:** If your laptop has a discrete Nvidia or AMD GPU that is unsupported, use this to disable it and save battery.
*   **SSDT-PNLF.aml:** Required for brightness control on laptop screens. Use the version compatible with AMD/NootedRed.

### DeviceProperties
For most desktop APUs, no specific entries are required as NootedRed handles discovery. For laptops, you may still need to inject `backlight-lamp-type` if the screen remains dark.

### Boot Arguments
Add these to `NVRAM -> Add -> 7C436110-AB2A-4BBB-A880-FE41995C9F82 -> boot-args` as needed:

*   `-nrdall` (Forces NootedRed to attempt loading on all GPUs).
*   `-nrdnoade` (Disables AMD Device Enabler; used if the system hangs during GPU initialization).
*   `-nrd_no_vram_pm` (Disables VRAM power management to prevent certain crashes).

## Additional Resources
* [**Official NootedRed GitHub Repository**](https://github.com/NootInc/NootedRed)
* [**AMD APU Compatibility List for macOS**](https://elitemacx86.com/threads/amd-apu-compatibility-list-for-macos.1157/)
* [**How to Enable AMD Integrated Graphics (APU) on macOS**](https://elitemacx86.com/threads/how-to-enable-amd-integrated-graphics-apu-on-macos-clover-opencore.1156/)

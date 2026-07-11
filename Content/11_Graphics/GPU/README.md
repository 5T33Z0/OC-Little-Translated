# GPU Support in macOS

For a comprehensive overview of hardware compatibility, always refer to Dortania's [**GPU Buyer's Guide**](https://dortania.github.io/GPU-Buyers-Guide/).

## Intel Graphics (iGPU)
For configuration and troubleshooting of Intel on-board graphics:

- [**Intel iGPU Fixes & Patching**](/Content/11_Graphics/iGPU)

---

## AMD Graphics

### Integrated Graphics (APU)
Support for AMD processors with integrated Vega graphics via NootedRed:

- [**AMD APU Support Overview**](/Content/11_Graphics/APU)

### Discrete Graphics (dGPU)
Support for dedicated AMD Radeon cards:

- [**AMD GPU Compatibility Chart**](/Content/11_Graphics/GPU/AMD_GPU_Compatbility.md) — Reference for supported models.
- [**Enabling (Big) Navi Cards**](/Content/11_Graphics/GPU/AMD_Navi) — RX 5000 and 6000 series.
- [**Enabling AMD Vega 56/64 Cards**](/Content/11_Graphics/GPU/AMD_Vega) — Specific fixes for GCN 5 cards.
- [**Enabling Undetected AMD GPUs**](/Content/11_Graphics/GPU/GPU_undetected) — Fixing "Black Screen" or non-recognition issues.
- [**Legacy AMD Cards (ATI/Radeon)**](https://web.archive.org/web/20170814210930/http://www.rampagedev.com/guides/graphic-cards-injection/) — Archive for ATI 4000 through AMD 300 series.

### AMD Utilities & Optimization

- [**SMCAMDProcessor**](https://github.com/trulyspinach/SMCAMDProcessor) – AMD CPU Power Management kext for AMD Zen processorst. Includes AMD Power Gadget
- [**RadeonSensor**](https://github.com/NootInc/RadeonSensor) — Temperature monitoring for AMD GPUs.
- [**AMD Radeon Tweaks**](/Content/11_Graphics/GPU/AMD_Radeon_Tweaks) — Performance and power tuning.
- [**GPU BAR Size in OpenCore**](/Content/main/11_Graphics/GPU/GPU-BAR_Size) — Resizable BAR configurations.

---

## NVIDIA Graphics

### Modern NVIDIA GPUs (Unsupported)
NVIDIA Turing (RTX 20xx), Ampere (RTX 30xx), and Ada Lovelace (RTX 40xx) cards **do not work** in any version of macOS because no drivers exist. 
- [List of Unsupported NVIDIA GPUs](https://dortania.github.io/GPU-Buyers-Guide/modern-gpus/nvidia-gpu.html#unsupported-nvidia-gpus).

### Legacy & Web Driver Support (via OCLP)
While official NVIDIA support ended with High Sierra (Web Drivers) and Big Sur (Native Kepler support), community tools like **OpenCore Legacy Patcher (OCLP)** allow for continued functionality in newer macOS versions. This is necessary because:

*   **Native Kepler Support:** Support for GTX 6xx/7xx cards was removed in macOS Monterey.
*   **Web Driver Revocation:** In 2022, certificates were revoked, making standard Web Driver installation impossible on modern macOS without OCLP's root patching.

#### Verified Models for OCLP Root Patching
The following GPUs that functioned with Web Drivers in High Sierra are generally compatible with OCLP patching in modern macOS:

*   **GTX 650** (Kepler – GK104)
*   **GTX 650 TI Boost** (Kepler – GK106)
*   **GT 710** (Kepler - GK107)
*   **Quadro K620** (Maxwell - GM107)
*   **GTX 860M** (Maxwell - GM107)
*   **GT 1030** (Pascal - GP107)
*   **GTX 1050Ti** (Pascal - GP107)

**Source:** [OCLP GitHub](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/993) | [Installation Guide](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/)

## Troubleshooting & Notes

*   **Legacy Hardware:** Native Kepler support (GTX 600/700 series) was dropped in macOS Monterey. These cards now require root patching with OCLP to enable graphics acceleration.
*   **Hardware Fatigue:** Be cautious when buying older NVIDIA cards (like the GTX 760). Due to their age, these cards have a high failure rate in modern systems.
*   **Web Driver Certificates:** Note that Nvidia Web Driver certificates were revoked by Nvidia in 2022; patching via OCLP is the only reliable way to bypass this on modern macOS versions.


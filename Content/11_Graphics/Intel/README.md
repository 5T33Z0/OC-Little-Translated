# Intel iGPU Support

An incomplete collection of iGPU-related fixes and optimizations for Intel graphics. For general configuration, refer to the [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/). For in-depth patching walkthroughs, see Dortania's [Intel iGPU Patching Guide](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/).

## Intel iGPU Fixes

### Fundamentals & Framebuffer Patching
- [**Intel Framebuffer Patching Guide for Laptops**](/Content/11_Graphics/Intel/Framebuffer_Patching/README.md) — Comprehensive guide to connector patching, flags, and bus IDs when using a Laptop.
- [**Intel Display Pipeline Fundamentals**](/Content/11_Graphics/Intel/Framebuffer_Patching/Technical_Background.md) — Understanding Pipes, BusIDs, and architecture logic.
- [**iGPU Framebuffer List**](/Content/11_Graphics/Intel/iGPU_DeviceProperties.md) — Reference list of common IDs and properties across Intel generations.
- [**Force-enabling graphics with a fake ig-platform-id**](/Content/11_Graphics/Intel/Inject_Fake_IG-Platform-ID/README.md) — How to force-enable graphics when native IDs are unsupported.

### Display Connectivity & Audio Fixes
- [**Injecting EDID to fix display issues**](/Content/11_Graphics/Intel/Inject_EDID/README.md) — Injecting `AAPL00,override-no-connect` to fix black screens, sleep wake, or missing resolutions.
- [**Disabling HDMI/DisplayPort Audio**](/Content/11_Graphics/Intel/iGPU_disable_audio_over_HDMI-DP.md) — Troubleshooting digital audio output conflicts on Intel graphics.

### Generation-Specific Solutions
- [**WhateverXe**](https://github.com/b00t0x/WhateverXe) + [**WhateverXe-Graphics**](https://github.com/b00t0x/WhateverXe-Graphics) – Experimental graphics acceleration for selected Intel Xe-LP iGPUs, targeting **Tiger Lake** and **Alder Lake-N / Twin Lake**. Requires the WhateverXe Lilu plugin, the companion graphics-driver package, Lilu, a modified AMFIPass build, and specific system security settings. Check the repositories for supported GPU IDs, macOS compatibility, and installation instructions.
- [**Skylake Graphics in macOS Ventura+**](/Content/11_Graphics/Intel/Skylake_Spoofing_macOS13/README.md) — Spoofing Gen 6 iGPUs as Kaby Lake for continued support in macOS 13 through 26.
- [**Comet Lake & 500-Series Issues**](/Content/11_Graphics/Intel/Cometlake_Z590/README.md) — Fixes for 10th Gen iGPU display glitches on Z590, H570, and B560 motherboards.

### Optimization, Features & Firmware
- [**Activity Monitor & Metal 3 Support**](/Content/11_Graphics/Intel/Metal_3/README.md) — Enabling the "GPU" tab, hardware acceleration, and Metal 3 in macOS 13+.
- [**Apple's GuC Firmware**](/Content/11_Graphics/Intel/GUC_Firmware.md) — How Graphics MicroCode works, performance benefits, and how to enable it.
- [**The `rps-control` Property**](/Content/11_Graphics/Intel/RPS-Control.md) — Deep-dive into iGPU power management and throttle control.
- [**Enable Firefox Hardware Acceleration**](/Content/11_Graphics/Intel/Enable_Firefox_Hardware-Acceleration.md) — Forcing hardware-accelerated WebRender in Firefox on Intel iGPUs.

---

## Resources & Documentation

- **Pre-made Patches:**
    - [**Desktop EFIs Section**](/Content/F_Desktop_EFIs/README.md) — Includes `DeviceProperties` for most Intel desktop generations.
    - [**Clover Laptop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs) — Source for interchangeable `DeviceProperties` compatible with OpenCore.
- **Deep Technical Specs:**
    - [**DVMT/StolenMem Explained**](https://osxlatitude.com/forums/topic/17804-dvmtstolenmemfbmemcursormem-why-do-we-patch-these-for-broadwell-and-later/) — Why memory patching is required for Broadwell and newer.
    - [**Intel iGPU OpRegion Specs**](https://01.org/sites/default/files/documentation/acpi_igd_opregion_spec_0.pdf) (**PDF**) — Official ACPI IGD OpRegion documentation.

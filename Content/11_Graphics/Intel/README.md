# Intel iGPU Support

An incomplete collection of iGPU-related fixes, workarounds, and optimizations for Intel graphics. For general configuration, refer to the [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/). For in-depth patching walkthroughs, see Dortania's [Intel iGPU Patching Guide](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/).

## Intel iGPU Guides

### Intel iGPU Configuration & Reference

- [**Intel Display Pipeline Fundamentals**](/Content/11_Graphics/Intel/Framebuffer_Patching/Technical_Background.md) — Understanding Pipes, BusIDs, and display pipeline architecture.
- [**iGPU Framebuffer List**](/Content/11_Graphics/Intel/DeviceProperties/iGPU_DeviceProperties.md) — Reference list of common platform IDs and properties across Intel generations.
- [**Intel Graphics Framebuffer Reference**](/Content/11_Graphics/Intel/DeviceProperties/Intel_FB_Reference.md) — Reference for connector types, BusIDs, flags, framebuffer structures, and memory calculations.
- [**Connector and Framebuffer Flags**](/Content/11_Graphics/Intel/DeviceProperties/Connector_Framebuffer_Flags.md) — Reference list of available connector and framebuffer flags.

### iGPU Features & Power Management

- [**Apple's GuC Firmware**](/Content/11_Graphics/Intel/DeviceProperties/GUC_Firmware.md) — How the Graphics Micro Controller firmware works, its performance benefits, and how to enable it.
- [**`rps-control`**](/Content/11_Graphics/Intel/DeviceProperties/RPS-Control.md) — Deep dive into iGPU power management and throttle control.

### Framebuffer Patching & Workarounds

- [**Intel Framebuffer Patching Guide for Laptops**](/Content/11_Graphics/Intel/Framebuffer_Patching/README.md) — Comprehensive guide to connector patching, flags, and BusIDs on laptops.
- [**Force-enabling Graphics with a Fake `ig-platform-id`**](/Content/11_Graphics/Intel/Inject_Fake_IG-Platform-ID/README.md) — How to force-enable graphics when native platform IDs are unsupported.

### Troubleshooting

- [**Injecting EDID to Fix Display Issues**](/Content/11_Graphics/Intel/Inject_EDID/README.md) — Injecting `AAPL00,override-no-connect` to fix black screens, sleep/wake issues, or missing resolutions.
- [**Disabling HDMI/DisplayPort Audio**](/Content/11_Graphics/Intel/DeviceProperties/iGPU_disable_audio_over_HDMI-DP.md) — Troubleshooting digital audio output conflicts on Intel graphics.

### Generation-Specific Solutions

- [**WhateverXe**](https://github.com/b00t0x/WhateverXe) + [**WhateverXe-Graphics**](https://github.com/b00t0x/WhateverXe-Graphics) — Experimental graphics acceleration for selected Intel Xe-LP iGPUs, targeting **Tiger Lake** and **Alder Lake-N / Twin Lake**. Requires the WhateverXe Lilu plugin, companion graphics-driver package, Lilu, a modified AMFIPass build, and specific system security settings. Check the repositories for supported GPU IDs, macOS compatibility, and installation instructions.
- [**Skylake Graphics in macOS Ventura+**](/Content/11_Graphics/Intel/Skylake_Spoofing_macOS13/README.md) — Spoofing Gen 6 iGPUs as Kaby Lake to maintain graphics support in macOS 13 through 26.
- [**Comet Lake & 500-Series Issues**](/Content/11_Graphics/Intel/Cometlake_Z590/README.md) — Fixes for 10th Gen iGPU display glitches on Z590, H570, and B560 motherboards.

### Additional Optimizations

- [**Activity Monitor & Metal 3 Support**](/Content/11_Graphics/Intel/Metal_3/README.md) — Enabling the GPU tab in Activity Monitor, hardware acceleration, and Metal 3 in macOS 13+.
- [**Enable Firefox Hardware Acceleration**](/Content/11_Graphics/Intel/Enable_Firefox_Hardware-Acceleration.md) — Forcing hardware-accelerated WebRender in Firefox on Intel iGPUs.

---

## Resources & Documentation

### Tools for Intel Framebuffer Patching

- [**vbt2fbpatch**](https://github.com/5T33Z0/vbt2fbpatch/tree/main) — [**Web App**](https://vbt2fbpatch.ai.studio/) — Automatically generates Intel iGPU framebuffer patches by analyzing the system's VBT firmware data (connectors, BusIDs, and display pipes) and cross-referencing the results with WhateverGreen's Intel HD Graphics FAQs to identify required framebuffer properties, device-ID spoofs, and platform-specific quirks.
- [**Hackintool**](https://github.com/benbaker76/Hackintool) — GUI-based tool for manually inspecting, configuring, and generating Intel iGPU framebuffer patches, including connector mapping and framebuffer property editing.

### Pre-made Patches

- [**Desktop EFIs Section**](/Content/F_Desktop_EFIs/README.md) — Includes `DeviceProperties` configurations for most Intel desktop generations.
- [**Clover Laptop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/EFIs_and_Configs) — Source of interchangeable `DeviceProperties` configurations compatible with OpenCore.

### Deep Technical Specifications

- [**DVMT/StolenMem Explained**](https://osxlatitude.com/forums/topic/17804-dvmtstolenmemfbmemcursormem-why-do-we-patch-these-for-broadwell-and-later/) — Explains why memory patching is required for Broadwell and newer Intel platforms.
- [**Intel iGPU OpRegion Specifications**](https://cdrdv2-public.intel.com/728117/skl_opregion_rev0p5.pdf) (**PDF**) — Official ACPI IGD OpRegion documentation (PDF).

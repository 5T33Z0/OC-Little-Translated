# iGPU Fixes

An incomplete collection of iGPU-related fixes and optimizations. For general configuration, refer to the [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/). For in-depth patching walkthroughs, see Dortania's [Intel iGPU Patching Guide](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/).

## AMD iGPU Fixes
- [**Enabling AMD Vega iGPUs**](/Content/11_Graphics/iGPU/AMD) (Ryzen-based laptops and APUs)

## Intel iGPU Fixes

### Fundamentals & General Patching
- [**Intel Display Pipeline Fundamentals**](/Content/11_Graphics/iGPU/Framebuffer_Patching/Technical_Background.md) — Understanding Pipes, BusIDs, and architecture logic.
- [**iGPU Framebuffer List**](/Content/11_Graphics/iGPU/iGPU_DeviceProperties.md) — A reference of common IDs across generations.
- [**Fake ig-platform-id**](/Content/11_Graphics/iGPU/Fake_ig-platform-id.md) — How to force-enable graphics when native IDs are unsupported.
- [**Activity Monitor & Metal 3 Support**](/Content/11_Graphics/Metal_3) — Enabling the "GPU" tab, hardware acceleration, and Metal 3 in macOS 13+.

### Generation-Specific Solutions
- [**Skylake Graphics in macOS Ventura**](/Content/11_Graphics/iGPU/Skylake_Spoofing_macOS13) — Spoofing Gen 6 iGPUs for continued support.
- [**Comet Lake & 500-Series Issues**](/Content/11_Graphics/iGPU/Cometlake_Z590#comet-lake-igpu-issues-on-500-series-mainboards) — Fixes for Z590, H570, and B560 motherboards.
- [**Iris Xe (Gen 12) Development**](https://www.insanelymac.com/forum/topic/358305-80-solved-iris-xe-igpu-on-tiger-lake-successfully-loaded-icllp-frambuffer-and-vram-also-recognizes-1536mb-however-some-issues/?do=findComment&comment=2819650) — Information on the NootedBlue project.

### Connectivity & Audio
- [**Laptop External Display Patching**](/Content/11_Graphics/iGPU/Framebuffer_Patching/README.md) — Framebuffer patching to enable HDMI/DisplayPort on notebooks.
- [**Disabling HDMI/DisplayPort Audio**](/Content/11_Graphics/iGPU/iGPU_disable_audio_over_HDMI-DP.md) — Troubleshooting digital audio output conflicts.

### Advanced Optimization & Firmware
- [**Apple's GUC Firmware**](/Content/11_Graphics/iGPU/GUC_Firmware.md) — How Graphics MicroCode works and how to enable it.
- [**The `rps-control` Property**](/Content/11_Graphics/iGPU/RPS-Control.md) — Deep-dive into iGPU power management and throttle control.

## Resources & Documentation
- **Pre-made Patches:**
    - [**Desktop EFIs Section**](/F_Desktop_EFIs) — Includes `DeviceProperties` for most Intel desktop generations.
    - [**Clover Laptop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs) — Source for interchangeable `DeviceProperties` compatible with OpenCore.
- **Deep Technical Specs:**
    - [**DVMT/StolenMem Explained**](https://osxlatitude.com/forums/topic/17804-dvmtstolenmemfbmemcursormem-why-do-we-patch-these-for-broadwell-and-later/) — Why memory patching is required for Broadwell and newer.
    - [**Intel iGPU OpRegion Specs**](https://01.org/sites/default/files/documentation/acpi_igd_opregion_spec_0.pdf) (**PDF**) — Official ACPI IGD OpRegion documentation.

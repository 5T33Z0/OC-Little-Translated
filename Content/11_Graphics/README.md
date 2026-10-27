# Graphics

A collection of graphics-related fixes, patches, and workarounds for common issues when running macOS on Wintel systems. Entries focus on solving specific problems rather than providing full configuration guides.

**TABLE of CONTENTS**

- [**AMD**](/Content/11_Graphics/AMD/README.md)
	- **APU (Laptops & Desktop APUs)**
		- [Enabling AMD Vega iGPUs (NootedRed)](/Content/11_Graphics/AMD/APU/README.md)
	- **GPU (Discrete Graphics)**
		- [AMD Discrete GPU Compatibility](/Content/11_Graphics/AMD/GPU/AMD_GPU_Compatbility.md)
		- [Enabling AMD (Big) Navi Cards](/Content/11_Graphics/AMD/GPU/AMD_Navi/README.md)
		- [Enabling AMD Vega 56/64 Cards](/Content/11_Graphics/AMD/GPU/AMD_Vega/README.md)
		- [Enabling undetected AMD GPUs (SSDT-BRG0)](/Content/11_Graphics/AMD/GPU/GPU_undetected/README.md)
		- [AMD Radeon Tweaks (PowerPlay & DAGPM)](/Content/11_Graphics/AMD/GPU/AMD_Radeon_Tweaks/README.md)
		- [GPU BAR Size in OpenCore](/Content/11_Graphics/AMD/GPU/GPU-BAR_Size/README.md)
		- [Disabling audio over HDMI/DisplayPort (AppleGFXHDA)](/Content/11_Graphics/AMD/GPU/Disabling_AppleGFXHDA/README.md)
		- [Legacy AMD Cards and macOS](https://web.archive.org/web/20170814210930/http://www.rampagedev.com/guides/graphic-cards-injection/) (ATI 4000 to 7000 and AMD 200/300. Wayback-Machine Link)

- [**Intel**](/Content/11_Graphics/Intel/README.md)
	- [Intel Framebuffer Patching (Laptop)](/Content/11_Graphics/Intel/Framebuffer_Patching/README.md)
	- [iGPU Framebuffers List](/Content/11_Graphics/Intel/iGPU_DeviceProperties.md)
	- [Injecting EDID to fix display issues](/Content/11_Graphics/Intel/Inject_EDID/README.md)
	- [Force-enabling graphics with a fake ig-platform-id](/Content/11_Graphics/Intel/Inject_Fake_IG-Patform-ID/README.md)
	- [Enabling Skylake Graphics in macOS Ventura+](/Content/11_Graphics/Intel/Skylake_Spoofing_macOS13/README.md)
	- [Comet Lake and Z590-series mainboard iGPU issues](/Content/11_Graphics/Intel/Cometlake_Z590/README.md)
	- [Enabling Metal 3 and GPU Tab in macOS Ventura+](/Content/11_Graphics/Intel/Metal_3/README.md)
	- [Loading GuC Firmware](/Content/11_Graphics/Intel/GUC_Firmware.md)
	- [RPS-Control (iGPU Power Management)](/Content/11_Graphics/Intel/RPS-Control.md)
	- [Disabling audio over HDMI/DisplayPort](/Content/11_Graphics/Intel/iGPU_disable_audio_over_HDMI-DP.md)
	- [Enabling Firefox Hardware Acceleration](/Content/11_Graphics/Intel/Enable_Firefox_Hardware-Acceleration.md)

- [**NVIDIA**](/Content/11_Graphics/NVIDIA/README.md)
	- **RTX**
		- [Modern NVIDIA RTX Support (Experimental Translation Drivers)](/Content/11_Graphics/NVIDIA/RTX/README.md)
    - **Legacy**
		- [Disabling unsupported GPUs (Optimus / SSDT-dGPU-Off)](/Content/11_Graphics/NVIDIA/Legacy/Disabling_unsupported_GPUs/README.md)
		- [Kepler GPUs in macOS 12+ (OCLP)](/Content/11_Graphics/NVIDIA/Legacy/Kepler/README.md)


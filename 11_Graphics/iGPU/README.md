# iGPU Fixes

Incomplete collection of iGPU related fixes. For general configuration of Intel iGPUs, please refer to the corresponding section of the OpenCore Install Guide for your CPU. For in-depth explanations check Dortania's [Intel iGPU Patching](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/#getting-started) Guide.

## Table of Contents
- **AMD**
	- [**Enabling AMD Vega iGPUs**](/11_Graphics/iGPU/AMD) 
- **Intel**
	- Iris Xe Support ([**NootedBlue – in Development**](https://www.insanelymac.com/forum/topic/358305-80-solved-iris-xe-igpu-on-tiger-lake-successfully-loaded-icllp-frambuffer-and-vram-also-recognizes-1536mb-however-some-issues/?do=findComment&comment=2819650)) 	
	- [**iGPU Framebuffer List**](/11_Graphics/iGPU/iGPU_DeviceProperties.md)
	- [**Enabling Skylake Graphics in macOS Ventura**](/11_Graphics/iGPU/Skylake_Spoofing_macOS13)
	- [**Fixing Comet Lake and Z500-series mainboard iGPU issues**](/11_Graphics/iGPU/Cometlake_Z590#comet-lake-igpu-issues-on-500-series-mainboards)
	- [**Disabling audio over HDMI/DisplayPort**](/11_Graphics/iGPU/iGPU_disable_audio_over_HDMI-DP.md)
	- [**Force-enabling graphics with a fake ig-platform-id**](/11_Graphics/iGPU/Fake_ig-platform-id.md)
	- [**How to enable "GPU" Tab in Activity Monitor, Hardware Acceleration and Metal 3 Support in macOS 13+**](/11_Graphics/Metal_3)
	- [**Framebuffer patching for enabling external display on Laptops**](/11_Graphics/iGPU/Framebuffer_Patching/README.md)
 	- [**How the `rps-control` property works**](/11_Graphics/iGPU/RPS-Control.md)
  	- [**How Apple's GUC firmware works**](/11_Graphics/iGPU/GUC_Firmware.md)

## Resources
- `DeviceProperties` with Framebuffer Patches for numerous Intel iGPUs for most CPU Generations can be obtained from the config.plists in the &rarr; [**Desktop EFIs Section**](/F_Desktop_EFIs).
- For Notebooks, you can use the `Properties` inside of the &rarr; [**Clover Laptop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs). OpenCore's `DeviceProperties` and Clover's `Devices/Properties` entries are interchangeable.
- [**Intel iGPU OpRegion Specs**](https://01.org/sites/default/files/documentation/acpi_igd_opregion_spec_0.pdf) (**PDF**)
- [**DVMT/stolenmem/fbmem/cursormem explained**](https://osxlatitude.com/forums/topic/17804-dvmtstolenmemfbmemcursormem-why-do-we-patch-these-for-broadwell-and-later/)

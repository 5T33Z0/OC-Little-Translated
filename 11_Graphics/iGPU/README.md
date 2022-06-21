# Intel iGPU Fixes

Incomplete collection of Intel iGPU related fixes. For general configuration of Intel iGPUs, please refer to the corresponding section of the OpenCore Install Guide for your CPU. For in-depth explanations check Dortania's [Intel iGPU Patching](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/intel-patching/#getting-started) Guide.

## Table of Contents

- [Enabling Skylake Graphics in macOS Ventura ](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13)
- [Force-enabling graphics with a fake ig-platform-id](https://github.com/5T33Z0/OC-Little-Translated/blob/main/11_Graphics/iGPU/Fake_ig-platform-id.md)

## Notes

- `DeviceProperties` with Framebuffer Patches for numerous Intel iGPUs for most CPU Generations can be obtained from the config.plists in the &rarr; [**Desktop EFIs Section**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/F_Desktop_EFIs).
- For Notebooks, you can use the `Properties` inside of my &rarr; [**Clover Laptop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs). 
- OpenCore's `DeviceProperties` and Clover's `Devices/Properties` entries are interchangeable.

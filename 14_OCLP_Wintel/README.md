# Installing newer versions of macOS on legacy hardware

## About

Although you can use OpenCore and [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) (OCLP) to install newer versions of macOS on Wintel systems with CPUs that were dropped from macOS 13 (everything prior to Kaby Lake), it's not officially supported by Dortania nor is it documented, nor will you get any support for this on discord.

Officially, OCLP only supports end of life (or "legacy") Macs by Apple. But you can run OLCP on Wintel systems in Post-Install as well  to re-install drivers and Frameworks which were removed from macOS 12 and newer, mainly iGPU drivers (to [reinstate graphics acceleration and Metal Graphics API support](https://khronokernel.github.io/macos/2022/11/01/LEGACY-METAL-PART-1.html)) and GPU drivers for legacy AMD and NVIDIA Kepler Cards. It also offers additional patches that allow booting with the correct SMBIOS for your CPU, re-enabling SMC CPU Power Management in macOS Ventura and working around issues with System Updates caused by disabling SecureBootModel, System Integrity Protection (SIP) and Apple Mobile File Integrity (AMFI).

## Available Guides
- [Installing macOS Ventura on Sandy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sandy_Bridge_Ventura.md)
- [Installing macOS Ventura on Ivy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md#installing-macos-ventura-on-ivy-bridge-systems)
- [Installing macOS Ventura on Haswell/Broadwell systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Haswell-Broadwell_Ventura.md#installing-macos-ventura-on-haswellbroadwell-systems)
- [Installing macOS Ventura on Skylake systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Skylake_Ventura.md#installing-macos-ventura-on-skylake-systems)

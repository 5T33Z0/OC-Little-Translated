# Installing newer versions of macOS on legacy hardware

## About

Although you can use OpenCore and [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) (OCLP) to install newer versions of macOS on Wintel systems with CPUs that were dropped from macOS 12 and newer (everything prior to Kaby Lake), it's not officially supported by Dortania nor is it documented, nor will you get any support for this on discord. That's why I created this section.

Officially, OCLP only supports end of life (or "legacy") Macs by Apple. But you can run OLCP on Wintel systems in Post-Install as well to re-install drivers and Frameworks which were removed from macOS 12 and newer, mainly iGPU drivers (to [reinstate graphics acceleration and Metal Graphics API support](https://khronokernel.github.io/macos/2022/11/01/LEGACY-METAL-PART-1.html)) and GPU drivers for legacy AMD and NVIDIA Kepler Cards as well as re-enabling Wifi in macOS Sonoma. OCLP also offers additional workarounds that allow booting with the correct SMBIOS for your CPU, re-enabling SMC CPU Power Management in macOS Ventura and working around issues with System Updates caused by disabling SecureBootModel, System Integrity Protection (SIP) and Apple Mobile File Integrity (AMFI).

## Configuration Guides
- [Installing macOS 13+ on 1st Gen Intel Core](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Nehalem-Westmere_Ventura.md)
- [Installing macOS 13+ on Sandy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sandy_Bridge_Ventura.md)
- [Installing macOS 13+ on Ivy Bridge systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md#installing-macos-ventura-on-ivy-bridge-systems)
- [Installing macOS 13+ on Haswell/Broadwell systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Haswell-Broadwell_Ventura.md#installing-macos-ventura-on-haswellbroadwell-systems)
- [Installing macOS 13+ on Skylake systems](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Skylake_Ventura.md#installing-macos-ventura-on-skylake-systems)
- [General CPUs and SMBIOSes Guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/CPU_to_SMBIOS.md#cpu-family-to-smbios-conversion)

## Re-Enabling Features
- [**Fixing WiFi in macOS Sonoma**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/WIiFi_Sonoma.md)

## Other
- [macOS Sonoma Notes](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sonoma_Notes.md)
- [Fetching kext updates from OCLP with OCAT](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Fetching_OCLP_Kexts.md)
- [Install Windows from within macOS without Bootcamp](https://github.com/5T33Z0/OC-Little-Translated/blob/main/I_Windows/Install_Windows_NoBootcamp.md)

## Contribute?
Although I've created these guides with a lot of attention to detail, there's always room for improvement. As far as legacy systemes go, I only have an Ivy Bridge Notebook and an iMac11,3 (Lynnfield) to test legacy configs. So if you have any suggestions or updated instructions to improve the workflow, feel free to create an issue and let me know!

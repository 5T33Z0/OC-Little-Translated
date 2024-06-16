# Installing newer versions of macOS on legacy hardware

## About
Although you can use OpenCore and [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) (OCLP) to install newer versions of macOS on Wintel systems (aka Windows PCs and Laptops) with CPUs that were dropped from macOS 12 and newer (everything prior to Kaby Lake), it's not officially supported by Dortania nor is it documented, nor will you get any help for doing so on discord. That's why I created this section.

Officially, OCLP only supports end of life (or "legacy") Macs by Apple. But you can run OLCP on Wintel systems as well to re-install drivers and frameworks which were removed from macOS 12 and newer (check [this repo](https://github.com/dortania/PatcherSupportPkg) for references). This includes:

- iGPU drivers (to [reinstate graphics acceleration and Metal Graphics API support](https://khronokernel.github.io/macos/2022/11/01/LEGACY-METAL-PART-1.html)) 
- GPU drivers for legacy (non-metal) AMD and NVIDIA Kepler Cards 
- Components for re-enabling previously supported Wi-Fi cards (macOS 14)

OCLP also introduced a bunch of new kexts that allow booting with the correct SMBIOS for your CPU, re-enabling SMC CPU Power Management in macOS 13+, fix issues with System Updates caused by disabling SecureBootModel, System Integrity Protection (SIP) and Apple Mobile File Integrity (AMFI) that can be utilized on Wintel systems as well.

## Important Updates

- Updating from from macOS 14.3.x to 14.4.x might crash the installer early. This is mostly related to `SecureBootModel` (&rarr; see [**Workarounds**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/W_Workarounds/macOS14.4.md) section for details)

## Configuration Guides
Based on analyzing EFI folders and configs that OCLP generates for Macs of 1st to 6th gen CPUs, I've compiled configuration guides for adjusting your existing OpenCore config so you can install and run macOS 13+ on unsupported hardware:

- [**Installing macOS 13+ on 1st Gen Intel Core**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Nehalem-Westmere-Lynnfield.md)
- [**Installing macOS 13+ on Sandy Bridge systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Sandy_Bridge.md)
- [**Installing macOS 13+ on Ivy Bridge systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Ivy_Bridge.md)
- [**Installing macOS 13+ on Haswell/Broadwell systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Haswell-Broadwell.md)
- [**Installing macOS 13+ on Skylake systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Skylake.md)
- [**General CPUs and SMBIOSes Guide**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/CPU_to_SMBIOS.md)

## Re-Enabling Features
- [**Fixing WiFi in macOS Sonoma**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md)
- [**Force-enable GPU Patching**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/GPU_Sonoma.md)

## Troubleshooting
- [**Recovering from failed root patching attempts**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Reverting_Root_Patches.md)

## Fetching macOS Installers

There are several options to fetch and download macOS Installers directly from Apple. Here are some of them:

1. **OpenCore Legacy Patcher**. It has the options to download macOS and create a USB Installer right build in
2. [**MIST**](https://github.com/ninxsoft/Mist): Gui based app to download macOS Installers and Firmwares
3. **Terminal**. Open Terminal and enter the following commands:<br>
	`softwareupdate  --fetch-full-installer --list-full-installers` (to fetch the list of Installers)
	`softwareupdate  --fetch-full-installer --list-full-installer-version xx.xx` (replace xx.xx by the version you want to download)

Foe more options, check the [**Utilities**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/C_Utilities_and_Resources#getting-macos) section
 
## Other
- [**macOS Sequoia Notes**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sequoia_Notes.md)
- [**macOS Sonoma Notes**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sonoma_Notes.md)
- [**Fetching kext updates from OCLP with OCAT**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Fetching_OCLP_Kexts.md)
- [**Installing Windows from within macOS without Bootcamp**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/I_Windows/Install_Windows_NoBootcamp.md)
- [**Collection of Non-Metal Apple apps**](https://archive.org/details/apple-apps-for-non-metal-macs) (Archive.org)
- [**macOS Release Notes**](https://developer.apple.com/documentation/macos-release-notes)

## Contribute?
Although I've created these guides with a lot of attention to detail, there's always room for improvement. As far as legacy systemes go, I only have an Ivy Bridge Notebook and an iMac11,3 (Lynnfield) to test legacy configs. So if you have any suggestions or updated instructions to improve the workflow, feel free to create an issue and let me know!

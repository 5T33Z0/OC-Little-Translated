# Installing newer versions of macOS on legacy Wintel PC hardware

## About
As you may know, Dortania developed the [**OpenCore Legacy Patcher**](https://github.com/dortania/OpenCore-Legacy-Patcher) (OCLP) to install and run macOS 12 and newer on end-of-life Macs with Intel Core CPUs from the 1st to 6th generation. It does this by installing the OpenCore boot loader, injecting additional kexts and installing on-disk patches ("root-patches") in Post-Install to re-enable iGPU, GPU and WiFi drivers in order to extend the lifecycle of these expansive machines.

These kexts and root-patches can also be applied to Wintel systems. But the process of adjusting the `config.plist` – which settings to add and which kexts to inject – is not officially documented nor supported by Dortania, nor will you get any help for this on Discord. That's why I created in-depth configuration guides to prepare your old Hackintosh to run macOS 12 and newer.

**The patches relevant to us are**:

- iGPU drivers (to [reinstate graphics acceleration and Metal Graphics API support](https://khronokernel.github.io/macos/2022/11/01/LEGACY-METAL-PART-1.html)) 
- GPU drivers for legacy (non-metal) AMD and NVIDIA Kepler Cards 
- Frameworks for re-enabling previously supported Wi-Fi/Bluetooth cards
 
The OCLP repo also contains [additional kexts](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts) which need to be injected via OpenCore. They are required for installing and booting newer versions of macOS with the native SMBIOS for your CPU, re-enabling SMC CPU Power Management in macOS 13+, fix issues with System Updates caused by disabling `SecureBootModel`, System Integrity Protection (`SIP`) and Apple Mobile File Integrity (`AMFI`). The OCLP repo also provides kexts of previous macOS versions as well as kexts by Acidanthera required to re-enable legacy devices such as LAN, WiFi, Bluetooth and even Firewire. For a complete list and explanation of applicable patches, refer to [this List](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches).

## Latest OCLP status updates
- [**macOS Sequoia OCLP Notes**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sequoia_Notes.md)
- [**macOS Sonoma OCLP Notes**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Sonoma_Notes.md)

## Configuration Guides
Based on analyzing EFI folders and configs that OCLP generates for Macs of 1st to 6th gen CPUs, I've compiled configuration guides for adjusting your existing OpenCore config so you can install and run macOS 13+ on unsupported hardware:

- [**Installing macOS 13+ on 1st Gen Intel Core systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Nehalem-Westmere-Lynnfield.md)
- [**Installing macOS 13+ on Sandy Bridge systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Sandy_Bridge.md)
- [**Installing macOS 13+ on Ivy Bridge systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Ivy_Bridge.md)
- [**Installing macOS 13+ on Haswell/Broadwell systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Haswell-Broadwell.md)
- [**Installing macOS 13+ on Skylake systems**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Skylake.md)
- [**General CPU and SMBIOS Guide**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/CPU_to_SMBIOS.md)

> [!IMPORTANT]
>
> Updating from from macOS 14.3.x to 14.4.x and newer might crash the installer early. This is related to `SecureBootModel`, so it should be set to `Disabled` during installation (&rarr; see [**Workarounds**](/W_Workarounds/macOS14.4.md) section for details).

## (Re-)Enabling Features
- [**Fixing WiFi and Bluetooth in macOS Sonoma+**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md)
- [**Force-enable GPU Patching**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/GPU_Sonoma.md)
- [**How to disable Gatekeeper in macOS Sequoia**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Disable_Gatekeeper.md)
- [**How to enable auto-root-patching during macOS installation**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Auto-Patching.md)

## Troubleshooting
- [**Dos and Don'ts of running macOS beta versions**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Beta_dos_donts.md)
- [**Recovering from failed root patching attempts**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Reverting_Root_Patches.md)
- [**OCLP and the macOS compatibility gap**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Bridging_the_gap.md)
- [**Triggering macOS Updates via Terminal**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/macOS_Update_Terminal.md)
- [**Addressing sleep isues in macOS Sequoia**](https://www.insanelymac.com/forum/topic/360040-macos-15-sequoia-does-not-enter-sleep-mode-properly/#comment-2826474) (Thread on insanelymac)

## Fetching macOS Installers

There are several options to fetch and download macOS installers directly from Apple. Here are some of them:

1. **OpenCore Legacy Patcher**. It can download macOS 11+ and create a USB Installer as well.
2. [**MIST**](https://github.com/ninxsoft/Mist): GUI-based app to download macOS Installers and Apple Silicon Firmwares
3. **Terminal**. Open Terminal and enter the following commands:<br>
	`softwareupdate  --fetch-full-installer --list-full-installers` (to fetch the list of Installers)<br>
	`softwareupdate  --fetch-full-installer --list-full-installer-version xx.xx` (replace xx.xx by the version you want to download)

For more options, check the [**Utilities**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/C_Utilities_and_Resources#getting-macos) section
 
## Miscellaneous
- [**OCLP Changelog**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/CHANGELOG.md)
- [**OCLP Troubleshooting**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/docs/TROUBLESHOOTING.md)
- [**Fetching kext updates from OCLP with OCAT**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Fetching_OCLP_Kexts.md)
- [**Installing Windows from within macOS without Bootcamp**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/I_Windows/Install_Windows_NoBootcamp.md)
- [**Collection of Non-Metal Apple apps**](https://archive.org/details/apple-apps-for-non-metal-macs) (Archive.org)
- [**macOS Release Notes**](https://developer.apple.com/documentation/macos-release-notes)

## Contribute
Although I've created these guides with a lot of attention to detail, there's always room for improvement. As far as verifying the guides are concerned, I only have an iMac11,3 (Lynnfield), an iMac12,2 (Sandy Bridge), and and Ivy Bridge Notebook for testing. So if you have any suggestions or updated instructions to improve the guides or workflows, feel free to create an issue and let me know!

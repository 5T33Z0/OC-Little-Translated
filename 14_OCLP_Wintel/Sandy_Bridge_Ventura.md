# Installing macOS Ventura on Sandy Bridge systems

## About
Although installing macOS Ventura on Sandy Bridge systems can be achieved with OpenCore and the OpenCore Legacy Patcher (OCLP), it's not officially supported nor documented – only for legacy Macs by Apple. So there is no official guide on how to do it. Since I don't have a Sandy Bridge sytsem, I developed this guide based on analyzing the changelog, config and EFI folder structure after building OpenCore with (OCLP) for the following systems:

- **Desktop**: iMac12,x 
- **Laptop**: MacBookPro8,x (`8,1` = 13" Core i5; `8,2` = 15" i5; `8,3` = 17" i7)
- **NUC/USDT**: Macmini5,x
- **HEDT**: N/A

**Mac Models**: https://dortania.github.io/OpenCore-Legacy-Patcher/MODELS.html

## Precautions and Limitations
This is what you need to know before attempting to install macOS Monterey and newer on unsupported systems:

- Backup your working EFI folder on a FAT32 formatted USB Flash Drive – just in case something goes wrong.
- Check if your iGPU/GPU is supported by OCLP. Although Drivers for Intel, NVIDIA and AMD cards can be added in Post-Install, the [list of supported GPUs](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches) is limited.
- AMD Polaris Cards (Radeon 4xx/5xx, etc.) can't be used with Sandy Bridge CPUs because they rely on the AVX2 instruction set which is only supported by Haswell and newer.
- Check if any peripherals you are using are compatible with macOS 12+ (Wifi and BlueTooth come to mind).
- When using Broadcom Wifi/BT Cards, you may need different [combinations of kexts](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) which need to be controlled via `MinKernel` and `MaxKernel` settings. Same applies to Intel Wifi/BT Cards
- Incremental (or delta) System Updates won't be available after applying root patches with OCLP. Instead, the whole macOS Installer will be downloaded every time (approx. 12 GB)!
- Modifying the system with OCLP Requires SIP, Apple Secure Boot and AMFI to be disabled so there are some compromises in terms of security.

## Preparations
I assume you already have a working OpenCore configuration for your Sandy Bridge system. Otherwise follow Dortania's [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) to create one. The instructions below are only additional steps required to install and boot macOS Monterey and newer.

### Update OpenCore and kexts
Update OpenCore to 0.9.2 or newer (mandatory). Because prior to 0.9.2, the `AppleCpuPmCfgLock` Quirk is [skipped when macOS Ventura is running](https://github.com/acidanthera/OpenCorePkg/commit/77d02b36fa70c65c40ca2c3c2d81001cc216dc7c) so the kexts required for re-enabling SMC CPU Power Management can't be patched and the system won't boot unless you have a (modded) BIOS where CFG Lock can be disabled. Update your kexts to the latest versions as well to avoid compatibility issues.

## Config Edits
Section | Setting | Description
:------:| ------- | ---------
 **`Booter/Patch`**| Add and enable both Booter Patches from OpenCore Legacy Patcher's [**Board-ID VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof): <ul> <li> **"Skip Board ID check"** <li> **"Reroute HW_BID to OC_BID"** | Skips board-id checks in macOS &rarr; Allows booting macOS with unsupported, native SMBIOS best suited for your CPU.
**`DeviceProperties/Add`**|**PciRoot(0x0)/Pci(0x2,0x0)** <ul><li> **Desktop** (Headless): <ul> <li> **AAPL,snb-platform-id**: 00000500 <li> **device-id**: 02010000 </ul></ul><ul><li>**Desktop** (Default): <ul><li> **AAPL,snb-platform-id**: 10000300 <li> **device-id**: 26010000 </ul> </ul><ul> <li> **Laptop**: <ul><li> **AAPL,snb-platform-id**: 00000100 <li> **AAPL00,DualLink**: 01000000 </ul></ul><ul><li> **Intel NUC** (or other USDT): <ul><li> **AAPL,snb-platform-id**: 10000300 </ul>| **iGPU Support**: :warning: Intel HD 3000 only!<ul> <li>**Headless**: For systems with an iMac SMBIOS, iGPU and a GPU which is used for graphics. The example in the OC Install Guide is actually wrong. <li> **Default**: Use this if you have a PC and the iGPU is used for driving a display. The example in the OC Install Guide is actually wrong. <li> **AAPL00,DualLink**: Only required for DualLink laptop displays with 1600x900 pixels or more.<li> **NUCs**: For Intels NUCs and other Ultra Slim Desktops (USDT), such as: HP 6300 Pro, HP 8300 Elite, etc.</ul> Refer to [**Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-25004000-ivy-bridge-processors) for more details. Remember: the FAQ displays the ig-platform-ids in Big Endian but for the config you need Little Endian!
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li>**AMFIPass** (`MinKernel`: `21.0.0`) ([Must to be optained from OpenCore Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/AMFIPass.md)) <li>[**ASPP-Override.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/ASPP-Override-v1.0.1.zip) (`MinKernel`: `21.0.0`)<li> [**CryptexFixup**](https://github.com/acidanthera/CryptexFixup) (`MinKernel`: `22.0.0`)<li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) <li> [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagement-v1.0.0.zip) (`MinKernel`: `22.0.0`)<li> [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagementClient-v1.0.0.zip) (`MinKernel`: `22.0.0`)</ul> **Delete the following Kexts** from EFI/OC/Kexts and config (if present):<ul><li> **CPUFriend** <li> **CPUFriendDataProvider**|<ul><li> **AMFIPass**: Beta kext from OCLP 0.6.7. Allows booting macOS 12+ without disabling AMFI.<li>**ASPP-Override.kext**: Codeless kext from OCLP. Forces `ACPI_SMC_PlatformPlugin` to outmatch `X86PlatformPlugin`. May be required on real Macs only. Monitor CPU behavior in Intel Power Gadget with and without it.<li>**Cryptexfixup**: Required for installing and booting macOS Ventura on systems without AVX 2.0 support (see [OCLP Support Issue #998](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998)). <li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters. <li> **AppleIntelCPUPowerManagement** kexts: Required for re-enabling SMC CPU Power Management ([more details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura)).

**TO BE CONTINUED…**

## Credits
- Acidanthera for OpenCore, OCLP and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- dhinakg for AMFIPass
- Dortania for OpenCore Legacy Patcher and Guide
- Rehabman for Laptop framebuffer patches

# Installing macOS Ventura on Sandy Bridge systems

## About
Although installing macOS Ventura on systems with Intel CPUs of the Sandy Bridge family
can be achieved with OpenCore and the OpenCore Legacy Patcher (OCLP), it's not officially supported nor documented – only for legacy Macs by Apple. So there is no official guide on how to do it. Since I don't have a Sandy Bridge sytsem, I developed this guide based on analyzing the changelog, config and EFI folder structure after building OpenCore with (OCLP) for the following systems:

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

To check which version of OpenCore and OpenCore Patcher you're currently using, run the following commands in the Terminal:

```shell
OpenCore Version:
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version

Patcher Version:
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:OCLP-Version
```

## Config Edits
Section | Setting | Description
:------:| ------- | ---------
 **`Booter/Patch`**| Add and enable both Booter Patches from OpenCore Legacy Patcher's [**Board-ID VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof): <ul> <li> **"Skip Board ID check"** <li> **"Reroute HW_BID to OC_BID"** | Skips board-id checks in macOS &rarr; Allows booting macOS with unsupported, native SMBIOS best suited for your CPU.
**`DeviceProperties/Add`**|**PciRoot(0x0)/Pci(0x2,0x0)** <ul><li> **Desktop** (Headless): <ul> <li> **AAPL,snb-platform-id**: 00000500 <li> **device-id**: 02010000 </ul></ul><ul><li>**Desktop** (Default): <ul><li> **AAPL,snb-platform-id**: 10000300 <li> **device-id**: 26010000 </ul> </ul><ul> <li> **Laptop**: <ul><li> **AAPL,snb-platform-id**: 00000100 <li> **AAPL00,DualLink**: 01000000 </ul></ul><ul><li> **Intel NUC** (or other USDT): <ul><li> **AAPL,snb-platform-id**: 10000300 </ul>| **iGPU Support**: :warning: Intel HD 3000 only!<ul> <li>**Headless**: For systems with an iMac SMBIOS, iGPU and a GPU which is used for graphics. The example in the OC Install Guide is actually wrong. <li> **Default**: Use this if you have a PC and the iGPU is used for driving a display. The example in the OC Install Guide is actually wrong. <li> **AAPL00,DualLink**: Only required for DualLink laptop displays with 1600x900 pixels or more.<li> **NUCs**: For Intels NUCs and other Ultra Slim Desktops (USDT), such as: HP 6300 Pro, HP 8300 Elite, etc.</ul> Refer to [**Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-20003000-sandy-bridge-processors) for more details. Remember: the FAQ displays ig-platform-ids in Big Endian but for the config you need Little Endian!
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li>**AMFIPass** (`MinKernel`: `21.0.0`) ([Must to be optained from OpenCore Patcher](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/AMFIPass.md)) <li>[**ASPP-Override.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/ASPP-Override-v1.0.1.zip) (`MinKernel`: `21.0.0`)<li> [**CryptexFixup**](https://github.com/acidanthera/CryptexFixup) (`MinKernel`: `22.0.0`)<li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) <li> [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagement-v1.0.0.zip) (`MinKernel`: `22.0.0`)<li> [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagementClient-v1.0.0.zip) (`MinKernel`: `22.0.0`)</ul> **Delete the following Kexts** from EFI/OC/Kexts and config (if present):<ul><li> **CPUFriend** <li> **CPUFriendDataProvider**|<ul><li> **AMFIPass**: Beta kext from OCLP 0.6.7. Allows booting macOS 12+ without disabling AMFI.<li>**ASPP-Override.kext**: Codeless kext from OCLP. Forces `ACPI_SMC_PlatformPlugin` to outmatch `X86PlatformPlugin`. May be required on real Macs only. Monitor CPU behavior in Intel Power Gadget with and without it.<li>**Cryptexfixup**: Required for installing and booting macOS Ventura on systems without AVX 2.0 support (see [OCLP Support Issue #998](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998)). <li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters. <li> **AppleIntelCPUPowerManagement** kexts: Required for re-enabling SMC CPU Power Management ([more details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura)).
**`Kernel/Patch`** | Add and enable the following Kernel Patches from the [**OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist) (click on "Download RAW File"): <ul> <li> **"SurPlus v1 - PART 1 of 2"** <li> **"SurPlus v1 - PART 2 of 2"** <li> **"Disable Library Validation Enforcement"**<li>**"Disable _csr_check() in _vnode_check_signature"** <li> **Force FileVault on Broken Seal** (optional)| Kernel Patches from OCLP, so Sandy Bridge CPUs can boot macOS 12+.
**`Kernel/Quirks`** | <ul><li> Enable **`AppleCpuPmCfgLock`**. Not required if you can disable CFG Lock in BIOS. <li> Disable **`AppleXcmpCfgLock`** (if enabled) <li> Disable **`AppleXcpmExtraMsrs`** (if enabled) | Apple SMC CPU Management requirements.
**`NVRAM/Add/...-4BCCA8B30102`** | Add the following Keys: <ul> <li> **Key**: `OCLP-Settings`<br>**Type**: String <br>**Value**: `-allow_amfi` <li> **Key**: `revblock` <br> **Type**: String <br> **Value**: `media`<li>  **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm,f16c`| <ul> <li> Settings for OCLP and RestrictEvents. <li> `media`: Blocks `mediabranalysisd` service on Ventura+ (for Metal 1 GPUs) <li>`sbvmm,f16c` &rarr; Enables OTA updates and addresses graphics issues in macOS 13 (check RestrictEvents documentation for details)|
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | Add the following Strings: <ul> <li>  `OCLP-Settings` <li> `revblock` <li> `revpatch` | Deletes NVRAM for these parameters before writing them. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.  
**`NVRAM/Add/...-FE41995C9F82`**  | **Add the following**`boot-args`: <ul><li> ~~**`amfi_get_out_of_my_way=0x1`** or **`amfi=0x80`** (same)~~ <li> **`ipc_control_port_options=0`**</ul>**Optional boot-args for GPUs** (Select based on GPU Vendor): <ul><li> **`-radvesa`** <li> **`nv_disable=1`** <li> **`ngfxcompat=1`**<li>**`ngfxgl=1`**<li> **`nvda_drv_vrl=1`** <li> **`agdpmod=vit9696`**|<ul> <li>**`amfi=0x80`**: Disables Apple Mobile File Integrity validation. Required for applying Root Patches with OCLP ~~and booting macOS 12+~~. :bulb: No longer needed for booting thanks to AMFIPass.kext – only for installing Root Patches with OCLP. Disabling AMFI causes issues with [3rd party apps' access to Mics and Cameras](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Webcams.md).<li> **`ipc_control_port_options=0`**: Required for Intel HD 40000. Fixes issues with Firefox and electron-based apps like Discord. <li> **`-radvesa`** (AMD only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS 12+. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li> **`nv_disable=1`** (NVIDIA only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS Ventura. Kepler Cards switch into VESA mode automatically without it. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li>**`ngfxcompat=1`** (NVIDIA only): Ignores compatibility check in `NVDAStartupWeb`. Not required for Kepler GPUs <li>**`ngfxgl=1`** (NVIDIA only): Disables Metal Spport so OpenGL is used for rendering instead. Not required for Kepler GPUs. <li> **`nvda_drv_vrl=1`** (NVIDIA only): Enables Web Drivers. Not required for Kepler GPUs. <li> **`agdpmod=vit9696`** &rarr; Disables board-id check. Useful if screen turns black after booting macOS which can happen after installing NVIDIA Webdrivers. <li> **`-wegnoigpu`** &rarr; Optional. Disables the iGPU in macOS. **ONLY** required when using an AMD GPU and an SMBIOS for a CPU without on-board graphics (i.e. `iMacPro1,1` or `MacPro7,1`) to let the GPU handle background rendering and other tasks. Requires Polaris or Vega cards to work properly (Navi is not supported by OCLP). Combine with `unfairgva=x` bitmask (x= 1 to 7) to [address DRM issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#unfairgva-overrides)

### Adjusting the SMBIOS
If your system reboots successfully, we need to edit the config one more time and adjust the SMBIOS depending on the macOS Version *currently* installed.

#### When Upgrading from macOS Big Sur 11.3+

When upgrading from macOS 11.3 or newer, we can use macOSes virtualization capabilities to trick it into thinking that it is running in a VM so spoofing a compatible SMBIOS is no longer a requirement.

Based on your system, use one of the following SMBIOSes for Sandy Bridge CPUs. Open your config.plist and change the SMBIOS in the `PlatformInfo/Generic` section.

- **For Desktops**: 

- **For Laptops**:

- **For NUCs**:

#### When Upgrading from macOS Catalina or older

When upgrading from macOS Catalina or older, the Booter Patches don’t work so changing to an SMBIOS supported by macOS Ventura temporarily is necessary in order to be able to install macOS Ventura – otherwise you will be greeted by the crossed-out circle instead of the Apple logo when trying to boot.

**Supported SMBIOSes**:

- For Desktops: 
- For Laptops:
- For NUCs: 

Generate new Serials using [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

> **Note**: Once macOS Ventura is up and running, the VMM Board-ID spoof will work, so revert to an SMBIOS best suited for your Sandy Bridge CPU and reboot to enjoy all the benefits of a proper SMBIOS. You may want to generate a new [SSDT-PM](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)) to optimize CPU Power Management.

## macOS Ventura Installation
With all the prep work out of the way you can now upgrade to macOS Ventura. Depending on the version of macOS you are coming from, the installation process differs.

### Getting macOS
- Download the latest release of [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and run it
- Click on "Create macOS Installer"
- Click on "Download macOS Installer"
- Select macOS 13.x (whatever the latest available version is)  
- Once the download is finished the "Install macOS Ventura" app will be located in your "Programs" folder

> **Note**: OCLP can also create a USB Installer if you want to perform a clean install (highly recommended)

### Option 1: Upgrading from macOS 11.3 or newer 

Only applicable when upgrading from macOS 11.3+. If you are on macOS Catalina or older, use Option 2 instead.

- Run the "Install macOS Ventura" App
- There will be a few reboots
- Boot from the new macOS Partition until it's no longer present in the Boot Picker

Once the installation has finished and the system boots it will run without graphics acceleration if you only have an iGPU or if you GPU is not supported by macOS. We will address this in Post-Install.

### Option 2: Upgrading from macOS Catalina or older
When upgrading from macOS Catalina or older a clean install from USB flash drive is recommended. To create a USB Installer, you can use OpenCore Legacy Patcher:

- Run Disk utility
- Create a new APFS Volume on your internal HDD/SSD or use a separate internal disk (at least 60 GB in size) for installing macOS 13 – DON'T install it on an external drive – it won't boot!
- Attach an empty USB flash drive for creating the installer (16 GB+)
- Run OCLP and follow the [**instructions**](https://dortania.github.io/OpenCore-Legacy-Patcher/INSTALLER.html#creating-the-installer)
- Once the USB Installer has been created, do the following:
	- Copy the OpenCore-Patcher App to the USB Installer
	- Add Optional tools (Optional, in case internet is not working): 
		- Add Python Installer
		- Add MountEFI
		- Add ProperTree
- Reboot 
- Select "Install macOS Ventura" from the BootPicker
- Install macOS Ventura on the volume you prepared earlier 
- There will be a few reboots during installation. Boot from the new "Install macOS" Partition until it's no longer present in the Boot Picker
- Once the macOS Ventura installation is finished, switch back to an SMBIOS best suited for your Sandy Bridge CPU mentioned earlier.

After the installation is completed and the system boots it will run without hardware graphics acceleration if you only have an iGPU or if you GPU is no longer supported by macOS. We will address this in Post-Install. 

## Post-Install
OpenCore Legacy patcher can re-install components which were removed from macOS, such as Graphics Drivers, Frameworks, etc. This is called "root patching". For Wintel systems, we will make use of it to install iGPU and GPU drivers primarily.

### Installing Intel HD 2000/3000 drivers

**TO BE CONTINUED…**

## Credits
- Acidanthera for OpenCore, OCLP and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- dhinakg for AMFIPass
- Dortania for OpenCore Legacy Patcher and Guide
- Rehabman for Laptop framebuffer patches

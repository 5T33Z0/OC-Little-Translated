# Installing macOS Ventura and newer on Sandy Bridge systems

[![OpenCore Version](https://img.shields.io/badge/OpenCore_Version:-0.9.4+-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤15.2-white.svg)

<details>
<summary><b>TABLE of CONTENTS</b> (Click to reveal)</summary><br>

- [About](#about)
	- [How Sandy Bridge systems are affected](#how-sandy-bridge-systems-are-affected)
	- [Disclaimer](#disclaimer)
- [Precautions and Limitations](#precautions-and-limitations)
- [Preparations](#preparations)
	- [Update OpenCore and kexts](#update-opencore-and-kexts)
- [Config Edits](#config-edits)
- [Testing the changes](#testing-the-changes)
	- [Adjusting the SMBIOS](#adjusting-the-smbios)
		- [When Upgrading from macOS Big Sur 11.3+](#when-upgrading-from-macos-big-sur-113)
		- [When Upgrading from macOS Catalina or older](#when-upgrading-from-macos-catalina-or-older)
- [macOS installation](#macos-installation)
	- [Getting macOS](#getting-macos)
	- [Option 1: Upgrading from macOS 11.3 or newer](#option-1-upgrading-from-macos-113-or-newer)
	- [Option 2: Upgrading from macOS Catalina or older](#option-2-upgrading-from-macos-catalina-or-older)
- [Post-Install](#post-install)
	- [Installing Intel HD 2000/3000 drivers](#installing-intel-hd-20003000-drivers)
	- [Installing Drivers for other GPUs](#installing-drivers-for-other-gpus)
	- [Verifying SMC CPU Power Management](#verifying-smc-cpu-power-management)
		- [Optimizing CPU Power Management](#optimizing-cpu-power-management)
	- [Removing/Disabling boot-args](#removingdisabling-boot-args)
	- [Verifying AMFI is enabled](#verifying-amfi-is-enabled)
- [OCLP and System Updates](#oclp-and-system-updates)
- [Notes](#notes)
- [Further Resources](#further-resources)
- [Credits](#credits)

</details>

## About
Although installing macOS Ventura and newer on systems with Intel CPUs of the Sandy Bridge family can be achieved with OpenCore and the OpenCore Legacy Patcher (OCLP), it's not officially supported nor documented by Dortania since they only provide support for legacy Macs by Apple. 

This guide was created based on my experiences root patching my 27" `iMac12,2` with a Sandy Bridge CPU and an NVIDIA Quadro GPU as well as analyzing the EFI folder content, config and log after building OpenCore with OCLP.

| ⚠️ Important Status Updates |
|:----------------------------|
| All good.

### How Sandy Bridge systems are affected
In macOS Ventura+, support for CPU families prior to Kaby Lake was dropped. For Sandy Bridge systems this mainly affects the CPU (missing AVX 2.0 and [rdrand](https://github.com/reenigneorcim/SurPlus) instructions), CPU Power Management (removed `ACPI_SMC_PlatformPlugin`), integrated Graphics and Metal support. So what we will do is prepare the config with the required patches, settings and kexts for installing and running macOS Ventura and then add iGPU/GPU drivers in Post-Install using OpenCore Legacy Patcher.

### Disclaimer
This guide is intended to provide general information for adjusting your EFI and config.plist to install and run macOS Ventura and newer on unsupported Wintel systems. It is not a comprehensive configuration guide. Please refrain from using the "report issue" function to seek individualized assistance for fixing your config. Such issue reports will be closed immediately!

## Precautions and Limitations
This is what you need to know before attempting to install macOS Monterey and newer on unsupported systems:

- ⚠️ **Backup** your working EFI folder on a FAT32 formatted USB flash drive just in case something goes wrong because we have to modify the config and content of the EFI folder.
- **iGPU/GPU**: 
	- Check if your iGPU/GPU is supported by OCLP. Although Drivers for Intel, NVIDIA and AMD cards can be added in Post-Install, the [list is limited](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches)
	- AMD Navi Cards (Radeon 5xxx and 6xxx) can't be used with Sandy Bridge CPUs since they require the AVX 2.0 instruction set which is only available on Haswell and newer.
- **Networking**:
	- For **Ethernet**, there are kexts for legacy LAN controllers [available here](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet)
	- **Wifi and Bluetooth**:
		- For enabling Broadcom Wifi/BT Cards, you will need a different [set of kexts](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) to load which need to be controlled via `MinKernel` and `MaxKernel` settings. On macOS 12.4 and newer, a new address check has been introduced in `bluetoothd`, which will trigger an error if two Bluetooth devices have the same address. This can be circumvented by adding boot-arg `-btlfxallowanyaddr` (provided by [BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM) kext).
		- Same applies to [Intel WiFi/BT](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-8a-intel-wifi-airportitlwm-and-bluetooth-intelbluetoothfirmware) cards using [OpenIntelWirless](https://github.com/OpenIntelWireless) kexts
		- [Enabling Wifi in macOS Sonoma](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md) requires additional kext and also applying root patches in Post-Install!
- **Security**: Modifying the system with OCLP Requires SIP, Apple Secure Boot and AMFI to be disabled so there are some compromises in terms of security.
- **System Updates**: 
	- Incremental (or delta) updates won't be available after applying root patches with OCLP. Instead, the whole macOS Installer will be downloaded every time (approx. 12 GB)!
	- ⚠️ Don't install **Security Response Updates** (RSR) introduced in macOS 13! They will fail to install on pre-Haswell systems. More info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019).
- **Other**: Check the links below for in-depth documentation about components/features that have been removed from macOS 12 and newer and the impact this has on systems prior to Kaby Lake. But keep in mind that this was written for real Macs so certain issues don't apply to Wintel systems.
	- [Status of OpenCore Legacy Patcher Support for macOS Sonoma](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1076)
	- [Status of OpenCore Legacy Patcher Support for macOS Ventura](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998)
	- [Legacy Metal Support and macOS Ventura/Sonoma](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1008)

## Preparations
I assume you already have a working OpenCore configuration for your Sandy Bridge system. Otherwise follow Dortania's [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) to create one. The instructions below are only additional steps required to install and boot macOS Monterey and newer.

### Update OpenCore and kexts
Update OpenCore to 0.9.2 or newer (mandatory). Because prior to 0.9.2, [`AppleCpuPmCfgLock` Quirk is skipped when macOS Ventura is running](https://github.com/acidanthera/OpenCorePkg/commit/77d02b36fa70c65c40ca2c3c2d81001cc216dc7c) so the kexts required for re-enabling SMC CPU Power Management can't be injected and the system won't boot unless you have a (modded) BIOS where CFG Lock can be disabled. To check which version of OpenCore you're currently using, run the following commands in Terminal:

```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```
Update your kexts to the latest version as well to avoid compatibility issues with macOS!

## Config Edits
Listed below, you find the required modifications to prepare your config.plist and EFI folder for installing macOS Monterey or newer on Sandy Bridge systems. If this is over your head, there's an [accompanying plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Sandy_Bridge_OCLP_Wintel_Patches.plist) that contains the necessary settings that you can use for cross-referencing. 

:bulb: If your system (or components thereof) doesn't work afterwards, please refer to OCLP's [patch documentation](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/docs/PATCHEXPLAIN.md) and see if need additional settings or kexts.

Config Section | Action | Description
:-------------:| ------ | ---------
**`Booter/Patch`**| **Add** and **enable** the following Booter patch from OCLP's config: <ul> <li> [**"Skip Board ID check"**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L243) | <ul><li> Skips board-id check. <li> In combination with ResterictEvents kext, this allows: <ul> <li> Booting macOS with unsupported, native SMBIOS best suited for your CPU <li> Installing Sytsem Updates on unsupported systems </ul> <li> More [Details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof#booter-patches)
**`DeviceProperties/Add`**|**PciRoot(0x0)/Pci(0x2,0x0)** – Verify/Adjust `AAPL,snb-platform-id` (optional,, relevant for CPUs with integrated grapics only) <ul><li> **Desktop** (Headless): <ul> <li> **AAPL,snb-platform-id**: 00000500 <li> **device-id**: 02010000 </ul></ul><ul><li>**Desktop** (Default): <ul><li> **AAPL,snb-platform-id**: 10000300 <li> **device-id**: 26010000 </ul></ul><ul><li> **Laptop**: <ul><li> **AAPL,snb-platform-id**: 00000100 <li> **AAPL00,DualLink**: 01000000 </ul></ul><ul><li> **Intel NUC** (or other USDT): <ul><li> **AAPL,snb-platform-id**: 10000300 </ul></ul>**PciRoot(0x0)/Pci(0x16,0x0)** – Check requirement for spoofed **IMEI** device <ul> <li> **device-id**: 3A1C0000| **iGPU Support**: Intel HD 2000/3000. <ul> <li>**Headless**: For systems with an iMac SMBIOS, iGPU and a GPU which is used for graphics. The example in the OC Install Guide is actually wrong. <li> **Default**: Use this if you have a PC and the iGPU is used for driving a display. The example in the OC Install Guide is actually wrong. <li> **AAPL00,DualLink**: Only required for DualLink laptop displays with 1600x900 pixels or more.<li> **NUCs**: For Intel NUCs and other Ultra Slim Desktops (USDT), such as: HP 6300 Pro, HP 8300 Elite, etc. <li> **IMEI**: Only needed if you are using a Sandy Bridge CPU with 7-series mainboard (ie. B75, Q75, Z75, H77, Q77, Z77).</ul> Refer to [**Intel HD FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-20003000-sandy-bridge-processors) for more details. Remember: the FAQ displays ig-platform-ids in Big Endian but for the config you need Little Endian!
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul> <li>[**AutoPkgInstaller**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) <li>[**AMFIPass**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (`MinKernel`: `21.0.0`) <li> [**ASPP-Override**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/ASPP-Override-v1.0.1.zip) (`MinKernel`: `21.4.0`) <li> [**CryptexFixup**](https://github.com/acidanthera/CryptexFixup) (`MinKernel`: `22.0.0`)<li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) <li>  [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagement-v1.0.0.zip) (`MinKernel`: `22.0.0`)<li> [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/raw/main/payloads/Kexts/Misc/AppleIntelCPUPowerManagementClient-v1.0.0.zip) (`MinKernel`: `22.0.0`) <li> [**FeatureUnlock**](https://github.com/acidanthera/FeatureUnlock) (optional) </ul> </ul> **WiFi** (optional) <ul><li>[**IOSkywalk.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IOSkywalkFamily-v1.0.0.zip) (`MinKernel`: `23.0.0`)  <li>[**IO80211FamilyLegacy.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IO80211FamilyLegacy-v1.0.0.zip) (contains `AirPortBrcmNIC.kext`, ensure this is injected as well) (`MinKernel`: `23.0.0`) </ul>**Delete the following Kexts** from EFI/OC/Kexts and config (if present): <ul><li> **CPUFriend** <li> **CPUFriendDataProvider**| <ul><li>**AutoPkgInstaller**: For applying root-patches during macOS istallation automatically. Requires preparation of the installer ([**Details**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Auto-Patching.md)) <li> **AMFIPass**: Beta kext from OCLP 0.6.7. Allows booting macOS 12+ without disabling AMFI. <li> **ASPP-Override**: Prioritizes plugin-type 0 over plugin-type 1 so SMC CPU Power Management works. <li> **Cryptexfixup**: Required for installing and booting macOS Ventura on systems without AVX 2.0 support (see [OCLP Support Issue #998](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998)) <li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters. <li> **AppleIntelCPUPowerManagement** kexts: Required for re-enabling SMC CPU Power Management in macOS Ventura and newer ([more details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#re-enabling-acpi-power-management-in-macos-ventura))<li> **FeatureUnlock**: Unlocks NightShift and AirPlay to Mac <li> **WiFi Kexts**: For macOS Sonoma. Re-Enable modern WiFi: BCM94350, BCM94360, BCM43602, BCM94331 and BCM943224. Legacy WiFi: Atheros chipsets, Broadcom BCM94322, BCM94328.
**`Kernel/Block`**| Block `com.apple.iokit.IOSkywalkFamily`: <br> ![](https://user-images.githubusercontent.com/76865553/256150446-54079541-ee2e-4848-bb80-9ba062363210.png)| Blocks macOS'es IOSkywalk kext, so the injected one will be used instead. Only required for "Modern" Wifi Cards (&rarr; [Wifi Patching Guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md)). 
**`Kernel/Emulate`** | Disable `DummyPowermanagement` (if enabled) | If you imject the Kexts to re-instatate ACPI CPU Power Management on macOS13+ while this setting is still enabled, the system will freeze 10 to 15 seconds after booting.
**`Kernel/Patch`** | Add and enable the following Kernel Patches from [**OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist) (apply `MinKernel` and `MaxKernel` settings as well): <ul>  <li> **Force FileVault on Broken Seal** (optional) <li> **"SurPlus v1 - PART 1 of 2"** <li> **"SurPlus v1 - PART 2 of 2"** <li> **"Disable Library Validation Enforcement"** <li> **"Disable _csr_check() in _vnode_check_signature"** <li> **Fix PCI bus enumeration (Ventura)** <li> **Fix PCI bus enumeration (Sonoma)** </ul> **NOTE**: VMM board-id kernel patches are no longer required since `RestrictEvents` kext can enable the VMM board-id via `sbvmm` NVRAM entry! | <ul> <li> **Force FileVault on Broken Seal** is only required when using FileVault <li> [**SurPlus patches**](https://github.com/reenigneorcim/SurPlus): required for Sandy Bridge and older. <li> **"Disable _csr_check() in _vnode_check_signature"** might not be necessary. Try for yourself. <li> **Fix PCI bus enumeration** patches fix internal PCIe devices showing up as express cards in the menu bar: ![Screenshot](https://github.com/user-attachments/assets/d362d81c-01f7-491e-98c9-cd9372f30eb1)
**`Kernel/Quirks`** | <ul><li> Enable **`AppleCpuPmCfgLock`**. Not required if you can disable CFG Lock in BIOS. <li> Disable **`AppleXcmpCfgLock`** (if enabled) <li> Disable **`AppleXcpmExtraMsrs`** (enable when using a Sandy Bridge E CPU!) | Apple SMC CPU Management requirements.
**`NVRAM/Add/...-4BCCA8B30102`** | **Add the following Keys**: <ul> <li> **Key**: `OCLP-Settings`<br>**Type**: String <br>**Value**: `-allow_amfi` <li> **Key**: `revblock` <br> **Type**: String <br> **Value**: `media`<li>  **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm,f16c`| <ul> <li> Settings for OCLP and RestrictEvents. <li> `media`: Blocks `mediabranalysisd` service on Ventura+ (for Metal 1 GPUs) <li>`sbvmm,f16c` &rarr; Enables OTA updates and addresses graphics issues in macOS 13 (check RestrictEvents documentation for details)|
**`Misc/Security`**| <ul> <li>**SecureBootModel**: `Disabled` <li> **Vault**: `Optional`| Required when patching in graphics drivers for AMD and NVIDIA GPUs. Intel HD graphics might work with SecureBootModel set to `Default`. Try for yourself.
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | **Add the following Strings**: <ul> <li>  `OCLP-Settings` <li> `revblock` <li> `revpatch` | Deletes NVRAM for these parameters before writing them. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.  
**`NVRAM/Add/...-FE41995C9F82`** | **Change** **`csr-active-config`** to: <ul><li>**`03080000`** <li> When using an NVIDIA GPU, set it to: **`030A0000`** </ul> **Add the following**`boot-args`: <ul><li> **`amfi_get_out_of_my_way=0x1`** or **`amfi=0x80`** (same)<li> **`ipc_control_port_options=0`** <li> **`-disable_sidecar_mac`** </ul>**Optional boot-args for GPUs** (Select based on GPU Vendor): <ul><li> **`-radvesa`** <li> **`nv_disable=1`** <li> **`ngfxcompat=1`**<li>**`ngfxgl=1`**<li> **`nvda_drv_vrl=1`** <li> **`agdpmod=vit9696`** | <ul> <li>**`amfi=0x80`**: Disables Apple Mobile File Integrity validation. Required for applying Root Patches with OCLP ~~and booting macOS 12+~~. :bulb: No longer needed for booting thanks to AMFIPass.kext – only for installing Root Patches with OCLP. Disabling AMFI causes issues with [3rd party apps' access to Mics and Cameras](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Webcams.md).<li> **`ipc_control_port_options=0`**: Required for Intel HD 3000. Fixes issues with Firefox and electron-based apps like Discord.<li> **`-disable_sidecar_mac`**: For FeatureUnlock &rarr; Disables Sidecar/AirPlay/Universal Control patches because they are not supported by the hardware.**<li> **`-radvesa`** (AMD only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS 12+. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li> **`nv_disable=1`** (NVIDIA only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS Ventura. Kepler Cards switch into VESA mode automatically without it. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li> **`ngfxcompat=1`** (NVIDIA only): Ignores compatibility check in `NVDAStartupWeb`. Not required for Kepler GPUs <li>**`ngfxgl=1`** (NVIDIA only): Disables Metal Spport so OpenGL is used for rendering instead. Not required for Kepler GPUs. <li> **`nvda_drv_vrl=1`** (NVIDIA only): Enables Web Drivers. Not required for Kepler GPUs. <li> **`agdpmod=vit9696`** &rarr; Disables board-id check. Useful if screen turns black after booting macOS which can happen after installing NVIDIA Webdrivers. <li> **`-wegnoigpu`** &rarr; Optional. Disables the iGPU in macOS. **ONLY** required when using an AMD GPU and an SMBIOS for a CPU without on-board graphics (i.e. `iMacPro1,1` or `MacPro7,1`) to let the GPU handle background rendering and other tasks. Requires Polaris or Vega cards to work properly (Navi is not supported by OCLP). Combine with `unfairgva=x` bitmask (x= 1 to 7) to [address DRM issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#unfairgva-overrides)
**`UEFI/Drivers`** and <br> **`EFI/OC/Drivers`**| <ul> <li> Add `ResetNvramEntry.efi` to `EFI/OC/Drivers` <li> And to your config:<br> ![resetnvram](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/8d955605-fb27-401f-abdd-2c616b233418) | Adds a boot menu entry to perform an NVRAM reset but without resetting the order of the boot drives. Requires a BIOS with UEFI support.

> [!CAUTION]
> 
> Don't add the NVRAM parameter `OCLP-Version` to your config – it's meant for real Macs only! It checks if your `config.plist` is up to par with the one provided by OCLP. If the version in your config is lower, a pop-up will appear asking you if you would like to update OpenCore:
>
> ![oclp-version](https://github.com/user-attachments/assets/3376afa3-da56-4311-9960-a9ec90e6010f)
>
> If you would press "OK" in this scenario, your `OC` folder would be replaced by the one created for the corresponding Mac model leaving your macOS installation in an unbootable state!

## Testing the changes
Once you've added the required kexts and made the necessary changes to your config.plist, save, reboot and perform an NVRAM Reset. If your system still boots fine after that, you can now prepare the system for installing macOS 13.

### Adjusting the SMBIOS
If your system reboots successfully, we need to edit the config one more time and adjust the SMBIOS depending on the macOS Version *currently* installed.

#### When Upgrading from macOS Big Sur 11.3+
When upgrading from macOS 11.3 or newer, we can use macOSes virtualization capabilities to trick it into thinking that it is running in a VM so spoofing a compatible SMBIOS is no longer a requirement.

Based on your system, use one of the following SMBIOSes for Sandy Bridge CPUs. Open your config.plist and change the SMBIOS in the `PlatformInfo/Generic` section.

- **For Desktops**: **`iMac12,1`** or **`iMac12,2`** 
- **For Laptops**: 
	- **`MacBookPro8,1`** (= 13″ Display, Core i5)
	- **`MacBookPro8,2`** (= 15″ Display, Core i5) 
	- **`MacBookPro8,3`** (= 17″ Display, Core i7)
- **For NUCs**: **`Macmini5,x`**

> [!NOTE]
> 
> Once macOS 12 or newer is installed, you can disable the "Reroute kern.hv" and "IOGetVMMPresent" Kernel Patches. RestrictEvents will handle the VMM-Board-id spoof from now on. **Only Exception**: Before running the "Install macOS" App, you have to re-enable the kernel patches again. Otherwise the installer will say the system is incompatible because of the unsupported SMBIOS it detects.

#### When Upgrading from macOS Catalina or older
Since macOS Catalina and older lack the virtualization capabilities required to apply the VMM Board-ID spoof, switching to a supported SMBIOS temporarily is mandatory in order to be able to install macOS Ventura. Otherwise you will be greeted by the crossed-out circle instead of the Apple logo when trying to boot.

**Supported SMBIOSes**:

- **Desktop**: 
	- **`iMac18,1`** or newer
	- **`MacPro7,1`** or **`iMacPro1,1`** (High End Desktops)
- **Laptop**: 
	- **`MacBookPro14,1`** or 
	- **`MacBookAir8,1`**
- **NUC**: 
	- **`Macmini8,1`** 
- Generate new Serials using [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

> [!NOTE]
> 
> - Once macOS 12 or newer is installed, you can switch to an SMBIOS best suited for your Ivy Bridge CPU and reboot to enjoy all the benefits of a proper SMBIOS. 
> - You may want to generate a new [**SSDT-PM**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)) in Post-Install to optimize CPU Power Management. 
> - You can also disable the "Reroute kern.hv" and "IOGetVMMPresent" Kernel Patches. RestrictEvents will handle the VMM-Board-id spoof from now on. **Only Exception**: Before running the "Install macOS" App, you have to re-enable the kernel patches again. Otherwise the installer will say the system is incompatible because of the unsupported SMBIOS it detects. 

## macOS installation
With all the prep work out of the way you can now upgrade to macOS Ventura. Depending on the version of macOS you are coming from, the installation process differs.

### Getting macOS
- Download the latest release of [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and run it
- Click on "Create macOS Installer"
- Next, click on "Download macOS Installer"
- Select the macOS version you want to install
- Once the download is completed, the "Install macOS…" app will be located the "Programs" folder.

> [!NOTE]
> 
> OCLP can also create a USB installer if you want to perform a clean install (highly recommended). Creating a USB installer is a necessity if you want to install an older OS since macOS does not allow downgrading.

### Option 1: Upgrading from macOS 11.3 or newer 
Only applicable when upgrading from macOS 11.3+. If you are on macOS Catalina or older, use Option 2 instead.

- Run the "Install macOS…" App
- There will be a few reboots
- Boot from the new macOS install partition until it's no longer present in the Boot Picker

Once the installation is completed and the system boots it will run without graphics acceleration if you only have an iGPU or if you GPU is not supported by the newer version of macOS. We will address this next in Post-Install.

> [!TIP]
> 
> Instead of upgrading your runnning macOS installation, create a new APFS volume and install macOS on there. This way you can always revert back to your previous macOS installation if you are facing issues with the new macOS version.

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
- Select "Install macOS…" from the BootPicker
- Install macOS on the volume you prepared earlier 
- There will be a few reboots during installation. Boot from the new "Install macOS" Partition until it's no longer present in the Boot Picker
- Once the macOS Ventura installation is finished, switch back to an SMBIOS best suited for your Sandy Bridge CPU mentioned earlier.

After the installation is completed and the system boots it will run without hardware graphics acceleration if you only have an iGPU or if you GPU is no longer supported by the newer version of macOS. We will address this in Post-Install. 

## Post-Install
OpenCore Legacy patcher can re-install components which were removed from macOS, such as Graphics Drivers, Frameworks, etc. This is called "root patching". For Wintel systems, we will make use of it to install iGPU and GPU drivers primarily.

### Installing Intel HD 2000/3000 drivers
Once you reach the set-up assistant (where you select your language, time zone, etc), you will notice that the system feels super sluggish – that's normal because it is running in VESA mode without graphics acceleration, since the friendly guys at Apple removed the Intel HD 2000/3000 drivers from macOS.

To bring them back, do the following:

- Run the OpenCore Patcher App 
- In the OpenCore Legacy Patcher menu, select "Post Install Root Patch":</br>![Post_Root_Patches](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/15fe5dc1-793c-465c-9252-1ee6e503c680)
- Follow the instructions of the Patcher App (I don't have a Sandy Bridge so I can't capture screenshots. I also couldn't find any online.)

### Installing Drivers for other GPUs
- Works basically the same way as installing iGPU drivers
- OCLP detects the GPU and if it has drivers for it, they can be installed. Afterwards, GPU Hardware Acceleration should work. Note that additional settings in OCLP may be required based on the GPU you are using.
- After the drivers have been installed, disable the following `boot-args` prior to rebooting to re-enable GPU graphics acceleration:
  - `-radvesa` – put a `#` in front to disable it: `#-radvesa`
  - `nv_disable=1` – put a `#` in front to disable it: `#nv_disable=1`

> [!NOTE]
> 
> Prior to installing macOS updates you probably have to re-enable boot-args for AMD and NVIDIA GPUs again to put them into VESA mode so you have a picture and not a black screen!

### Verifying SMC CPU Power Management
To verify that SMC CPU Power Management is working, enter the following command in Terminal:

```shell
sysctl machdep.xcpm.mode
```
If the output is `0`, the legacy `ACPI_SMC_PlatformPlugin` is used for CPU Power Management and everything is ok. If the output is `1`, the `X86PlatformPlugin` for `XCPM` is active, which is not good since Sandy Bridge CPUs don't support XCPM. In this case, check if the necessary kexts for SMC CPU Power Management were injected by OpenCore. Enter in Terminal:

```shell
kextstat | grep com.apple.driver.AppleIntelCPUPowerManagement
```
This should result in the following output:

```
com.apple.driver.AppleIntelCPUPowerManagement (222.0.0)
com.apple.driver.AppleIntelCPUPowerManagementClient (222.0.0) 
```
If the 2 kexts are not present, they were not injected. So check your config and EFI folder again. Also ensure that the `AppleCpuPmCfgLock` Quirk is enabled.

#### Optimizing CPU Power Management
Once you've verified that SMC CPU Power Management (plugin-type `0`) is working, monitor the behavior of the CPU using [Intel Power Gadget](https://www.insanelymac.com/forum/files/file/1056-intel-power-gadget/). If it doesn't reach its maximum turbo frequency or if the base frequency is too high/low or if the idle frequency is too high, [generate an `SSDT-PM`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)#readme) to optimize CPU Power Management.

### Removing/Disabling boot-args
After macOS Ventura is installed and OCLP's root patches have been applied in Post-Install, remove or disable the following boot-args:

- `ipc_control_port_options=0`: ONLY when using a dedicated GPU. You still need it when using the Intel HD 4000 so Firefox and electron-based apps will work.
- `amfi_get_out_of_my_way=0x1`: ONLY needed for re-applying root patches with OCLP after System Updates
- Change `-radvesa` to `#-radvesa` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on AMD GPUs.
- Change `nv_disable=1` to `#nv_disable=1` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on NVIDIA GPUs.

> [!NOTE]
> 
> Keep a backup of your currently working EFI folder on a FAT32 USB flash drive just in case your system won't boot after removing/disabling these boot-args!

### Verifying AMFI is enabled
We can check whether or not AMFI is enabled by entering the following command in Terminal:

```shell
sudo /usr/sbin/nvram -p | /usr/bin/grep -c "amfi_get_out_of_my_way=1"
```

- The desired output is `0`: this means, the `amfi_get_out_of_my_way=1` boot-arg which disables AMFI is not present in NVRAM which indicates that AMFI is enabled. This is good.
- If the output is `1`: this means, the `amfi_get_out_of_my_way=1` boot-arg which disables AMFI is present in NVRAM which indicates that AMFI is disabled. 

Since the new `AMFIPass.kext` allows booting macOS with applied root patches and SIP as well as SecureBootModel disabled but AMFI enabled, we want the output to be `0`!

## OCLP and System Updates

### Re-applying root patches after System Updates
The major advantage of using OCLP over other Patchers is that it remains on the system even after installing System Updates. After an update, it detects that the graphics drivers are missing and asks you, if you want to to patch them in again, as shown in ths example:

![Notify](https://user-images.githubusercontent.com/76865553/181934588-82703d56-1ffc-471c-ba26-e3f59bb8dec6.png)

You just click on "Okay" and the drivers will be re-installed. After the obligatory reboot, everything will be back to normal.

### OCLP App Update Notifications

OCLP can also inform you about availabled updates of the Patcher app itself. But this requires adding the key `OCLP-Version`to the `NVRAM/Add` section of your config.plist:

![OCLPver01](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/4a7b0fc8-2ab5-4d2c-9ab2-ea62ca7614ff)

This ke is optional for Hackintosh users, since the OCLP app also informs you about updates once you run it. If you choose to add it to your config, you also have to add a reset key to the corresponding `NVRAM/Delete` section, so that new values can be applied:

![OCLPver03](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/2ca84e3b-fb66-4d96-8fe8-d8ee94fde0a5)

After that, you will be notified whenever an update for the OpenCore Patcher is available:

![OCLPver02](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/dc61fb53-2a72-4523-81fe-a0df3596bc73)

Note that this Pop-up refers to "OpenCore" and not the Patcher because OCLP was designed with real Macs and Mac users in mind. For "regular" Mac users, using OCLP is most likely the only way they update OpenCore, config and kexts. So after downloading the latest OCLP update, they, just rebuild the EFI, mount the ESP, replaces the EFI/OC folder, apply reoo patches, reboot and that's it. 

But as Hackintosh users, we only care about the App updates to apply new, updated or refined root patches for iGPUs, Wi-FI, etc. Please keep in mind that you have to manually adjust the OCLP version number after each update so that you won't be notified about a possibly outdated patcher app although the newest version is installed already. So adding the OCLP-Version Key to a Hackintosh build is not really a necessity.

> [!TIP]
> 
> If your system won't boot after patching it with OpenCore Legacy Patcher, you have several options to [revert root patches](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Reverting_Root_Patches.md).

## Notes
- Applying Root Patches to the system partition breaks its security seal. This affects System Updates: every time a System Update is available, the FULL Installer (about 12 GB) will be downloaded. There is a [**workaround**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/S_System_Updates/OTA_Updates.md) to this but it's only applicable to Haswell/Broadwell and newer.
- After each System Update, the iGPU/GPU drivers have to be re-installed. OCLP will take care of this. Just make sure to re-enable the appropriate boot-args to put AMD/NVIDIA GPUs in VESA mode prior to updating/upgrading macOS.
- ⚠️ You cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)). 

## Further Resources
- [**Non-Metal Wiki**](https://moraea.github.io/) by Moraea
- [**SMBIOS Compatibility Chart**](https://docs.google.com/spreadsheets/d/1DSxP1xmPTCv-fS1ihM6EDfTjIKIUypwW17Fss-o343U/edit#gid=483826077)
- [**Enabling NVIDIA WebDrivers in 11+**](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/) by elitemacx86.com

## Credits
- Acidanthera for OpenCore and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- dhinakg for AMFIPass
- Dortania for [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and [Guide](https://dortania.github.io/OpenCore-Legacy-Patcher/)
- Rehabman for Laptop framebuffer patches

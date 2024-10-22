# Installing macOS Ventura or newer on Haswell/Broadwell systems

[![OpenCore Version](https://img.shields.io/badge/OpenCore_Version:-0.9.4+-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤15.1-white.svg)

<details>
<summary><b>TABLE of CONTENTS</b> (Click to reveal)</summary>

**TABLE of CONTENTS**

- [About](#about)
	- [How Haswell/Broadwell systems are affected](#how-haswellbroadwell-systems-are-affected)
	- [Disclaimer](#disclaimer)
- [Precautions and Limitations](#precautions-and-limitations)
	- [Update OpenCore and kexts](#update-opencore-and-kexts)
- [Config Edits](#config-edits)
- [Testing the changes](#testing-the-changes)
	- [Adjusting the SMBIOS](#adjusting-the-smbios)
		- [When Upgrading from macOS Big Sur 11.3+](#when-upgrading-from-macos-big-sur-113)
		- [When Upgrading from macOS Catalina or older](#when-upgrading-from-macos-catalina-or-older)
- [macOS Ventura Installation](#macos-ventura-installation)
	- [Getting macOS](#getting-macos)
	- [Option 1: Upgrading from macOS 11.3 or newer](#option-1-upgrading-from-macos-113-or-newer)
	- [Option 2: Upgrading from macOS Catalina or older](#option-2-upgrading-from-macos-catalina-or-older)
- [Post-Install](#post-install)
	- [Installing Intel Haswell/Broadwell Graphics Acceleration Patches](#installing-intel-haswellbroadwell-graphics-acceleration-patches)
	- [Installing Drivers for other GPUs](#installing-drivers-for-other-gpus)
	- [Revert SMBIOS (after upgrading from macOS Catalina or older only)](#revert-smbios-after-upgrading-from-macos-catalina-or-older-only)
	- [Removing/Disabling boot-args](#removingdisabling-boot-args)
	- [Verifying AMFI is enabled](#verifying-amfi-is-enabled)
- [OCLP and System Updates](#oclp-and-system-updates)
- [Notes](#notes)
- [Further Resources](#further-resources)
- [Credits](#credits)

</details>

## About
Although installing and running macOS Ventura on machines with Intel Haswell and Broadwell CPUs is possible with OpenCore and the OpenCore Legacy Patcher (OCLP), it’s not documented nor officially supported by Dortania – their support is limited to Apple Macs. Since no guide exists, I created this one in order to bridge the gap. I wrote it based on my experiences getting macOS Ventura to run on an Ivy Bridge Laptop and analyzing the log, config and EFI folder after building OpenCore with OCLP for a Haswell system.

| ⚠️ Important Status Updates |
|:----------------------------|
| Don't install macOS Sequoia yet. OCLP cannot patch it yet. Currently, there's no solution to make enable iGPU drivers on Haswell systems!

### How Haswell/Broadwell systems are affected
In macOS Ventura, support for CPU families prior to Kaby Lake was dropped. For Haswell/Broadwell CPUs this mainly affects integrated Graphics and Metal support. So what we will do is prepare the config with the required patches, settings and kexts for installing and running macOS Ventura and then add iGPU/GPU drivers in Post-Install using OpenCore Legacy Patcher.

### Disclaimer
This guide is intended to provide general information for adjusting your EFI and config.plist to install and run macOS Ventura and newer on unsupported Wintel systems. It is not a comprehensive configuration guide. Please refrain from using the "report issue" function to seek individualised assistance for fixing your config. Such issue reports will be closed immediately!

## Precautions and Limitations
This is what you need to know before attempting to install macOS Ventura on unsupported systems:

- :warning: **Backup** your working EFI folder on a FAT32 formatted USB Flash Drive just in case something goes wrong because we have to modify the config and content of the EFI folder.
- **iGPU/GPU**: Check if your iGPU/GPU is supported by OCLP. Although Drivers for Intel, NVIDIA and AMD cards can be added in Post-Install, the [list is limited](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches) 
- Check if any peripherals you are using are compatible with macOS 12+ (Printers, WiFi and BlueTooth come to mind).
- **Networking**:
	- For **Ethernet**, there are kexts for legacy LAN controllers [available here](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Ethernet)
	- **Wifi and Bluetooth**:
		- For enabling Broadcom Wifi/BT Cards, you will need a different [set of kexts](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) to load which need to be controlled via `MinKernel` and `MaxKernel` settings. On macOS 12.4 and newer, a new address check has been introduced in `bluetoothd`, which will trigger an error if two Bluetooth devices have the same address. This can be circumvented by adding boot-arg `-btlfxallowanyaddr` (provided by [BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM) kext).
		- Same applies to [Intel WiFi/BT](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-8a-intel-wifi-airportitlwm-and-bluetooth-intelbluetoothfirmware) cards using [OpenIntelWirless](https://github.com/OpenIntelWireless) kexts
		- [Enabling Wifi in macOS Sonoma](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md) requires additional kext and also applying root patches in Post-Install!
- **Security**: Modifying the system with OCLP Requires SIP, Apple Secure Boot and AMFI to be disabled so there are some compromises in terms of security.
- **System Updates**: Incremental (or delta) updates won't be available after applying root patches with OCLP. Instead, the whole macOS Installer will be downloaded every time (approx. 12 GB)!
- **Other**: Check the links below for in-depth documentation about components/features that have been removed from macOS 12 and newer and the impact this has on systems prior to Kaby Lake. But keep in mind that this was written for real Macs so certain issues don't apply to Wintel systems.
	- [Status of OpenCore Legacy Patcher Support for macOS Sonoma](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1076)
	- [Status of OpenCore Legacy Patcher Support for macOS Ventura](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998)
	- [Legacy Metal Support and macOS Ventura/Sonoma](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1008)

### Update OpenCore and kexts
Update OpenCore and kexts to the latest version to maximize compatibility with macOS. To check which version of OpenCore you're currently using, run the following commands in Terminal:

```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

## Config Edits
Listed below, you find the required modifications to prepare your config.plist and EFI folder for installing macOS Monterey or newer on Haswell/Broadwell systems. You can use this [.plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Haswell-Broadwell_OCLP_Wintel_Patches.plist) which contains all the necessary settings for cross-referencing.

:bulb: If your system (or components thereof) doesn't work afterwards, please refer to OCLP's [patch documentation](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/docs/PATCHEXPLAIN.md) and see if need additional settings or kexts.

Config Section | Action | Description
:-------------:| ------ | ------------
**`Booter/Patch`**| **Add** and **enable** the following Booter patch from OCLP's config: <ul> <li> [**"Skip Board ID check"**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L243) | <ul><li> Skips board-id check. <li> In combination with ResterictEvents kext, this allows: <ul> <li> Booting macOS with unsupported, native SMBIOS best suited for your CPU <li> Installing Sytsem Updates on unsupported systems </ul> <li> More [Details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof#booter-patches)
**`DeviceProperties/Add`**|**PciRoot(0x0)/Pci(0x2,0x0)** – Verify/adjust Framebuffer patch. <ul><li> **Desktop** (Haswell Headless) <ul><li> **AAPL,ig-platform-id**: 04001204 <li> **device-id**: 12040000 (Only reqd. for HD 4400)</ul></ul><ul><li> **Desktop** (Haswell Default) <ul><li> **AAPL,ig-platform-id**: 0300220D <li> **device-id**: 12040000 (Only reqd. for HD 4400) </ul></ul><ul><li> **Desktop** (Broadwell Default) <ul><li> **AAPL,ig-platform-id**: 07002216 <li> **device-id**: 12040000 (Only reqd. for HD 4400) </ul></ul><ul><li> **Laptop/NUC** (Haswell): &rarr; see [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/haswell.html#add-2) </ul><ul><li> **Laptop/NUC** (Broadwell): &rarr; see [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/broadwell.html#add-2) </ul>|**iGPU Support**: Intel HD 4200/4400/4600, HD 5000/5100/5200/5600 and Iris Pro 6200 <ul> <li> **Haswell Headless**: For systems with a Haswell CPU using an iMac SMBIOS, iGPU and a GPU which is used for graphics. <li> **Haswell/Broadwell Default**: Use this if you have a Desktop PC and the iGPU is used for driving a display. <li>**Laptop/NUC**: Depending on the iGPU used in your Lapto, Nuc or USDT a different combination of **AAPL,ig-platform-id** and **device-id** may be required. </ul> **Note**: Additional properties need to be added when using the iGPU for displaying graphics. Please refer to the OpenCore Install guide in this case. This section is only here to ensure that you are using the correct `AAPL,ig-platform-id`!
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li>[**AMFIPass**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) (`MinKernel`: `21.0.0`)<li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) <li> [**FeatureUnlock**](https://github.com/acidanthera/FeatureUnlock) (optional) </ul> **WiFi** (optional) <ul><li>[**IOSkywalk.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IOSkywalkFamily-v1.0.0.zip) (`MinKernel`: `23.0.0`) <li>[**IO80211FamilyLegacy.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IO80211FamilyLegacy-v1.0.0.zip) (contains `AirPortBrcmNIC.kext`, ensure this is injected as well) (`MinKernel`: `23.0.0`) </ul> **Disable the following Kexts** (if present): <ul><li> **CPUFriend** <li> **CPUFriendDataProvider** </ul> | <ul><li> **AMFIPass**: Beta kext from OCLP 0.6.7. Allows booting macOS 12+ without disabling AMFI.  <li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates on systems with disabled SIP. Requires additional NVRAM parameters. <li> **FeatureUnlock**: Unlocks additional features in macOS that are only avaiable for certain Mac models/SMBIOSes. <li> **CPUFriend**: When changing the SMBIOS, it's recommeneded to generate a new CPUFriendDataProvider.kext! <li> **WiFi Kexts**: For macOS Sonoma. Re-Enable modern WiFi: BCM94350, BCM94360, BCM43602, BCM94331 and BCM943224. Legacy WiFi: Atheros chipsets, Broadcom BCM94322, BCM94328.
**`Kernel/Block`**| Block `com.apple.iokit.IOSkywalkFamily`: <br> ![](https://user-images.githubusercontent.com/76865553/256150446-54079541-ee2e-4848-bb80-9ba062363210.png)| Blocks macOS'es IOSkywalk kext, so the injected one will be used instead. Only required for "Modern" Wifi Cards (&rarr; [Wifi Patching Guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Enable_Features/WiFi_Sonoma.md)). 
**`Kernel/Emulate`** <br>(HEDT only!)| **Haswell E**: <ul> <li> **Cpuid1Data**: C3060300 00000000 00000000 00000000 <li> **Cpuid1Mask**: FFFFFFFF 00000000 00000000 00000000 </ul> **Broadwell E**: <ul> <li> **Cpuid1Data**: D4060300 00000000 00000000 00000000 <li> **Cpuid1Mask**: FFFFFFFF 00000000 00000000 00000000 | :warning: Only required for High End Desktop Workstations using Haswell E or Broadwell E CPUs! DON'T add to Desktop, Laptop or NUC configs!
**`Kernel/Patch`** | Add and enable the following Kernel Patches from [**OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist) (apply `MinKernel` and `MaxKernel` settings as well): <ul> <li> **Force FileVault on Broken Seal** (optional) <li> **"Disable Library Validation Enforcement"**<li>**"Disable _csr_check() in _vnode_check_signature"** <li> **Fix PCI bus enumeration (Ventura)** <li> **Fix PCI bus enumeration (Sonoma)**| <ul> <li> **Force FileVault on Broken Seal** is only required when using FileVault <li> **"Disable _csr_check() in _vnode_check_signature"** is not required on my Laptop, but on some Desktops it's needed. Try for yourself. <li> The "Fix PCI bus enumeration" patches fix internal PCIe devices showing up as express cards in the menu bar: ![Sreenshot](https://user-images.githubusercontent.com/83997656/284185052-d7a951de-9921-4680-939d-e29d003db03a.png) </ul> **NOTE**: Kernel VMM patches are no longer needed since RestrictEvents handles this now!
**`Misc/Security`**| <ul> <li>**SecureBootModel**: `Disabled` <li> **Vault**: `Optional`| Required when patching in graphics drivers for AMD and NVIDIA cards. Intel HD graphics might work with SecureBootModel set to `Default`. Try for yourself.
**`NVRAM/Add/...-4BCCA8B30102`** | **Add the following Keys**: <ul> <li> **Key**: `OCLP-Settings`<br>**Type**: String <br> **Value**: `-allow_amfi`<li> **Key**: `revblock` <br> **Type:** String <br> **Value**: `media`<li> **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm,asset`| **Explanaitons**: <ul> <li> Settings for OCLP and RestrictEvents. <li> `revblock`: `media` &rarr; Blocks mediaanalysisd on Ventura+ (for Metal 1 GPUs) which helps with graphical issues <li>`revpatch`: `sbvmm,asset` &rarr; Enables OTA updates and content caching (Check RestrictEvents documentation for details)|
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | **Add the following Strings**: <ul> <li>  `OCLP-Settings` <li> `revblock` <li> `revpatch` |Deletes NVRAM for these parameters before writing them. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.  
**`NVRAM/Add/...-FE41995C9F82`** | <li> **Change** **`csr-active-config`** to: **`03080000`** <br><br>**Add the following**`boot-args`: <ul><li> **`amfi_get_out_of_my_way=0x1`** or **`amfi=0x80`** (same) <li> **`ipc_control_port_options=0`** <li> **`-disable_sidecar_mac`** (optinal) </ul>**Optional boot-args for GPUs** (Select based on GPU Vendor): <ul><li> **`-radvesa`** <li> **`nv_disable=1`** <li> **`ngfxcompat=1`**<li>**`ngfxgl=1`**<li> **`nvda_drv_vrl=1`** <li> **`agdpmod=vit9696`** | <ul> <li>**`amfi=0x80`**: Disables Apple Mobile File Integrity validation. Required for applying Root Patches with OCLP ~~and booting macOS 12+~~. :bulb: No longer needed for booting thanks to AMFIPass.kext – only for installing Root Patches with OCLP. Disabling AMFI causes issues with [3rd party apps' access to Mics and Cameras](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Webcams.md).<li> **`ipc_control_port_options=0`**: Required for Intel HD Graphics. Fixes issues with Firefox and electron-based apps like Discord. <li> **`-disable_sidecar_mac`**: For FeatureUnlock &rarr; Disables Sidecar/AirPlay/Universal Control patches. Since the features that can be enabled depend on the chosen SMBIOS refer to the [documentation](https://github.com/acidanthera/FeatureUnlock) <li> **`-radvesa`** (AMD only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS 12+. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li> **`nv_disable=1`** (NVIDIA only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS Ventura. Kepler Cards switch into VESA mode automatically without it. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li>**`ngfxcompat=1`** (NVIDIA only): Ignores compatibility check in `NVDAStartupWeb`. Not required for Kepler GPUs <li>**`ngfxgl=1`** (NVIDIA only): Disables Metal Spport so OpenGL is used for rendering instead. Not required for Kepler GPUs. <li> **`nvda_drv_vrl=1`** (NVIDIA only): Enables Web Drivers. Not required for Kepler GPUs. <li> **`agdpmod=vit9696`** &rarr; Disables board-id check. Useful if screen turns black after booting macOS which can happen after installing NVIDIA Webdrivers. <li> **`-wegnoigpu`** &rarr; Optional. Disables the iGPU in macOS. **ONLY** required when using an AMD GPU and an SMBIOS for a CPU without on-board graphics (i.e. `iMacPro1,1` or `MacPro7,1`) to let the GPU handle background rendering and other tasks. Requires Polaris or Vega cards to work properly (Navi is not supported by OCLP). Combine with `unfairgva=x` bitmask (x= 1 to 7) to [address DRM issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#unfairgva-overrides)
**`UEFI/Drivers`** and <br> **`EFI/OC/Drivers`**| <ul><li> Add `ResetNvramEntry.efi` to `EFI/OC/Drivers` <li> And to your config:<br> ![resetnvram](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/8d955605-fb27-401f-abdd-2c616b233418) | Adds a boot menu entry to perform an NVRAM reset but without resetting the order of the boot drives. Requires a BIOS with UEFI support.

## Testing the changes
Once you've added the required kexts and made the necessary changes to your config.plist, save, reboot and perform an NVRAM Reset. If your system still boots fine after that, you can now prepare the system for installing macOS 13.

### Adjusting the SMBIOS
If your system reboots successfully, we need to edit the config one more time to adjust the SMBIOS depending on the macOS Version *currently* installed.

#### When Upgrading from macOS Big Sur 11.3+
When upgrading from macOS 11.3 or newer, we can use macOSes virtualization capabilities to trick it into "thinking" that it is running in a virtual machine so spoofing a macOS compatible SMBIOS is no longer a requirement. Based on your system, use one of the following correct/native SMBIOSes for Haswell/Broadwell CPUs:

- Mount your EFI and open your config.plist. 
- Under `PlatformInfo/Generic`, change `SystemProductname` resembling your hardware.
	- **Desktops**:
		- **`iMac14,4`** &rarr; For Haswell with iGPU only
		- **`iMac15,1`** &rarr; For Haswell with dGPU
		- **`iMac16,1`** &rarr; For Broadwell
	- **Laptops/NUCs** (Haswell): 
		- **`MacBookAir6,1`** = 11″ Screen, Dual Core, iGPU: HD 5000
		- **`MacBookAir6,2`** = 13″ Screen, Dual Core, iGPU: HD 5000
		- **`MacBookPro11,1`** = 13″ Screen, Dual Core, iGPU: Iris 5100 
		- **`MacBookPro11,2`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200
		- **`MacBookPro11,3`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200 + dGPU: GT 750M
		- **`MacBookPro11,4`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200
		- **`MacBookPro11,5`** = 5″ Screen, Quad Core, iGPU: Iris Pro 5200 + dGPU: R9 M370X
		- **`Macmini7,1`** = NUCs/USDTs with HD 5000/Iris 5100 iGPU
	- **Laptops/NUCs** (Broadwell):
		- **`MacBook8,1`** = 12″ Screen, Dual Core (7 Watts), iGP: HD 5300
		- **`MacBookAir7,1`** = 11″ Screen, Dual Core (15 W), iGPU: HD 6000
		- **`MacBookAir7,2`** = 13″ Screen, Dual Core (15 W), iGPU: HD 6000
		- **`MacBookPro12,1`** = 13″ Screen, Dual Core (28 W), iGPU: Iris 6100
		- **`MacBookPro11,2`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200
		- **`MacBookPro11,3`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200 + dGPU: GT 750M
		- **`MacBookPro11,4`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200
		- **`MacBookPro11,5`** = 15″ Screen, Quad Core, iGPU: Iris Pro 5200 + dGPU: R9 370X
		- **`iMac16,1`** = NUC with HD 6000 or Iris Pro 6200 
	- **High Ende Desktop** (Haswell/Broadwell-E): **`iMacPro1,1`** 
- Generate new Serials with [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) or [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)

#### When Upgrading from macOS Catalina or older
Since macOS Catalina and older lack the virtualization capabilities required to apply the VMM Board-ID spoof, switching to a supported SMBIOS temporarily is mandatory in order to be able to install macOS Ventura. Otherwise you will be greeted by the crossed-out circle instead of the Apple logo when trying to boot. So adjust the `SystemProductName` (under `PlatformInfo`) accordingly.

**Supported SMBIOSes**:

- **Desktop**:
	- **`iMac18,1`** or newer
	- **`MacPro7,1`** or **`iMacPro1,1`** (High End Desktops)
- **Laptop**:
	- **`MacBookPro14,1`** or
	- **`MacBookAir8,1`**
- **NUC**:
	- **`Macmini8,1`**

Generate new Serials using [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) or [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)

> [!NOTE]
>
> Once macOS Ventura is up and running, you can switch to an SMBIOS best suited for your Haswell/Broadwell CPU for optimal CPU Power Management. 

## macOS Ventura Installation
With all the prep work out of the way you can now upgrade to macOS Ventura. Depending on the version of macOS you are coming from, the installation process differs.

### Getting macOS
- Download the latest release of [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and run it
- Click on "Create macOS Installer"
- Next, click on "Download macOS Installer"
- Select macOS 13.x (whatever the latest available build is)  
- Once the download is completed, the "Install macOS Ventura" app will be located in the "Programs" folder

> [!NOTE]
> 
> OCLP can also create a USB Installer if you want to perform a clean install (highly recommended)

### Option 1: Upgrading from macOS 11.3 or newer
Only applicable when upgrading from macOS 11.3+. If you are on macOS Catalina or older, use Option 2 instead.

- Run the "Install macOS Ventura" App
- There will be a few reboots
- Boot from the new macOS Partition until it's no longer present in the Boot Picker

Once the installation has finished and the system boots it will run without graphics acceleration if you only have an iGPU or if you GPU is not supported by macOS. We will address this next in Post-Install.

### Option 2: Upgrading from macOS Catalina or older
When upgrading from macOS Catalina or older a clean install from USB flash drive is recommended. To create a USB Installer, you can use OpenCore Legacy Patcher:

- Run Disk utility
- Create a new APFS Volume on your internal HDD/SSD or use a separate internal disk (at least 60 GB in size) for installing macOS 13 – DON'T install it on an external drive – it won't boot!
- Attach an empty USB flash drive for creating the installer (16 GB+)
- Run OCLP and follow the [**instructions**](https://dortania.github.io/OpenCore-Legacy-Patcher/INSTALLER.html#creating-the-installer)
- Once the USB Installer has been created, do the following:
	- Copy the OpenCore-Patcher App to the USB Installer
	- Optional: Copy the following tools (in case internet is not working after):
		- Python Installer
		- MountEFI
		- ProperTree
- Reboot
- Select "Install macOS Ventura" from the BootPicker
- Install macOS Ventura on the volume you prepared earlier
- There will be a few reboots during installation. Boot from the new "Install macOS" Partition until it's no longer present in the Boot Picker
- Next, Boot into macOS Ventura. 

Once the installation has finished and the system boots it will run without graphics acceleration if you only have an iGPU or if you GPU is not supported by macOS. We will address this next in Post-Install.

## Post-Install
OpenCore Legacy patcher can re-install components which were removed from macOS, such as Graphics Drivers, Frameworks, etc. This is called "root patching". For Wintel systems, we will make use of it to install iGPU and GPU drivers primarily.

### Installing Intel Haswell/Broadwell Graphics Acceleration Patches
Once you reach the set-up assistant (where you select your language, time zone, etc), you will notice that the system feels super sluggish – that's normal because it is running in VESA mode without graphics acceleration, since the friendly guys at Apple removed the iGPU drivers for Haswell and Broadwell from macOS.

To bring them back, do the following:

- Run the OpenCore Patcher App
- In the OpenCore Legacy Patcher menu, select "Post Install Root Patch":</br>![Post_Root_Patches](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/15fe5dc1-793c-465c-9252-1ee6e503c680)
- Follow the instructions of the Patcher App (I don't have a Haswell or Broadwell system, so I can't capture screenshots. I also couldn't find any online.)

### Installing Drivers for other GPUs
- Works basically the same way as installing iGPU drivers
- OCLP detects the GPU and if it has drivers for it, they can be installed. Afterwards, GPU Hardware Acceleration should work. Note that additional settings in OCLP may be required based on the GPU you are using.
- After the drivers have been installed, disable the following `boot-args` prior to rebooting to re-enable GPU graphics acceleration:
  - `-radvesa` – put a `#` in front to disable it: `#-radvesa`
  - `nv_disable=1` – put a `#` in front to disable it: `#nv_disable=1`

> [!NOTE]
> 
> Prior to installing macOS updates you probably have to re-enable boot-args for AMD and NVIDIA GPUs again to put the card in VESA mode.

### Revert SMBIOS (after upgrading from macOS Catalina or older only)
Once macOS Ventura is up and running, the VMM Board-ID spoof will work, so you can now revert to one of the "native" SMBIOSes mentioned in the "When Upgrading from macOS Big Sur 11.3+" section that suits for your Haswell/Broadwell CPU for optimal CPU/GPU Power Management. To further adjust/optimize CPU Power Management, generate a new `CPUFriendDataProvider.kext` with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend) or [One-Key-CPUFriend](https://github.com/stevezhengshiqi/one-key-cpufriend) and add it to your config and EFI.

### Removing/Disabling boot-args
After macOS Ventura is installed and OCLP's root patches have been applied in Post-Install, remove or disable the following boot-args:

- `ipc_control_port_options=0`: ONLY when using a dedicated GPU. You still need it when using the Intel HD 4000 so Firefox and electron-based apps will work.
- `amfi_get_out_of_my_way=0x1`: ONLY needed for re-applying root patches with OCLP after System Updates
- Change `-radvesa` to `#-radvesa` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on AMD GPUs.
- Change `nv_disable=1` to `#nv_disable=1` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on NVIDIA GPUs.

> [!IMPORTANT]
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
- Applying Root Patches to the system partition breaks its security seal. This affects System Updates: every time a System Update is available, the FULL Installer (about 12 GB) will be downloaded. But there is a [**workaround to reduce the size of OTA Updates**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/S_System_Updates/OTA_Updates.md).
- After each System Update, the iGPU/GPU drivers have to be re-installed. OCLP will take care of this. Just make sure to re-enable the appropriate boot-args to put AMD/NVIDIA GPUs in VESA mode prior to updating/upgrading macOS.

## Further Resources
- [**Non-Metal Wiki**](https://moraea.github.io/) by Moraea
- [**SMBIOS Compatibility Chart**](https://docs.google.com/spreadsheets/d/1DSxP1xmPTCv-fS1ihM6EDfTjIKIUypwW17Fss-o343U/edit#gid=483826077)
- [**Enabling NVIDIA WebDrivers in macOS 11+**](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/) by elitemacx86.com

## Credits
- Acidanthera for OpenCore, OCLP and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- dhinakg for AMFIPass
- Dortania for [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and [Guide](https://dortania.github.io/OpenCore-Legacy-Patcher/)

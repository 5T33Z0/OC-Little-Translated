# Installing macOS Ventura or newer on Skylake systems

[![OpenCore Version](https://img.shields.io/badge/OpenCore_Version:-≤0.9.4-success.svg)](https://github.com/acidanthera/OpenCorePkg) ![macOS](https://img.shields.io/badge/Supported_macOS:-≤14.0-white.svg)

<details>
<summary><b>TABLE of CONTENTS</b> (Click to reveal)</summary>

**TABLE of CONTENTS**

- [About](#about)
	- [How Skylake systems are affected](#how-skylake-systems-are-affected)
	- [Disclaimer](#disclaimer)
- [Precautions and Limitations](#precautions-and-limitations)
- [Preparations](#preparations)
	- [Update OpenCore and kexts](#update-opencore-and-kexts)
- [Upgrade options](#upgrade-options)
	- [Option 1: Installing macOS Ventura without Root Patches](#option-1-installing-macos-ventura-without-root-patches)
		- [Pros and Cons of this method](#pros-and-cons-of-this-method)
	- [Option 2: Installing macOS Ventura with Root Patches](#option-2-installing-macos-ventura-with-root-patches)
		- [Pros and Cons of this method](#pros-and-cons-of-this-method-1)
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
	- [Installing Intel Skylake Graphics Acceleration Patches (macOS 13)](#installing-intel-skylake-graphics-acceleration-patches-macos-13)
	- [Installing Drivers for other GPUs](#installing-drivers-for-other-gpus)
	- [Removing/Disabling boot-args](#removingdisabling-boot-args)
	- [Verifying AMFI is enabled](#verifying-amfi-is-enabled)
- [OCLP and System Updates](#oclp-and-system-updates)
- [Notes](#notes)
- [Further Resources](#further-resources)
- [Credits](#credits)

</details>

## About
Although it is possible to utilize OpenCore and the OpenCore Legacy Patcher (OCLP) to install and run macOS Ventura on machines with 6th Gen Intel Core CPUs (Skylake/Skylake X/W), it's not officially supported nor documented by Dortania – they only support legacy Macs by Apple. That's why I created this guide. Since I no longer own a Skylake system, their might be something I am missing.

### How Skylake systems are affected
In macOS Ventura, support for CPU families prior to Kaby Lake was dropped. For Skylake CPUs this mainly affects integrated Graphics and Metal support. So what we will do is prepare the config with the required patches, settings and kexts for installing and running macOS Ventura and then add iGPU/GPU drivers in Post-Install using OpenCore Legacy Patcher.

> **Note**: Check out the [list of things that were removed macOS Ventura](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) and the impact this has on pre-Kaby Lake systems. But keep in mind that this was written for real Macs so certain issues don't affect Wintel machines.

### Disclaimer
This guide is intended to provide general information for adjusting your EFI and config.plist to install and run macOS Ventura and newer on unsupported Wintel systems. It is not a comprehensive configuration guide. Please refrain from using the "report issue" function to seek individualized assistance for fixing your config. Such issue reports will be closed immediately!

## Precautions and Limitations
This is what you need to know before attempting to install macOS Ventura on unsupported systems:

- :warning: **Backup** your working EFI folder on a FAT32 formatted USB Flash Drive just in case something goes wrong because we have to modify the config and content of the EFI folder.
- **iGPU/GPU**: Check if your iGPU/GPU is supported by OCLP. Although Drivers for Intel, NVIDIA and AMD cards can be added in Post-Install, the [list is limited](https://dortania.github.io/OpenCore-Legacy-Patcher/PATCHEXPLAIN.html#on-disk-patches) 
- Check if any peripherals you are using are compatible with macOS 12+ (Printers, WiFi and BlueTooth come to mind).
- **Networking**:
	- When using Broadcom Wifi/BT Cards, you will need a different [set of kexts](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-7-broadcom-wifi-and-bluetooth) to load which need to be controlled via `MinKernel` and `MaxKernel` settings. On macOS 12.4 and newer, a new address check has been introduced in `bluetoothd`, which will trigger an error if two Bluetooth devices have the same address. This can be circumvented by adding boot-arg `-btlfxallowanyaddr` (provided by [BrcmPatchRAM](https://github.com/acidanthera/BrcmPatchRAM) kext).
	- Same applies to [Intel WiFi/BT](https://github.com/5T33Z0/OC-Little-Translated/tree/main/10_Kexts_Loading_Sequence_Examples#example-8-intel-wifi-and-bluetooth) cards using [OpenIntelWirless](https://github.com/OpenIntelWireless) kexts
- **Security**: Modifying the system with OCLP Requires SIP, Apple Secure Boot and AMFI to be disabled so there are some compromises in terms of security.
- **System Updates**: Incremental (or delta) System Updates won't be available after applying root patches with OCLP. Instead, the whole macOS Installer will be downloaded every time (approx. 12 GB)!
- **Other**: Check out the [list of things that were removed macOS Ventura](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) and the impact this has on pre-Kaby Lake systems. But keep in mind that this was written for real Macs so certain issues don't apply to Wintel systems.

## Preparations
I assume you already have a working OpenCore configuration for your Skylake system. Otherwise follow Dortania's OpenCore Install Guide ([Desktop](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html), [Laptop/NUC](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html), [HEDT](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html)) to create one. The instructions below only contain additional steps required to install and boot macOS Monterey and newer.

### Update OpenCore and kexts
Update OpenCore and kexts to the latest versions to maximize compatibility with macOS. To check which version of OpenCore you're currently using, run the following commands in Terminal:

```shell
nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:opencore-version
```

## Upgrade options
Since Skylake CPUs are relatively new, the only thing which doesn't really work out of the box is the Intel HD 530/P530/Iris iGPU which is only compatible up to macOS Monterey. So there are 2 possible upgrade option for installing macOS Ventura, depending on your hardware configuration:

### Option 1: Installing macOS Ventura without Root Patches
If you are using a PC and don't have to rely on the iGPU for driving a display and your GPU is compatible with macOS Ventura, the you only need to change the SMBIOS and add a Kaby Lake device-id to your iGPU framebuffer as explained here: [**Enabling Skylake Graphics in macOS 13**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/11_Graphics/iGPU/Skylake_Spoofing_macOS13).

Once you have the spoof configured, jump to [**macOS Ventura Installation**](#macos-ventura-installation)

#### Pros and Cons of this method
- **Pros**:
	- Requires much less effort
	- Incremental system updates will still work afterwards
- **Cons**:
	- iGPU is not working 100%
	- CPU Power Management is not optimal (can be addressed by implementing Board-ID VMM spoof and RestrictEvents kext)

### Option 2: Installing macOS Ventura with Root Patches
While an iGPU spoof works well for systems which use a dedicated GPU for displaying graphics, it's not working so well if the iGPU is required for driving a display becasue [these files were removed from macOS](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/docs/PATCHEXPLAIN.md#extensions-5). So if you are using a Desktop/Laptop/NUC that relies on the iGPU because it has no dGPU or it is incompatible with macOS 12 or newer (e.g. NVIDIA Kepler Cards) then applying Root Patches in Post-Install with OCLP is the way to go.

#### Pros and Cons of this method

- **Pros**:
	- iGPU is working correctly
	- Legacy GPU can be enabled (if OpenCore Legacy Patcher has drivers for it)
	- Ideal CPU/GPU Power Management because a Skylake SMBIOS can by used
- **Cons**:
	- Takes more effort
	- AMFI, SIP and SecureBootModel have to be disabled
	- Incremental System Updates won't work. Instead, the full installer (about 12 GB) is downloaded every time a System Update is available.

### Config Edits
Listed below, you find the required modifications to prepare your config and EFI folder for installing macOS Monterey or newer on Skylake systems. I've also prepared a [.plist](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/plist/Skylake_OCLP_Wintel_Patches.plist) for cross-referencing which contains the necessary settings.

:bulb: If your system (or components thereof) doen't work afterwards, please refer to OCLP's [patch documentation](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/docs/PATCHEXPLAIN.md) and see if need additional settings or kexts.

Config Section | Setting | Description
:-------------:| ------- | ------------
 **`Booter/Patch`**| Add and enable both Booter Patches from OpenCore Legacy Patcher's [**Board-ID VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof): <ul> <li> **"Skip Board ID check"** <li> **"Reroute HW_BID to OC_BID"** | Skips board-id checks in macOS &rarr; Allows booting macOS with unsupported, native SMBIOS best suited for your CPU.
**`DeviceProperties/Add`**|**PciRoot(0x0)/Pci(0x2,0x0)** – Verify/adjust Framebuffer patch. <ul><li> **Desktop** (Headless) <ul><li> **AAPL,ig-platform-id**: 01001219 </ul></ul><ul><li> **Desktop** (Default) <ul><li> **AAPL,ig-platform-id**: 00001219 </ul></ul><ul></ul></ul><ul><li> **Laptop/Intel NUC** (or other USDT): <ul><li> **AAPL,ig-platform-id**: &rarr; See [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/skylake.html#add-2)</ul> | **iGPU Support**: Intel HD 510/515/520/530/540/550/580 and P530. <ul> <li> **Headless**: For systems with an iMac SMBIOS, iGPU and a GPU which is used for graphics. The example in the OC Install Guide is actually wrong. <li> **Default**: Use this if you have a PC and the iGPU is used for driving a display. <li>**Laptops/NUCs**: Use the recommended Framebuffer for your device and iGPU listed in the OpenCore Install guide – but **DON'T spoof a Kaby Lake device-id**! 
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li>[**AMFIPass**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/sonoma-development/payloads/Kexts/Acidanthera) (`MinKernel`: `21.0.0`)<li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) <li> [**FeatureUnlock**](https://github.com/acidanthera/FeatureUnlock) (optional) </ul> </ul> **WiFi** (optional) <ul><li>[**IOSkywalk.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IOSkywalkFamily-v1.0.0.zip) (`MinKernel`: `23.0.0`) <li>[**IO80211FamilyLegacy.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/e21efa975c0cf228cb36e81a974bc6b4c27c7807/payloads/Kexts/Wifi/IO80211FamilyLegacy-v1.0.0.zip) (contains `AirPortBrcmNIC.kext`, ensure this is injected as well) (`MinKernel`: `23.0.0`) </ul> **Disable the following Kexts** (if present): <ul><li> **CPUFriend** <li> **CPUFriendDataProvider**| <ul> <li> **AMFIPass**: Beta kext from OCLP 0.6.7. Allows booting macOS 12+ without disabling AMFI.  <li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters. <li> **FeatureUnlock**: Unlocks AirPlay to Mac. <li> **WiFi Kexts**: For macOS Sonoma. Re-Enable modern WiFi: BCM94350, BCM94360, BCM43602, BCM94331 and BCM943224. Legacy WiFi: Atheros chipsets, Broadcom BCM94322, BCM94328.
**`Kernel/Block`**| Block `com.apple.iokit.IOSkywalkFamily`: <br> ![](https://user-images.githubusercontent.com/76865553/256150446-54079541-ee2e-4848-bb80-9ba062363210.png)| Blocks macOS'es IOSkywalk kext, so the injected one will be used instead. Only required for "Modern" [Wifi patching](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/WIiFi_Sonoma.md). 
**`Kernel/Patch`** | Add and enable the following Kernel Patches from [**OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist) (click on "Download RAW File"): <ul><li> **Reroute kern.hv_vmm_present patch (1)** <li> **Reroute kern.hv_vmm_present patch (2) Legacy** (enable for installing Monterey, but disable for installing Ventura/Sonoma!) <li> **Reroute kern.hv_vmm_present patch (2) Ventura** (enable for installing Ventura but disable for installing Monterey!) <li>**_IOGetVMMPresent** <li>**"Disable Library Validation Enforcement"**<li>**"Disable _csr_check() in _vnode_check_signature"** | <ul><li>The **"Reroute kern.hv"** and "**IOGetVMMPresent**" Kernel Patches are required, so upgrading from Big Sur to macOS Ventura is possible when using an unsupported SMBIOS. <li> **"Disable _csr_check() in _vnode_check_signature"** might not be necessary. Try for yourself.
**`Misc/Security`**| <ul> <li>**SecureBootMbodel**: `Disabled` <li> **Vault**: `Optional`| Required when patching in graphics drivers for AMD and NVIDIA cards. Intel HD graphics might work with SecureBootModel set to `Default`. Try for yourself.
**`NVRAM/Add/...-4BCCA8B30102`** | **Add the following Keys**: <ul> <li> **Key**: `OCLP-Settings`<br>**Type**: String <br> **Value**: `-allow_amfi`<li> **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm,asset`| <ul> <li> Settings for OCLP and RestrictEvents.  <li>`sbvmm,asset` &rarr; Enables OTA updates and content caching (&rarr; Check RestrictEvents documentation for details)|
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | **Add the following Strings**: <ul> <li>  `OCLP-Settings` <li> `revblock` <li> `revpatch` | Deletes NVRAM for these parameters before writing them. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.  
**`NVRAM/Add/...-FE41995C9F82`** | <li> **Change** **`csr-active-config`** to: **`03080000`** <br><br> **Add the following**`boot-args`: <ul><li> **`amfi_get_out_of_my_way=0x1`** or **`amfi=0x80`** (same)<li> **`ipc_control_port_options=0`** <li> **`-disable_sidecar_mac`** </ul>**Optional boot-args for GPUs** (Select based on GPU Vendor): <ul><li> **`-radvesa`** <li> **`nv_disable=1`** <li> **`ngfxcompat=1`**<li>**`ngfxgl=1`**<li> **`nvda_drv_vrl=1`** <li> **`agdpmod=vit9696`** | <ul> <li>**`amfi=0x80`**: Disables Apple Mobile File Integrity validation. Required for applying Root Patches with OCLP ~~and booting macOS 12+~~. :bulb: No longer needed for booting thanks to AMFIPass.kext – only for installing Root Patches with OCLP. Disabling AMFI causes issues with [3rd party apps' access to Mics and Cameras](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Webcams.md).<li> **`ipc_control_port_options=0`**: Required for Intel HD Graphics. Fixes issues with Firefox and electron-based apps like Discord. <li> **`-disable_sidecar_mac`**: For FeatureUnlock &rarr; Disables Sidecar/AirPlay/Universal Control patches. <li> **`-radvesa`** (AMD only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS 12+. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li> **`nv_disable=1`** (NVIDIA only): Disables hardware acceleration and puts the card in VESA mode. Only required if your screen turns off after installing macOS Ventura. Kepler Cards switch into VESA mode automatically without it. Once you've installed the GPU drivers with OCLP, **disable it** so graphics acceleration works! <li>**`ngfxcompat=1`** (NVIDIA only): Ignores compatibility check in `NVDAStartupWeb`. Not required for Kepler GPUs <li>**`ngfxgl=1`** (NVIDIA only): Disables Metal Spport so OpenGL is used for rendering instead. Not required for Kepler GPUs. <li> **`nvda_drv_vrl=1`** (NVIDIA only): Enables Web Drivers. Not required for Kepler GPUs. <li> **`agdpmod=vit9696`** &rarr; Disables board-id check. Useful if screen turns black after booting macOS which can happen after installing NVIDIA Webdrivers. <li> **`-wegnoigpu`** &rarr; Optional. Disables the iGPU in macOS. **ONLY** required when using an AMD GPU and an SMBIOS for a CPU without on-board graphics (i.e. `iMacPro1,1` or `MacPro7,1`) to let the GPU handle background rendering and other tasks. Requires Polaris or Vega cards to work properly (Navi is not supported by OCLP). Combine with `unfairgva=x` bitmask (x= 1 to 7) to [address DRM issues](https://github.com/5T33Z0/OC-Little-Translated/tree/main/H_Boot-args#unfairgva-overrides)
`UEFI/Drivers` and <br> `EFI/OC/Drivers`| <ul> <li> Add `ResetNvramEntry.efi` to `EFI/OC/Drivers` <li> And to your config:<br> ![resetnvram](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/8d955605-fb27-401f-abdd-2c616b233418) | Adds a boot menu entry to perform an NVRAM reset but without resetting the order of the boot drives. Requires a BIOS with UEFI support.

## Testing the changes
Once you've added the required kexts and made the necessary changes to your config.plist, save, reboot and perform an NVRAM Reset. If your system still boots fine after that, you can now prepare the system for installing macOS 13.

### Adjusting the SMBIOS
If your system reboots successfully, we need to edit the config one more time and adjust the SMBIOS depending on the macOS Version *currently* installed.

#### When Upgrading from macOS Big Sur 11.3+

When upgrading from macOS 11.3 or newer, we can use macOSes virtualization capabilities to trick it into thinking that it is running in a VM so spoofing a compatible SMBIOS is no longer a requirement.

Based on your system, use one of the following SMBIOSes for Skylake CPUs. Open your config.plist and change the SMBIOS in the `PlatformInfo/Generic` section.

- **For Desktops**: `iMac17,1`
- **For HEDT**: `iMacPro1,1`
- **For Laptops**:
	- `MacBookPro13,1` = 13″ Display, Core i5, iGPU: Iris 540
	- `MacBookPro13,2` = 13″ Display, Core i5, iGPU: Iris 550
	- `MacBookPro13,3` = 15″ Display, Core i7, iGPU: HD 530 + GPU: Radeon Pro 450/45
- **For NUC and USDTs**: `iMac17,1` (Apple never released a MacMini with Skylake CPUs)
- Generate new Serials using [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) or [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)

> **Note**: Once macOS 12 or newer is installed, you can disable the "Reroute kern.hv" and "IOGetVMMPresent" Kernel Patches. RestrictEvents will handle the VMM-Board-id spoof from now on. **Only Exception**: Before running the "Install macOS" App, you have to re-enable the kernel patches again. Otherwise the installer will say the system is incompatible because of the unsupported SMBIOS it detects.

#### When Upgrading from macOS Catalina or older
Since macOS Catalina and older lack the virtualization capabilities required to apply the VMM Board-ID spoof, switching to a supported SMBIOS temporarily is mandatory in order to be able to install macOS Ventura. Otherwise you will be greeted by the crossed-out circle instead of the Apple logo when trying to boot.

**Supported SMBIOSes**:

- **Desktop**:
	- **iMac18,1** or newer
	- **MacPro7,1** or **iMacPro1,1** (High End Desktops)
- **Laptop**:
	- **MacBookPro14,1** or
	- **MacBookAir8,1**
- **NUC**:
	- **Macmini8,1**
- Generate new Serials with [**GenSMBIOS**](https://github.com/corpnewt/GenSMBIOS) or [**OCAT**](https://github.com/ic005k/OCAuxiliaryTools/releases)

> **Note**: <li> Once macOS Ventura is up and running, you can switch to an SMBIOS best suited for your Haswell/Broadwell CPU for optimal CPU Power Management. <li> You can also disable the "Reroute kern.hv" and "IOGetVMMPresent" Kernel Patches. RestrictEvents will handle the VMM-Board-id spoof from now on. **Only Exception**: Before running the "Install macOS" App, you have to re-enable the kernel patches again. Otherwise the installer will say the system is incompatible because of the unsupported SMBIOS it detects.

## macOS Ventura Installation
With all the prep work out of the way you can now upgrade to macOS Ventura. Depending on the version of macOS you are coming from, the installation process differs.

### Getting macOS
- Download the latest release of [OpenCore Patcher GUI App](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and run it
- Click on "Create macOS Installer"
- Next, click on "Download macOS Installer"
- Select macOS 13.x (whatever the latest available build is)  
- Once the download is completed, the "Install macOS Ventura" app will be located in the "Programs" folder

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
- Once the macOS Ventura installation is finished, switch back to an SMBIOS best suited for your Skylake CPU.

After the installation is completed and the system boots it will run without hardware graphics acceleration if you only have an iGPU or if you GPU is no longer supported by macOS. We will address this in Post-Install.

## Post-Install
OpenCore Legacy patcher can re-install components which were removed from macOS, such as Graphics Drivers, Frameworks, etc. This is called "root patching". For Wintel systems, we will make use of it to install iGPU and GPU drivers primarily.

### Installing Intel Skylake Graphics Acceleration Patches (macOS 13)
Once you reach the set-up assistant (where you select your language, time zone, etc), you will notice that the system feels super sluggish – that's normal because it is running in VESA mode without graphics acceleration, since the friendly guys at Apple removed the Intel HD 2000/3000 drivers from macOS.

To bring them back, do the following:

- Run the OpenCore Patcher App
- In the OpenCore Legacy Patcher menu, select "Post Install Root Patch":</br>![Post_Root_Patches](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/15fe5dc1-793c-465c-9252-1ee6e503c680)
- Follow the instructions of the Patcher App (I don't have a Skylake CPU, so I can't capture screenshots. I also couldn't find any online.)

### Installing Drivers for other GPUs
- Works basically the same way as installing iGPU drivers
- OCLP detects the GPU and if it has drivers for it, they can be installed. Afterwards, GPU Hardware Acceleration should work. Note that additional settings in OCLP may be required based on the GPU you are using.
- After the drivers have been installed, disable the following `boot-args` prior to rebooting to re-enable GPU graphics acceleration:
  - `-radvesa` – put a `#` in front to disable it: `#-radvesa`
  - `nv_disable=1` – put a `#` in front to disable it: `#nv_disable=1`

> **Note**: Prior to installing macOS updates you probably have to re-enable boot-args for AMD and NVIDIA GPUs again to put them into VESA mode so you have a picture and not a black screen!

### Removing/Disabling boot-args
After macOS Ventura is installed and OCLP's root patches have been applied in Post-Install, remove or disable the following boot-args:

- `ipc_control_port_options=0`: ONLY when using a dedicated GPU. You still need it when using the Intel HD 4000 so Firefox and electron-based apps will work.
- `amfi_get_out_of_my_way=0x1`: ONLY needed for re-applying root patches with OCLP after System Updates
- Change `-radvesa` to `#-radvesa` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on AMD GPUs.
- Change `nv_disable=1` to `#nv_disable=1` &rarr; This disables the boot-arg which in return re-enables hardware acceleration on NVIDIA GPUs.

> **Note**: Keep a backup of your currently working EFI folder on a FAT32 USB flash drive just in case your system won't boot after removing/disabling these boot-args!

### Verifying AMFI is enabled
We can check whether or not AMFI is enabled by entering the following command in Terminal:

```shell
sudo /usr/sbin/nvram -p | /usr/bin/grep -c "amfi_get_out_of_my_way=1"
```

- The desired output is `0`: this means, the `amfi_get_out_of_my_way=1` boot-arg which disables AMFI is not present in NVRAM which indicates that AMFI is enabled. This is good.
- If the output is `1`: this means, the `amfi_get_out_of_my_way=1` boot-arg which disables AMFI is present in NVRAM which indicates that AMFI is disabled.

Since the new `AMFIPass.kext` allows booting macOS with applied root patches and SIP as well as SecureBootModel disabled but AMFI enabled, we want the output to be `0`!

## OCLP and System Updates
The major advantage of using OCLP over other Patchers is that it remains on the system even after installing System Updates. After an update, it detects that the graphics drivers are missing and asks you, if you want to to patch them in again, as shown in ths example:</br>![Notify](https://user-images.githubusercontent.com/76865553/181934588-82703d56-1ffc-471c-ba26-e3f59bb8dec6.png)

You just click on "Okay" and the drivers will be re-installed. After the obligatory reboot, everything will be back to normal.

## Notes
- Installing drivers on the system partition breaks its security seal. This affects System Updates: every time a System Update is available, the FULL Installer (about 12 GB) will be downloaded.
- After each System Update, the iGPU/GPU drivers have to be re-installed. OCLP will take care of this. Just make sure to re-enable the appropriate boot-args to put AMD/NVIDIA GPUs in VESA mode prior to updating/upgrading macOS.
- ⚠️ You cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)).

## Further Resources
- [**Non-Metal Wiki**](https://moraea.github.io/) by Moraea
- [**SMBIOS Compatibility Chart**](https://docs.google.com/spreadsheets/d/1DSxP1xmPTCv-fS1ihM6EDfTjIKIUypwW17Fss-o343U/edit#gid=483826077)
- [**Enabling NVIDIA WebDrivers in macOS 11+**](https://elitemacx86.com/threads/how-to-enable-nvidia-webdrivers-on-macos-big-sur-and-monterey.926/) by elitemacx86.com

## Credits
- Acidanthera for OpenCore, OCLP and numerous Kexts
- Corpnewt for MountEFI, GenSMBIOS and ProperTree
- dhinakg for AMFIPass
- Dortania for [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) and [Guide](https://dortania.github.io/OpenCore-Legacy-Patcher/)
- Rehabman for Laptop framebuffer patches

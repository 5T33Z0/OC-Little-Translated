# Enabling Skylake Graphics in macOS 13 or newer

![spoofkbl](https://user-images.githubusercontent.com/76865553/174740275-9bb63d0c-f8f1-4dde-ab52-a101334b9def.png)

**INDEX**

- [About](#about)
- [Option 1a: Kaby Lake iGPU spoof via `DeviceProperties`](#option-1a-kaby-lake-igpu-spoof-via-deviceproperties)
  - [Re-enabling Intel HD 520/530 (Desktop)](#re-enabling-intel-hd-520530-desktop)
    - [Verifying iGPU Acceleration](#verifying-igpu-acceleration)
  - [Re-enabling Intel HD 520/530 (Laptop)](#re-enabling-intel-hd-520530-laptop)
    - [Verifying iGPU Acceleration](#verifying-igpu-acceleration-1)
- [Option 1b: Kaby Lake iGPU spoof via SSDT](#option-1b-kaby-lake-igpu-spoof-via-ssdt)
  - [Re-enabling Intel HD 520/530 (Desktop)](#re-enabling-intel-hd-520530-desktop-1)
- [Option 2: Re-enable Skylake Graphics with OpenCore Legacy Patcher (macOS 13+)](#option-2-re-enable-skylake-graphics-with-opencore-legacy-patcher-macos-13)
- [Optional Refinement: Implement Board-ID VMM Spoof](#optional-refinement-implement-board-id-vmm-spoof)
  - [Config Adjustments](#config-adjustments)
- [NOTES and CREDITS](#notes-and-credits)

---

## About

With the release of macOS 13 beta, support for 4th to 6th Gen CPUs was [dropped](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) – on-board graphics included. In order to enable integrated graphics on Skylake CPUs, you need to either spoof Kaby Lake Framebuffers (Option 1) or use OpenCore Legacy Patcher to re-enable Skylake graphics (Option 2).

> [!TIP]
>
> There might be a third option which needs to be investigated further: using the [**OSIEnhancer**](https://github.com/b00t0x/OSIEnhancer) kext in combination with a custom SSDT that allows switching AAPL,ig-platform-id and device-ids based on the used Darwin Kernel.

## Option 1a: Kaby Lake iGPU spoof via `DeviceProperties`

### Re-enabling Intel HD 520/530 (Desktop)

Do the following to enabled Intel HD 520/530 or P530 on-board graphics in macOS 13 on desktop systems: 

- Update [**Lilu**](https://dortania.github.io/builds/?product=Lilu&viewall=true)
- Update [**Whatevergreen**](https://dortania.github.io/builds/?product=WhateverGreen&viewall=true)
- Change the SMBIOS to `iMac18,1`
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)` if it doesn't exist already.
- Add/modify `DeviceProperties` for HD 530 (HD 520 and Laptops might need different values. Refer to the [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) for details):
  |Key Name                |Value     | Type | Notes
  -------------------------|----------|:----:| :-----:
  AAPL,ig-platform-id      | 00001259 | Data | For Intel HD 520/530
  device-id                | 12590000 | Data | "
  ||
  AAPL,ig-platform-id      | 00001B59 | Data | For [Intel P530](https://www.insanelymac.com/forum/topic/354495-solved-intel%C2%AE-hd-p530-no-graphics-acceleration-on-ventura/?do=findComment&comment=2796368)
  device-id                | 26590000 | Data | "
  ||
  AAPL,GfxYTile            | 01000000 | Data | Optional. If your having glitches.
- Optional: add boot-arg `-igfxsklaskbl` (when using macOS 12)
- Save and reboot

> [!NOTE]
>
> The used example is from an i7 6700K

#### Verifying iGPU Acceleration

Run either [**VDADecoderChecker**](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc to verify that iGPU acceleration is workinf. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

### Re-enabling Intel HD 520/530 (Laptop)

Do the following to enabled Intel HD 520/530 or P530 on-board graphics in macOS 13 on desktop systems: 

- Update [**Lilu**](https://dortania.github.io/builds/?product=Lilu&viewall=true)
- Update [**Whatevergreen**](https://dortania.github.io/builds/?product=WhateverGreen&viewall=true)
- Change the SMBIOS to `iMac18,1`
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)` if it doesn't exist already.
- Add/modify `DeviceProperties` for HD 530 (HD 520 and Laptops might need different values. Refer to the [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) for details):
  |Key Name                |Value     | Type | Notes
  -------------------------|----------|:----:| :-----:
  AAPL,ig-platform-id      | 00001B59 | Data | For Intel HD 520/530
  device-id                | 12590000 | Data | "
  ||
  AAPL,ig-platform-id      | 00001B59 | Data | For [Intel P530](https://www.insanelymac.com/forum/topic/354495-solved-intel%C2%AE-hd-p530-no-graphics-acceleration-on-ventura/?do=findComment&comment=2796368)
  device-id                | 26590000 | Data | "
  ||
  AAPL,GfxYTile            | 01000000 | Data | Optional. If your having glitches.
- Optional: add boot-arg `-igfxsklaskbl` (when using macOS 12)
- Save and reboot

#### Verifying iGPU Acceleration

Run either [**VDADecoderChecker**](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc to verify that iGPU acceleration is workinf. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

> [!NOTE]
>
> If this spoof does not work on your Laptop out of the box, try other combinations of mobile Kaby Lake ig-platform and device-ids listed in the [IntelHD FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-uhd-graphics-610-650-kaby-lake-and-amber-lake-y-processors). If this still won't work try the OCLP method instead.

## Option 1b: Kaby Lake iGPU spoof via SSDT

This option allows spoofing the Kaby Lake framebuffer patch by injecting the `AAPL,ig-platform-id` and `device-id` into macOS 13 and newer via an SSDT and a new kext called [**OSIEnhancer**](https://github.com/b00t0x/OSIEnhancer). The kext allows using modified versions of the "If (_OSI ("Darwin"))" method to inject properties based of the macOS or Kernel version, e.g. "If (_OSI ("Ventura"))" or "If (_OSI ("Darwin 22")) for macOS Ventura.

This way, you can leave your DeviceProperties as is for older versions of macOS but apply

### Re-enabling Intel HD 520/530 (Desktop)

- Download [**`OSIEnhancer.kext`**](https://github.com/b00t0x/OSIEnhancer/releases)
- Add it to `EFI/OC/Kexts` and your `config.plist` 
- Download [**`SSDT-Darwin.dsl`**](/SSD/SSDT-Darwin.aml)
- Download [**`SSDT-GFX0.dsl`**](/SSD/SSDT-GFX0.aml)
- Add them to `EFI/OC/ACPI` and your `config.plist`
- If present, revert framebuffer patch to the [default](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html#add-2) for Skylake systems. 
- Save your `config.plist` and rebbot into macOS 13 or newer. 

The SSDT should inject the required iGPU properties into macOS Ventura and newer, so that the Kaby Lake spoof will work. If it doesn't work, add the ACPI patch from [this `.plist`](/11_Graphics/iGPU/Skylake_Spoofing_macOS13/_DSM_Rename.plist) to your config. It renames the `_DSM` method of your iGPU to `XDSM`, so that the `_DSM` method injected by `SSDT-GFX0` takes precedence. Don't modify the PCI device path listed under `base`, since Whatevergreen corrects the path of the iGPU device in your `DSDT`, which matches the one in the .plist! 

> [!IMPORTANT]
>
> Please store a backup of your current EFI folder on a FAT32 formatted USB flash drive before applying this spoof, so you can boot from it in case something goes wrong. Because I cannot test this spoof since I don't have a Skylake system.

## Option 2: Re-enable Skylake Graphics with OpenCore Legacy Patcher (macOS 13+)

Instead of spoofing a Kaby Lake Framebuffer, you could utilize OpenCore Legacy Patcher to re-install files to enable Skylake graphics in macOS Ventura and newer.

Follow my [**Skylake configuration guide**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Skylake.md) to… 

- Prepare your config and EFI to install and run macOS Ventura or newer
- Apply Post-Install Root Patches with OpenCore Legacy Patcher. This will install the following files on the system volume:
  ```
  AppleIntelSKLGraphics.kext
  AppleIntelSKLGraphicsFramebuffer.kext
  AppleIntelSKLGraphicsGLDriver.bundle
  AppleIntelSKLGraphicsMTLDriver.bundle
  AppleIntelSKLGraphicsVADriver.bundle
  AppleIntelSKLGraphicsVAME.bundle
  AppleIntelGraphicsShared.bundle
  ```

This way, you won't have to spoof a different iGPU and your Intel HD520/530 will work as expected. The downside is that every time a system update is available, the whole Installer will be downloader (13 GB+), since root patching breaks the security seal of the system volume.

## Optional Refinement: Implement Board-ID VMM Spoof

Apply the config changes liste below after upgrading to macOS 13 or newer in order to boot with a native SMBIOS for Skylake CPUs for optimal CPU/GPU Power Management while retaining the ability to install macOS System Updates.

### Config Adjustments

Config Section | Setting | Description
---------------| ------- | ---------
 **`Booter/Patch`**| Add and enable the [**"Skip Board ID check"**](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/payloads/Config/config.plist#L220-L243) from OCLP's config| Skips board-id check in macOS &rarr; Allows booting macOS with unsupported, native SMBIOS best suited for your CPU.
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) </ul> **Disable the following Kexts** (if present): <ul><li> **CPUFriend** <li> **CPUFriendDataProvider**| <ul><li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters.
**`NVRAM/Add/...-4BCCA8B30102`** | **Add the following Key**: <ul> **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm`| <ul> <li> `sbvmm`  &rarr; Setting for RestrictEvents.kext. Allows OTA updates when using an unsupporred SMBIOS/board-id|
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | **Add the following String**: <ul> <li> `revpatch` | Deletes NVRAM before writing the parameter. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.
**`PlatormInfo/Generic`**| **Change SMBIOS** <ul> <li>**Desktop**: iMac17,1 <li> **Laptop**: <ul><li> MacBook9,1 (Intel Core m) <li> MacBookPro13,1 (Intel Core i5) <li> MacBookPro13,2 (Intel Core i5) <li> MacBookPro13,3 (Intel Core i7)</ul><li>**NUC**: iMac17,1 <li> **HEDT**: iMacPro1,1 | Once macOS Ventura is installed and running, you can revert to a "native" SMBIOS for Skylake CPUs for optimal CPU/GPU Power Management. But if you want/need to modify the frequency vectors of your CPU, you can generate a new DataProvider kext for CPUFriend with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend). Note that Apple never released a MacPro and MacMini model with Skylake CPUs.

## NOTES and CREDITS
- Thanks to b00t0x for [**OSIEnhancer**](https://github.com/b00t0x/OSIEnhancer/releases) and SSDT Samples 
- [**Board-id VMM spoof explained**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
- When spoofing the iGPU in macOS Ventura, you might experience glitches and issues related to HEVC encoding/decoding.
- The previously used `SKLAsKBLGraphicsInfo.kext` is no longer required
- PMheart for the Patch 
- Acidanthera for OpenCore, Lilu and Whatevergreen
- Cyberdevs for the [**desktop settings**](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2785675)

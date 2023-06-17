# Enabling Skylake Graphics in macOS 13
![spoofkbl](https://user-images.githubusercontent.com/76865553/174740275-9bb63d0c-f8f1-4dde-ab52-a101334b9def.png)

With the release of macOS 13 beta, support for 4th to 6th Gen CPUs was [dropped](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) – on-board graphics included. In order to enable integrated graphics on Skylake CPUs, you need to spoof Kaby Lake Framebuffers. The example below is from an i7 6700K.

Do the following to enabled Intel HD 520/530 on-board graphics in macOS 13 (Desktop): 

- [**Download**](https://dortania.github.io/builds/?product=Lilu&viewall=true) the latest version of Lilu from Dortania's Build Repo.
- [**Download**](https://dortania.github.io/builds/?product=WhateverGreen&viewall=true) the latest version of Whatevergreen as well.
- Add the kexts to your `EFI/OC/Kexts` folder and config.plist.
- Change the SMBIOS to `iMac18,1`
- Under `DeviceProperties/Add`, create the Dictionary `PciRoot(0x0)/Pci(0x2,0x0)` if it doesn't exist already.
- Add/modify `DeviceProperties` for HD 530 (HD 520 and Laptops might need different values. Refer to the [**Intel HD Graphics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) for details):
	|Key Name                |Value     | Type | Notes
	-------------------------|----------|:----:| :-----:
	AAPL,ig-platform-id      | 00001259 | Data | For Intel HD 520/530
	device-id                | 12590000 | Data | "
	AAPL,ig-platform-id      | 00001B59 | Data | For [Intel P530](https://www.insanelymac.com/forum/topic/354495-solved-intel%C2%AE-hd-p530-no-graphics-acceleration-on-ventura/?do=findComment&comment=2796368)
	device-id                | 26590000 | Data | "
	AAPL,GfxYTile            | 01000000 | Data | Optional. If your having glitches.
- Optional: add boot-arg `-igfxsklaskbl` (when using macOS 12)
- Save and reboot

## Verifying
Run either [VDADecoderChecker](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

## Optional: Implement Board-ID VMM Spoof
Apply the config changes below after upgrading to macOS 13 in order to boot with a native SMBIOS for Skylake CPUs for optimal CPU/GPU Power Management while retaining the ability to install macOS System Updates. 

Config Section | Setting | Description
---------------| ------- | ---------
 **`Booter/Patch`**| Add and enable both Booter Patches from OpenCore Legacy Patcher's [**Board-ID VMM spoof**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof): <ul> <li> **"Skip Board ID check"** <li> **"Reroute HW_BID to OC_BID"** | Skips board-id checks in macOS &rarr; Allows booting macOS with unsupported, native SMBIOS best suited for your CPU.
**`Kernel/Add`** and <br>**`EFI/OC/Kexts`** |**Add the following Kexts**:<ul><li> [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) (`MinKernel`: `20.4.0`) </ul> **Disable the following Kexts** (if present): <ul><li> **CPUFriend** <li> **CPUFriendDataProvider**| <ul><li> **RestrictEvents**: Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer. Requires additional NVRAM parameters.
**`NVRAM/Add/...-4BCCA8B30102`** | **Add the following Key**: <ul> **Key**: `revpatch` <br> **Type:** String <br> **Value**: `sbvmm`| <ul> <li> `sbvmm`  &rarr; Setting for RestrictEvents.kext. Allows OTA updates when using an unsupporred SMBIOS/board-id|
**`NVRAM/Delete/...-4BCCA8B30102`** (Array) | **Add the following String**: <ul> <li> `revpatch` | Deletes NVRAM before writing the parameter. Otherwise you would need to perform an NVRAM reset every time you change any of them in the corresponding `Add` section.
**`PlatormInfo/Generic`**| **Change SMBIOS** <ul> <li>**Desktop**: iMac17,1 <li>**Laptop**: <ul><li> MacBook9,1 (Intel Core m) <li> MacBookPro13,1 (Intel Core i5) <li> MacBookPro13,2 (Intel Core i5) <li> MacBookPro13,3 (Intel Core i7)</ul><li>**NUC**: iMac17,1 <li> **HEDT**: iMacPro1,1 | Once macOS Ventura is installed and running, you can revert to a "native" SMBIOS for Skylake CPUs for optimal CPU/GPU Power Management. But if you want/need to modify the frequency vectors of your CPU, you can generate a new DataProvider kext for CPUFriend with [CPUFriendFriend](https://github.com/corpnewt/CPUFriendFriend). Note that Apple never released a MacPro and MacMini model with Skylake CPUs.

## NOTES and CREDITS
- [**Board-id VMM spoof explained**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
- When spoofing the iGPU in macOS Ventura, you might experience glitches and issues related to HEVC encoding/decoding.
- The previously used `SKLAsKBLGraphicsInfo.kext` is no longer required
- PMheart for the Patch 
- Acidanthera for OpenCore, Lilu and Whatevergreen
- Cyberdevs for the [**settings**](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2785675)

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
	|Key Name                |Value     | Type. | Notes
	-------------------------|----------|:----:| -----
	AAPL,ig-platform-id      | 00001259 | Data | 
	device-id                | 12590000 | Data |
	AAPL,GfxYTile            | 01000000 | Data | Optional. If your having glitches.
- Optional: add boot-arg `-igfxsklaskbl` (when using macOS 12 or older)
- Save and reboot

## Verifying
Run either [VDADecoderChecker](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

## NOTES and CREDITS
- When spoofing the iGPU in macOS Ventura this way, there are still issues related to HEVC encoding/decoding. Aben is working on a [test build of WEG](https://github.com/abenraj/WhateverGreen/tree/SKL-HEVC-test) which tries to address this issue.
- The previously used, additional `SKLAsKBLGraphicsInfo.kext` is no longer required
- PMheart for the Patch 
- Acidanthera for OpenCore, Lilu and Whatevergreen
- Cyberdevs for the [settings](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2785675)

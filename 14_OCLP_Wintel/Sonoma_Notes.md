# macOS Sonoma Notes

This section covers the current status of OpenCore Legacy Patcher development for macOS Sonoma.

## (Officially) Supported SMBIOS (Intel Models)

![Somona_SMBIOS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/9ebc9596-5f1a-4a63-9758-a89018501372)

- **iMac**: iMac19,x, iMac20,x, iMacPro1,1
- **MacPro**: MacPro7,1
- **MacBookAir**: MacBookAir9,1
- **MacBookPro**: MacBookPro15,x, MacBookPro16,x
- **Mac mini**: Macmini8,1

## OCLP Update Status
- **May 30th, 2024**: [**OCLP v1.50**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.5.0) released
	- OCLP now has a .pkg installer which is the new recommended method for installing OpenCore Legacy Patcher (on real Macs)
	- New Privileged Helper Tool which removes requirement of password prompts for installing patches, creating installers, etc.
- **February 12th, 2024**: Updated [**IOSkywalkFamily.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Wifi) for legacy WIFI. Required for macOS 14.4 beta.
- **November 6th, 2023**: **OCLP 1.3.0 beta**. Fixes Intel HD 4000 and Kepler GPU Windowserver crashes in macOS 14.2 beta 3
- **November 6th, 2023**: **OCLP v1.2.0** is released and includes a long list of [changes](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/1.2.0)
- **October 23rd, 2023**: [**OCLP v1.1.0**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) was released. Includes updated kexts, binaries for Non-Metal GPUs for macOS Sonoma and other improvements (&rarr; see changelog for details)
- **October 2nd, 2023**: [**OCLP v1.0.0:**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases) was released. It enables running macOS Sonoma on 83 previously unsupported Mac models. With it, they also switched the numbering of releases from a simple "counter" to Semantic Versioning.
- **OCLP 069**: [Nightly build](https://github.com/dortania/OpenCore-Legacy-Patcher/pull/1077#issuecomment-1646934494) 
	- Introduces kexts and root patching options to re-enable previously working Wifi Cards
- [**OCLP 068**](https://github.com/dortania/OpenCore-Legacy-Patcher/releases/tag/0.6.8): 
	- Fixes graphics acceleration patches in Sonoma
	- Introduces AMFIPass.kext which allows AMFI to work with lowered/disabled SIP settings, resolving issues with [granting 3rd party app access to peripherals](https://github.com/5T33Z0/OC-Little-Translated/blob/main/13_Peripherals/Fixing_Peripherals.md) like webcams and micreophones
- **OCLP 067**: currently not working (which was expected)

## Create USB Installer
```text
sudo /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume
```

## Removed Kexts and Drivers
- `IO80211FamilyLegacy.kext` has been removed &rarr; renders ALL Broadcom WiFi/BT cards useless (for now?)
- Kaby Lake iGPU drivers are still present in beta 1
- Dreamwhite had some interesintg findings in regards to the dropped  `IO80211FamilyLegacy.kext`: https://www.insanelymac.com/forum/topic/356881-pre-release-macos-sonoma/?do=findComment&comment=2805853

## Beta boot-args
For kext that haven't been updated for macOS 14 support:

- ~~**`-wegbeta`** &rarr; so Whatevergreen works~~ &rarr; no longer required
- ~~**`-revbeta`** &rarr; so RestrichEvents works~~ &rarr; no longer required
- **`-brcmfxbeta`** &rarr; for AirportBrcmFixup. Try, If you cannot connect to Hotspots after applying Root Patches for re-enabling broadcom Wi-Fi cards

> [!NOTE]
> 
> Always check for the latest nightly builds of OpenCore and kexts on Dortania's ["Builds"](https://dortania.github.io/builds/) site before upgrading macOS! 

## Other
- How to delete Sonoma's new Live Wallpapers: [https://youtu.be/EmAxYGLkM1w](https://youtu.be/EmAxYGLkM1w)
- [Discussing OCLP and Security Concerns](https://forums.macrumors.com/threads/security-for-oclp-opencore-legacy-patcher.2406586/page-2?post=32613005#post-32613005)

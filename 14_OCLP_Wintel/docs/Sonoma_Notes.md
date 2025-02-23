# macOS Sonoma Notes

This section covers the current status of OCLP for macOS Sonoma.

## (Officially) Supported SMBIOS (Intel Models)

![Somona_SMBIOS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/9ebc9596-5f1a-4a63-9758-a89018501372)

- **iMac**: iMac19,x, iMac20,x, iMacPro1,1
- **MacPro**: MacPro7,1
- **MacBookAir**: MacBookAir9,1
- **MacBookPro**: MacBookPro15,x, MacBookPro16,x
- **Mac mini**: Macmini8,1

## Create USB Installer

```bashx
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

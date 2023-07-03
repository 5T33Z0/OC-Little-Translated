# macOS Sonoma Notes

## Supported SMBIOS (Intel)
- **iMac**: iMac19,x, iMac20,x, iMacPro1,1
- **MacPro**: MacPro7,1
- **MacBookAir**: MacBookAir9,1
- **MacBookPro**: MacBookPro15,x, MacBookPro16,x
- **Mac mini**: Macmini8,1

<details>
<summary><b>Source</b></summary>

![Somona_SMBIOS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/9ebc9596-5f1a-4a63-9758-a89018501372)

</details>

## Create USB Installer

```text
sudo /Applications/Install\ macOS\ 14\ beta.app/Contents/Resources/createinstallmedia --volume /Volumes/yourdiskname
```

## Kexts and Drivers

- `IO80211FamilyLegacy.kext` has been removed &rarr; renders ALL Broadcom WiFi/BT cards useless (for now?)
- Kaby Lake iGPU drivers are still present in beta 1
- Dreamwhite had some interesintg findings in regards to the dropped  `IO80211FamilyLegacy.kext`: https://www.insanelymac.com/forum/topic/356881-pre-release-macos-sonoma/?do=findComment&comment=2805853

## Beta boot-args
For kext that haven't been updated for macOS 14 support:

~~**`-wegbeta`** &rarr; so Whatevergreen works~~ &rarr; no longer required <br> 
~~**`-revbeta`** &rarr; so RestrichEvents works~~ &rarr; no longer required

**NOTE**: Always look for the latest nightly builds of OpenCore and kexts on Dortania's ["Builds"](https://dortania.github.io/builds/) site before upgrading macOS! 

## OCLP Status
- **OCLP 067**: currently not working (which was expected)

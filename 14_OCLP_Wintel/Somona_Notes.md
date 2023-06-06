# macOS Somona Notes

## Supportes SMBIOS
- **iMac**: iMac19,x, iMac20,x
- **iMacPro1,1**
- **MacBookAir**: MacBookAir9,1
- **MacBookPro**: MacBookPro15,x, MacBookPro16,x
- **MacPro**: MacPro7,1
- **Mac mini**: Macmini8,1

<details>
<summary><b>Source</b></summary>

![Somona_SMBIOS](https://github.com/5T33Z0/OC-Little-Translated/assets/76865553/9ebc9596-5f1a-4a63-9758-a89018501372)

</details>

## Kexts and Drivers

- `IO80211FamilyLegacy.kext` has been removed &rarr; renders ALL Broadcom WiFi/BT cards useless (for now?)
- Kaby Lake drivers are still present in beta 1

## Create USB Installer: 

```text
sudo /Applications/Install\ macOS\ 14\ beta.app/Contents/Resources/createinstallmedia --volume /Volumes/yourdiskname
```

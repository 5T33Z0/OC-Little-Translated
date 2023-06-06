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

![](/Users/5t33z0/Desktop/Somona_SMBIOS.jpg)

</details>

## Kexts and Drivers

- `IO80211FamilyLegacy.kext` has been removed &rarr; renders ALL Broadcom WiFi/BT cards useless (for now?)
- Kaby Lake drivers are still present in beta 1

## Create USB Installer: 

```text
sudo /Applications/Install\ macOS\ 14\ beta.app/Contents/Resources/createinstallmedia --volume /Volumes/yourdiskname
```

# Intel I225-V Ethernet Controller Fix

## About
The stock firmware of the Intel I225-V Ethernet Controller used on some Gigabyte Z490 Boards contains incorrect Subsystem-ID and Subsystem Vendor-ID infos. The Vendor-ID (`8086`, for Intel) is also used as Subsystem-Vendor-ID (instead of `1458`) and the Subsystem-ID only contains zeros instead of the correct value (`E000`). This results in Internet not working on macOS Monterey and newer since it cannot connect to the necessary driver. Apply this fix to re-enable Internet in macOS Monterey and newer.

## Option 1: Add `AppleIGC.kext` 
Earlier 2023. a new kext called [**AppleIGC**](https://github.com/SongXiaoXi/AppleIGC) for I225/I226 cards was released. It's an "Intel 2.5G Ethernet driver for macOS. Based on the Intel igc implementation in Linux". It works on both stock and custom firmware, rendering all previously used fixes obsolete. It's highly recommended to revert old fixes and use this kext instead.

### Instructions: 

- **Revert previous Fixes**:
	- Disable/Delete `SSDT-I225-V.aml`(if present) 
	- Disable/Delete `FakePCIID.kext` (if present)
	- Disable/Delete `FakePCIID_Intel_I225-V.kext` (if present)
	- Disable/Delete `AppleIntelI210Ethernet.kext` (if preent)
	- Disable Kernel/Patch `__Z18e1000_set_mac_typeP8e1000_hw` (if present)

- **Add `AppleIGC.kext`**
	- Add `AppleIGC.kext` to `EFI/OC/Kexts` and config.plist.
	- Optional: add `e1000=0` to `boot-args` (macOS Monterey+). For Big Sur, use `dk.e1000=0`. I don't need it on my system.
	- In `Kernel/Quirks`, turn on `DisableIoMapper` (might work without it. I need it on my I225-V with custom firmware).
	- Save your config and reboot
	- Run **IORegistryExplorer** and verify that the kext is servicing the Intel I225-V: <br> ![](https://user-images.githubusercontent.com/88431749/259463074-b1d3801b-c46d-4250-ac8b-8f5c666698fe.png)

<details>
<summary><strong>Option 2</strong> (Click to reveal!)</summary>

## Option 2: Adding SSDT-I225-V (obsolete)
Use the attached SSDT to inject the correct header descriptions for the Intel I225-V into macOS Monterey and newer. 

For macOS 13, you also need to inject AppleIntel210Ethernet.kext, since it has been removed from the IONetworkingFamily.kext and you can't use the .dext version unless you flash a modded firmware.

:warning: Before adding this SSDT, verify the ACPI path of the I225-V is matching the one used in your `DSDT` and adjust it accordingly! You can use Hackintool and IO RegistryExplorer to find the correct ACPI path.

> **Note**: Location of AppleIntelI210Ethernet.kext in previous versions of macOS: `System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/`

### Instructions

- Disable/Delete `FakePCIID.kext` (if present)
- Disable/Delete `FakePCIID_Intel_I225-V.kext` (if present)
- [**Download**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V)/SSDT-I225V.aml?raw=true) `SSDT-I225V.aml`
- Add it to `EFI/OC/ACPI` and config.plist 
- **macOS 13 only**: 
	- Add [**this kext**](https://github.com/5T33Z0/OC-Little-Translated/raw/main/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V)/AII210E.zip) 
	- Set `MinKernel` to `22.0.0` so it's only injected into macOS Ventura!
- Add boot-arg `dk.e1000=0` (macOS 11) and/or `e1000=0` (macOS 12+)
- Apply the correct **Settings** from the table below.
- Save the config and reboot.

## Settings
Listed below are the required BIOS and config Settings for various versions of macOS.

macOS |Vt-D|DisableIoMapper|DMAR (OEM)|DMAR (dropped/replaced)[^1]| I225-V / 3rd Party working|
:-----|:------:|:----------:|:--------:|:-----------------:|:--------------------------:
12.5+ (with SSDT)| ON |**OFF**| **YES** | **NO / NO**| **YES / YES**
12.5+ (stock fw) | ON | OFF | YES| NO / NO | **NO / YES**
11.4 to 11.6.7 | ON | ON [^2]| NO | YES / YES | [**YES / YES**](https://github.com/5T33Z0/Gigabyte-Z490-Vision-G-Hackintosh-OpenCore/issues/19#issuecomment-1153315826)
10.15 to 11.3 [^3]| OFF/ON |OFF/ON | YES | NO / NO | **YES / NO**

[^1]: Check my guide for [dropping ACPI tables](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI/ACPI_Dropping_Tables#readme) for details
[^2]: Combining `Vt-D` and `DisableIOMapper` makes no sense to me in regards to enabling the I225-V in macOS but that's what the user reported as working.
[^3]: Enabling the I225-V in macOS Catalina requires modified `DeviceProperties` as well as a Kernel Patch since it's not supported natively. With this, the I225-V will be spoofed as Intel I219 and work. Copy the settings from the attached "I225_Catalina.plist" into your Config. Disable the spoof for macOS 11.4 and newer!

> **Note**: OpenCore 0.9.2 introduced a new Quirk called `DisableIoMapperMapping`. It works independently of `DisableIoMapper` and addresses reoccurring connectivity issues in macOS 13.3+ which weren't there before. If your configuration required to drop/replace the DMAR table before it still does now!

## Troubleshooting

If you are facing issues afterwards, you could try attaching the I225-V to the `AppleIntelI210Ethernet.kext` by using boot boot-arg `dk.e1000=0` (Big Sur) or `e1000=0` (macOS Monterey/Ventura).

If you can't access the Internet after flashing the custom firmware, remove the following preferences via Terminal and reboot and reset kext cache:

- `sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist`
- `sudo rm /Library/Preferences/SystemConfiguration/preferences.plist`
- `sudo kextcache -i /`

After a few seconds, the connection should work. If you still can't access the Internet, delete the following preferences followed by a reboot:

- `/Library/Preferences/com.apple.networkextension.necp.plist`
- `/Library/Preferences/com.apple.networkextension.plist`
- `/Library/Preferences/com.apple.networkextension.uuidcache.plist`

</details>


## Credits
- [**MacAbe**](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786836) for SSDT-I225-V.aml

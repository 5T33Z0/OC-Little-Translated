# Intel I225-V Ethernet Controller Fix

- [About](#about)
- [Method 1: Add `AppleIGC.kext`](#method-1-add-appleigckext)
	- [Instructions](#instructions)
	- [Troubleshooting](#troubleshooting)
- [Method 2: Adding `SSDT-I225-V` (obsolete)](#method-2-adding-ssdt-i225-v-obsolete)
	- [Instructions](#instructions-1)
- [Settings](#settings)
- [Troubleshooting](#troubleshooting-1)
- [Credits](#credits)

---

## About
The stock firmware of the Intel I225-V Ethernet Controller used on some Gigabyte Z490 Boards contains incorrect Subsystem-ID and Subsystem Vendor-ID infos. The Vendor-ID (`8086`, for Intel) is also used as Subsystem-Vendor-ID (instead of `1458`) and the Subsystem-ID only contains zeros instead of the correct value (`E000`). This results in Internet not working on macOS Monterey and newer since it cannot connect to the necessary driver. Apply this fix to re-enable Internet in macOS Monterey and newer.

## Method 1: Add `AppleIGC.kext` 
Earlier in 2023 a new kext called [**AppleIGC**](https://github.com/SongXiaoXi/AppleIGC) for I225/I226 cards was released. It's an "Intel 2.5G Ethernet driver for macOS. Based on the Intel igc implementation in Linux". It works on both stock and custom firmware, rendering all previously used fixes obsolete. It's highly recommended to revert old fixes and use this kext instead.

### Instructions
- **Revert previous Fixes**:
	- Disable/Delete `SSDT-I225-V.aml`(if present) 
	- Disable/Delete `FakePCIID.kext` (if present)
	- Disable/Delete `FakePCIID_Intel_I225-V.kext` (if present)
	- Disable/Delete `AppleIntelI210Ethernet.kext` (if present)
	- Disable Kernel/Patch `__Z18e1000_set_mac_typeP8e1000_hw` (if present)
- Add `AppleIGC.kext` to `EFI/OC/Kexts` and config.plist.
- Save your config and reboot
- Run **IORegistryExplorer** and verify that the kext is servicing the Intel I225-V: <br> ![](https://user-images.githubusercontent.com/88431749/259463074-b1d3801b-c46d-4250-ac8b-8f5c666698fe.png)

### Troubleshooting
If Ethernet is not working afterwards, adjust the following settings. Use _either_ Option 1 or 2  based on whether or not you need Vt-d.

- **Option 1**: If you don't need Vt-d:
	- Disable Vt-D in BIOS or enable `Kernel/Quirks/DisableIoMapper` if you don't need AppleVTD (some Network/Wifi/BT cards require it to work properly)
	- Save your config and reboot
	- Run **IORegistryExplorer** and verify that the kext is servicing the Intel I225-V: <br> ![](https://user-images.githubusercontent.com/88431749/259463074-b1d3801b-c46d-4250-ac8b-8f5c666698fe.png)
- **Option 2**: If you have Vt-d enabled in BIOS and your system has a `DMAR` table with Reserved Memory regions:
	- Drop the original `DMAR` table ([Guide](/Content/00_ACPI/ACPI_Dropping_Tables#example-1-dropping-the-dmar-table))
	- Replace it by a modified `DMAR` without Reserved Memory Regions ([Guide](/Content/00_ACPI/ACPI_Dropping_Tables#example-2-replacing-the-dmar-table-by-a-modified-one))
	- Deselect `DisableIoMapper` (if enabled)
	- Enable `DisableIoMapperMapping` (macOS 13.3 and newer only)
	- Save your config and reboot
	- Run **IORegistryExplorer** and verify that the kext is servicing the Intel I225-V: <br> ![](https://user-images.githubusercontent.com/88431749/259463074-b1d3801b-c46d-4250-ac8b-8f5c666698fe.png)

If the LAN controller still does not work afterwards, try Method 2.

<details>
<summary><strong>Method 2</strong> (Click to reveal!)</summary>

## Method 2: Adding `SSDT-I225-V` (obsolete)
Use the attached SSDT to inject the correct header descriptions for the Intel I225-V into macOS Monterey and newer. 

For macOS 13 and newer, you also need to inject `AppleIntel210Ethernet.kext` if your ethernet controller cannot utilize the newer .dext version of this driver unless you flash a modded firmware, since the .kext has been removed from the IONetworkingFamily.kext.

:warning: Before adding this SSDT, verify the ACPI path of the I225-V is matching the one used in your `DSDT` and adjust it accordingly! You can use Hackintool and IO RegistryExplorer to find the correct ACPI path.

> **Note**: Location of AppleIntelI210Ethernet.kext in previous versions of macOS: `System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/`

### Instructions

- Disable/Delete `FakePCIID.kext` (if present)
- Disable/Delete `FakePCIID_Intel_I225-V.kext` (if present)
- [**Download**](/Content/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V)/SSDT-I225V.aml?raw=true) `SSDT-I225V.aml`
- Add it to `EFI/OC/ACPI` and config.plist 
- **macOS 13 only**: 
	- Add [**this kext**](/Content/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V)/AII210E.zip) 
	- Set `MinKernel` to `22.0.0` so it's only injected into macOS Ventura!
- Optional: add boot-arg `dk.e1000=0` (macOS 11) and/or `e1000=0` (macOS 12+)
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

[^1]: Check my guide for [dropping ACPI tables](/Content/00_About_ACPI/ACPI_Dropping_Tables#readme) for details
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


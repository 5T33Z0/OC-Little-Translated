![macOS](https://img.shields.io/badge/Applicable_to:-macOS_12+-version.svg) ![macOS](https://img.shields.io/badge/Affected_Mainboard:-Gigabyte_Z490-white.svg)

# Intel I225-V Ethernet Controller Fix

**TABLE of CONTENTS**

- [About](#about)
- [Adding SSDT-I225-V](#adding-ssdt-i225-v)
- [Settings](#settings)
- [Troubleshooting](#troubleshooting)

## About
The stock firmware of the Intel I225-V Ethernet Controller used on some Gigabyte Z490 Boards contains incorrect Subsystem-ID and Subsystem Vendor-ID infos.[^1] The Vendor-ID (`8086`, for Intel) is also used as Subsystem-Vendor-ID (instead of `1458`) and the Subsystem-ID only contains zeros instead of the correct value (`E000`). This results in Internet not working on macOS Monterey and newer since it cannot connect to the necessary driver.

Apply this fix to re-enable Intenet in macOS Monterey and newer.

[^1]: Check [this thread](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786699) for details.

## Adding SSDT-I225-V
Use the attached SSDT to inject the correct header descriptions for the Intel I225-V into macOS Monterey and newer. For macOS 13, you also need to inject AppleIntel210Ethernet.kext, since it has been removed from the IONetworkingFamily.kext and you can't use the .dext version (unless you flash a modded firmware).

:warning: Before deploying this SSDT, verify the ACPI path of the I225-V is identical to the one used in your `DSDT` and adjust it accordingly! You can use Hackintool and IO RegistryExplorer to find the correct ACPI path.

**Instructions**:

- [**Download**](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/Intel_I225-V_Fix_(SSDT-I225V)/SSDT-I225V.aml?raw=true) `SSDT-I225V.aml`
- Add it to `EFI/OC/ACPI` and config.plist (OCAT users can just drag it into the ACPI/Add section)
- macOS 13 only: 
	- [**Download**](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786214) the `AppleIntel210Ethernet.kext` and unzip it.
	- Add it to `EFI/OC/Kexts` and config.plist (OCAT users can just drag it into the Kernel/Add section)
	- Change `MinKernel` to `22.0.0` so the AppleIntel210Ethernet.kext is only injected into macOS Ventura!
- Add boot-arg `dk.e1000=0` (macOS Big Sur) or `e1000=0` (macOS Monterey/Ventura)
- Apply the correct Settings shown below
- Save the config
- Reboot

Since I have flashed a modded firmware months ago I can't test this fix, but it has been reported as [working successfully](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786756).

## Settings
Listed below are the required BIOS and config Settings for various versions of macOS.

macOS          |Vt-D    |DisableIoMapper|DMAR (OEM)|DMAR (dropped/replaced)[^2]| I225-V / 3rd Party working|
:--------------|:------:|:-------------:|:--------:|:---------------------:|:--------------------------:
12.5+ (with SSDT)  | ON     |**OFF**        | **YES**  | **NO / NO**           | **YES / YES**
12.5+ (stock fw)  | ON     | OFF           | YES      | NO / NO               | **NO / YES**
11.4 to 11.6.7 | ON     | ON [^3]       | NO       | YES / YES | [**YES / YES**](https://github.com/5T33Z0/Gigabyte-Z490-Vision-G-Hackintosh-OpenCore/issues/19#issuecomment-1153315826)
10.15 to 11.3 [^4]| OFF/ON |OFF/ON         | YES      | NO / NO               | **YES / NO**

[^2]: Check my guide for [dropping ACPI tables](https://github.com/5T33Z0/OC-Little-Translated/tree/main/00_About_ACPI/ACPI_Dropping_Tables#readme) for details
[^3]: Combining `Vt-D` and `DisableIOMapper` makes no sense to me in regards to enabling the I225-V in macOS but that's what the user reported as working.
[^4]: Enabling the I225-V in macOS Catalina requires modified DeviceProperties as well as a Kernel Patch since it's not supported natively. With this, the Controller will be spoofed as an Intel I219 and work. Copy the settings from the attached "I225_Catalina.plist" into your Config. Disable the DeviceProperties for anything newer than macOS 11.3!

## Troubleshooting

If you are facing issues afterwards, you could try attaching the I225-V to the `AppleIntelI210Ethernet.kext` by using boot boot-arg `dk.e1000=0` (Big Sur) or `e1000=0` (macOS Monterey/Ventura).

If you can't access the Internet after flashing the custom firmware, remove the following preferences via Terminal and reboot and reset kext cache:

- `sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist`
- `sudo rm /Library/Preferences/SystemConfiguration/preferences.plist`
- `sudo kextcache -i /`

After a few seconds, the connection should work. If you still can't access the Internet, delete the following prefeences followed by a reboot:

- `/Library/Preferences/com.apple.networkextension.necp.plist`
- `/Library/Preferences/com.apple.networkextension.plist`
- `/Library/Preferences/com.apple.networkextension.uuidcache.plist`

## Credits and Resources
- [**MacAbe**](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786836) for SSDT-I225-V.aml

# Intel I225-V Ethernet Controller Fix
> **Affected Boards**: Gigabyte Z490 </br>
> **Applicable to:** macOS 12 and newer

**TABLE of CONTENTS**

- [About](#about)
- [Adding SSDT-I225-V](#adding-ssdt-i225-v)
- [Settings](#settings)
- [Troubleshooting](#troubleshooting)

## About
The stock firmware of the Intel I225-V Ethernet Controller used on some Gigabyte Z490 Boards contains incorrect Subsystem-ID and Subsystem Vendor-ID infos. The Vendor-ID (`8086`, for Intel) is also used as Subsystem-Vendor-ID (instead of `1458`) and the Subsystem-ID only contains zeros instead of the correct value (`E000`). This results in Internet not working on macOS Monterey and newer since it cannot connect to the necessary driver.

Apply this fix to re-enable Intenet in macOS Monterey and newer.

## Adding SSDT-I225-V
Use the attached SSDT to inject the correct header descriptions for the Intel I225-V into macOS. For macOS Ventura, you also need to inject the .kext version of the AppleIntel210Ethernet driver to make it work.

:warning: Before using this SSDT, verify the ACPI path of the I225-V is identical to the one used in your `DSDT` and adjust it accordingly! You can use Hackintool and IO RegistryExplorer to find the correct ACPI path.

**Instructions**:

- Add `SSDT-I225V.aml` to the `EFI/OC/ACPI` folder and config.plist (just drag it into the ACPI/Add section in OCAT)
- macOS 13 only: 
	- [**Download**](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786214) the `AppleIntel210Ethernet.kext` and unzip it.
	- Add it to `EFI/OC/Kexts` and config.plist (just drag it into the Kernel/Add section in OCAT)
	- Change `MinKernel` to `22.0.0` so the AppleIntel210Ethernet.kext is only injected into macOS Ventura!
- Add boot-arg `dk.e1000=0` (macOS Big Sur) or `e1000=0` (macOS Monterey/Ventura)
- Apply the correct Settings as shown below
- Save the config
- Reboot

Since I have flashed a modded firmware months ago I can't test this fix, but it has been reported as [working successfully](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786756).

## Settings
Listed below are the required BIOS and config Settings for various versions of macOS.

macOS          |Vt-D    |DisableIoMapper|DMAR (OEM)|DMAR (dropped/replaced)| I225-V / 3rd Party working|
:--------------|:------:|:-------------:|:--------:|:---------------------:|:--------------------------:
12.5+ (with SSDT)  | ON     |**OFF**        | **YES**  | **NO / NO**           | **YES / YES**
12.5+ (stock fw)  | ON     | OFF           | YES      | NO / NO               | **NO / YES**
11.4 to 11.6.7 | ON     | ON [^1]       | NO       | YES / YES | [**YES / YES**](https://github.com/5T33Z0/Gigabyte-Z490-Vision-G-Hackintosh-OpenCore/issues/19#issuecomment-1153315826)
10.15 to 11.3  | OFF/ON |OFF/ON         | YES      | NO / NO               | **YES / NO**

[^1]: Combining `Vt-D` and `DisableIOMapper` makes no sense to me but that's what the user reported as working.

## Troubleshooting

If you are facing issues afterwards, you could try attaching the I225-V to the `AppleIntelI210Ethernet.kext` by using boot boot-arg `dk.e1000=0` (Big Sur) or `e1000=0` (macOS Monterey/Ventura).

If you can't access the Internet after flashing the custom firmware, remove the following preferences via Terminal and reboot:

- `sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist`
- `sudo rm /Library/Preferences/SystemConfiguration/preferences.plist`

If you still can't access the Internet, delete the following prefeences followed by a reboot:

- `/Library/Preferences/com.apple.networkextension.necp.plist`
- `/Library/Preferences/com.apple.networkextension.plist`
- `/Library/Preferences/com.apple.networkextension.uuidcache.plist`

## Credits and Resources
- [**MacAbe**](https://www.insanelymac.com/forum/topic/352281-intel-i225-v-on-ventura/?do=findComment&comment=2786836) for SSDT-I225-V.aml

# Fake Ethernet Controller (Null Ethernet)

## Description

Some machines don't have have a native Ethernet port (which is rare), but you can spoof one with this SSDT and a kext. The purpose of this driver is to enable internet access via USB Wifi even if your device doesn't have a built-in Ethernet port, so you still can access the Mac App Store. The source for this kext is  based on a heavily modified version Mieze's `RealtekRTL8111.kext`, stripped down to only a shell of an Ethernet driver.

Nowadays, this approach feels pretty outdated since you simply can create a mobile hotspot with your smartphone to access the web over your phone's mobile data plan. You could also use USB Tethering. For iPhones no extra driver is needed. Android devices require [HorNDIS](https://github.com/jwise/HoRNDIS) to enable it.

## Instructions

- Add ***SSDT-LAN*** to `OC\ACPI`.
- Add **NullEthernet.kext** to `OC\Kexts`.
- Add the newly added files to the `config.plist` and save it. 

## Reset Ethernet `BSD Name` to `en0`

- Open **Network** in **System Preferences**.
- Delete all non-working LAN connections and hit "Apply" afterwards.
- Delete `\Library\Preferences\SystemConfiguration\NetworkInterfaces.plist`.
- Reboot.
- Once in the system again, open **Networks** in **System Preferences** again.
- Add **Ethernet** and the other required networks in order, and click **Apply**.

## Credit
**RehabMan** for [**NullEthernet.kext**](https://github.com/RehabMan/OS-X-Null-Ethernet/blob/master/README.md)

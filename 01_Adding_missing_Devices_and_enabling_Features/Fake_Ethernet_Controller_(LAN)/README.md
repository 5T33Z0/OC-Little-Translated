# Fake Ethernet (Null Ethernet)

## Description

Some machines don't have native Ethernet, but you can spoof it with this SSDT and a kext. The purpose of this driver is to enable internet access via USB Wifi even if your device doesn't have a built-in Ethernet port with supporting drivers, so you still can access the Mac App Store.

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

## Credits and Resources
RehabMan for [NullEthernet.kext](https://github.com/RehabMan/OS-X-Null-Ethernet/blob/master/README.md)

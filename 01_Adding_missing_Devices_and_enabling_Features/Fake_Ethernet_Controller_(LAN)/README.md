# Fake Ethernet (NullEthernet)

## Description

Some machines don't have native Ethernet, but you can spoof Ethernet with a SSDT and a Kext. 

## Instructions

- Add ***SSDT-LAN*** to `OC\ACPI`.
- Add **NullEthernet.kext** to `OC\Kexts`.
- Add the newly added files to the `config.plist` and save it. 

## Reset Ethernet `BSD Name` to `en0`

- Open **Network** in **System Preferences** .
- Delete all non-working LAN connections and hit "Apply" afterwards.
- Delete `\Library\Preferences\SystemConfiguration\NetworkInterfaces.plist`.
- Reboot.
- Once in the system again, open **Networks** in **System Preferences** again.
- Add **Ethernet** and the other required networks in order, and click **Apply**.

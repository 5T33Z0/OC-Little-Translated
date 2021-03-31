# Fake Ethernet

## Description

Some machines don't have native Ethernet, but you can spoof Ethernet with a SSDT and a Kext. 

## Instructions

- Add ***SSDT-LAN*** to `OC\ACPI`.
- Add **NullEthernet.kext** to `OC\Kexts`.
- Add the newly added files to the config.plist

## Reset Ethernet `BSD Name` to `en0`

- Open **Network** in **System Preferences** .
- Delete all networks, as shown in the figure `Clear all networks`.
- Delete the `Repository\Preferences\SystemConfiguration\NetworkInterfaces.plist` file.
- Reboot.
- Once in the system again, open **Networks** in **System Preferences** again.
- Add **Ethernet** and the other required networks in order, and click **Apply**.
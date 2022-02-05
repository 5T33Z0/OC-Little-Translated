# Fake Firmware Hub Device (`SSDT-FWHD`) 
Adds `FWHD` device to the IO Registry in macOS – nothing more. My research of DSDT and ioreg files depict that the Intel Firmware Hub Device is present in almost every Intel-based Mac model. It is listed in IORegistryExplorer as "FWHD" with the HID `INT0800`.

Mac Models containing `FWHD`:

- **iMac**: 7,1, 8,1, 11,x to 20,x
- **iMacPro1,1**
- **MacBook**: 1,1 to 4,1, 8,1, 9,1
- **MacBookAir**: 1,1, 4,x, 5,x, 7,2, 8,1
- **MacBookPro**: 1,x, 3,1, 4,1, 6,x, 8,x to 16,1
- **MacMini**: 1,1, 2,1, 5,x to 8,1 
- **MacPro**: 1,1 to 7,1
- **Xserve**: 1,1 to 3,1

## Verifying that the patch is working
- Add **SSDT-FWHD.aml** to your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `FWHD`
- If the Device is present, it should look like this:
  
## Notes and Credits
- Make sure the name of the LPC bus is consistent with the name uses in your `DSDT` (either `LPCB` or `LPC`) 
- Baio1977 for providing the SSDT

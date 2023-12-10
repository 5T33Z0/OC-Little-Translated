# Fake Firmware Hub Device (`SSDT-FWHD`) 
Adds a virtual, non-functional `FWHD` device to the I/O Registry in macOS which has to be considered purely cosmetic. My research of DSDT and .ioreg files showed that the Intel Firmware Hub Device is present in almost every Intel-based Mac. It is listed in **IORegistryExplorer** as "**FWHD**" with the HID `INT0800`.

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
- Add ***SSDT-FWHD.aml*** to your EFI's ACPI folder and config.plist.
- Restart your system 
- Open IORegistryExplorer and search for `FWHD`
- If the Device is present, it should look like this:</br></br>![fwhd](https://user-images.githubusercontent.com/76865553/152636354-76767c7b-5517-47da-a85d-5c9f35211488.png)
  
## NOTES and CREDITS
- When using this patch, ensure that the ACPI path of the LPC Bus (`LPC` or `LPCB`) used in the SSDT is consistent with the one used in your system's `DSDT`. 
- Thanks to Baio1977 for **SSDT-FWHD**

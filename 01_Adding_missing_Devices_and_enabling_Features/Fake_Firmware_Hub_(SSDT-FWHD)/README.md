# Fake Firmware Hub Device (`SSDT-FWHD`) 
Adds `FWHD` device to IO Registry in macOS – nothing more. My research showed that `FWHD` is present in the IORegistries of a wide range of Mac models. It is listed in IORegistryExplorer as "FWHD" (Firmware Hub Device) with the HID `INT0800`.

Used in the following **SMBIOS**:

- iMac11,x to iMac20,x (10th Gen Intel Core)
- iMacPro1,1 (Xeon W)
- MacBook8,1, MacBook9,1
- MacBookAir8,1
- macBookPro15,x (9th Gen Intel Core), macBookPro16,x (9th Gen)
- MacMini5,x MacMini6,1, MacMini7,1, MacMini8,1
- MacPro1,1 to MacPro7,1 (Xeon W)

## Credits
- Baio1977 for providing the SSDT

# Fake Apple Realtime Clock (`SSDT-ARTC`) 
Adds `ARTC` device to IORegistry in macOS – nothing more. My research showed that `ARTC` is present in the IO Registries of Macs with Coffee Lake, Comet Lake, Ice Lake and Xeon W CPUs. When added, it is listed in IOreg as "ARTC" (Apple Realtime Clock) while the actual clock in use is "RTC".

It has `ACPI000E` as Hardware ID (HID), which is identical to the `AWAC` Clock found in DSTDs of modern systems (300-series and newer).

Appllicable to **SMBIOS**:

- macBookAir9,x (10th Gen Ice Lake)
- macBookPro15,x (9th Gen Intel Core), macBookPro16,x (9th Gen)
- iMac19,1 iMac20,x (10th Gen)
- iMacPro1,1 (Xeon W)
- macPro7,1 (Xeon W)

:warning: Don't use this SSDT for fixing your System Clock! This is just a cosmetic device. If you need to fix your Clock, look into [SSDT-AWAC](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC)) or [SSDT-RTC0](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)) instead!

## Credits
- Baio1977 for providing the SSDT

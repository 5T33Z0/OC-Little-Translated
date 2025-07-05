# Fake Apple Realtime Clock (`SSDT-ARTC`) 
Adds `ARTC` device to IORegistry in macOS – nothing more. My research showed that `ARTC` is present in the IO Registries of Macs with Coffee Lake, Comet Lake, Ice Lake and Xeon W CPUs. When added, it is listed in IOreg as "ARTC" (Apple Realtime Clock) while the actual clock in use is "RTC".

It has `ACPI000E` as Hardware ID (HID), which is identical to the `AWAC` Clock found in DSTDs of modern systems (300-series and newer).

Appllicable to **SMBIOS**:

- **iMac**: 19,1, 20,x
- **iMacPro1,1**
- **MacBookAir9,x**
- **MacBookPro**: 15,x, 16,x
- **MacMini8,1**
- **MacPro7,1**

> [!CAUTION]
>
> Don't use this SSDT for fixing your System Clock! This is just a _virtual/fake_  device. If you need to fix your Clock, use [**SSDT-AWAC**](/Content/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-AWAC)) or [**SSDT-RTC0**](/Content/01_Adding_missing_Devices_and_enabling_Features/System_Clock_(SSDT-RTC0)) instead!

## Credits
- [**Baio1977**](https://www.mstx.cn/Baio1977) for **SSDT-ARTC**

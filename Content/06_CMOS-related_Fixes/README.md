# CMOS-related Fixes
**CMOS** (complementary metal-oxide-semiconductor) memory holds important data such as date, time, hardware configuration information, auxiliary setup information, boot settings, hibernation information, etc. 

On a real Mac, non-volatile RAM (NVRAM) is used for this instead. Just like CMOS, NVRAM is also powered by a small battery, which allows it to retain its data when the system power is off.

When running macOS on Wintel systems, it can sometimes trigger a CMOS-reset on some BIOSes/Firmwares when shutting down or restarting the system.

You can use one of the following fixes to resolve the issue:

- [**CMOS Reset Fix**](/Content/06_CMOS-related_Fixes/CMOS_Reset_Fix/README.md) – For fixing CMOS resets triggered by macOS after shutting down or rebooting.
- [**Emulating CMOS Memory**](/Content/06_CMOS-related_Fixes/Emulating_CMOS/README.md) – For fixing conflicts between `AppleRTC` and the BIOS/UEFI Firmware. Can be helpful when trying to fix hibernation.

# Enabling general-purpose I/O devices (`SSDT-GPIO`)
The presence of a `GPIO` device is usually **required for a I2C TouchPads** to function properly. Usually, this is combined with [**SSDT-XOSI**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/OS_Compatibility_Patch_(XOSI)) to improve TouchPad support under macOS. Another approach is to use [**SSDT-OSYS**](https://gist.github.com/rockavoldy/eeff232c932bf3eaa01b47c4d9253dd3).

## Patching Principle
- If `GPI0` should be enabled, its `_STA` must `Return (0x0F)`.
- The sample is for reference only. Verify the presence of `GPEN` or `GPHD` in the `_STA` of the GPI0 device when using it. See Binary Renaming and Preset Variables for details.

## Resources
- See [**this chapter**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/05_Laptop-specific_Patches/Trackpad_Patches) for enabling Touchpad Support on Laptops
- [**Fixing Trackpads**](https://dortania.github.io/Getting-Started-With-ACPI/Laptops/trackpad-methods/manual.html#checking-gpi0) Guide by Dortania.

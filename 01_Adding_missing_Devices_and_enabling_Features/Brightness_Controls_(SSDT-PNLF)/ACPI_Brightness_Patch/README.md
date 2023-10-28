# ACPI Brightness Patch

## Description

You can try this method if the common injection methods do not work. It requires an SSDT and a Kext.

### 1. Patch: ***SSDT-PNLF-ACPI***

- Dump ACPI Tables
- Search for the methods `_BCL`, `_BCM` and `_BQC` in all tables and note the name and path of the device they belong to, e.g. `LCD`, `LCD0`, etc. If you don't find these methods, this patch is not for you!
- Copy the content of [`SSDT-PNLF-ACPI.dsl`](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/ACPI_Brightness_Patch/SSDT-PNLF-ACPI.dsl) to maciASL
- in the SSDT, change `DD1F` to the previously found name/path (`DD1F` is replaced by `LCD`). Refer to the screenshot shown in the example.
- Modify `IGPU` in the patch file to be the name of the graphics card for ACPI (e.g. `IGPU` is replaced with `GFX0`).
- Export `SSDT-PNLF-ACPI.aml` and add it to the `EFI/OC/ACPI` folder and `config.plist`

### 2. Kext: `ACPIBacklight.kext`
- Add `ACPIBacklight.kext` to kext folder and config
- Save `config.plist` and reboot.

**NOTE**: ACPIBacklight kext is deprecated and has been replaced by IntelBacklight kext since macOS 10.11: https://github.com/RehabMan/OS-X-Intel-Backlight

### Example
![](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/ACPI_Brightness_Patch/Example.jpg?raw=true.jpg)

## Notes and Credits
- [**Guide by Rehabman**](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightfixup-kext.218222/)
- If `ACPIBacklight.kext` is used, you need to disable the built-in brightness driver of `Whatevergreen.kext` by adding `applbkl=0` to boot-args.
- This method is pretty much deprecated now. You may use the `SSDT-PNLF` sample included in the OpenCore package instead. But maybe this does work better on some legacy notebooks.
- `ACPIBacklight.kext` by RehabMan: https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/

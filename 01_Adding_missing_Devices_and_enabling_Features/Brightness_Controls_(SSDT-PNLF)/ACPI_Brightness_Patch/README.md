# ACPI Brightness Patch

## Description

You can try this method if the common injection methods do not work. 

### 1. Patch: ***SSDT-PNLF-ACPI***

The patch may need to be modified to work. Modification method:

- Extract local ACPI
- Search for `_BCL`, `_BCM`, `_BQC` in all ACPI files and record the name of the device they belong to, e.g. `LCD`, `LCD0`, etc. If you don't find these methods, this patch is not for you.
- Modify `DD1F` in the patch file to the previously recorded name (`DD1F` is replaced by `LCD`). Refer to the screenshot shown in the example.
- Modify `IGPU` in the patch file to be the name of the graphics card for ACPI (e.g. `IGPU` is replaced with `GFX0`).
- Add `SSDT-PNLF-ACPI.aml` to ACPI folder and `config.plist`

### 2. Kext: `ACPIBacklight.kext`
- Add `ACPIBacklight.kext` to kext folder and config
- Save `config.plist` and reboot.

**NOTE**: ACPIBacklight kext is deprecated and has been replaced by IntelBacklight kext since macOS 10.11: https://github.com/RehabMan/OS-X-Intel-Backlight

### Example
![](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/ACPI_Brightness_Patch/Example.jpg?raw=true.jpg)

## Notes and Credits
- If `ACPIBacklight.kext` is used, you need to disable the built-in brightness driver of `Whatevergreen.kext` by adding `applbkl=0` to boot-args.
- This method is pretty much deprecated now. You may use the `SSDT-PNLF` sample included in the OpenCore package instead. But maybe this does work better on some legacy notebooks.
- `ACPIBacklight.kext` by RehabMan: https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/

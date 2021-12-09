# ACPI Brightness Patch

## Description

Try this method when common injection methods do not work. 

### Patch: ***SSDT-PNLF-ACPI***

The patch may need to be modified to work for you. Modification method:

- Extract local ACPI
- Search for `_BCL`, `_BCM`, `_BQC` in all ACPI files and record the name of the device they belong to, e.g. `LCD`.
- Modify `DD1F` in the patch file to the previously recorded name (`DD1F` is replaced by `LCD`). Refer to ***Modification Diagram***.
- Modify `IGPU` in the patch file to be the name of the graphics card for ACPI (e.g. `IGPU` is replaced with `GFX0`).

### Kext

- `ACPIBacklight.kext`

### Screenshot
![](/Users/kl45u5/Documents/GitHub/OC-Little-Translated/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)/ACPI_Brightness_Patch/Example.jpg)

## Notes and Credits
- This method is pretty much depricated now. You may use the SSDT-PNLF sample in the OpenCore package instead. But maybe the old method does work better on some legacy notebooks.
- `ACPIBacklight.kext` by Rehabman: https://bitbucket.org/RehabMan/os-x-acpi-backlight/downloads/

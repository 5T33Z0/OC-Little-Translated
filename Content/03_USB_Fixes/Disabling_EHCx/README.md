# Disabling `EHCx` USB Controllers

## Description
This section contains SSDts to disable Extended Host Controllers `EHC1` and `EHC2` (present in machines with 7, 8 and 9 series chipsets). They need to be disabled in one of the following cases:

- ACPI contains the `EHC1` and/or `EHC2` controller(s) but the machine does not have the associated hardware installed.
- ACPI contains the code for `EHC1` and/or `EHC2`, the actual hardware is present, but no ports are mapped to it.

## System Requirements
- If you cannot enable `XHCI Mode`in BIOS and the conditions in the **description** are met, use the patches listed below.
- For 7, 8 and 9-series machines with macOS 10.11 or newer.
- For 7-series machines, ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF*** cannot be used together.
- The patch adds `_INI` method under `Scope (\)`, if it duplicates `_INI` of other patches, the contents of `_INI` should be merged.

## Patches
- ***SSDT-EHC1_OFF***: Disables `EHC1`
- ***SSDT-EHC2_OFF***: Disables `EHC2`
- ***SSDT-EHCx_OFF***: Combined patch of ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF***.

## Notes
- The official OpenCore Package contains a similar ACPI Patch called `SSDT-EHCx-DISABLE`.
- For Notebooks: if your Laptop supports a docking station with USB ports, you should not disable any of the EHCs because it's most likely that one of them is used to support the USB ports of the dock!

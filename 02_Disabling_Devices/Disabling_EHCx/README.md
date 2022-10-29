# Disabling `EHCx` USB Controllers

## Description
`EHC1` and `EHC2` busses need to be disabled in one of the following cases:

- The ACPI contains `EHC1` and/or `EHC2` controllers but the machine does not have the associated hardware.
- ACPI contains `EHC1`and/or `EHC2`, the actual hardware controllers exist but no ports are mapped to it (external and internal).

## System Requirements
- If you cannot enable `XHCI Mode`in BIOS and the conditions in the **description** are met, use the patches listed below.
- For 7, 8 and 9-series machines with macOS 10.11 or higher.
- For 7-series machines, ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF*** cannot be used together.
- The patch adds `_INI` method under `Scope (\)`, if it duplicates `_INI` of other patches, the contents of `_INI` should be merged.

## Patch
- ***SSDT-EHC1_OFF***: Disables `EHC1`.
- ***SSDT-EHC2_OFF***: Disables `EHC2`.
- ***SSDT-EHCx_OFF***: Combined patch of ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF***.

## Notes
The official OpenCore Package contains a similar ACPI Patch called `SSDT-EHCx-DISABLE`.



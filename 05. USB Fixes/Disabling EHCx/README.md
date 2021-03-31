# Disabling EHCx

## Description
The Enhanced Host Controller Interface (EHCI) specification describes the register-level interface for a host controller for the Universal Serial Bus (USB) Revision 2.0. The specification includes a description of the hardware and software interface between system software and the host controller hardware.

The `EHC1` and `EHC2` busses have to be disabled in one of the following cases.

1. ACPI contains either `EHC1` or `EHC2` but the machine itself does not have the associated hardware.
2. ACPI contains either `EHC1` or `EHC2` and the machine has the associated hardware but no actual output ports (external and internal).

## Patch

- ***SSDT-EHC1_OFF***: Disables `EHC1`.
- ***SSDT-EHC2_OFF***: Disables `EHC2`.
- ***SSDT-EHCx_OFF*** is a combined patch of ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF***.

## Usage

- Priority BIOS setting: `XHCI Mode` = `Enabled`.
- If the BIOS does not have the `XHCI Mode` option and one of the **descriptions** is met, use the above patch.

### Caution

- For 7, 8, 9 series machines with macOS 10.11 or higher.
- For 7-series machines, ***SSDT-EHC1_OFF*** and ***SSDT-EHC2_OFF*** cannot be used together.
- Patch adds `_INI` method under `Scope (\)`, if it duplicates `_INI` of other patches, the contents of `_INI` should be merged.

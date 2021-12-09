# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## About `SSDT-IMEI`
Adds IMEI (Intel Management Engine Interface) Device to ACPI. Required for Intel GPU acceleration. Adding IMEI is only required in two cases:

- Sandy Bridge CPUs running on 7-series mainboards or
- Ivy Bridge CPUs running on 6-series mainboards

## Instructions

In **DSDT**, search for:

`0x00160000`. If missing, add ***SSDT-IMEI*** to ACPI Folder and Config.

**CAUTION:** When using this patch, make sure that the device path of the low pin configuration bus (`LPC`/`LPCB`) is consistent with the one used in the original `DSDT`.

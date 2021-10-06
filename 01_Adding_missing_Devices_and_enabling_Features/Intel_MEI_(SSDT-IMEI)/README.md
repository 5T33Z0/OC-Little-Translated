# Add missing parts

Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## Instructions

In **DSDT**, search for:

- `0x00160000`, if missing, add ***SSDT-IMEI***. Adds Intel MEI. Required for Intel GPU acceleration (Req for 6th-series mainboards only)

**CAUTION:** When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.

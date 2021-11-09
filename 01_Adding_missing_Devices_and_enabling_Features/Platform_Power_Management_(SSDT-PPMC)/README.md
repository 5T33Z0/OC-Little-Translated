# Add missing parts
Although adding any of the missing parts listed below may improve performance, they can only be regarded as a refinement. They are not a necessity for getting your Hackintosh to work, except for `PMCR` which may be a requirement for Z390 Chipsets.

## About `SSDT-PPMC`

- What it is: Adds Platform Power Management Controller Device
- What it does: Improves Power Management (supposedly)
- Supported CPU Families:
  - **Desktop**: 7th and 8th Gen Intel (100 and 200 Series Mainboards only)
  - **Mobile/NUC**: 6th to 8th Gen Intel

## Instructions

- In **DSDT**, search for Address `0x001F0002` or `Device (PPMC)`. Make sure it's the address is not associated with a SATA Device!
- If missing, add `SSDT-PPMC.aml`

**CAUTION**: When using the any of the patches, note that `LPC`/`LPCB` name should be consistent with the name used in the original ACPI.

### Verifying
In IORegistryExplorer search for 'PPMC'. If present, it should look like this:

![PPMC](https://user-images.githubusercontent.com/76865553/140606933-94dbfeda-386e-4885-b2a6-ea214b9f4f07.png)
